class AddSecurityQuestionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :answer1, :string
    add_column :users, :answer2, :string
    add_column :users, :answer3, :string
  end
end
