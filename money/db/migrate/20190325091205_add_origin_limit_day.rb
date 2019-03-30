class AddOriginLimitDay < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :money_limit_day_origin, :date
  end
end
