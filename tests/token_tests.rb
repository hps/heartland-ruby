require File.join( File.dirname(__FILE__), 'test_helper' )
require File.join( File.dirname(__FILE__), 'hps_token_service')
require File.join( File.dirname(__FILE__), 'test_data' )

describe 'token_tests' do

  let(:public_key) { Hps::TestHelper.valid_multi_use_public_key}
  let(:token_service) { Hps::HpsTokenService.new(public_key) }


  #Basic single token fetching tests

  it 'Should return a one time use token' do
    token_response = token_service.get_token(Hps::TestData.valid_visa)
    token_response['token_value'].should_not eq(nil)
    token_response['token_value'].should include('supt')
  end

  it 'Should fail getting a token due to bad key' do
    expect { Hps::HpsTokenService.new('bad_key') }.to raise_error('Public API Key must contain at least two underscores')
  end

  it 'Should fail getting an empty JSON response due to bad key' do
    token_service = Hps::HpsTokenService.new('Still_bad_key')
    expect { token_service.get_token(Hps::TestData.valid_visa) }.to raise_error('A JSON text must at least contain two octets!')
  end

  it 'Should fail and return an Error Card not Recognized' do
    card = Hps::TestData.valid_visa
    card.number = '11111111111111111'
    token_response = token_service.get_token(card)
    token_response['error']['message'].should eq('Card number is not a recognized brand.')
  end

  it 'Should fail and return Card Expiration Month invalid' do
    card = Hps::TestData.valid_visa
    card.exp_month = 13
    token_response = token_service.get_token(card)
    token_response['error']['message'].should eq('Card expiration month is invalid.')
  end

  it 'Should fail and return Card Expiration Year invalid' do
    card = Hps::TestData.valid_visa
    card.exp_year = 12
    token_response = token_service.get_token(card)
    token_response['error']['message'].should eq('Card expiration year is invalid.')
  end

  #Charge Testing with a token

  it 'Should get a token from a Amex card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    charge = Hps::TestHelper.charge_token(token['token_value'])

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
  end

  it 'Should get a token from a Discover card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    charge = Hps::TestHelper.charge_token(token['token_value'])

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
  end

  it 'Should get a token from a Master card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    charge = Hps::TestHelper.charge_token(token['token_value'])

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
  end

  it 'Should get a token from a Visa card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    charge = Hps::TestHelper.charge_token(token['token_value'])

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
  end

  # Charge Testing with a multi use token

  it 'Should get a multi use token from a Amex card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    multi_token = charge.token_data.token_value
    charge_multi_token = Hps::TestHelper.charge_token(multi_token)
    charge_multi_token.transaction_id.should_not eq(nil)
    charge_multi_token.response_code.should eq('00')
  end

  it 'Should get a multi use token from a Discover card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    multi_token = charge.token_data.token_value
    charge_multi_token = Hps::TestHelper.charge_token(multi_token)
    charge_multi_token.transaction_id.should_not eq(nil)
    charge_multi_token.response_code.should eq('00')
  end

  it 'Should get a multi use token from a Master card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    multi_token = charge.token_data.token_value
    charge_multi_token = Hps::TestHelper.charge_token(multi_token)
    charge_multi_token.transaction_id.should_not eq(nil)
    charge_multi_token.response_code.should eq('00')
  end

  it 'Should get a multi use token from a Visa card and charge it with out error' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    multi_token = charge.token_data.token_value
    charge_multi_token = Hps::TestHelper.charge_token(multi_token)
    charge_multi_token.transaction_id.should_not eq(nil)
    charge_multi_token.response_code.should eq('00')
  end

  ## Auth Testing with a token

  it 'Should get a token from a Amex card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    auth = Hps::TestHelper.auth_token(token['token_value'])

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
  end

  it 'Should get a token from a Discover card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    auth = Hps::TestHelper.auth_token(token['token_value'])

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
  end

  it 'Should get a token from a Master card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    auth = Hps::TestHelper.auth_token(token['token_value'])

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
  end

  it 'Should get a token from a Visa card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    auth = Hps::TestHelper.auth_token(token['token_value'])

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
  end

  # Authorize Testing with a multi use token

  it 'Should get a multi use token from a Amex card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    auth = Hps::TestHelper.auth_token(token['token_value'],true)

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
    auth.token_data.token_value.should_not eq(nil)

    multi_token = auth.token_data.token_value
    auth_multi_token = Hps::TestHelper.auth_token(multi_token)
    auth_multi_token.transaction_id.should_not eq(nil)
    auth_multi_token.response_code.should eq('00')
  end

  it 'Should get a multi use token from a Discover card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    auth = Hps::TestHelper.auth_token(token['token_value'],true)

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
    auth.token_data.token_value.should_not eq(nil)

    multi_token = auth.token_data.token_value
    auth_multi_token = Hps::TestHelper.auth_token(multi_token)
    auth_multi_token.transaction_id.should_not eq(nil)
    auth_multi_token.response_code.should eq('00')
  end

  it 'Should get a multi use token from a Master card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    auth = Hps::TestHelper.auth_token(token['token_value'],true)

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
    auth.token_data.token_value.should_not eq(nil)

    multi_token = auth.token_data.token_value
    auth_multi_token = Hps::TestHelper.auth_token(multi_token)
    auth_multi_token.transaction_id.should_not eq(nil)
    auth_multi_token.response_code.should eq('00')
  end

  it 'Should get a multi use token from a Visa card and auth it with out error' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    auth = Hps::TestHelper.auth_token(token['token_value'],true)

    auth.transaction_id.should_not eq(nil)
    auth.response_code.should eq('00')
    auth.token_data.token_value.should_not eq(nil)

    multi_token = auth.token_data.token_value
    auth_multi_token = Hps::TestHelper.auth_token(multi_token)
    auth_multi_token.transaction_id.should_not eq(nil)
    auth_multi_token.response_code.should eq('00')
  end

  # Verify Testing with a token

  it 'Should get a token from a Amex card and verify it with out error' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    verify = Hps::TestHelper.verify_token(token['token_value'])

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('00')
  end

  it 'Should get a token from a Discover card and verify it with out error' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    verify = Hps::TestHelper.verify_token(token['token_value'])

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('85')
  end

  it 'Should get a token from a Master card and verify it with out error' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    verify = Hps::TestHelper.verify_token(token['token_value'])

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('85')
  end

  it 'Should get a token from a Visa card and verify it with out error' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    verify = Hps::TestHelper.verify_token(token['token_value'])

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('85')
  end

  # Verify Testing with a multi use token

  it 'Should get a token from a Amex card verify it get a multi token and test with out error' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    verify = Hps::TestHelper.verify_token(token['token_value'],true)

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('00')
    verify.token_data.token_value.should_not eq(nil)

    multi_token = verify.token_data.token_value
    verify_multi_token = Hps::TestHelper.verify_token(multi_token)
    verify_multi_token.transaction_id.should_not eq(nil)
    verify_multi_token.response_code.should eq('00')
  end

  it 'Should get a token from a Discover card verify it get a multi token and test with out error' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    verify = Hps::TestHelper.verify_token(token['token_value'],true)

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('85')
    verify.token_data.token_value.should_not eq(nil)

    multi_token = verify.token_data.token_value
    verify_multi_token = Hps::TestHelper.verify_token(multi_token)
    verify_multi_token.transaction_id.should_not eq(nil)
    verify_multi_token.response_code.should eq('85')
  end

  it 'Should get a token from a Master card verify it get a multi token and test with out error' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    verify = Hps::TestHelper.verify_token(token['token_value'],true)

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('85')
    verify.token_data.token_value.should_not eq(nil)

    multi_token = verify.token_data.token_value
    verify_multi_token = Hps::TestHelper.verify_token(multi_token)
    verify_multi_token.transaction_id.should_not eq(nil)
    verify_multi_token.response_code.should eq('85')
  end

  it 'Should get a token from a Visa card verify it get a multi token and test with out error' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    verify = Hps::TestHelper.verify_token(token['token_value'],true)

    verify.transaction_id.should_not eq(nil)
    verify.response_code.should eq('85')
    verify.token_data.token_value.should_not eq(nil)

    multi_token = verify.token_data.token_value
    verify_multi_token = Hps::TestHelper.verify_token(multi_token)
    verify_multi_token.transaction_id.should_not eq(nil)
    verify_multi_token.response_code.should eq('85')
  end

  # Refund Token Tests

  it 'Should get Amex token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    refund = Hps::TestHelper.refund_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end


  it 'Should get Discover token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    refund = Hps::TestHelper.refund_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end


  it 'Should get MasterCard token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    refund = Hps::TestHelper.refund_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get Visa token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    refund = Hps::TestHelper.refund_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  # Refund Multi Token Tests

  it 'Should get Amex Mulit token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.refund_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get Discover Mulit token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.refund_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get MasterCard Mulit token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.refund_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get Visa Mulit token return should be okay' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.refund_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  # Reverse Token Tests

  it 'Should get Amex token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    refund = Hps::TestHelper.reverse_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end


  it 'Should get Discover token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    refund = Hps::TestHelper.reverse_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end


  it 'Should get MasterCard token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    refund = Hps::TestHelper.reverse_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get Visa token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    refund = Hps::TestHelper.reverse_token(token['token_value'])

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  # Reverse Multi Token Tests

  it 'Should get Amex Mulit token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_amex)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.reverse_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get Discover Mulit token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_discover)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.reverse_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get MasterCard Mulit token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_mastercard)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.reverse_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

  it 'Should get Visa Mulit token reverse should be okay' do
    token = token_service.get_token(Hps::TestData.valid_visa)
    charge = Hps::TestHelper.charge_token(token['token_value'],true)

    charge.transaction_id.should_not eq(nil)
    charge.response_code.should eq('00')
    charge.token_data.token_value.should_not eq(nil)

    refund = Hps::TestHelper.reverse_token(charge.token_data.token_value)

    refund.transaction_id.should_not eq(nil)
    refund.response_code.should eq('00')
  end

end