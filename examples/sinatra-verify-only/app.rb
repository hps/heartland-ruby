require 'sinatra'
require 'hps'

Hps.configure do |config|
  config.secret_api_key = 'skapi_cert_MTyMAQBiHVEAewvIzXVFcmUd2UcyBge_eCpaASUp0A'
end

service = Hps::HpsChargeService.new

get '/' do
  erb :index
end

post '/charge' do
  card_holder = Hps::HpsCardHolder.new
  card_holder.first_name = request['FirstName']
  card_holder.last_name = request['LastName']
  card_holder.address = Hps::HpsAddress.new
  card_holder.address.address = request['Address']
  card_holder.address.city = request['City']
  card_holder.address.state = request['State']
  card_holder.address.zip = request['Zip']

  token = request['token_value']

  logger.info card_holder
  logger.info token

  verification = service.verify(token, card_holder, true)

  erb :result, :locals => { :verification => verification }
end
