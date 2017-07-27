require 'hps'

module Hps
  module TestCheck
    def self.approve
      check = HpsCheck.new()
      check.account_number = '24413815'
      check.routing_number = '490000018'
      check.check_type = HpsCheckType.personal
      check.account_type = HpsAccountType.checking
      check.sec_code = HpsSECCode.ppd

      check.check_holder = HpsCheckHolder.new()
      check.check_holder.first_name = "Bill"
      check.check_holder.last_name = "Johnson"
      check.check_holder.address = HpsAddress.new
      check.check_holder.address.address = "One Heartland Way"
      check.check_holder.address.city = "Jeffersonville"
      check.check_holder.address.state = "IN"
      check.check_holder.address.zip = "47130"
      check.check_holder.address.country = "United States"
      check.check_holder.dl_number = '1234567'
      check.check_holder.dl_state = 'TX'
      check.check_holder.phone = '1234567890'

      check
    end

    def self.invalid_check_holder
      check = HpsCheck.new()
      check.account_number = '24413815'
      check.routing_number = '490000018'
      check.check_type = HpsCheckType.personal
      check.account_type = HpsAccountType.checking
      check.sec_code = HpsSECCode.ppd

      check.check_holder = HpsCheckHolder.new()
      check.check_holder.first_name = "Bill"
      check.check_holder.last_name = "Johnson"
      check.check_holder.address = HpsAddress.new
      check.check_holder.address.address = "One Heartland Way"
      check.check_holder.address.city = "Jeffersonville"
      check.check_holder.address.state = "IN"
      check.check_holder.address.zip = "47130"
      check.check_holder.address.country = "United States"
      check.check_holder.dl_number = ''
      check.check_holder.dl_state = ''
      check.check_holder.phone = '1234567890'

      check
    end

    def self.decline
      check = HpsCheck.new()
      check.account_number = '24413815'
      check.routing_number = '490000034'
      check.check_type = HpsCheckType.personal
      check.account_type = HpsAccountType.checking
      check.sec_code = HpsSECCode.ppd

      check.check_holder = HpsCheckHolder.new()
      check.check_holder.first_name = "Bill"
      check.check_holder.last_name = "Johnson"
      check.check_holder.address = HpsAddress.new
      check.check_holder.address.address = "One Heartland Way"
      check.check_holder.address.city = "Jeffersonville"
      check.check_holder.address.state = "IN"
      check.check_holder.address.zip = "47130"
      check.check_holder.address.country = "United States"
      check.check_holder.dl_number = '1234567'
      check.check_holder.dl_state = 'TX'
      check.check_holder.phone = '1234567890'

      check
    end
  end
end
