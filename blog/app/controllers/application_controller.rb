class ApplicationController < ActionController::Base
  #protect_from_forgery

  def authenticate
    begin
      @person = Person.find(session[:id])
    rescue
      @person = nil
    end
    
    unless @person
      flash[:error] = "You must be logged."      
      redirect_to(posts_path)
    end
  end


end
