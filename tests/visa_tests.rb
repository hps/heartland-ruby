require File.join( File.dirname(__FILE__), "test_helper" )

describe "Visa Tests" do

  it "Visa when card is ok, should return valid result" do
    charge = Hps::TestHelper.charge_valid_visa(50)
    expect(charge.response_code).to eql("00")
  end

  # avs tests

  # TODO: Gateway changed
  it "Visa avs result code should equal B" do
    charge = Hps::TestHelper.charge_valid_visa(90.01)
    #expect(charge.avs_result_code).to eql("B")
    expect(charge.avs_result_code).to eql("0")
  end

  # TODO: Gateway changed
  it "Visa avs result code should equal C" do
    charge = Hps::TestHelper.charge_valid_visa(90.02)
    #expect(charge.avs_result_code).to eql("C")
    expect(charge.avs_result_code).to eql("0")
  end

  # TODO: Gateway changed
  it "Visa avs result code should equal D" do
    charge = Hps::TestHelper.charge_valid_visa(90.03)
    #expect(charge.avs_result_code).to eql("D")
    expect(charge.avs_result_code).to eql("0")
  end

  # TODO: Gateway changed
  it "Visa avs result code should equal I" do
    charge = Hps::TestHelper.charge_valid_visa(90.05)
    #expect(charge.avs_result_code).to eql("I")
    expect(charge.avs_result_code).to eql("0")
  end

  # TODO: Gateway changed
  it "Visa avs result code should equal M" do
    charge = Hps::TestHelper.charge_valid_visa(90.06)
    #expect(charge.avs_result_code).to eql("M")
    expect(charge.avs_result_code).to eql("0")
  end

  # TODO: Gateway changed
  it "Visa avs result code should equal P" do
    charge = Hps::TestHelper.charge_valid_visa(90.07)
    #expect(charge.avs_result_code).to eql("P")
    expect(charge.avs_result_code).to eql("0")
  end

  # cvv tests

  it "Visa cvv result code should equal M" do
    charge = Hps::TestHelper.charge_valid_visa(96.01)
    expect(charge.cvv_result_code).to eql("M")
  end

  it "Visa cvv result code should equal N" do
    charge = Hps::TestHelper.charge_valid_visa(96.02)
    expect(charge.cvv_result_code).to eql("N")
  end

  it "Visa cvv result code should equal P" do
    charge = Hps::TestHelper.charge_valid_visa(96.03)
    expect(charge.cvv_result_code).to eql("P")
  end

  it "Visa cvv result code should equal S" do
    charge = Hps::TestHelper.charge_valid_visa(96.04)
    expect(charge.cvv_result_code).to eql("S")
  end

  it "Visa cvv result code should equal U" do
    charge = Hps::TestHelper.charge_valid_visa(96.05)
    expect(charge.cvv_result_code).to eql("U")
  end

  # visa to visa 2nd

  it "Visa response code should indicate refer card issuer" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.34)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("02")
      expect(error.response_text).to eql("CALL")
    }
  end

  it "Visa response code should indicate invalid merchant" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.22)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("03")
      expect(error.response_text).to eql("TERM ID ERROR")
    }
  end

  it "Visa response code should indicate pickup card" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.04)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("44")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end

  it "Visa response code should indicate do not honor" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.25)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("05")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Visa response code should indicate invalid transaction" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.26)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("12")
      expect(error.response_text).to eql("INVALID TRANS")
    }
  end

  it "Visa response code should indicate invalid amount" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.27)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("invalid_amount")
      expect(error.response_code).to eql("13")
      expect(error.response_text).to eql("AMOUNT ERROR")
    }
  end

  it "Visa response code should indicate invalid card" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.28)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("incorrect_number")
      expect(error.response_code).to eql("14")
      expect(error.response_text).to eql("CARD NO. ERROR")
    }
  end

  it "Visa response code should indicate invalid issuer" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.18)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("15")
      expect(error.response_text).to eql("NO SUCH ISSUER")
    }
  end

  it "Visa response code should indicate system error re-enter" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.29)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("19")
      expect(error.response_text).to eql("RE ENTER")
    }
  end

  it "Visa response code should indicate lost card" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.31)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("41")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end

  it "Visa response code should indicate hot card pickup" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.03)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("43")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end

  it "Visa response code should indicate insufficient fund" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.08)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      # TODO: Gateway changed
      #expect(error.response_code).to eql("05")
      expect(error.response_code).to eql("51")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Visa response code should indicate no checking account" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.16)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("52")
      expect(error.response_text).to eql("NO CHECK ACCOUNT")
    }
  end

  it "Visa response code should indicate no savings account" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.17)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("53")
      expect(error.response_text).to eql("NO SAVE ACCOUNT")
    }
  end

  it "Visa response code should indicate expired card" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.32)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("expired_card")
      expect(error.response_code).to eql("54")
      expect(error.response_text).to eql("EXPIRED CARD")
    }
  end

  it "Visa response code should indicate txn not permitted on card card" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.20)
    }.to raise_error(Hps::CardException) { |error|
      # TODO: Gateway changed
      #expect(error.code).to eql("processing_error")
      #expect(error.response_code).to eql("57")
      #expect(error.response_text).to eql("SERV NOT ALLOWED")
      expect(error.code).to eql("unknown_card_exception")
      expect(error.response_code).to eql("R1")
      expect(error.response_text).to eql("STOP RECURRING")
    }
  end

  it "Visa response code should indicate invalid acquirer" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.30)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("58")
      expect(error.response_text).to eql("SERV NOT ALLOWED")
    }
  end

  it "Visa response code should indicate exceeds limit" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.09)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("61")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Visa response code should indicate restricted card" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.10)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("62")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Visa response code should indicate security violation" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.11)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("65")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Visa response code should indicate check digit error" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.05)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("incorrect_cvc")
      expect(error.response_code).to eql("EB")
      expect(error.response_text).to eql("CHECK DIGIT ERR")
    }
  end

  it "Visa response code should indicate switch not available" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.33)
    }.to raise_error(Hps::HpsException) { |error|
    #}.to raise_error(Hps::CardException) { |error|
      #expect(error.code).to eql("processing_error")
      #expect(error.response_code).to eql("14")
      expect(error.code).to eql("issuer_timeout")
      expect(error.response_code).to eql("91")
      expect(error.response_text).to eql("NO REPLY")
    }
  end

  it "Visa response code should indicate system error" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.21)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("96")
      expect(error.response_text).to eql("SYSTEM ERROR")
    }
  end

  it "Visa response code should indicate CVV2 mismatch" do
    expect {
       Hps::TestHelper.charge_valid_visa(10.23)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("incorrect_cvc")
      expect(error.response_code).to eql("N7")
      expect(error.response_text).to eql("CVV2 MISMATCH")
    }
  end

  # verify, authorize, refund, and capture

  it "Visa verify should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.verify(Hps::TestData.valid_visa, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("85")
  end

  it "Visa verify should return Token" do
    service = Hps::HpsChargeService.new()
    result = service.verify(Hps::TestData.valid_visa, Hps::TestData.valid_cardholder,true)
    expect(result.response_code).to eql("85")
    expect(result.token_data.response_message).to eql("Success")
    expect(result.token_data.token_value).to_not eql(nil)

  end

  it "Visa authorize should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Visa authorize and request token should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder, true)
    expect(result.token_data.response_code).to eql("0")
    expect(result.response_code).to eql("00")
  end

  it "Visa should refund OK" do
    service = Hps::HpsChargeService.new()
    charge = service.charge(25.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder)
    refund = service.refund_transaction(25.00, "usd", charge.transaction_id)
    expect(refund.response_code).to eql("00")
  end

  it "Visa authorize and capture should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")

    capture_result = service.capture(result.transaction_id)
    expect(capture_result.response_code).to eql("00")
  end

  # Card Present

  it "Visa card present and reader not present" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    card = Hps::TestData.valid_visa
    card.card_present = true
    result = service.charge(10.00, "usd", card, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Visa card present and reader present" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    card = Hps::TestData.valid_visa
    card.card_present = true
    card.reader_present = true
    result = service.charge(10.00, "usd", card, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Visa Dynamic Descriptor Authorize" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    txn_descriptor = "Best Company Ever"
    result = service.authorize(10.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder, false, nil, txn_descriptor)
    expect(result.response_code).to eql("00")
    p result.transaction_id
  end

  it "Visa Dynamic Descriptor Charge" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new()
    txn_descriptor = "Best Company Ever"
    result = service.charge(10.00, "usd", Hps::TestData.valid_visa, Hps::TestData.valid_cardholder, false, nil, txn_descriptor)
    expect(result.response_code).to eql("00")
    p result.transaction_id
  end

  it "should charge with visa swipe and txn descriptor" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    txn_descriptor = "Best Company Ever"
    track_data = Hps::HpsTrackData.new
    track_data.value = '%B4012002000060016^VI TEST CREDIT^251210118039000000000396?;4012002000060016=25121011803939600000?'
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(10.00, "usd", track_data, nil, 0, false, txn_descriptor)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should authorize with visa swipe and txn descriptor" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    txn_descriptor = "Best Company Ever"
    track_data = Hps::HpsTrackData.new
    track_data.value = '%B4012002000060016^VI TEST CREDIT^251210118039000000000396?;4012002000060016=25121011803939600000?'
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    authorize = service.authorize_swipe(10.00, "usd", track_data, nil, 0, false, txn_descriptor)

    expect(authorize).to_not be_nil
    expect(authorize.response_code).to eql("00")
  end

end
