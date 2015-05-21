require 'active_support/concern'
require 'active_support/inflector'

module Fakturownia
  module Api
    module DefaultCrud
      extend ActiveSupport::Concern

      def list(options = {})
        connection.get("/#{self.class.resource}", options)
      end

      def show(id, options = {})
        connection.get("/#{self.class.resource}/#{id}", options)
      end

      def create(params)
        connection.post("/#{self.class.resource}", "#{self.class.resource.singularize}": params)
      end

      def update(id, params)
        connection.put("/#{self.class.resource}/#{id}", "#{self.class.resource.singularize}": params)
      end

      def delete(id)
        connection.delete("/#{self.class.resource}/#{id}")
      end

      module ClassMethods
        attr_reader :resource
        def set_resource(resource_name)
          @resource = resource_name.to_s
        end
      end
    end
  end
end