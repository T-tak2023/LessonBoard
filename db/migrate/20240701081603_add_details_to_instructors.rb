class AddDetailsToInstructors < ActiveRecord::Migration[7.1]
  def change
    add_column :instructors, :instructor_name, :string
    add_column :instructors, :course, :string
  end
end
