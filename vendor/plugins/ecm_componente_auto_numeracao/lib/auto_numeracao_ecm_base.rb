class AutoNumeracaoEcmBase
#-----------------------------------------------------------------------------------------------------------------------------------------------------
# ITEM DO FORMULARIO
  def salvar_item(item_form, params)
    item_form.opcoes = params[:opcoes]
    return item_form.save
  end

  def apos_criar_item(form_item)
    if form_item.formulario.cadastros.size > 0
      form_item.formulario.cadastros.each do |cadastro|
        texto = EcmItemTexto.new
        texto.entidade_id = cadastro.entidade_id
        texto.formulariocategoria_id = cadastro.formulario.formulariocategoria_id
        texto.formulario_id = cadastro.formulario_id
        texto.itensformulario_id = form_item.id
        texto.cadastro_id = cadastro.id

        form_item.opcoes[:valor] = (form_item.opcoes[:valor].to_i + 1).to_s
        form_item.save
        num = "#{form_item.opcoes[:prefixo]}#{form_item.opcoes[:valor]}#{form_item.opcoes[:posfixo]}"

        texto.conteudo = num
        texto.save
      end
    end
  end

  def remover_filtro_em_referencia(form_item, deleta_form_item)
    return true
  end

#-----------------------------------------------------------------------------------------------------------------------------------------------------
# CADASTRO
#

   def validar_opcoes(form_item)
      return true
   end

   def acessores(cadastro, item_form)
      cadastro.acessores("item_#{item_form.id}")
   end

   def validar(cadastro, form_item, cadastro_itens)
      unless cadastro_itens["item_#{form_item.id}"]
        cadastro.errors.add("item_#{form_item.id}", "Campo #{form_item.rotulo} Requerido!")
      end
   end

   def save(cadastro, form_item, cadastro_itens)
      texto = EcmItemTexto.new
      texto.entidade_id = cadastro.entidade_id
      texto.formulariocategoria_id = cadastro.formulario.formulariocategoria_id
      texto.formulario_id = cadastro.formulario_id
      texto.itensformulario_id = form_item.id
      texto.cadastro_id = cadastro.id

      form_item.opcoes[:valor] = (form_item.opcoes[:valor].to_i + 1).to_s
      form_item.save
      num = "#{form_item.opcoes[:prefixo]}#{form_item.opcoes[:valor]}#{form_item.opcoes[:posfixo]}"

      texto.conteudo = num
      texto.save
   end

   def update(cadastro, form_item, cadastro_itens)
     texto = EcmItemTexto.find(:first, :conditions=>["entidade_id = ? and
                                                   formulariocategoria_id = ? and
                                                   formulario_id = ? and
                                                   itensformulario_id = ? and
                                                   cadastro_id = ?",
                                                   cadastro.entidade_id,
                                                   cadastro.formulariocategoria_id,
                                                   cadastro.formulario_id,
                                                   form_item.id,
                                                   cadastro.id])
      texto.conteudo = cadastro_itens["item_#{form_item.id}"]
      texto.save
   end

   def busca_avancada(form_item, params, valor=nil)
     unless valor
      cads = EcmItemTexto.find(:all, :conditions=>["itensformulario_id = ? and
                                                    conteudo like ?",
                                                    form_item.id,
                                                    "%#{params[:cadastro]["item_#{form_item.id}"]}%"]).collect {|c| c.cadastro_id}
     else
       cads = EcmItemTexto.find(:all, :conditions=>["itensformulario_id = ? and
                                                    conteudo like ?",
                                                    form_item.id,
                                                    "%#{valor}%"]).collect {|c| c.cadastro_id}
     end
   end

   def busca_cadastro_item(form_item, cadastro)
    EcmItemTexto.find(:first, :conditions=>["entidade_id = ? and
                                                   formulariocategoria_id = ? and
                                                   formulario_id = ? and
                                                   itensformulario_id = ? and
                                                   cadastro_id = ?",
                                                   cadastro.entidade_id,
                                                   cadastro.formulariocategoria_id,
                                                   cadastro.formulario_id,
                                                   form_item.id,
                                                   cadastro.id])
  end

  def deleta_cadastro_item(form_item, cadastro)
    EcmItemTexto.find(:first, :conditions=>["entidade_id = ? and
                                                   formulariocategoria_id = ? and
                                                   formulario_id = ? and
                                                   itensformulario_id = ? and
                                                   cadastro_id = ?",
                                                   cadastro.entidade_id,
                                                   cadastro.formulariocategoria_id,
                                                   cadastro.formulario_id,
                                                   form_item.id,
                                                   cadastro.id]).destroy
  end
end

