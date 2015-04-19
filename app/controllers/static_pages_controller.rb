class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user! #, :only => [:home, :help, :about, :contact]
  
  def home
    @reviews = Review.order(created_at: :asc).last(10).reverse
  end

  def help
  end

  def about
  end

  def contact
  end
end
