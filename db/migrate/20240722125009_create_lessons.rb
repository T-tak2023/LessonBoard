class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :instructor, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
