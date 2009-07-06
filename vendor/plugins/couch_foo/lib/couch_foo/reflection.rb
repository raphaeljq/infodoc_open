module CouchFoo
  module Reflection # :nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Reflection allows you to interrogate Couch Foo classes and objects about their associations and aggregations.
    # This information can, for example, be used in a form builder that took an Couch Foo object and created input
    # fields for all of the attributes depending on their type and displayed the associations to other objects.
    #
    # You can find the interface for the AggregateReflection and AssociationReflection classes in the abstract MacroReflection class.
    module ClassMethods
      def create_reflection(macro, name, options, couch_foo)
        case macro
          when :has_many, :belongs_to, :has_one, :has_and_belongs_to_many
            reflection = AssociationReflection.new(macro, name, options, couch_foo)
          #when :composed_of
          #  reflection = AggregateReflection.new(macro, name, options, couch_foo)
        end
        write_inheritable_hash :reflections, name => reflection
        reflection
      end
      
      # Returns a hash containing all AssociationReflection objects for the current class
      # Example:
      #
      #   Invoice.reflections
      #   Account.reflections
      #
      def reflections
        read_inheritable_attribute(:reflections) || write_inheritable_attribute(:reflections, {})
      end
       
      # Returns an array of AggregateReflection objects for all the aggregations in the class.
      def reflect_on_all_aggregations
        reflections.values.select { |reflection| reflection.is_a?(AggregateReflection) }
      end

      # Returns the AggregateReflection object for the named +aggregation+ (use the symbol). Example:
      #
      #   Account.reflect_on_aggregation(:balance) # returns the balance AggregateReflection
      #
      def reflect_on_aggregation(aggregation)
        reflections[aggregation].is_a?(AggregateReflection) ? reflections[aggregation] : nil
      end

      # Returns an array of AssociationReflection objects for all the associations in the class. If you only want to reflect on a
      # certain association type, pass in the symbol (<tt>:has_many</tt>, <tt>:has_one</tt>, <tt>:belongs_to</tt>) for that as the first parameter.
      # Example:
      #
      #   Account.reflect_on_all_associations             # returns an array of all associations
      #   Account.reflect_on_all_associations(:has_many)  # returns an array of all has_many associations
      #
      def reflect_on_all_associations(macro = nil)
        association_reflections = reflections.values.select { |reflection| reflection.is_a?(AssociationReflection) }
        macro ? association_reflections.select { |reflection| reflection.macro == macro } : association_reflections
      end

      # Returns the AssociationReflection object for the named +association+ (use the symbol). Example:
      #
      #   Account.reflect_on_association(:owner) # returns the owner AssociationReflection
      #   Invoice.reflect_on_association(:line_items).macro  # returns :has_many
      #
      def reflect_on_association(association)
        reflections[association].is_a?(AssociationReflection) ? reflections[association] : nil
      end
    end


    # Abstract base class for AggregateReflection and AssociationReflection that describes the interface available for both of
    # those classes. Objects of AggregateReflection and AssociationReflection are returned by the Reflection::ClassMethods.
    class MacroReflection
      attr_reader :couch_foo

      def initialize(macro, name, options, couch_foo)
        @macro, @name, @options, @couch_foo = macro, name, options, couch_foo
      end

      # Returns the name of the macro.  For example, <tt>composed_of :balance, :class_name => 'Money'</tt> will return
      # <tt>:balance</tt> or for <tt>has_many :clients</tt> it will return <tt>:clients</tt>.
      def name
        @name
      end

      # Returns the macro type. For example, <tt>composed_of :balance, :class_name => 'Money'</tt> will return <tt>:composed_of</tt>
      # or for <tt>has_many :clients</tt> will return <tt>:has_many</tt>.
      def macro
        @macro
      end

      # Returns the hash of options used for the macro.  For example, it would return <tt>{ :class_name => "Money" }</tt> for
      # <tt>composed_of :balance, :class_name => 'Money'</tt> or +{}+ for <tt>has_many :clients</tt>.
      def options
        @options
      end

      # Returns the class for the macro.  For example, <tt>composed_of :balance, :class_name => 'Money'</tt> returns the Money
      # class and <tt>has_many :clients</tt> returns the Client class.
      def klass
        @klass ||= class_name.constantize
      end

      # Returns the class name for the macro.  For example, <tt>composed_of :balance, :class_name => 'Money'</tt> returns <tt>'Money'</tt>
      # and <tt>has_many :clients</tt> returns <tt>'Client'</tt>.
      def class_name
        @class_name ||= options[:class_name] || derive_class_name
      end

      def document_class_name
        @document_class_name ||= klass.document_class_name
      end

      # Returns +true+ if +self+ and +other_aggregation+ have the same +name+ attribute, +couch_foo+ attribute,
      # and +other_aggregation+ has an options hash assigned to it.
      def ==(other_aggregation)
        name == other_aggregation.name && other_aggregation.options && couch_foo == other_aggregation.couch_foo
      end

      def sanitized_conditions #:nodoc:
        @sanitized_conditions ||= klass.send(:sanitize_conditions, options[:conditions]) if options[:conditions]
      end

      private
        def derive_class_name
          name.to_s.camelize
        end
    end


    # Holds all the meta-data about an aggregation as it was specified in the Couch Foo class.
    class AggregateReflection < MacroReflection #:nodoc:
    end

    # Holds all the meta-data about an association as it was specified in the Couch Foo class.
    class AssociationReflection < MacroReflection #:nodoc:
      def klass
        @klass ||= couch_foo.send(:compute_type, class_name)
      end

      def primary_key_name
        @primary_key_name ||= options[:foreign_key] || derive_primary_key_name
      end

      def association_foreign_key
        @association_foreign_key ||= @options[:association_foreign_key] || class_name.foreign_key
      end

      def counter_cache_property
        if options[:counter_cache] == true
          "#{couch_foo.name.underscore.pluralize}_count"
        elsif options[:counter_cache]
          options[:counter_cache]
        end
      end

      # Returns the AssociationReflection object specified in the <tt>:through</tt> option
      # of a HasManyThrough or HasOneThrough association. Example:
      #
      #   class Post < CouchFoo::Base
      #     has_many :taggings
      #     has_many :tags, :through => :taggings
      #   end
      #
      #   tags_reflection = Post.reflect_on_association(:tags)
      #   taggings_reflection = tags_reflection.through_reflection
      #
      def through_reflection
        @through_reflection ||= options[:through] ? couch_foo.reflect_on_association(options[:through]) : false
      end

      # Gets an array of possible <tt>:through</tt> source reflection names:
      #
      #   [:singularized, :pluralized]
      #
      def source_reflection_names
        @source_reflection_names ||= (options[:source] ? [options[:source]] : [name.to_s.singularize, name]).collect { |n| n.to_sym }
      end

      # Gets the source of the through reflection.  It checks both a singularized and pluralized form for <tt>:belongs_to</tt> or <tt>:has_many</tt>.
      # (The <tt>:tags</tt> association on Tagging below.)
      # 
      #   class Post < CouchFoo::Base
      #     has_many :taggings
      #     has_many :tags, :through => :taggings
      #   end
      #
      def source_reflection
        return nil unless through_reflection
        @source_reflection ||= source_reflection_names.collect { |name| through_reflection.klass.reflect_on_association(name) }.compact.first
      end

      def check_validity!
        if options[:through]
          if through_reflection.nil?
            raise HasManyThroughAssociationNotFoundError.new(couch_foo.name, self)
          end
          
          if source_reflection.nil?
            raise HasManyThroughSourceAssociationNotFoundError.new(self)
          end

          if options[:source_type] && source_reflection.options[:polymorphic].nil?
            raise HasManyThroughAssociationPointlessSourceTypeError.new(couch_foo.name, self, source_reflection)
          end
          
          if source_reflection.options[:polymorphic] && options[:source_type].nil?
            raise HasManyThroughAssociationPolymorphicError.new(couch_foo.name, self, source_reflection)
          end
          
          unless [:belongs_to, :has_many].include?(source_reflection.macro) && source_reflection.options[:through].nil?
            raise HasManyThroughSourceAssociationMacroError.new(self)
          end
        end
      end

      private
        def derive_class_name
          # get the class_name of the belongs_to association of the through reflection
          if through_reflection
            options[:source_type] || source_reflection.class_name
          else
            class_name = name.to_s.camelize
            class_name = class_name.singularize if [ :has_many, :has_and_belongs_to_many ].include?(macro)
            class_name
          end
        end

        def derive_primary_key_name
          if macro == :belongs_to
            "#{name}_id"
          elsif options[:as]
            "#{options[:as]}_id"
          else
            couch_foo.name.foreign_key
          end
        end
    end
  end
end