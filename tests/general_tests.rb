require File.join( File.dirname(__FILE__), "test_helper.rb" )

describe "General Tests" do

	before(:each) do
    Hps::TestHelper.configure_hps_module()
		@service = Hps::HpsChargeService.new()
	end

  it "SecretAPIKey with spaces on Visa charge should return OK" do
    Hps::TestHelper.configure_hps_module_secret_key_with_spaces
	@service = Hps::HpsChargeService.new()
    result = @service.charge(5, "usd", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    expect(result.response_code).to eql("00")
  end


  it "charge when amount is less than zero should throw invalid request exception" do
    expect {
      @service.charge(-5, "usd", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    }.to raise_error(Hps::InvalidRequestException)
  end

  it "charge when currency is empty should throw invalid request exception" do
    expect {
      @service.charge(50, "", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    }.to raise_error(Hps::InvalidRequestException)
  end

  it "charge when currency is not usd should throw invalid request exception" do
    expect {
      @service.charge(50, "eur", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    }.to raise_error(Hps::InvalidRequestException)
  end

  it "charge when configuration is invalid should throw hps exception" do
    expect {
      @service = Hps::HpsChargeService.new :service_uri => nil
      @service.charge(50, "usd", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    }.to raise_error(Hps::HpsException)
  end

  it "charge when license_id is invalid should throw authentication exception" do
    expect {
      @service = Hps::HpsChargeService.new :license_id => 11111
      @service.charge(50, "usd", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    }.to raise_error(Hps::AuthenticationException)
  end

  it "charge when card number is invalid should throw hps exception" do
    expect {
      @service.charge(50, "usd", Hps::TestData::invalid_card, Hps::TestData::valid_cardholder)
    }.to raise_error(Hps::HpsException)
  end

  it "list when charge is in filter range should show in list" do
    start_date = DateTime.now - 12.hours
    charge = @service.charge(50, "usd", Hps::TestData::valid_visa, Hps::TestData::valid_cardholder)
    end_date = DateTime.now

    charges = @service.list(start_date, end_date)
    expect(charges).to have_at_least(1).items
    expect(charges.any? { |c| c.transaction_id = charge.transaction_id }).to be_true
  end

  it "updates multi-use token" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    verify = service.verify(Hps::TestData::valid_visa, Hps::TestData.valid_cardholder, true)
    expect(verify).not_to be_nil
    expect(verify.response_code).to eql("85")
    expect(verify.token_data).not_to be_nil
    expect(verify.token_data.token_value).not_to be_nil
    expect(verify.token_data.token_value).not_to be_empty

    month = Time.now.strftime('%m')
    year = (Time.now + 2.years).strftime('%Y')
    result = service.update_token_expiration(verify.token_data.token_value, month, year)
    expect(result).not_to be_nil
    expect(result.response_code).to eql("00")
  end

  it "fails to update multi-use token with bad year" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    verify = service.verify(Hps::TestData::valid_visa, Hps::TestData.valid_cardholder, true)
    expect(verify).not_to be_nil
    expect(verify.response_code).to eql("85")
    expect(verify.token_data).not_to be_nil
    expect(verify.token_data.token_value).not_to be_nil
    expect(verify.token_data.token_value).not_to be_empty

    month = nil
    year = 19

    expect {
      service.update_token_expiration(verify.token_data.token_value, month, year)
    }.to raise_error(TypeError)
  end

  it "fails to update multi-use token with nil date" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    verify = service.verify(Hps::TestData::valid_visa, Hps::TestData.valid_cardholder, true)
    expect(verify).not_to be_nil
    expect(verify.response_code).to eql("85")
    expect(verify.token_data).not_to be_nil
    expect(verify.token_data.token_value).not_to be_nil
    expect(verify.token_data.token_value).not_to be_empty

    month = nil
    year = nil

    expect {
      service.update_token_expiration(verify.token_data.token_value, month, year)
    }.to raise_error(TypeError)
  end

  it "fails to update multi-use token with invalid token" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    month = Time.now.strftime('%m')
    year = (Time.now + 2.years).strftime('%Y')

    expect {
      service.update_token_expiration("abcdefg", month, year)
    }.to raise_error(Hps::HpsException)
  end

  it "fails to update multi-use token with nil token" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    month = Time.now.strftime('%m')
    year = (Time.now + 2.years).strftime('%Y')

    expect {
      service.update_token_expiration(nil, month, year)
    }.to raise_error(Hps::HpsException)
  end

end