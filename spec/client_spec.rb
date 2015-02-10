require 'spec_helper'

describe Fakturownia::Client do
  subject { described_class.new(subdomain: "test", api_token: "123") }

  it "api_token is required" do
    expect { Fakturownia::Client.new(subdomain: "test") }.
      to raise_error(ArgumentError, 'api_token is required')
  end

  it "api_token is required" do
    expect { Fakturownia::Client.new(api_token: "test") }.
      to raise_error(ArgumentError, 'subdomain is required')
  end

  describe "#invoice" do
    it "should return Invoice class" do
      expect(Fakturownia::Api::Invoice).to receive(:new).with(subject)
      subject.invoice
    end
  end

  describe '#invoices' do
    it 'is an alias of #invoice' do
      expect(subject.invoices).to be_instance_of(subject.invoice.class)
      expect(subject.invoices.client).to be(subject.invoice.client)
    end
  end
end
