class AddCreditsFromUsersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :credits, :integer
  end
end
