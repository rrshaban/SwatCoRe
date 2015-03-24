class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :Course
      t.string :name
      t.string :department
      t.string :crn

      t.timestamps null: false
    end
  end
end
