class Core::LoginController < ApplicationController
  skip_before_filter :autenticado
  skip_before_filter :autorizado
  layout "home"

  def index
    session[:sessao_atual]=nil
  end

  def create
    session[:sessao_atual]=nil
    sessao_id = Usuario.login(params[:login][:usuario], params[:login][:senha], request.remote_ip)
    if sessao_id
      session[:sessao_atual] = sessao_id
      redirect_to "/intranet"
    else
      session[:sessao_atual]=nil
      flash[:notice] = "Usuario ou senha Invalidos"
      render :action=>"index"
    end
  end

  def logout
    sessao = Sessao.find(session[:sessao_atual])
    sessao.status = false
    sessao.save
    session[:sessao_atual]=nil
    redirect_to "/intranet"
  end
end

