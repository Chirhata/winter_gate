class AddIncome < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :income, :integer
    add_column :users, :money_limit_origin, :integer
  end
end
