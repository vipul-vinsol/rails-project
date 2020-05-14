class AddRoleToUsersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :string, default: 'normal', null: false
  end
end
