require File.join( File.dirname(__FILE__), "test_helper.rb" )

describe "General Tests" do
  
	before(:each) do
    Hps::TestHelper.configure_hps_module()
		@service = Hps::HpsChargeService.new()
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
  
end