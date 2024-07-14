class AddDetailsToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :student_name, :string
    add_column :students, :course, :string
    add_column :students, :icon_image, :string
  end
end
