class AddNullConstraintToInstructorAndStudentName < ActiveRecord::Migration[7.1]
  def change
    change_column_null :instructors, :instructor_name, false
    change_column_null :students, :student_name, false
  end
end
