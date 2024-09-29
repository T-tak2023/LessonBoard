class ChangeVideoMaterialToTextInLessonLogs < ActiveRecord::Migration[7.1]
  def change
    change_column :lesson_logs, :video_material, :text
  end
end
