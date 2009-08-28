class NumeroInteiroEcmBase
#-----------------------------------------------------------------------------------------------------------------------------------------------------
# ITEM DO FORMULARIO
  def salvar_item(item_form, params)
    item_form.opcoes = params[:opcoes]
    return item_form.save
  end

  def apos_criar_item(form_item)
    if form_item.formulario.cadastros.size > 0
      form_item.formulario.cadastros.each do |cadastro|
        texto = EcmItemNumeroInteiro.new
        texto.entidade_id = cadastro.entidade_id
        texto.formulariocategoria_id = cadastro.formulario.formulariocategoria_id
        texto.formulario_id = cadastro.formulario_id
        texto.itensformulario_id = form_item.id
        texto.cadastro_id = cadastro.id
        texto.conteudo = 0
        texto.save
      end
    end
  end

#-----------------------------------------------------------------------------------------------------------------------------------------------------
# CADASTRO
#

   def validar_opcoes(form_item)
      return true
   end

   def acessores(cadastro, item_form)
    cadastro.instance_eval do
      eval("@item_#{item_form.id}")
      eval("def item_#{item_form.id}=(valor) @item_#{item_form.id}=valor end")
      eval("def item_#{item_form.id}() return @item_#{item_form.id} end")
    end
   end

   def validar(cadastro, form_item, cadastro_itens)
      if form_item.opcoes[:nulo] == "0" and cadastro_itens["item_#{form_item.id}"] == ""
        cadastro.errors.add("Item #{form_item.id}", ". Campo #{form_item.rotulo} Requerido!")
      end
      if form_item.opcoes[:unico] == "1"
        cadastro_itens["item_#{form_item.id}"].upcase! if form_item.opcoes[:semacento] == "1"
        cadastro_itens["item_#{form_item.id}"].remover_acentos! if form_item.opcoes[:maiusculo] == "1"

        cad = EcmItemNumeroInteiro.find(:first, :conditions=>["itensformulario_id = ? and conteudo = ? and cadastro_id = ?", form_item.id, cadastro_itens["item_#{form_item.id}"], cadastro.id])
        unless cad
          num = EcmItemNumeroInteiro.count(:all, :conditions=>["itensformulario_id = ? and conteudo = ?", form_item.id, cadastro_itens["item_#{form_item.id}"]])
          cadastro.errors.add("item_#{form_item.id}", "O #{form_item.rotulo} ja foi cadastrado anteriormente!") if num > 0
        else
          unless cad.conteudo == cadastro_itens["item_#{form_item.id}"]
            num = EcmItemNumeroInteiro.count(:all, :conditions=>["itensformulario_id = ? and conteudo = ?", form_item.id, cadastro_itens["item_#{form_item.id}"]])
            cadastro.errors.add("item_#{form_item.id}", "O #{form_item.rotulo} ja foi cadastrado anteriormente!") if num > 0
          end
        end
      end
   end

   def save(cadastro, form_item, cadastro_itens)
      numero_inteiro = EcmItemNumeroInteiro.new
      numero_inteiro.entidade_id = cadastro.entidade_id
      numero_inteiro.formulariocategoria_id = cadastro.formulario.formulariocategoria_id
      numero_inteiro.formulario_id = cadastro.formulario_id
      numero_inteiro.itensformulario_id = form_item.id
      numero_inteiro.cadastro_id = cadastro.id
      numero_inteiro.conteudo = cadastro_itens["item_#{form_item.id}"]
      numero_inteiro.save
   end

   def update(cadastro, form_item, cadastro_itens)
     numero_inteiro = EcmItemNumeroInteiro.find(:first, :conditions=>["entidade_id = ? and
                                                                       formulariocategoria_id = ? and
                                                                       formulario_id = ? and
                                                                       itensformulario_id = ? and
                                                                       cadastro_id = ?",
                                                                       cadastro.entidade_id,
                                                                       cadastro.formulariocategoria_id,
                                                                       cadastro.formulario_id,
                                                                       form_item.id,
                                                                       cadastro.id])
      numero_inteiro.conteudo = cadastro_itens["item_#{form_item.id}"]
      numero_inteiro.save
   end

      def busca_avancada(form_item, params, valor=nil)
     unless valor
      cads = EcmItemNumeroInteiro.find(:all, :conditions=>["itensformulario_id = ? and
                                                    conteudo >= ? and conteudo <= ?",
                                                    form_item.id,
                                                    params[:cadastro]["item_#{form_item.id}_1"], params[:cadastro]["item_#{form_item.id}_2"]]).collect {|c| c.cadastro_id}
     else
       cads = EcmItemTexto.find(:all, :conditions=>["itensformulario_id = ? and
                                                    conteudo >= ? and conteudo <= ?",
                                                    form_item.id,
                                                    valor[0], valor[1]]).collect {|c| c.cadastro_id}
     end
   end


end
