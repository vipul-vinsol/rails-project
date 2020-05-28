class AddRoleToUsersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :integer, default: 0, null: false
  end
end
