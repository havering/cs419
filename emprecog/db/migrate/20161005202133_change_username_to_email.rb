class ChangeUsernameToEmail < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :username, :email
  end
end
