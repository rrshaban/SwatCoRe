class AddCreditLabFysWritingToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :credit, :float
    add_column :courses, :lab, :bool
    add_column :courses, :fys, :bool
    add_column :courses, :writing, :bool
  end
end
