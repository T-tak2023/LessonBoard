class AddIconImageToInstructors < ActiveRecord::Migration[7.1]
  def change
    add_column :instructors, :icon_image, :string
  end
end
