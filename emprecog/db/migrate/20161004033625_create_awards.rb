class CreateAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awards do |t|
      t.string :type
      t.datetime :granted

      t.timestamps
    end
  end
end
