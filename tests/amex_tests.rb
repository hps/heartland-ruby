require File.join( File.dirname(__FILE__), "test_helper" )


describe "Amex Tests" do

  it "Amex when card is ok, should return valid result" do
    charge = Hps::TestHelper.charge_valid_amex(50)
    expect(charge.response_code).to eql("00")
  end

  # avs tests

  it "Amex avs result code should equal A" do
    charge = Hps::TestHelper.charge_valid_amex(90.01)
    expect(charge.avs_result_code).to eql("A")
  end

  it "Amex avs result code should equal N" do
    charge = Hps::TestHelper.charge_valid_amex(90.02)
    expect(charge.avs_result_code).to eql("N")
  end

  it "Amex avs result code should equal R" do
    charge = Hps::TestHelper.charge_valid_amex(90.03)
    expect(charge.avs_result_code).to eql("R")
  end

  it "Amex avs result code should equal S" do
    charge = Hps::TestHelper.charge_valid_amex(90.04)
    expect(charge.avs_result_code).to eql("S")
  end

  it "Amex avs result code should equal U" do
    charge = Hps::TestHelper.charge_valid_amex(90.05)
    expect(charge.avs_result_code).to eql("U")
  end

  it "Amex avs result code should equal W" do
    charge = Hps::TestHelper.charge_valid_amex(90.06)
    expect(charge.avs_result_code).to eql("W")
  end

  it "Amex avs result code should equal X" do
    charge = Hps::TestHelper.charge_valid_amex(90.07)
    expect(charge.avs_result_code).to eql("X")
  end

  it "Amex avs result code should equal Y" do
    charge = Hps::TestHelper.charge_valid_amex(90.08)
    expect(charge.avs_result_code).to eql("Y")
  end

  it "Amex avs result code should equal Z" do
    charge = Hps::TestHelper.charge_valid_amex(90.09)
    expect(charge.avs_result_code).to eql("Z")
  end

  # cvv tests

  # TODO: Gateway code changed, returning Y
  it "Amex cvv result code should equal M" do
    charge = Hps::TestHelper.charge_valid_amex(97.01)
    #expect(charge.cvv_result_code).to eql("M")
  end

  it "Amex cvv result code should equal N" do
    charge = Hps::TestHelper.charge_valid_amex(97.02)
    expect(charge.cvv_result_code).to eql("N")
  end

  it "Amex cvv result code should equal P" do
    charge = Hps::TestHelper.charge_valid_amex(97.03)
    expect(charge.cvv_result_code).to eql("P")
  end

  # amex to visa 2nd
  it "Amex response code should indicate denied" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.08)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("51")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Amex response code should card expired" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.32)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("expired_card")
      expect(error.response_code).to eql("54")
      expect(error.response_text).to eql("EXPIRED CARD")
    }
  end

  it "Amex response code should indicate please call" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.34)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("02")
      expect(error.response_text).to eql("CALL")
    }
  end

  it "Amex response code should indicate invalid merchant" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.22)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("03")
      expect(error.response_text).to eql("TERM ID ERROR")
    }
  end

  it "Amex response code should indicate invalid amount" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.27)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("invalid_amount")
      expect(error.response_code).to eql("13")
      expect(error.response_text).to eql("AMOUNT ERROR")
    }
  end

  it "Amex response code should indicate no action taken" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.14)
    }.to raise_error(Hps::CardException) { |error|
      # TODO: Gateway response changed
      # expect(error.code).to eql("processing_error")
      # expect(error.response_code).to eql("76")
      # expect(error.response_text).to eql("NO ACTION TAKEN")
      expect(error.code).to eql("incorrect_number")
      expect(error.response_code).to eql("14")
      expect(error.response_text).to eql("CARD NO. ERROR")
    }
  end

  it "Amex response code should indicate invalid cvv2" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.23)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("incorrect_cvc")
      expect(error.response_code).to eql("N7")
      expect(error.response_text).to eql("CVV2 MISMATCH")
    }
  end

  it "Amex response code should indicate invalid originator" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.30)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("58")
      expect(error.response_text).to eql("SERV NOT ALLOWED")
    }
  end

  it "Amex response code should indicate card declined" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.25)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("05")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Amex response code should indicate account canceled" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.13)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("78")
      expect(error.response_text).to eql("NO ACCOUNT")
    }
  end

  it "Amex response code should indicate merchant close" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.12)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("06")
      expect(error.response_text).to eql("ERROR")
    }
  end

  it "Amex response code should indicate pickup card" do
    expect {
       Hps::TestHelper.charge_valid_amex(10.04)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("44")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end

  # verify, authorize & capture

  it "Amex verify should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.verify(Hps::TestData.valid_amex, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Amex authorize should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_amex, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Amex authorize and request token should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_amex, Hps::TestData.valid_cardholder, true)
    expect(result.token_data.response_code).to eql("0")
    expect(result.response_code).to eql("00")
  end

  it "Amex authorize and capture should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_amex, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")

    capture_result = service.capture(result.transaction_id)
    expect(capture_result.response_code).to eql("00")
  end

  it "Amex card present and reader not present" do
    service = Hps::HpsChargeService.new()
    card = Hps::TestData.valid_amex
    card.card_present = true
    result = service.charge(10.00, "usd", card, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Amex card present and reader present" do
    service = Hps::HpsChargeService.new()
    card = Hps::TestData.valid_amex
    card.card_present = true
    card.reader_present = true
    result = service.charge(10.00, "usd", card, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Amex Dynamic Descriptor Authorize" do
    service = Hps::HpsChargeService.new()
    txn_descriptor = "Best Company Ever"
    result = service.authorize(10.00, "usd", Hps::TestData.valid_amex, Hps::TestData.valid_cardholder, false, nil, txn_descriptor)
    expect(result.response_code).to eql("00")
    p result.transaction_id
  end

  it "Amex Dynamic Descriptor Charge" do
    service = Hps::HpsChargeService.new()
    txn_descriptor = "Best Company Ever"
    result = service.charge(10.00, "usd", Hps::TestData.valid_amex, Hps::TestData.valid_cardholder, false, nil, txn_descriptor)
    expect(result.response_code).to eql("00")
    p result.transaction_id
  end

  it "should charge with amex swipe and txn descriptor" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    txn_descriptor = "Best Company Ever"
    track_data = Hps::HpsTrackData.new
    track_data.value = '%B3727 006992 51018^AMEX TEST CARD^2512990502700?;372700699251018=2512990502700?'
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(10.00, "usd", track_data, nil, 0, false, txn_descriptor)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should authorize with amex swipe and txn descriptor" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    txn_descriptor = "Best Company Ever"
    track_data = Hps::HpsTrackData.new
    track_data.value = '%B3727 006992 51018^AMEX TEST CARD^2512990502700?;372700699251018=2512990502700?'
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    authorize = service.authorize_swipe(10.00, "usd", track_data, nil, 0, false, txn_descriptor)

    expect(authorize).to_not be_nil
    expect(authorize.response_code).to eql("00")
  end

end
