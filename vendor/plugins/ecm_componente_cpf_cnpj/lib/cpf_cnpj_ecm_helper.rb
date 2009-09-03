module CpfCnpjEcmHelper
#================================================================
# helper para criação do item do formulario

  def cpf_cnpj_ecm_new_form_item
    view = ""
     view.concat("Item Texto")
     view.concat("<li>Este campo receberá valores de CPF/CNPJ</li>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Tipo:")
          view.concat(select "opcoes", :tipo, [["CPF", 1], ["CNPJ", 2], ["CPF/CNPJ", 3]])
          view.concat("<li>Informe o Tipo de Campo!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Aceitar Campo Nulo:")
          view.concat(select "opcoes", :nulo, [["Não", 0], ["Sim", 1]])
          view.concat("<li>Informe o Tipo de Campo!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Impedir Duplicação no Registro<br/>")
          view.concat(select "opcoes", :unico, [["Ativo", 1], ["Inativo", 0]])
          view.concat("<li>O campo não aceitará dois registros com o mesmo valor!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat(submit_tag("Salvar Item"))
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("</table>")
     view.concat("</table>")
  end
#-------------------------------------------------------------------------------

#===============================================================================
# Helper para edição do item no formulario

  def cpf_cnpj_ecm_edit_form_item(form_item)
    view = ""
     view.concat("Item Texto")
     view.concat("<li>Este campo receberá valores de CPF/CNPJ</li>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Tipo:")
          view.concat(select "opcoes", :tipo, [["CPF", 1], ["CNPJ", 2], ["CPF/CNPJ", 3]], :selected=>form_item.opcoes[:tipo].to_i)
          view.concat("<li>Informe o Tipo de Campo!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Aceitar Campo Nulo:")
          view.concat(select "opcoes", :nulo, [["Não", 0], ["Sim", 1]], :selected=>form_item.opcoes[:tipo].to_i)
          view.concat("<li>Informe o Tipo de Campo!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Impedir Duplicação no Registro<br/>")
          view.concat(select "opcoes", :unico, [["Não", 0], ["Sim", 1]])
          view.concat("<li>O campo não aceitará dois registros com o mesmo valor!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat(submit_tag("Salvar Item"))
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("</table>")
     view.concat("</table>")
  end
#-------------------------------------------------------------------------------

  def cpf_cnpj_ecm_show_form_item(form_item)
    view = ""
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Tipo")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(form_item.opcoes[:tipo])
      view.concat("</td>")
    view.concat("</tr>")
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Impedir Duplicação no Registro<br/>")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(status(form_item.opcoes[:unico]))
      view.concat("</td>")
    view.concat("</tr>")
  end

#===============================================================================
# helper de cadastro

  def cpf_cnpj_ecm_new_cadastro_item(form_item, params)
    view = ""
    unless params
       if form_item.opcoes[:tipo] == "1"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"999.999.999-99"})
       elsif form_item.opcoes[:tipo] == "2"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"99.999.999/0009-99"})
       else
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}")
       end
    else
       if form_item.opcoes[:tipo] == "1"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"999.999.999-99", :value=>params["item_#{form_item.id}"]})
       elsif form_item.opcoes[:tipo] == "2"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"99.999.999/0009-99", :value=>params["item_#{form_item.id}"]})
       else
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", :value=>params["item_#{form_item.id}"])
       end
    end
    return view
  end

  def cpf_cnpj_ecm_edit_cadastro_item(form_item, cadastro_item, params)
    view = ""
    unless params
       if form_item.opcoes[:tipo] == "1"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"999.999.999-99",:value=>cadastro_item.conteudo})
       elsif form_item.opcoes[:tipo] == "2"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"99.999.999/0009-99",:value=>cadastro_item.conteudo})
       else
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}",:value=>cadastro_item.conteudo)
       end
    else
       if form_item.opcoes[:tipo] == "1"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"999.999.999-99", :value=>params["item_#{form_item.id}"]})
       elsif form_item.opcoes[:tipo] == "2"
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", options={:mask=>"99.999.999/0009-99", :value=>params["item_#{form_item.id}"]})
       else
         view.concat(masked_text_field :cadastro, "item_#{form_item.id}", :value=>params["item_#{form_item.id}"])
       end
    end
    return view
  end

  def cpf_cnpj_ecm_find_cadastro_item(form_item)
    view = ""
    view.concat(text_field :cadastro, "item_#{form_item.id}")
    return view
  end


  def cpf_cnpj_ecm_show_cadastro_item(form_item, cadastro_item)
    return cadastro_item.conteudo
  end

  def cpf_cnpj_ecm_show_filtro_cadastro_item(form_item, cadastro_item)
    return cadastro_item.conteudo
  end

  def cpf_cnpj_ajax
  end
end

