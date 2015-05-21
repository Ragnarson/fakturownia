module Fakturownia
  module Api
    class Base
      include DefaultCrud
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def connection
        @connection ||= Fakturownia::Connection.new(client)
      end
    end
  end
end
