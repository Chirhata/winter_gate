class DeleteUnhashedPasswordColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :o_password, :string
    remove_column :users, :re_password, :string
  end
end
