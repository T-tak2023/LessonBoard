class AddStudentMemoToLessonLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :lesson_logs, :student_memo, :text
  end
end
