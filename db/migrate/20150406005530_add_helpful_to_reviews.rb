class AddHelpfulToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :helpful, :integer
    add_column :reviews, :votes, :integer
    add_column :reviews, :avg, :decimal
  end
end
