module Hps
  class HpsGatewayResponseValidation
    def self.check_response(response, expected_type)
      response_code = response["Header"]["GatewayRspCode"]
      response_text = response["Header"]["GatewayRspMsg"]
      transaction_id = response["Header"]["GatewayTxnId"]

      if !response_code.eql? "0"
        exception = Hps::ExceptionMapper.new.map_gateway_exception(transaction_id, response_code, response_text)
        exception.response_code = response_code
        exception.response_text = response_text
        raise exception
      end

      unless response["Transaction"] && response["Transaction"][expected_type.to_s]
        raise HpsGatewayException
      end
    end
  end
end
