class TransactionHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_information
end
