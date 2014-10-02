require 'hps'


describe "ExceptionMapper Tests" do

	before(:all) do
		@mapper = Hps::ExceptionMapper.new
	end


	it "mapping version number accessible" do
		expect(@mapper.version_number).to eq("1.0.0")
	end	

	# Issuer Exceptions

	it "issuer card declined test codes" do

		[ "02", "03", "04", "05", "41", "43", "44", "51", "56", "61", "62", "63", "65", "78" ].each { |code| 

			result = @mapper.map_issuer_exception(1, code, "")
			expect(result.transaction_id).to eq(1)
			expect(result.code).to eq("card_declined")
			expect(result.message).to eq(message_for_code("Exception_Message_CardDeclined"))
		}

	end

	it "issuer processing error test codes" do

		[ "06", "07", "12", "15", "19", "12", "52", "53", "57", "58", "76", "77", "91", "96", "EC" ].each { |code| 

			result = @mapper.map_issuer_exception(2, code, "")
			expect(result.transaction_id).to eq(2)
			expect(result.code).to eq("processing_error")
			expect(result.message).to eq(message_for_code("Exception_Message_ProcessingError"))
		}

	end

	it "issuer invalid amount test" do
		result = @mapper.map_issuer_exception(3, "13", "")
		expect(result.transaction_id).to eq(3)
		expect(result.code).to eq("invalid_amount")
		expect(result.message).to eq(message_for_code("Exception_Message_ChargeAmount"))			
	end

	it "issuer incorrect number test" do
		result = @mapper.map_issuer_exception(4, "14", "")
		expect(result.transaction_id).to eq(4)
		expect(result.code).to eq("incorrect_number")
		expect(result.message).to eq(message_for_code("Exception_Message_IncorrectNumber"))			
	end

	it "issuer expired card test" do
		result = @mapper.map_issuer_exception(5, "54", "")
		expect(result.transaction_id).to eq(5)
		expect(result.code).to eq("expired_card")
		expect(result.message).to eq(message_for_code("Exception_Message_CardExpired"))			
	end

	it "issuer invalid pin test" do
		result = @mapper.map_issuer_exception(6, "55", "")
		expect(result.transaction_id).to eq(6)
		expect(result.code).to eq("invalid_pin")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidPin"))			
	end

	it "issuer pin retries exceeded test" do
		result = @mapper.map_issuer_exception(7, "75", "")
		expect(result.transaction_id).to eq(7)
		expect(result.code).to eq("pin_retries_exceeded")
		expect(result.message).to eq(message_for_code("Exception_Message_PinExceeded"))			
	end

	it "issuer invalid expiry test" do
		result = @mapper.map_issuer_exception(8, "80", "")
		expect(result.transaction_id).to eq(8)
		expect(result.code).to eq("invalid_expiry")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidExpiry"))			
	end

	it "issuer pin verification test" do
		result = @mapper.map_issuer_exception(9, "86", "")
		expect(result.transaction_id).to eq(9)
		expect(result.code).to eq("pin_verification")
		expect(result.message).to eq(message_for_code("Exception_Message_PinVerification"))			
	end

	it "issuer incorrect cvc test" do
		[ "EB", "N7" ].each { |code| 
			result = @mapper.map_issuer_exception(10, code, "")
			expect(result.transaction_id).to eq(10)
			expect(result.code).to eq("incorrect_cvc")
			expect(result.message).to eq(message_for_code("Exception_Message_IncorrectCvc"))
		}	
	end

	it "issuer unknown test" do
		result = @mapper.map_issuer_exception(11, "Foo", "Foo")
		expect(result.transaction_id).to eq(11)
		expect(result.code).to eq("unknown_card_exception")
		expect(result.message).to eq("Foo")			
	end

	it "issuer nil test" do
		result = @mapper.map_issuer_exception(0, nil, nil)
		expect(result.transaction_id).to eq(0)
		expect(result.code).to eq("unknown_card_exception")
		expect(result.message).to eq("Hps::CardException")			
	end

	# Gateway exceptions

	it "gateway authentication exception test" do
		result = @mapper.map_gateway_exception(0, "-2", nil)
		expect(result.code).to eq("unknown")
		expect(result.message).to eq(message_for_code("Exception_Message_AuthenticationError"))			
	end

	it "gateway invalid request exception cpc test" do
		result = @mapper.map_gateway_exception(0, "12", nil)
		expect(result.param).to eq("card")
		expect(result.code).to eq("invalid_cpc_data")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidCpcData"))			
	end

	it "gateway invalid request exception card data test" do
		result = @mapper.map_gateway_exception(0, "13", nil)
		expect(result.param).to eq("card")
		expect(result.code).to eq("invalid_card_data")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidCardData"))			
	end

	it "gateway card exception test" do
		result = @mapper.map_gateway_exception(0, "14", nil)
		expect(result.code).to eq("invalid_number")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidNumber"))			
	end

	it "gateway message passthrough test" do
		result = @mapper.map_gateway_exception(0, "1", "Foo")
		expect(result.code).to eq("unknown")
		expect(result.message).to eq("Foo")			
	end

	it "gateway invalid original transaction test" do
		result = @mapper.map_gateway_exception(0, "3", "Foo")
		expect(result.code).to eq("invalid_original_transaction")
		expect(result.message).to eq("Foo")			
	end

	it "gateway no open batch test" do
		result = @mapper.map_gateway_exception(0, "5", "Foo")
		expect(result.code).to eq("no_open_batch")
		expect(result.message).to eq("Foo")			
	end

	it "gateway timeout test" do
		result = @mapper.map_gateway_exception(0, "30", nil)
		expect(result.code).to eq("unknown")
		expect(result.message).to eq(message_for_code("Exception_Message_GatewayTimedOut"))			
	end

	it "gateway unknown test" do
		result = @mapper.map_gateway_exception(0, "Foo", "Foo")
		expect(result.code).to eq("unknown")
		expect(result.message).to eq("Foo")			
	end

	# Sdk Exceptions

	it "sdk invalid transaction id test" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.invalid_transaction_id, nil)
		expect(result.param).to eq("gatewayTransactionId")
		expect(result.code).to eq("invalid_transaction_id")
		expect(result.message).to eq(message_for_code("Exception_Message_TransactionIdLessThanEqualZero"))			
	end	

	it "sdk invalid gateway url test" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.invalid_gateway_url, nil)
		expect(result.param).to eq("HpsServiceUri")
		expect(result.code).to eq("sdk_exception")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidGatewayUrl"))			
	end	

	it "sdk unable to process transaction test" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.invalid_gateway_url, nil)
		expect(result.param).to eq("HpsServiceUri")
		expect(result.code).to eq("sdk_exception")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidGatewayUrl"))			
	end

	it "sdk missing currency" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.missing_currency, nil)
		expect(result.param).to eq("currency")
		expect(result.code).to eq("missing_currency")
		expect(result.message).to eq(message_for_code("Exception_Message_ArgumentNull"))			
	end	

	it "sdk invalid currency" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.invalid_currency, nil)
		expect(result.param).to eq("currency")
		expect(result.code).to eq("invalid_currency")
		expect(result.message).to eq(message_for_code("Exception_Message_InvalidCurrency"))			
	end

	it "sdk invalid amount" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.invalid_amount, nil)
		expect(result.param).to eq("amount")
		expect(result.code).to eq("invalid_amount")
		expect(result.message).to eq(message_for_code("Exception_Message_ChargeAmount"))			
	end

	it "sdk reversal error after gateway timeout" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.reversal_error_after_gateway_timeout, nil)
		expect(result.code).to eq("gateway_timeout")
		expect(result.message).to eq(message_for_code("Exception_Message_UnableToReverseTransactionAfterGatewayTimeout"))			
	end

	it "sdk reversal error after issuer timeout" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.reversal_error_after_issuer_timeout, nil)
		expect(result.code).to eq("issuer_timeout")
		expect(result.message).to eq(message_for_code("Exception_Message_UnableToReverseTransactionAfterIssuerTimeout"))			
	end

	it "sdk processing error" do
		result = @mapper.map_sdk_exception(Hps::SdkCodes.processing_error, nil)
		expect(result.code).to eq("processing_error")
		expect(result.message).to eq(message_for_code("Exception_Message_ProcessingError"))			
	end	

	# Helper methods

	def message_for_code(code)

		mapping = @mapper.exceptions["exception_messages"].detect { |message| 
			message["code"] == code
		}

		mapping["message"] unless mapping.nil?

	end

end