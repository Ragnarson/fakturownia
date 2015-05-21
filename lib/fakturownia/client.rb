module Fakturownia
  class Client
    attr_reader :subdomain, :api_token

    def initialize(options = {})
      @subdomain = options[:subdomain] ||
        raise(ArgumentError.new('subdomain is required'))
      @api_token = options[:api_token] ||
        raise(ArgumentError.new('api_token is required'))
    end

    def invoices
      Fakturownia::Api::Invoice.new(self)
    end
    alias_method :invoice, :invoices

    def products
      Fakturownia::Api::Product.new(self)
    end
    alias_method :product, :products

    def clients
      Fakturownia::Api::Client.new(self)
    end
    alias_method :client, :clients
  end
end
