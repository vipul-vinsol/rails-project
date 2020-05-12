class CreateCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_transactions do |t|
      t.integer :amount
      t.integer :reason
      t.belongs_to :user
      t.timestamps
    end
  end
end
