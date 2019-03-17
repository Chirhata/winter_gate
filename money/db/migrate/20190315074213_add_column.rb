class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :money_managements, :income_and_spending, :integer
    add_column :money_managements, :use_for, :text
    add_column :money_managements, :money_limit, :integer
    add_column :money_managements, :money_limit_day, :date
    add_column :money_managements, :left_money, :integer
  end
end
