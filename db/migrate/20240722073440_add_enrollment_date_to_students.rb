class AddEnrollmentDateToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :enrollment_date, :date
  end
end
