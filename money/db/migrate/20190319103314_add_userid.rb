class AddUserid < ActiveRecord::Migration[5.2]
  def change
    add_column :money_managements, :user_id, :integer
  end
end
