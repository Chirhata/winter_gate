class AddIorS < ActiveRecord::Migration[5.2]
  def change
    add_column :money_managements, :income_or_supend, :text
  end
end
