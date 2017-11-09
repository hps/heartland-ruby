module Hps
  #  ===============
  #  = HpsGiftCard =
  #  ===============
  class HpsGiftCard
    attr_accessor :number, :track_data, :alias, :token_value,
                  :encryption_data, :pin

    def initialize(number = nil)
      self.number = number
    end
  end # HpsGiftCard

  #  =======================
  #  = HpsGiftCardActivate =
  #  =======================
  class HpsGiftCardActivate < HpsTransaction
    # Values used in the card activate response
    attr_accessor :authorization_code, :balance_amount, :points_balance_amount

    # The rewards (dollars or points) added to the account as
    # a result of the transaction
    attr_accessor :rewards

    # Notes contain reward messages to be displayed on a receipt,
    # mobile app, or web page to inform an account holder about
    # special rewards or promotions available on their account
    attr_accessor :notes

    def self.from_response(response, txn_type, return_type = nil)
      activation_response = response['Transaction'][txn_type]

      activation = return_type ? return_type.constantize.new : self.new

      activation.transaction_id = response['Header']['GatewayTxnId']
      activation.authorization_code = activation_response['AuthCode']
      activation.balance_amount = activation_response['BalanceAmt']
      activation.points_balance_amount = activation_response['PointsBalanceAmt']
      activation.rewards = activation_response['Rewards']
      activation.notes = activation_response['Notes']
      activation.response_code = activation_response['RspCode']
      activation.response_text = activation_response['RspText']

      return activation
    end # from_response
  end # HpsGiftCardActivate

  #  =========================
  #  = HpsGiftCardDeactivate =
  #  =========================
  class HpsGiftCardDeactivate < HpsGiftCardActivate

  end # HpsGiftCardDeactivate

  #  ======================
  #  = HpsGiftCardReplace =
  #  ======================
  class HpsGiftCardReplace < HpsGiftCardActivate

  end # HpsGiftCardReplace

  #  =======================
  #  = HpsGiftCardReversal =
  #  =======================
  class HpsGiftCardReversal < HpsGiftCardActivate

  end # HpsGiftCardReversal

  #  =====================
  #  = HpsGiftCardReward =
  #  =====================
  class HpsGiftCardReward < HpsGiftCardActivate

  end # HpsGiftCardReward

  #  ======================
  #  = HpsGiftCardBalance =
  #  ======================
  class HpsGiftCardBalance < HpsGiftCardActivate

  end # HpsGiftCardBalance

  #  =======================
  #  = HpsGiftCardAddValue =
  #  =======================
  class HpsGiftCardAddValue < HpsGiftCardActivate

  end # HpsGiftCardAddValue

  #  ===================
  #  = HpsGiftCardVoid =
  #  ===================
  class HpsGiftCardVoid < HpsGiftCardActivate

  end # HpsGiftCardVoid

  #  ===================
  #  = HpsGiftCardSale =
  #  ===================
  class HpsGiftCardSale < HpsGiftCardActivate
    attr_accessor :split_tender_card_amount, :split_tender_balance_due

    def self.from_response(response, txn_type)
      transaction = response['Transaction']
      
      sale = self.superclass.from_response(response, txn_type, self.name)

      sale.split_tender_card_amount = transaction['SplitTenderCardAmt']
      sale.split_tender_balance_due = transaction['SplitTenderBalanceDueAmt']

      return sale
    end # from_response
  end # HpsGiftCardSale

  #  ====================
  #  = HpsGiftCardAlias =
  #  ====================
  class HpsGiftCardAlias < HpsTransaction
    attr_accessor :gift_card

    def self.from_response(response, txn_type)
      alias_response = response['Transaction'][txn_type]

      alias_item = HpsGiftCardAlias.new
      alias_item.transaction_id = response['Header']['GatewayTxnId']
      alias_item.gift_card = HpsGiftCard.new(alias_response['CardData'])
      alias_item.response_code = alias_response['RspCode']
      alias_item.response_text = alias_response['RspText']

      return alias_item
    end # from_response
  end # HpsGiftCardAlias
end # Hps