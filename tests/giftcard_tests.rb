require File.join( File.dirname(__FILE__), "test_helper" )

describe "Giftcard Tests" do

  # Activate a card
  it "When card is ok, it should activate and return valid response" do
    response = Hps::TestHelper.activate_valid_gift_card(100.00)
    expect( response.response_code ).to eql("0")
  end

  # Add value to a card
  it "When card is ok, it should add value and return a valid response" do
    response = Hps::TestHelper.add_value_to_valid_gift_card(100.00)
    expect( response.response_code ).to eql("0")
  end

  # Check the balance on a card
  it "When card is ok, it should return valid response" do
    response = Hps::TestHelper.balance_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Deactivate a card
  it "When card is ok, it should deactivate and return a valid response" do
    response = Hps::TestHelper.deactivate_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Replace a card
  it "When card is ok, it should replace it and return a valid response" do
    response = Hps::TestHelper.replace_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Add rewards to a card
  it "When card is ok, it should add rewards and return a valid response" do
    ["USD", "POINTS"].each do |currency|
      response = Hps::TestHelper.reward_valid_gift_card(10.00, currency)
      expect( response.response_code ).to eql("0")
    end
  end

  # Complete a sale
  it "When card is ok, it should complete a sale and return a valid response" do
    response = Hps::TestHelper.sale_valid_gift_card(10.00)
    expect( response.response_code ).to eql("0")
  end

  # Void a transaction
  it "Should void a transaction" do
    response = Hps::TestHelper.sale_valid_gift_card(10.00)
    expect( response.response_code ).to eql("0")
    void_response = Hps::TestHelper.void_gift_card_sale( response.transaction_id )
    expect( void_response.response_code ).to eql("0")
  end

  # Reverse a transaction using transaction id
  it "Should reverse a gift card transaction using the transaction id" do
    response = Hps::TestHelper.sale_valid_gift_card(10.00)
    expect( response.response_code ).to eql("0")
    reverse_response = Hps::TestHelper.reverse_gift_card_sale( 10.00, response.transaction_id )
    expect( reverse_response.response_code ).to eql("0")
  end

  # Reverse transaction using giftcard
  it "Should reverse a giftcard transaction using the card" do
    response = Hps::TestHelper.sale_valid_gift_card(10.00, "USD", nil, nil, false)
    expect( response.response_code ).to eql("0")
    reverse_response = Hps::TestHelper.reverse_gift_card_sale(10.00)
    expect( reverse_response.response_code ).to eql("0")
  end

  context "exceptions for transactions" do
    before(:all) do
      @mapper = Hps::ExceptionMapper.new
    end

    # Amounts less than zero
    it "raises an exception for amounts less than zero" do
      %i{activate add_value reward sale reverse}.each do |method|
        expect{ Hps::TestHelper.gift_card_transaction_exception(-1.00, method) }.to raise_exception{|e|
          expect(e).to be_a( Hps::InvalidRequestException )
          expect(e.message).to eql("Amount must be greater than or equal 0.")
        }
      end
    end

    # Profile auth fails
    it "should raise an exception if profile auth fails" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(2.01) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql("ProfileError Subject 'ProfileAuthorizationFailed'.")
      }
    end

    # Profile closed
    it "should raise an exception if profile is closed" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(2.02) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql("ProfileError Subject 'ProfileClosed'.")
      }
    end

    # Profile not found
    it "should raise an exception if profile is not found" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(2.03) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql("ProfileError")
      }
    end

    # Profile frozen
    it "should raise an exception if profile is frozen" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(2.04) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql("ProfileError Subject 'ProfileFrozen'.")
      }
    end

    # Insufficient funds - card decline - code 5
    it "should raise an exception if insufficient funds" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.01) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_CardDeclined"))
      }
    end

    # Insufficient activation amount - card decline - code 5
    it "should raise an exception if insufficient activation amount" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.02) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_CardDeclined"))
      }
    end

    # Insufficient load amount - card decline - code 5
    it "should raise an exception if insufficient load amount" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.03) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_CardDeclined"))
      }
    end

    # Invalid Payment Type - unknown gift error - code 1
    it "should raise an exception if insufficient load amount" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.04) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql("SystemError Subject 'InvalidPaymentType'.")
      }
    end

    # Provide an invalid PIN - code 14
    it "Should raise an exception if PIN is invalid" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.05) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_InvalidPin"))
      }
    end

    # Invalid seller ID - unknown gift error - code 1
    it "should raise an exception if invalid seller profile ID" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.06) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql("SystemError")
      }
    end

    # Order exists - processing error - code 7
    it "should raise an exception if invalid seller profile ID" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.07) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_ProcessingError"))
      }
    end

    # Registration required - invalid card data - code 3
    it "should raise an exception if invalid seller profile ID" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.08) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_InvalidCardData"))
      }
    end

    # Account not active - invalid card data - code 8
    it "should raise an exception if invalid seller profile ID" do
      expect{ Hps::TestHelper.gift_card_transaction_exception(3.09) }.to raise_exception {|e|
        expect(e).to be_a(Hps::CardException)
        expect(e.message).to eql(message_for_code("Exception_Message_InvalidCardData"))
      }
    end

  end
end # Giftcard Tests

# Helper methods
def message_for_code(code)
  mapping = @mapper.exceptions["exception_messages"].detect { |message| 
    message["code"] == code
  }

  mapping["message"] unless mapping.nil?
end