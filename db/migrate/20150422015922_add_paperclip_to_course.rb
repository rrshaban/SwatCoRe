class AddPaperclipToCourse < ActiveRecord::Migration
  def change
    add_attachment :courses, :syllabus
    add_column :courses, :syllabus_uploader, :integer  
  end
end
