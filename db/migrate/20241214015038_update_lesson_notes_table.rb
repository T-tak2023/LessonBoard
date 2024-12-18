class UpdateLessonNotesTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :lesson_notes, :lesson_date, :datetime
    add_column :lesson_notes, :start_time, :datetime
    add_column :lesson_notes, :end_time, :datetime
  end
end
