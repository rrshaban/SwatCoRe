class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :department
      t.string :crn

      t.timestamps null: false
    end
  end
end
