module Fakturownia
  module Api
    class Invoice < Base
      def list(options = {})
        connection.get("/invoices", options)
      end

      def show(id, options = {})
        connection.get("/invoices/#{id}", options)
      end

      def create(params)
        connection.post("/invoices", invoice: params)
      end

      def update(id, params)
        connection.put("/invoices/#{id}", invoice: params)
      end

      def delete(id)
        connection.delete("/invoices/#{id}")
      end

      def change_status(id, status)
        connection.post("/invoices/#{id}/change_status",
          invoice: {status: status})
      end
    end
  end
end
