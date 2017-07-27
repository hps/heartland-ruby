module Hps
  class HpsCheckResponse < HpsTransaction
    attr_accessor :authorization_code,
                  :customer_id,
                  :details

    def self.from_hash(rsp, txn_type)
      header = rsp["Header"]
      data = rsp["Transaction"][txn_type.to_s]

      result = HpsCheckResponse.new(HpsService.new.hydrate_transaction_header(header))
      result.transaction_id = header["GatewayTxnId"]
      result.authorization_code = data["AuthCode"]
      result.reference_number = data["RefNbr"]
      result.response_code = data["RspCode"]
      result.response_text = data["RspMessage"]

      if data["CheckRspInfo"]
        result.details = []
        check_info = data["CheckRspInfo"]
        if check_info.is_a? Hash
          result.details = HpsCheckResponse.hydrate_rsp_details(check_info)
        else
          check_info.map { |details|
            result.details.push HpsCheckResponse.hydrate_rsp_details(details)
          }
        end
      end

      result
    end

    private

    def self.hydrate_rsp_details(check_info)
      details = HpsCheckResponseDetails.new
      details.message_type = check_info["Type"]
      details.code = check_info["Code"]
      details.message = check_info["Message"]
      details.field_number = check_info["FieldNumber"]
      details.field_name = check_info["FieldName"]
      details
    end
  end
end
