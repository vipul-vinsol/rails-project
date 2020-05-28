class CreateQuestionsTopicsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :questions_topics, id: false do |t|
      t.belongs_to :question
      t.belongs_to :topic
    end
  end
end
