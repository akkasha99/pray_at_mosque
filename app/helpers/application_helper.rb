module ApplicationHelper
  def create_customer_on_braintree(user)
    result = Braintree::Customer.create(
        :first_name => "parent1",
        :last_name => "last name",
        :email => "parent1@gmail.com"
    )
    # puts "----------Brain tree result----------", result.inspect
    if result.success?
      puts "44444444444444444444444444444444444", result.inspect
      user.update_attributes(:customer_id => result.customer.id)
      return true
    else
      # puts "55555555555555555555555555555555555", result.inspect
      puts "---------brain tree customer create error-----------", result.errors
      @user_errors = result.errors
      return false
    end
  end

  def create_payment_information(user, card_info)
    result = Braintree::CreditCard.create(
        :customer_id => user.customer_id,
        :cvv => card_info[:cvv],
        :number => card_info[:card_number],
        :expiration_date => card_info[:expiry_date],
        :cardholder_name => "", #card_info[:card_holder],
        :billing_address => {
            :first_name => card_info[:first_name],
            :last_name => card_info[:last_name],
            :locality => card_info[:city],
            :region => card_info[:state],
            :country_name => card_info[:country],
            :street_address => card_info[:address]
        },
        :options => {
            :verify_card => true,
            :fail_on_duplicate_payment_method => true,
            :make_default => true
        }
    )
    return result
  end

  def update_payment_information(token, cvv, credit_card_number, exp_date, first_name, last_name, city, state, country, address, c_name)
    result = Braintree::CreditCard.update(
        token,
        :cvv => cvv,
        :number => credit_card_number,
        :expiration_date => exp_date,
        :cardholder_name => c_name.present? ? c_name : "",
        :billing_address => {
            :first_name => first_name,
            :last_name => last_name,
            :locality => city,
            :region => state,
            :country_name => country,
            :street_address => address,
        },
        :options => {

            #:verify_card => true,
            #:fail_on_duplicate_payment_method => true,
            :make_default => true
        }
    )
    return result
  end
end
