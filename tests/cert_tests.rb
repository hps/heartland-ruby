require File.join( File.dirname(__FILE__), "test_helper" )

describe "Certification Tests" do
  
	before(:each) do
    Hps::TestHelper.configure_hps_module_for_certification()
		@service = Hps::HpsChargeService.new()
	end
  
  it "A batch should close OK" do
    begin
      service = Hps::HpsBatchService.new
      batch = service.close_batch
      expect(batch).not_to be_nil
    rescue => e
      expect(e.code).to eql("no_open_batch")
    end
  end
  
  it "B visa should charge OK" do
    result = @service.charge(17.01, "usd", Hps::TestData.valid_visa, Hps::TestData.cert_cardholder_shortzip)
    expect(result.response_code).to eql("00")
  end
  
  it "C mastercard should charge OK" do
    result = @service.charge(17.02, "usd", Hps::TestData.valid_mastercard, Hps::TestData.cert_cardholder_shortzip_no_street)
    expect(result.response_code).to eql("00")
  end
  
  it "D discover should charge OK" do
    result = @service.charge(17.03, "usd", Hps::TestData.valid_discover, Hps::TestData.cert_cardholder_longzip_no_street)
    expect(result.response_code).to eql("00")
  end 
  
  it "E amex should charge OK" do
    result = @service.charge(17.04, "usd", Hps::TestData.valid_amex, Hps::TestData.cert_cardholder_shortzip)
    expect(result.response_code).to eql("00")
  end 
  
  it "F jcb should charge OK" do
    result = @service.charge(17.05, "usd", Hps::TestData.valid_jcb, Hps::TestData.cert_cardholder_longzip)
    expect(result.response_code).to eql("00")
  end 
  
  it "G visa should verify OK" do
    result = @service.verify(Hps::TestData.valid_visa)
    expect(result.response_code).to eql("85")
  end 
  
  it "H mastercard should verify OK" do
    result = @service.verify(Hps::TestData.valid_mastercard)
    expect(result.response_code).to eql("85")
  end 
  
  it "I discover should verify OK" do
    result = @service.verify(Hps::TestData.valid_discover)
    expect(result.response_code).to eql("85")
  end 
  
  it "J amex should avs should be OK" do
    result = @service.verify(Hps::TestData.valid_amex, Hps::TestData.cert_cardholder_shortzip_no_street)
    expect(result.response_code).to eql("00")
  end 
  
  it "K mastercard return should be OK" do
    result = @service.refund(15.15, "usd", Hps::TestData.valid_mastercard, Hps::TestData.cert_cardholder_shortzip)
    expect(result.response_code).to eql("00")
  end 
  
  it "L visa should reverse OK" do
    result = @service.reverse(Hps::TestData.valid_visa, 17.01, "usd")
    expect(result.response_code).to eql("00")
  end  
  
end
