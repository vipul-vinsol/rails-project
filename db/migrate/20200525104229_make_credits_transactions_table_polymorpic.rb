class MakeCreditsTransactionsTablePolymorpic < ActiveRecord::Migration[6.0]
  def change
    change_table :credit_transactions do |t|
      t.references :contentable, polymorphic: true, index: true
    end
  end
end
