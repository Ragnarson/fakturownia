require "rest_client"
require "json"

module Fakturownia
  class Connection
    attr_reader :client, :format

    def initialize(client)
      @client = client
    end

    def get(path, options = {})
      @format = options.fetch(:format, :json)
      request(:get, path, options)
    end

    def post(path, options = {})
      request(:post, path, options)
    end

    def put(path, options = {})
      request(:put, path, options)
    end

    def delete(path, options = {})
      request(:delete, path, options)
    end

    def request(method, path, options = {})
      options = request_parameters(method, path, options)
      RestClient::Request.execute(options) do |response, request|
        process_response(response)
      end
    end

    def process_response(response)
      case response.code.to_i
      when 200...300
        body = parse(response)
      else
        raise Fakturownia::APIException.new(response.body, response.code)
      end
      response.return!
      body
    end

    def parse(response)
      case format
      when :json
        JSON.parse(response.body) rescue JSON::ParserError && {}
      when :pdf
        response.body
      else
        raise StandardError.new("Unknown format #{format}")
      end
    end

    def request_parameters(method, path, options = {})
      parameters = {
        method:  method,
        url:     "#{api_url}#{path}.#{format}",
        headers: headers

      }
      unless [:get, :head].include?(method)
        parameters = parameters.merge(payload: options.to_json)
      end
      parameters
    end

    def format
      @format ||= :json
    end

    def api_url
      "https://#{client.subdomain}.fakturownia.pl"
    end

    def headers
      {accept:       :json,
       content_type: :json,
       params: {api_token: client.api_token}
      }
    end
  end
end
