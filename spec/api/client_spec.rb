require 'spec_helper'

describe Fakturownia::Api::Client do
  let(:client) { Fakturownia::Client.new(subdomain: 'test', api_token: 'abcd') }
  let(:client_hash) { { id: 1234, name: 'example name', tax_no: '5252445767', bank: 'example_bank', bank_account: 'bank_account_example', city: 'example city', country: 'poland', email: 'example@mail.com', person: 'some_person', post_code: 'post-code', phone: '555666777', street: 'example street', street_no: 'street-no' } }

  describe '#list' do
    before { stub_request(:get, 'https://test.fakturownia.pl/clients.json?api_token=abcd').to_return(status: 200, body: [client_hash].to_json) }
    subject { client.clients.list }

    it 'returns list of clients' do
      expect(subject).to be_instance_of(Array)
      expect(subject[0]['id']).to eq(client_hash[:id])
      expect(subject[0]['name']).to eq(client_hash[:name])
      expect(subject[0]['tax_no']).to eq(client_hash[:tax_no])
      expect(subject[0]['bank']).to eq(client_hash[:bank])
      expect(subject[0]['bank_account']).to eq(client_hash[:bank_account])
      expect(subject[0]['city']).to eq(client_hash[:city])
      expect(subject[0]['country']).to eq(client_hash[:country])
      expect(subject[0]['email']).to eq(client_hash[:email])
      expect(subject[0]['person']).to eq(client_hash[:person])
      expect(subject[0]['post_code']).to eq(client_hash[:post_code])
      expect(subject[0]['phone']).to eq(client_hash[:phone])
      expect(subject[0]['street']).to eq(client_hash[:street])
      expect(subject[0]['street_no']).to eq(client_hash[:street_no])
    end
  end

  describe '#show' do
    context 'with no id given' do
      it { expect { client.clients.show }.to raise_error(ArgumentError) }
    end

    context 'with not existing client id given' do
      before { stub_request(:get, "https://test.fakturownia.pl/clients/9999.json?api_token=abcd").to_return(status: 404, body: 'Not Found') }
      it { expect { client.clients.show(9999) }.to raise_error(Fakturownia::APIException) }
    end

    context 'with existing product id given' do
      before { stub_request(:get, "https://test.fakturownia.pl/clients/#{client_hash[:id]}.json?api_token=abcd").to_return(status: 200, body: client_hash.to_json) }
      subject { client.clients.show(client_hash[:id]) }

      it 'returns client' do
        expect(subject).to be_instance_of(Hash)
        expect(subject['id']).to eq(client_hash[:id])
        expect(subject['name']).to eq(client_hash[:name])
        expect(subject['tax_no']).to eq(client_hash[:tax_no])
        expect(subject['bank']).to eq(client_hash[:bank])
        expect(subject['bank_account']).to eq(client_hash[:bank_account])
        expect(subject['city']).to eq(client_hash[:city])
        expect(subject['country']).to eq(client_hash[:country])
        expect(subject['email']).to eq(client_hash[:email])
        expect(subject['person']).to eq(client_hash[:person])
        expect(subject['post_code']).to eq(client_hash[:post_code])
        expect(subject['phone']).to eq(client_hash[:phone])
        expect(subject['street']).to eq(client_hash[:street])
        expect(subject['street_no']).to eq(client_hash[:street_no])
      end
    end
  end

  describe '#create' do
    context 'without client params given' do
      it { expect { client.client.create }.to raise_error(ArgumentError) }
    end

    context 'with client params given' do
      before { stub_request(:post, "https://test.fakturownia.pl/clients.json?api_token=abcd").
        with(body: { client: client_hash.except(:id) }.to_json, headers: {accept: 'application/json', content_type: 'application/json'}).to_return(status: 201, body: client_hash.except(:id).to_json) }
      subject { client.clients.create(client_hash.except(:id)) }
      
      it 'returns created client' do
        expect(subject).to be_instance_of(Hash)
        expect(subject['name']).to eq(client_hash[:name])
        expect(subject['tax_no']).to eq(client_hash[:tax_no])
        expect(subject['bank']).to eq(client_hash[:bank])
        expect(subject['bank_account']).to eq(client_hash[:bank_account])
        expect(subject['city']).to eq(client_hash[:city])
        expect(subject['country']).to eq(client_hash[:country])
        expect(subject['email']).to eq(client_hash[:email])
        expect(subject['person']).to eq(client_hash[:person])
        expect(subject['post_code']).to eq(client_hash[:post_code])
        expect(subject['phone']).to eq(client_hash[:phone])
        expect(subject['street']).to eq(client_hash[:street])
        expect(subject['street_no']).to eq(client_hash[:street_no])    
      end
    end
  end

  describe '#update' do
    context 'without id given' do
      it { expect { client.clients.update }.to raise_error(ArgumentError) }
    end

    context 'with product id' do
      context 'without attributes given' do
        it { expect { client.clients.update(client_hash[:id]) }.to raise_error(ArgumentError) }
      end

      context 'with attributes given' do
        let(:new_client_hash) { { phone: '444555666', city: 'some other city', street: 'golden river', street_no: 'str-99' } }
        before { stub_request(:put, "https://test.fakturownia.pl/clients/#{client_hash[:id]}.json?api_token=abcd").
          with(body: { client: new_client_hash }.to_json, headers: {accept: 'application/json', content_type: 'application/json'}).to_return(status: 200, body: client_hash.merge(new_client_hash).to_json) }
        subject { client.clients.update(client_hash[:id], new_client_hash) }
        
        it 'returns updated client' do
          expect(subject).to be_instance_of(Hash)
          expect(subject['phone']).to eq(new_client_hash[:phone])
          expect(subject['city']).to eq(new_client_hash[:city])
          expect(subject['street']).to eq(new_client_hash[:street])
          expect(subject['street_no']).to eq(new_client_hash[:street_no])
          expect(subject['name']).to eq(client_hash[:name])
          expect(subject['tax_no']).to eq(client_hash[:tax_no])
          expect(subject['bank']).to eq(client_hash[:bank])
          expect(subject['bank_account']).to eq(client_hash[:bank_account])
          expect(subject['country']).to eq(client_hash[:country])
          expect(subject['email']).to eq(client_hash[:email])
          expect(subject['person']).to eq(client_hash[:person])
          expect(subject['post_code']).to eq(client_hash[:post_code])
        end
      end
    end
  end

  describe '#delete' do
    context 'without id given' do
      it { expect { client.clients.delete }.to raise_error(ArgumentError) }
    end

    context 'with not existing client id given' do
      before { stub_request(:delete, "https://test.fakturownia.pl/clients/9999.json?api_token=abcd").to_return(status: 404, body: 'Not Found') }
      it { expect { client.clients.delete(9999) }.to raise_error(Fakturownia::APIException) }
    end

    context 'with existing client id given' do
      before { stub_request(:delete, "https://test.fakturownia.pl/clients/#{client_hash[:id]}.json?api_token=abcd").to_return(status: 200, body: 'ok') }
      subject { client.clients.delete(client_hash[:id]) }

      it 'returns empty hash' do
        expect(subject).to be_instance_of(Hash)
        expect(subject).to be_empty
      end
    end
  end
end