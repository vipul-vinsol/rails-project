class CreateProfilesTopicsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles_topics, id: false do |t|
      t.belongs_to :profile
      t.belongs_to :topic
    end
  end
end
