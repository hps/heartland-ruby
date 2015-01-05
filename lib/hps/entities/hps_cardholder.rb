module Hps
	class HpsCardHolder

		attr_accessor :first_name, :last_name, :phone, :email_address, :address

		def initialize
			self.address = Hps::HpsAddress.new
		end

	end
end