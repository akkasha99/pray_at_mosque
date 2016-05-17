class CreatePaymentInformations < ActiveRecord::Migration
  def change
    create_table :payment_informations do |t|
      t.references :user, index: true, foreign_key: true

      t.string :first_name
      t.string :last_name
      t.string :card_holder
      t.string :card_number
      t.string :expiry_date
      t.string :payment_method_token
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :cvv
      t.boolean :is_active
      t.string :card_type
      t.string :customer_id
      t.boolean :status

      t.timestamps null: false
    end
  end
end
