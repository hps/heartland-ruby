require File.join( File.dirname(__FILE__), "test_helper" )

describe "Secret Key Tests" do
  
  it "can charge with secret key" do
    Hps::TestHelper.configure_hps_module_secret_key()
    service = Hps::HpsChargeService.new()
    charge = service.charge(1.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder)
    expect(charge.response_code).to eql("00")
  end
  
end