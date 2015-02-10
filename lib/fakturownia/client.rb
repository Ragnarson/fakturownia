module Fakturownia
  class Client
    attr_reader :subdomain, :api_token

    def initialize(options = {})
      @subdomain = options[:subdomain] ||
        raise(ArgumentError.new('subdomain is required'))
      @api_token = options[:api_token] ||
        raise(ArgumentError.new('api_token is required'))
    end

    def invoice
      Fakturownia::Api::Invoice.new(self)
    end
    alias_method :invoices, :invoice
  end
end
