class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.references :notifyable, polymorphic: true
      t.integer :status

      t.timestamps
    end
  end
end
