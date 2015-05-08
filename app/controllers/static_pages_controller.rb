class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user! #, :only => [:home, :help, :about, :contact]
  
  def home
    @recent = Review.order(created_at: :asc).last(10).reverse
    @active = Review.order(updated_at: :asc).last(10).reverse
    @top = Review.order("cached_votes_score DESC").first
  end

  def help
  end

  def about
  end

  def contact
  end

  def stats
  end
end
