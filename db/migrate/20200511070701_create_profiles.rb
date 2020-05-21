class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.integer :credits
      t.belongs_to :user

      t.timestamps
    end
  end
end
