class Page::EntidadeController < ApplicationController
  skip_filter :autenticado
  skip_filter :autorizado

  layout 'entidade'

  def show
    @entidade = Entidade.find(params[:id])
  end

end

