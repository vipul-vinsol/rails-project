class RemoveCreditsFromProfilesTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :credits, :integer
  end
end
