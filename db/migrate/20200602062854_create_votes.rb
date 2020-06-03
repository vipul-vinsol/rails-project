class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :vote_type
      t.belongs_to :user
      t.bigint  :voteable_id
      t.string  :voteable_type

      t.timestamps
    end
  end
end
