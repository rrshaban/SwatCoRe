class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # def after_sign_in_path_for(resource)
  #   resource_path
  # end

  private

    def get_depts
       @dept_options = Department.all.map{|d| [d.name, d.id]}
    end

    def get_profs
       @prof_options = Professor.all.map{|p| [p.name, p.id]}
    end





end
