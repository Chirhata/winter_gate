class CreateMoneyManagements < ActiveRecord::Migration[5.2]
  def change
    create_table :money_managements do |t|

      t.timestamps
    end
  end
end
