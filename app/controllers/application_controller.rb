class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def get_depts
       @dept_options = Department.all.map{|d| [d.name, d.id]}
    end

    def get_profs
       @prof_options = Professor.all.map{|p| [p.name, p.id]}
    end





end
