module Hps
  class HpsCheck
    attr_accessor :routing_number,
                  :account_number,
                  :check_number,
                  :check_type,
                  :check_holder,
                  :micr_number,
                  :account_type,
                  :data_entry_mode,
                  :check_verify,
                  :sec_code

    def initialize
      @data_entry_mode = HpsDataEntryMode.manual
    end
  end
end
