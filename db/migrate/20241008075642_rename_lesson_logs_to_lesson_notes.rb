class RenameLessonLogsToLessonNotes < ActiveRecord::Migration[7.1]
  def change
    rename_table :lesson_logs, :lesson_notes
  end
end
