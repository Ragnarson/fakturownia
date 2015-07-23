require 'spec_helper'

describe Fakturownia::Api::Invoice do
  let(:client) { Fakturownia::Client.new(subdomain: "test", api_token: "123") }
  subject { described_class.new(client) }
  let(:connection) { subject.connection }

  describe "#list" do
    it "should perform GET request on connection at '/invoices'" do
      expect(connection).to receive(:get).with('/invoices', period: 'this_month')
      subject.list(period: 'this_month')
    end
  end

  describe "#get" do
    it "should perform GET request on connection at '/invoices'" do
      expect(connection).to receive(:get).with('/invoices/123', format: :pdf)
      subject.show(123, format: :pdf)
    end
  end

  describe "#create" do
    it "should perform POST request on connection at '/invoices'" do
      expect(connection).to receive(:post).with('/invoices',
        invoice: {buyer: 'John Doe'})
      subject.create(buyer: 'John Doe')
    end
  end

  describe "#list" do
    it "should perform PUT request on connection at '/invoices'" do
      expect(connection).to receive(:put).with('/invoices/123',
        invoice: {buyer: 'John Doe'})
      subject.update(123, buyer: 'John Doe')
    end
  end

  describe "#list" do
    it "should perform DELETE request on connection at '/invoices'" do
      expect(connection).to receive(:delete).with('/invoices/123')
      subject.delete(123)
    end
  end

  describe "#change_status" do
    it "should perform POST request on connection at /invoices/ID/change_status" do
      expect(connection).to receive(:post).with('/invoices/123/change_status',
        invoice: {status: 'paid'})
      subject.change_status(123, 'paid')
    end
  end
end
