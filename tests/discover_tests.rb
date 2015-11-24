require File.join( File.dirname(__FILE__), "test_helper" )

describe "Discover Tests" do

  it "Discover when card is ok should return valid result" do
    charge = Hps::TestHelper.charge_valid_discover(50)
    expect(charge.response_code).to eql("00")
  end

  it "Discover avs result code should equal A" do
    charge = Hps::TestHelper.charge_valid_discover(91.01)
    expect(charge.avs_result_code).to eql("A")
  end

  it "Discover avs result code should equal N" do
    charge = Hps::TestHelper.charge_valid_discover(91.02)
    expect(charge.avs_result_code).to eql("N")
  end

  it "Discover avs result code should equal U" do
    charge = Hps::TestHelper.charge_valid_discover(91.05)
    expect(charge.avs_result_code).to eql("U")
  end

  it "Discover avs result code should equal Y" do
    charge = Hps::TestHelper.charge_valid_discover(91.06)
    expect(charge.avs_result_code).to eql("Y")
  end

  it "Discover avs result code should equal Z" do
    charge = Hps::TestHelper.charge_valid_discover(91.07)
    expect(charge.avs_result_code).to eql("Z")
  end

  # discover to 2nd visa

  it "Discover response code should indicate refer card issuer" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.34)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("02")
      expect(error.response_text).to eql("CALL")
    }
  end

  it "Discover response code should indicate invalid merchant" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.22)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("03")
      expect(error.response_text).to eql("TERM ID ERROR")
    }
  end

  it "Discover response code should indicate pickup card" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.04)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("44")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end

  it "Discover response code should indicate do not honor" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.25)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("05")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Discover response code should indicate invalid transaction" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.26)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("12")
      expect(error.response_text).to eql("INVALID TRANS")
    }
  end

  it "Discover response code should indicate invalid amount" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.27)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("invalid_amount")
      expect(error.response_code).to eql("13")
      expect(error.response_text).to eql("AMOUNT ERROR")
    }
  end

  it "Discover response code should indicate invalid card" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.28)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("incorrect_number")
      expect(error.response_code).to eql("14")
      expect(error.response_text).to eql("CARD NO. ERROR")
    }
  end

# TODO: Gateway change, used to raise exception but doesn't now
#   it "Discover response code should indicate invalid issuer" do
#     expect {
#        Hps::TestHelper.charge_valid_discover(10.18)
#     }.to raise_error(Hps::CardException) { |error|
#       expect(error.code).to eql("processing_error")
#       expect(error.response_code).to eql("15")
#       expect(error.response_text).to eql("NO SUCH ISSUER")
#     }
#   end

  it "Discover response code should indicate system error re-enter" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.29)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("19")
      expect(error.response_text).to eql("RE ENTER")
    }
  end

  it "Discover response code should indicate message format error" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.06)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("EC")
      expect(error.response_text).to eql("CID FORMAT ERROR")
    }
  end

  it "Discover response code should indicate lost card" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.31)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("41")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end

  it "Discover response code should indicate insufficient funds" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.08)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("05")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Discover response code should indicate no saving account" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.17)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("53")
      expect(error.response_text).to eql("NO SAVE ACCOUNT")
    }
  end

  it "Discover response code should indicate expired card" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.32)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("expired_card")
      expect(error.response_code).to eql("54")
      expect(error.response_text).to eql("EXPIRED CARD")
    }
  end

  it "Discover response code should indicate no card record" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.24)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("56")
      expect(error.response_text).to eql("INVALID TRANS")
    }
  end

  it "Discover response code should indicate txn not permitted on card" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.20)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("57")
      expect(error.response_text).to eql("SERV NOT ALLOWED")
    }
  end

  it "Discover response code should indicate invalid aquirer" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.30)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      expect(error.response_code).to eql("58")
      expect(error.response_text).to eql("SERV NOT ALLOWED")
    }
  end

  it "Discover response code should indicate exceeds limit" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.09)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("61")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Discover response code should indicate restricted card" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.10)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("62")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Discover response code should indicate security violation" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.19)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("63")
      expect(error.response_text).to eql("SEC VIOLATION")
    }
  end

  it "Discover response code should indicate exceeds freq limit" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.11)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("65")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  it "Discover response code should indicate no account" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.13)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("card_declined")
      expect(error.response_code).to eql("78")
      expect(error.response_text).to eql("NO ACCOUNT")
    }
  end

  it "Discover response code should indicate invalid account" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.14)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("incorrect_number")
      expect(error.response_code).to eql("14")
      expect(error.response_text).to eql("CARD NO. ERROR")
    }
  end

  # TODO: Gateway change, used to throw exception but now it doesn't
  # it "Discover response code should indicate switch not available" do
  #   expect {
  #      Hps::TestHelper.charge_valid_discover(10.33)
  #   }.to raise_error(Hps::HpsException) { |error|
  #   #}.to raise_error(Hps::CardException) { |error|
  #     #expect(error.code).to eql("processing_error")
  #     #expect(error.response_code).to eql("14")
  #     expect(error.code).to eql("issuer_timeout")
  #     expect(error.response_code).to eql("91")
  #     expect(error.response_text).to eql("NO REPLY")
  #   }
  # end

  it "Discover response code should indicate system error" do
    expect {
       Hps::TestHelper.charge_valid_discover(10.26)
    }.to raise_error(Hps::CardException) { |error|
      expect(error.code).to eql("processing_error")
      # TODO: Gateway change
      #expect(error.response_code).to eql("96")
      #expect(error.response_text).to eql("SYSTEM ERROR")
      expect(error.response_code).to eql("12")
      expect(error.response_text).to eql("INVALID TRANS")
    }
  end

  # Verify, Authorize, and Capture

  it "Discover verify should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.verify(Hps::TestData.valid_discover, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("85")
  end

  it "Discover authorize should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_discover, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Discover authorize and request token should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_discover, Hps::TestData.valid_cardholder, true)
    expect(result.token_data.response_code).to eql("0")
    expect(result.response_code).to eql("00")
  end

  it "Discover authorize and capture should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_discover, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")

    capture_result = service.capture(result.transaction_id)
    expect(capture_result.response_code).to eql("00")
  end

  it "Discover card present and reader not present" do
    service = Hps::HpsChargeService.new()
    card = Hps::TestData.valid_discover
    card.card_present = true
    result = service.charge(10.00, "usd", card, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Discover card present and reader present" do
    service = Hps::HpsChargeService.new()
    card = Hps::TestData.valid_discover
    card.card_present = true
    card.reader_present = true
    result = service.charge(10.00, "usd", card, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")
  end

  it "Discover Dynamic Descriptor Authorize" do
    service = Hps::HpsChargeService.new()
    txn_descriptor = "Best Company Ever"
    result = service.authorize(10.00, "usd", Hps::TestData.valid_discover, Hps::TestData.valid_cardholder, false, nil, txn_descriptor)
    expect(result.response_code).to eql("00")
    p result.transaction_id
  end

  it "Discover Dynamic Descriptor Charge" do
    service = Hps::HpsChargeService.new()
    txn_descriptor = "Best Company Ever"
    result = service.charge(10.00, "usd", Hps::TestData.valid_discover, Hps::TestData.valid_cardholder, false, nil, txn_descriptor)
    expect(result.response_code).to eql("00")
    p result.transaction_id
  end

  it "should charge with discover swipe and txn descriptor" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    txn_descriptor = "Best Company Ever"
    track_data = Hps::HpsTrackData.new
    track_data.value = '%B6011000990156527^DIS TEST CARD^25121011000062111401?;6011000990156527=25121011000062111401?'
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(10.00, "usd", track_data, nil, 0, false, txn_descriptor)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should authorize with discover swipe and txn descriptor" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    txn_descriptor = "Best Company Ever"
    track_data = Hps::HpsTrackData.new
    track_data.value = '%B6011000990156527^DIS TEST CARD^25121011000062111401?;6011000990156527=25121011000062111401?'
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    authorize = service.authorize_swipe(10.00, "usd", track_data, nil, 0, false, txn_descriptor)

    expect(authorize).to_not be_nil
    expect(authorize.response_code).to eql("00")
  end

end
