class PaymentInformation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :expiry_date, :cvv, :card_number, :user_id
end
