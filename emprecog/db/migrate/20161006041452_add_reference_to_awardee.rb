class AddReferenceToAwardee < ActiveRecord::Migration[5.0]
  def change
    add_column :awards, :name, :string
    add_column :awards, :email, :string
  end
end
