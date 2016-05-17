class CreateTransactionHistories < ActiveRecord::Migration
  def change
    create_table :transaction_histories do |t|
      t.references :user, index: true, foreign_key: true
      t.references :payment_information, index: true, foreign_key: true
      t.string :transaction_id
      t.string :status
      t.string :transaction_type
      t.float :transaction_amount
      t.float :braintree_fee
      t.float :petaway_fee
      t.timestamps null: false
    end
  end
end
