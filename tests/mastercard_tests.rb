require File.join( File.dirname(__FILE__), "test_helper" )

describe "Mastercard Tests" do
  
  it "Mastercard when card is ok, should return valid result" do
    charge = Hps::TestHelper.charge_valid_mastercard(50)
    expect(charge.response_code).to eql("00")
  end
  
  # avs tests
  
  it "Mastercard avs result code should equal A" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.01)
    expect(charge.avs_result_code).to eql("A")
  end
  
  it "Mastercard avs result code should equal N" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.02)
    expect(charge.avs_result_code).to eql("N")
  end
  
  it "Mastercard avs result code should equal R" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.03)
    expect(charge.avs_result_code).to eql("R")
  end
  
  it "Mastercard avs result code should equal S" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.04)
    expect(charge.avs_result_code).to eql("S")
  end
  
  it "Mastercard avs result code should equal U" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.05)
    expect(charge.avs_result_code).to eql("U")
  end
  
  it "Mastercard avs result code should equal W" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.06)
    expect(charge.avs_result_code).to eql("W")
  end
  
  it "Mastercard avs result code should equal X" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.07)
    expect(charge.avs_result_code).to eql("X")
  end
  
  it "Mastercard avs result code should equal Y" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.08)
    expect(charge.avs_result_code).to eql("Y")
  end
  
  it "Mastercard avs result code should equal Z" do
    charge = Hps::TestHelper.charge_valid_mastercard(90.09)
    expect(charge.avs_result_code).to eql("Z")
  end
  
  # cvv tests
  
  it "Mastercard cvv result code should equal M" do
    charge = Hps::TestHelper.charge_valid_mastercard(95.01)
    expect(charge.cvv_result_code).to eql("M")
  end
  
  it "Mastercard cvv result code should equal N" do
    charge = Hps::TestHelper.charge_valid_mastercard(95.02)
    expect(charge.cvv_result_code).to eql("N")
  end
  
  it "Mastercard cvv result code should equal P" do
    charge = Hps::TestHelper.charge_valid_mastercard(95.03)
    expect(charge.cvv_result_code).to eql("P")
  end
  
  it "Mastercard cvv result code should equal U" do
    charge = Hps::TestHelper.charge_valid_mastercard(95.04)
    expect(charge.cvv_result_code).to eql("U")
  end
  
  # mastercard to 8583
  
  it "Mastercard response code should indicate refer card issuer" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.34)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("02")
      expect(error.response_text).to eql("CALL")
    }
  end
  
  it "Mastercard response code should indicate term id error" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.22)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("03")
      expect(error.response_text).to eql("TERM ID ERROR")
    }
  end

  # TODO: Gateway not throwing error
  # it "Mastercard response code should indicate invalid merchant" do
  #   expect {
  #      Hps::TestHelper.charge_valid_mastercard(10.01)
  #   }.to raise_error(Hps::CardException) { |error| 
  #     expect(error.code).to eql("card_declined")      
  #     expect(error.response_code).to eql("04")
  #     expect(error.response_text).to eql("HOLD-CALL")
  #   }
  # end
  
  it "Mastercard response code should indicate do not honor" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.25)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("05")
      expect(error.response_text).to eql("DECLINE")
    }
  end

  # TODO: Gateway not throwing error  
  # it "Mastercard response code should indicate invalid transaction" do
  #   expect {
  #      Hps::TestHelper.charge_valid_amex(10.26)
  #   }.to raise_error(Hps::CardException) { |error| 
  #     expect(error.code).to eql("processing_error")      
  #     expect(error.response_code).to eql("12")
  #     expect(error.response_text).to eql("INVALID TRANS")
  #   }
  # end
  
  it "Mastercard response code should indicate invalid amount" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.27)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("invalid_amount")      
      expect(error.response_code).to eql("13")
      expect(error.response_text).to eql("AMOUNT ERROR")
    }
  end
  
  it "Mastercard response code should indicate invalid card" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.28)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("incorrect_number")      
      expect(error.response_code).to eql("14")
      expect(error.response_text).to eql("CARD NO. ERROR")
    }
  end
  
  it "Mastercard response code should indicate invalid issuer" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.18)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("processing_error")      
      expect(error.response_code).to eql("15")
      expect(error.response_text).to eql("NO SUCH ISSUER")
    }
  end
  
  it "Mastercard response code should indicate lost card" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.31)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("41")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end
  
  it "Mastercard response code should indicate hold call" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.03)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("43")
      expect(error.response_text).to eql("HOLD-CALL")
    }
  end
  
  it "Mastercard response code should indicate decline" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.08)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("51")
      expect(error.response_text).to eql("DECLINE")
    }
  end
  
  it "Mastercard response code should indicate expired card" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.32)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("expired_card")      
      expect(error.response_code).to eql("54")
      expect(error.response_text).to eql("EXPIRED CARD")
    }
  end
  
  it "Mastercard response code should indicate exceeds limit" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.09)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("61")
      expect(error.response_text).to eql("DECLINE")
    }
  end
  
  it "Mastercard response code should indicate restricted card" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.10)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("62")
      expect(error.response_text).to eql("DECLINE")
    }
  end
  
  it "Mastercard response code should indicate security violation" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.19)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("63")
      expect(error.response_text).to eql("SEC VIOLATION")
    }
  end
  
  it "Mastercard response code should indicate exceeds freq limit" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.11)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("card_declined")      
      expect(error.response_code).to eql("65")
      expect(error.response_text).to eql("DECLINE")
    }
  end
  
  it "Mastercard response code should indicate card no error" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.14)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("incorrect_number")      
      expect(error.response_code).to eql("14")
      expect(error.response_text).to eql("CARD NO. ERROR")
    }
  end
  
  it "Mastercard response code should indicate invalid account" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.06)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("processing_error")      
      # TODO: Gateway change
      #expect(error.response_code).to eql("79")
      expect(error.response_code).to eql("EC")
      expect(error.response_text).to eql("CID FORMAT ERROR")
    }
  end
  
  # TODO: Gateway change, used to throw exception but now it doesn't
  it "Mastercard response code should indicate switch not available" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.33)
    }.to raise_error(Hps::HpsException) { |error|    
    #}.to raise_error(Hps::CardException) { |error|       
      #expect(error.code).to eql("processing_error")      
      #expect(error.response_code).to eql("14")
      expect(error.code).to eql("issuer_timeout")      
      expect(error.response_code).to eql("91")
      expect(error.response_text).to eql("NO REPLY")
    }
  end  
  
  it "Mastercard response code should indicate system error" do
    expect {
       Hps::TestHelper.charge_valid_mastercard(10.21)
    }.to raise_error(Hps::CardException) { |error| 
      expect(error.code).to eql("processing_error")      
      expect(error.response_code).to eql("96")
      expect(error.response_text).to eql("SYSTEM ERROR")
    }
  end
  
  # verify, authorize, refund, and capture
  
  it "Mastercard verify should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.verify(Hps::TestData.valid_mastercard, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("85")  
  end
  
  it "Mastercard authorize should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_mastercard, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")  
  end
  
  it "Mastercard authorize and request token should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_mastercard, Hps::TestData.valid_cardholder, true)
    expect(result.token_data.response_code).to eql("0")
    expect(result.response_code).to eql("00")  
  end
  
  it "Mastercard should refund OK" do 
    service = Hps::HpsChargeService.new()
    charge = service.charge(25.00, "usd", Hps::TestData.valid_mastercard, Hps::TestData.valid_cardholder)    
    refund = service.refund_transaction(25.00, "usd", charge.transaction_id)
    expect(refund.response_code).to eql("00")
  end
  
  it "Mastercard authorize and capture should return OK" do
    service = Hps::HpsChargeService.new()
    result = service.authorize(50.00, "usd", Hps::TestData.valid_mastercard, Hps::TestData.valid_cardholder)
    expect(result.response_code).to eql("00")  
    
    capture_result = service.capture(result.transaction_id)
    expect(capture_result.response_code).to eql("00")
  end  
  
end