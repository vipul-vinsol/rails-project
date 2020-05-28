class AddingIndexToNameInTopicsAndReasonInCreditTransactionsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :topics, :name, unique: true
    add_index :credit_transactions, :reason
  end
end
