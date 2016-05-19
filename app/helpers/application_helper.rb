module ApplicationHelper
  # def create_customer_on_braintree(user)
  #   result = Braintree::Customer.create(
  #       :first_name => "parent1",
  #       :last_name => "last name",
  #       :email => "parent1@gmail.com"
  #   )
  #   # puts "----------Brain tree result----------", result.inspect
  #   if result.success?
  #     puts "44444444444444444444444444444444444", result.inspect
  #     user.update_attributes(:customer_id => result.customer.id)
  #     return true
  #   else
  #     # puts "55555555555555555555555555555555555", result.inspect
  #     puts "---------brain tree customer create error-----------", result.errors
  #     @user_errors = result.errors
  #     return false
  #   end
  # end

  def create_payment_information(user, card_info)
    result = Braintree::CreditCard.create(
        :customer_id => user.customer_id,
        :cvv => card_info[:cvv],
        :number => card_info[:card_number],
        :expiration_date => card_info[:expiry_date],
        :cardholder_name => card_info[:card_holder],
        :billing_address => {
            :first_name => card_info[:first_name],
            :last_name => card_info[:last_name],
            :locality => card_info[:city],
            :region => card_info[:state],
            :country_name => card_info[:country],
            :street_address => card_info[:address]
        },
        :options => {
            # :verify_card => true,
            # :fail_on_duplicate_payment_method => true,
            :make_default => true
        }
    )
    return result
  end

  def update_payment_information(card_info, token)
    result = Braintree::CreditCard.update(
        token,
        :cvv => card_info[:cvv],
        :number => card_info[:card_number],
        :expiration_date => card_info[:expiry_date],
        :cardholder_name => card_info[:card_holder],
        :billing_address => {
            :first_name => card_info[:first_name],
            :last_name => card_info[:last_name],
            :locality => card_info[:city],
            :region => card_info[:state],
            :country_name => card_info[:country],
            :street_address => card_info[:address]
        },
        :options => {

            #:verify_card => true,
            #:fail_on_duplicate_payment_method => true,
            :make_default => true
        }
    )
    return result
  end

    def parent_transaction(user, amount, user_payment_information)
    result = Braintree::Transaction.sale(
        :customer_id => user.customer_id,
        :amount => amount,
        :payment_method_token => user_payment_information.payment_method_token,
        :options => {
            :submit_for_settlement => true
        }
    )
    return result
  end
end
