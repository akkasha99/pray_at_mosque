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
end
