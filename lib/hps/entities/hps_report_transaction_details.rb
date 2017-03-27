module Hps
  class HpsReportTransactionDetails < HpsAuthorization
    attr_accessor :original_transaction_id, :masked_card_number, :transaction_type, :transaction_date, :exceptions,
                  :transaction_status

    def initialize(header)
      super(header)
    end
  end
end
