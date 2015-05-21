# Fakturownia

Ruby wrapper around API of invoice service fakturownia.pl

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fakturownia_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fakturownia_api

## Usage

Create a client with `api_token` and `subdomain`:

    client = Fakturownia::Client.new(api_token: 'YOUR_TOKEN', subdomain: 'YOUR_DOMAIN')


### Invoices

Create invoice with ([full list of available options](https://github.com/fakturownia/api/)):

```ruby
invoice = {
  buyer_name: 'Name',
  buyer_tax_no: ''
  positions: [
    {name: 'Product 1', total_price_gross: 10.0, quantity: 2},
    {name: 'Product 2', total_price_gross: 20.0, quantity: 4}
  ]
}

client.invoice.create(ruby_hash)
```

Download invoice as PDF

    client.invoice.show(id, format: :pdf)


You can use singular `client.invoice` or plural method names `client.invoices`.

Other supported resources are products:
```ruby
client.products.create(name: 'example name', price_net: 100)
client.products.show(id)
client.products.update(id, { name: 'new name' })
client.products.delete(id)
client.products.list
```

and clients (your customers):
```ruby
client.clients.create(name: 'example name', email: 'example@email.com')
client.clients.show(id)
client.clients.update(id, { name: 'new name' })
client.clients.delete(id)
client.clients.list
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fakturownia/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes and tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
