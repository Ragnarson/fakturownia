module Fakturownia
  class APIException < Exception
    attr_reader :code, :body

    def initialize(body, code)
      @code = code
      @body = body
    end

    def inspect
      [code, body].join(" - ")
    end
  end
end
