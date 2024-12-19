class AddLocationToLessonsAndLessonNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :location, :string
    add_column :lesson_notes, :location, :string
  end
end
