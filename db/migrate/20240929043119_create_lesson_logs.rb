class CreateLessonLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :lesson_logs do |t|
      t.references :instructor, foreign_key: true
      t.references :student, foreign_key: true
      t.datetime :lesson_date
      t.text :content
      t.text :instructor_memo
      t.string :image_material
      t.string :video_material
      t.string :log_status

      t.timestamps
    end
  end
end
