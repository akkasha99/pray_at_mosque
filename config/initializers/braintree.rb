module ActionView
  module Helpers
    module TagHelper
      def tag_options_with_data_encrypted_name(options, escape = true)
        if options['data-encrypted-name']
          options['data-encrypted-name'] = options.delete("name")
        end
        tag_options_without_data_encrypted_name(options, escape)
      end

      alias_method_chain :tag_options, :data_encrypted_name
    end
  end
end

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.logger = Logger.new('log/braintree.log')
Braintree::Configuration.merchant_id = "vqkq77gzkbhg7hhw"
Braintree::Configuration.public_key = 'nz7zjbdd3vt3jwmz'
Braintree::Configuration.private_key = '6f509304a3b4f4c88f211454a8fc5f82'
#Braintree::Configuration.client_side_encryption_key = 'MIIBCgKCAQEA+gkL4bFnoxTUVaHyjARZLm9aeNO22+w78feaYVFj2HTi6mcVOhivms5AjzwHr4XthAUT1LzFEqXhcSp9I/wN/u8J8ELOY4jRFVl9SOLIBe4LozIf0k8VkxfPNLQd+dbL94XbEnAgWJiBTWmYga/NyuJ9cnzoa9JDBfFb+CQxRGXFvLUla5TLugactRWMGKqD7S03ryPQc9LEYTjkoe4hnS6h41+C0y2rPAWSHn3an98DNWyFHaYESOZu'
