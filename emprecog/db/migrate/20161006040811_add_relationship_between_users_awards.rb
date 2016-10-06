class AddRelationshipBetweenUsersAwards < ActiveRecord::Migration[5.0]
  def change
    # this is for the reference to the user who created the award, not the user receiving
    add_reference :awards, :user, index: true, foreign_key: true
  end
end
