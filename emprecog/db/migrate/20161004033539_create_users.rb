class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password
      t.blob :signature
      t.string :role

      t.timestamps
    end
  end
end
