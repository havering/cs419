class ChangeNameOfTypeInAwards < ActiveRecord::Migration[5.0]
  def change
    rename_column :awards, :type, :award_type
  end
end
