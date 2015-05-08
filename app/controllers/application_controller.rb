class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?


  # def after_sign_in_path_for(resource)
  #   resource_path
  # end


  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end

  private 

    # def current_user
    #   User.find(session["warden.user.user.key"][0][0])
    # end

    def get_depts
       @dept_options = Department.all.map{|d| [d.name, d.id]}
    end

    def get_profs
       @prof_options = Professor.all.map{|p| [p.name, p.id]}
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
