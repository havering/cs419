class AddGrantedByToAwards < ActiveRecord::Migration[5.0]
  def change
    add_column :awards, :given_by, :integer
  end
end
