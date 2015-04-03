class AddProfessorIdToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :professor, index: true, foreign_key: true
  end
end
