class DelOldPasswor < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :o_password, :string
    add_column :users, :re_password, :string
  end
end
