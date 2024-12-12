class RemoveLogStatusFromLessonNotes < ActiveRecord::Migration[7.1]
  def change
    remove_column :lesson_notes, :log_status, :string
  end
end
