require 'spec_helper'

describe Fakturownia::Connection do
  let(:client) { Fakturownia::Client.new(subdomain: 'test', api_token: '123') }
  subject { Fakturownia::Connection.new(client) }

  describe "#request" do
    it "should get request parameters" do
      expect(RestClient::Request).to receive(:execute).with(
        {method: :get,
         url: "https://test.fakturownia.pl/invoices.json",
         headers: {accept: :json, content_type: :json, params: {api_token: '123'}}
        }
      )
      subject.request(:get, "/invoices", {sth: "foo"})
    end

    it "should pass response to process_response method" do
      response = double(RestClient::Response)
      request = double(RestClient::Request)
      expect(subject).to receive(:process_response).with(response)
      allow(RestClient::Request).to receive(:execute).and_yield(response, request)
      subject.request("/invoices", :get)
    end
  end


  describe "#process_response" do
    let(:response) { double(RestClient::Response, code: 200, body: "{}",
      return!: nil) }
    let(:request) { double(RestClient::Request) }

    before do
      allow(RestClient::Request).to receive(:execute).and_yield(response, request)
    end

    it "should not follow redirections" do
      expect(response).to receive(:return!)
      subject.get('/invoices')
    end

    it "should parse JSON" do
      allow(response).to receive(:body).and_return({ok: true}.to_json)
      expect(subject.get("/invoices")).to eq('ok' => true)
    end

    it "should return body for PDF" do
      allow(subject).to receive(:format).and_return(:pdf)
      allow(response).to receive(:body).and_return("pdf content")
      expect(subject.get("/invoices")).to eq("pdf content")
    end

    it "should return empty hash if response is not a valid JSON" do
      expect(JSON).to receive(:parse).with("").and_raise(JSON::ParserError)
      allow(response).to receive(:body).and_return("")
      expect(subject.post("/invoices")).to eq({})
    end

    context "on unsupported response" do
      it "should raise generic APIException" do
        allow(response).to receive(:code).and_return(500)
        allow(response).to receive(:body).and_return("")
        expect { subject.post("/") }.to raise_error { |error|
          expect(error).to be_a(Fakturownia::APIException)
          expect(error.body).to eq("")
          expect(error.code).to eq(500)
        }
      end
    end
  end

  describe "#get" do
    it "should make GET request to given path" do
      expect(subject).to receive(:request).with(:get, "/invoices", {})
      subject.get("/invoices")
    end
  end

  describe "#post" do
    it "should make POST request to given path with parameters" do
      expect(subject).to receive(:request).with(:post, "/invoices", name: "pink-one")
      subject.post("/invoices", name: "pink-one")
    end
  end

  describe "#put" do
    it "should make PUT resquest to given path with parameters" do
      expect(subject).to receive(:request).with(:put, "/invoices", name: "new-one")
      subject.put("/invoices", name: "new-one")
    end
  end

  describe "#delete" do
    it "should make DELETE request to given path with parameters" do
      expect(subject).to receive(:request).with(:delete, "/invoices", name: "new-one")
      subject.delete("/invoices", name: "new-one")
    end

    it "should make DELETE request to apps with parameters" do
      expect(subject).to receive(:request).with(:delete, "/invoices/1", {})
      subject.delete("/invoices/1")
    end
  end
end
