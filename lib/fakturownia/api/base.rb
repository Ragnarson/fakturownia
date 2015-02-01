module Fakturownia
  module Api
    class Base
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
