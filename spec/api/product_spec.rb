require 'spec_helper'

describe Fakturownia::Api::Product do
  let(:client) { Fakturownia::Client.new(subdomain: 'test', api_token: 'abcd') }
  let(:product_hash) { { id: 1234, name: 'example name', code: 'P1234', price_net: 150, tax: 23, description: 'example description'} }

  describe '#list' do
    before { stub_request(:get, 'https://test.fakturownia.pl/products.json?api_token=abcd').to_return(status: 200, body: [product_hash].to_json) }
    subject { client.products.list }

    it 'returns list of products' do
      expect(subject).to be_instance_of(Array)
      expect(subject[0]['id']).to eq(product_hash[:id])
      expect(subject[0]['name']).to eq(product_hash[:name])
      expect(subject[0]['code']).to eq(product_hash[:code])
      expect(subject[0]['price_net']).to eq(product_hash[:price_net])
      expect(subject[0]['tax']).to eq(product_hash[:tax])
      expect(subject[0]['description']).to eq(product_hash[:description])
    end
  end

  describe '#show' do
    context 'with no id given' do
      it { expect { client.products.show }.to raise_error(ArgumentError) }
    end

    context 'with not existing product id given' do
      before { stub_request(:get, 'https://test.fakturownia.pl/products/9999.json?api_token=abcd').to_return(status: 404, body: 'Not Found') }
      it { expect { client.products.show(9999) }.to raise_error(Fakturownia::APIException) }
    end

    context 'with existing product id given' do
      before { stub_request(:get, "https://test.fakturownia.pl/products/#{product_hash[:id]}.json?api_token=abcd").to_return(status: 200, body: product_hash.to_json) }
      subject { client.products.show(product_hash[:id]) }

      it 'returns product' do
        expect(subject).to be_instance_of(Hash)
        expect(subject['id']).to eq(product_hash[:id])
        expect(subject['name']).to eq(product_hash[:name])
        expect(subject['code']).to eq(product_hash[:code])
        expect(subject['price_net']).to eq(product_hash[:price_net])
        expect(subject['tax']).to eq(product_hash[:tax])
        expect(subject['description']).to eq(product_hash[:description])
      end
    end
  end

  describe '#create' do
    context 'without product params given' do
      it { expect { client.products.create }.to raise_error(ArgumentError) }
    end

    context 'with product params given' do
      before { stub_request(:post, 'https://test.fakturownia.pl/products.json?api_token=abcd')
        .with(body: { product: product_hash.except(:id) }.to_json, headers: { accept: 'application/json', content_type: 'application/json' }).to_return(status: 201, body: product_hash.except(:id).to_json) }
      subject { client.products.create(product_hash.except(:id)) }
      
      it 'returns created product' do
        expect(subject).to be_instance_of(Hash)
        expect(subject['id']).to_not eq(product_hash[:id])
        expect(subject['name']).to eq(product_hash[:name])
        expect(subject['code']).to eq(product_hash[:code])
        expect(subject['price_net']).to eq(product_hash[:price_net])
        expect(subject['tax']).to eq(product_hash[:tax])
        expect(subject['description']).to eq(product_hash[:description])        
      end
    end
  end

  describe '#update' do
    context 'without id given' do
      it { expect { client.products.update }.to raise_error(ArgumentError) }
    end

    context 'with product id' do
      context 'without attributes given' do
        it { expect { client.products.update(product_hash[:id]) }.to raise_error(ArgumentError) }
      end

      context 'with attributes given' do
        let(:new_product_hash) { { name: 'this is new name', code: 'CC22', tax: 19, description: 'this is new description' } }
        before { stub_request(:put, "https://test.fakturownia.pl/products/#{product_hash[:id]}.json?api_token=abcd")
          .with(body: { product: new_product_hash }.to_json, headers: { accept: 'application/json', content_type: 'application/json' }).to_return(status: 200, body: new_product_hash.merge(id: product_hash[:id]).to_json) }
        subject { client.products.update(product_hash[:id], new_product_hash) }
        
        it 'returns updated product' do
          expect(subject).to be_instance_of(Hash)
          expect(subject['id']).to eq(product_hash[:id])
          expect(subject['name']).to eq(new_product_hash[:name])
          expect(subject['code']).to eq(new_product_hash[:code])
          expect(subject['price_net']).to eq(new_product_hash[:price_net])
          expect(subject['tax']).to eq(new_product_hash[:tax])
          expect(subject['description']).to eq(new_product_hash[:description])
        end
      end
    end
  end

  describe '#delete' do
    context 'without id given' do
      it { expect { client.products.delete }.to raise_error(ArgumentError) }
    end

    context 'with not existing product id given' do
      before { stub_request(:delete, 'https://test.fakturownia.pl/products/9999.json?api_token=abcd').to_return(status: 404, body: 'Not Found') }
      it { expect { client.products.delete(9999) }.to raise_error(Fakturownia::APIException) }
    end

    context 'with existing product id given' do
      before { stub_request(:delete, "https://test.fakturownia.pl/products/#{product_hash[:id]}.json?api_token=abcd").to_return(status: 200, body: 'ok') }
      subject { client.products.delete(product_hash[:id]) }

      it 'returns empty hash' do
        expect(subject).to be_instance_of(Hash)
        expect(subject).to be_empty
      end
    end
  end
end