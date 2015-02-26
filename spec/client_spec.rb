require 'spec_helper'

describe Fakturownia::Client do
  subject { described_class.new(subdomain: "test", api_token: "123") }

  describe '.new' do
    it 'requires api_token' do
      expect { Fakturownia::Client.new(subdomain: 'test') }.to raise_error(ArgumentError, 'api_token is required')
    end

    it 'requires subdomain' do
      expect { Fakturownia::Client.new(api_token: 'test') }.to raise_error(ArgumentError, 'subdomain is required')
    end
  end

  describe '#invoices' do
    it { expect(subject.invoices).to be_instance_of(Fakturownia::Api::Invoice) }
  end

  describe '#invoice' do
    it 'is an alias of #invoices' do
      expect(subject.invoice).to be_instance_of(subject.invoices.class)
      expect(subject.invoice.client).to be(subject.invoices.client)
    end
  end

  describe '#invoices' do
    it 'is an alias of #invoice' do
      expect(subject.invoices).to be_instance_of(subject.invoice.class)
      expect(subject.invoices.client).to be(subject.invoice.client)
    end
  end

  describe '#products' do
    it { expect(subject.products).to be_instance_of(Fakturownia::Api::Product) }
  end

  describe '#product' do
    it 'is an alias of #products' do
      expect(subject.product).to be_instance_of(subject.products.class)
      expect(subject.product.client).to be(subject.products.client)
    end
  end

  describe '#clients' do
    it { expect(subject.client).to be_instance_of(Fakturownia::Api::Client) }
  end

  describe '#client' do
    it 'is an alias of #clients' do
      expect(subject.client).to be_instance_of(subject.clients.class)
      expect(subject.client.client).to be(subject.clients.client)
    end
  end
end
