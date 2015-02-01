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
end
