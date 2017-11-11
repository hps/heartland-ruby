module Hps
  class HpsCheckService < HpsService
    def sale(check, amount, client_txn_id = nil)
      build_transaction('SALE', check, amount, client_txn_id)
    end

    def void(transaction_id = nil, client_txn_id = nil)
      if (transaction_id == nil && client_txn_id == nil) ||
          (transaction_id != nil && client_txn_id != nil)
        raise Error, 'Please provide either a transaction ID or a client transaction ID'
      end

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps :CheckVoid do
          xml.hps :Block1 do
            xml.hps :GatewayTxnId, transaction_id if transaction_id
            xml.hps :ClientTxnId, client_txn_id if client_txn_id
          end
        end
      end

      submit_transaction(xml.target!, :CheckVoid)
    end

    private

    def build_transaction(action, check, amount, client_txn_id)
      amount = HpsInputValidation::check_amount(amount)

      if check.sec_code == HpsSECCode.ccd &&
          (check.check_holder == nil || check.check_holder.check_name == nil)
        raise Error, 'For SEC code CCD, the check name is require', 'check_name'
      end

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps :CheckSale do
          xml.hps :Block1 do
            xml.hps :Amt, amount
            xml << hydrate_check_data(check)
            xml.hps :CheckAction, action
            xml.hps :SECCode, check.sec_code
            xml.hps :CheckType, check.check_type if check.check_type
            xml << hydrate_consumer_info(check.check_holder) if check.check_holder
          end
        end
      end

      submit_transaction(xml.target!, :CheckSale, client_txn_id)
    end

    def hydrate_check_data(check)
      xml = Builder::XmlMarkup.new
      xml.hps :AccountInfo do
        xml.hps :AccountNumber, check.account_number if check.account_number
        xml.hps :CheckNumber, check.check_number if check.check_number
        xml.hps :MICRData, check.micr_number if check.micr_number
        xml.hps :RoutingNumber, check.routing_number if check.routing_number
        xml.hps :AccountType, check.account_type if check.account_type
      end
      xml.target!
    end

    def hydrate_consumer_info(check_holder)
      xml = Builder::XmlMarkup.new
      xml.hps :ConsumerInfo do
        if check_holder.address
          xml.hps :Address1, check_holder.address.address if check_holder.address.address
          xml.hps :City, check_holder.address.city if check_holder.address.city
          xml.hps :State, check_holder.address.state if check_holder.address.state
          xml.hps :Zip, check_holder.address.zip if check_holder.address.zip
        end

        xml.hps :CheckName, check_holder.check_name if check_holder.check_name
        xml.hps :CourtesyCard, check_holder.courtesy_card if check_holder.courtesy_card
        xml.hps :DLNumber, check_holder.dl_number if check_holder.dl_number
        xml.hps :DLState, check_holder.dl_state if check_holder.dl_state
        xml.hps :EmailAddress, check_holder.email if check_holder.email_address
        xml.hps :FirstName, check_holder.first_name if check_holder.first_name
        xml.hps :LastName, check_holder.last_name if check_holder.last_name
        xml.hps :PhoneNumber, check_holder.phone if check_holder.phone

        if check_holder.ssl4 || check_holder.dob_year
          xml.hps :IdentityInfo do
            xml.hps :SSNL4, check_holder.ssl4 if check_holder.ssl4
            xml.hps :DOBYear, check_holder.dob_year if check_holder.dob_year
          end
        end
      end

      xml.target!
    end

    def submit_transaction(xml, txn_type, client_txn_id = nil)
      response = doTransaction(xml, client_txn_id)
      HpsGatewayResponseValidation::check_response(response, txn_type)
      response = HpsCheckResponse::from_hash(response, txn_type)

      return response if response.response_code == '0'

      raise HpsCheckException.new(
        response.transaction_id,
        response.details,
        response.response_code,
        response.response_text
      )
    end
  end
end
