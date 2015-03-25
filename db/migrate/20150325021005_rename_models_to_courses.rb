class RenameModelsToCourses < ActiveRecord::Migration
  def change
    rename_table :models, :courses
  end
end
