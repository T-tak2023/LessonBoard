class AddInstructorIdToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :instructor_id, :integer
  end
end
