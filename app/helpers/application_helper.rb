# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def f_data(d)
      "#{d.to_s[8..9]}/#{d.to_s[5..6]}/#{d.to_s[0..3]}"
  end

  def status(valor)
    if valor == true or valor == 1 or valor == "1"
      return "Ativo"
    else
      return "Inativo"
    end
  end

#====================================================================
# form_item
# esses helpers sao usados para a configuraçãos dos intens do
# formulario na criação de cada item

  def ecm_new_form_item(componente)
    eval("#{componente}_ecm_new_form_item")
  end

  def ecm_edit_form_item(form_item)
    eval("#{form_item.componente}_ecm_edit_form_item(form_item)")
  end

  def ecm_show_form_item(form_item)
    eval("#{form_item.componente}_ecm_show_form_item(form_item)")
  end
# ------------------------------------------------------------------

#====================================================================
# Cadastro_item
# esses helpers sao usados para a configuraçãos dos intens do
# Cadastro na criação de cada item

  def ecm_new_cadastro_item(form_item, params = nil)
    eval("#{form_item.componente}_ecm_new_cadastro_item(form_item, params)")
  end

  def ecm_edit_cadastro_item(form_item, cadastro_item, params = nil)
    eval("#{form_item.componente}_ecm_edit_cadastro_item(form_item, cadastro_item, params)")
  end

  def ecm_show_cadastro_item(form_item, cadastro_item)
    eval("#{form_item.componente}_ecm_show_cadastro_item(form_item, cadastro_item)")
  end
end

