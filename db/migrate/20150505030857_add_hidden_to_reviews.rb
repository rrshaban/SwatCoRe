class AddHiddenToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :hidden, :boolean, :default => false
  end
end
