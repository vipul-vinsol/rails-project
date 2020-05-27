class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.integer :status
      t.string :slug
      t.belongs_to :user

      t.timestamps
    end
  end
end
