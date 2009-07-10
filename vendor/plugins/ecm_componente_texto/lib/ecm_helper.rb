module EcmHelper
  def texto_new_item
    view = ""
     view.concat(hidden_field "itensformulario", :tipo, :value=>"Texto")
     view.concat("Item Texto")
     view.concat("<li> Este item receberá dados textuais, com tamanho maximo de 255 caracteres.</li>")
     view.concat("<table>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Largura:<br/>")
          view.concat(text_field "opcoes", :largura)
          view.concat("<li>Informe a largura da caixa de texto</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Quant. Caracter:<br/>")
          view.concat(text_field "opcoes", :max_length)
          view.concat("<li>Informe a Quantidade de Caracteres</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Aceita valor Vazio?:")
          view.concat(check_box "opcoes", :nulo)
          view.concat("<li>Informe o campo poderá ser Nulo(vazio)!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Forçar letras maiúsculas:")
          view.concat(check_box "opcoes", :maiusculo)
          view.concat("<li>Forçar o texto a ser maiúsculo!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Remover acentuação:")
          view.concat(check_box "opcoes", :semacento)
          view.concat("<li>Remover as acentuações do texto</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Texto de Exemplo:<br/>")
          view.concat(text_field "opcoes", :exemplo)
          view.concat("<li>Informe um exemplo para o campo, se achar necessário</li>")
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
  def texto_edit_item(opcoes = nil)
    view = ""
     view.concat(hidden_field "itensformulario", :tipo, :value=>"Texto")
     view.concat("Item Texto")
     view.concat("<li> Este item receberá dados textuais, com tamanho maximo de 255 caracteres.</li>")
     view.concat("<table>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Largura:<br/>")
          view.concat(text_field "opcoes", :largura, :value=>opcoes[:largura])
          view.concat("<li>Informe a largura da caixa de texto</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Quant. Caracter:<br/>")
          view.concat(text_field "opcoes", :max_length, :value=>opcoes[:max_length])
          view.concat("<li>Informe a Quantidade de Caracteres</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Aceita valor Vazio?:")
          view.concat(check_box "opcoes", :nulo)
          view.concat("<li>Informe o campo poderá ser Nulo(vazio)!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Forçar letras maiúsculas:")
          view.concat(check_box "opcoes", :maiusculo, :value=>opcoes[:maiusculo])
          view.concat("<li>Forçar o texto a ser maiúsculo!</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Remover acentuação:")
          view.concat(check_box "opcoes", :semacento, :value=>opcoes[:semacento])
          view.concat("<li>Remover as acentuações do texto</li>")
        view.concat("</td>")
      view.concat("</tr>")
      view.concat("<tr>")
        view.concat("<td>")
          view.concat("Texto de Exemplo:<br/>")
          view.concat(text_field "opcoes", :exemplo, :value=>opcoes[:exemplo])
          view.concat("<li>Informe um exemplo para o campo, se achar necessário</li>")
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

  def texto_show_item(opcoes = nil)
    view = ""
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Largura")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(opcoes[:largura])
      view.concat("</td>")
    view.concat("</tr>")
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Quant. Caracter:<br/>")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(opcoes[:max_length])
      view.concat("</td>")
    view.concat("</tr>")
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Sem Acento:<br/>")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(opcoes[:semacento])
      view.concat("</td>")
    view.concat("</tr>")
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Exemplo:<br/>")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(opcoes[:exemplo])
      view.concat("</td>")
    view.concat("</tr>")
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Nulo:<br/>")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(opcoes[:nulo])
      view.concat("</td>")
    view.concat("</tr>")
    view.concat("<tr>")
      view.concat("<td class='lista_item'>")
        view.concat("Maiuscolo:<br/>")
      view.concat("</td>")
      view.concat("<td class='lista_conteudo'>")
        view.concat(opcoes[:maiusculo])
      view.concat("</td>")
    view.concat("</tr>")
  end
end

