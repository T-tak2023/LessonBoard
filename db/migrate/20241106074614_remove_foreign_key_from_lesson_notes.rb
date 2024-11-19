class RemoveForeignKeyFromLessonNotes < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :lesson_notes, :students
  end
end
