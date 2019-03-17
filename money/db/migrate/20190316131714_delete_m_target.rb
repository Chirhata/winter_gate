class DeleteMTarget < ActiveRecord::Migration[5.2]
  def change
    remove_column :money_managements, :money_limit, :integer
    remove_column :money_managements, :money_limit_day, :date
    remove_column :money_managements, :left_money, :integer
    add_column :users, :money_limit, :integer
    add_column :users, :money_limit_day, :date
  end
end
