require File.join( File.dirname(__FILE__), "test_data.rb" )
require File.join( File.dirname(__FILE__), "test_check.rb" )
require "hps"
require "rspec"

module Hps
  module TestHelper

    def self.configure_hps_module
      Hps.configure do |config|
        config.service_uri = "https://cert.api2.heartlandportico.com/Hps.Exchange.PosGateway/PosGatewayService.asmx?wsdl"
        config.user_name = "777700004035"
        config.password = "$Test1234"
        config.developer_id = 123456
        config.version_number = 1234
        config.license_id = 20855
        config.device_id = 1519321
        config.site_id = 20856
        config.site_trace = "trace0001"
      end
    end


    def self.configure_hps_module_secret_key
      Hps.configure do |config|
        config.secret_api_key = "skapi_uat_MXZOAAC7LmEFVeOYGlVHe_WhvRf_UzWzJq5VJ8A-jA"
      end
    end

    def self.configure_hps_module_secret_key_with_spaces
      Hps.configure do |config|
        #config.service_uri = "https://cert.api2.heartlandportico.com/Hps.Exchange.PosGateway/PosGatewayService.asmx?wsdl"
        config.secret_api_key = "  skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ  "
      end
    end

    def self.configure_hps_module_for_certification
      Hps.configure do |config|
        config.service_uri = "https://cert.api2.heartlandportico.com/Hps.Exchange.PosGateway/PosGatewayService.asmx?wsdl"
        config.user_name = "777700005412"
        config.password = "$Test1234"
        config.developer_id = 123456
        config.version_number = 1234
        config.license_id = 20994
        config.device_id = 1522326
        config.site_id = 20995
        config.site_trace = "trace0001"
      end
    end

    def self.charge_valid_amex(amount)
      TestHelper.configure_hps_module()
      service = Hps::HpsChargeService.new()
      service.charge(amount, "usd", TestData.valid_amex, TestData.valid_cardholder)
    end

    def self.charge_valid_discover(amount)
      TestHelper.configure_hps_module()
      service = Hps::HpsChargeService.new()
      service.charge(amount, "usd", TestData.valid_discover, TestData.valid_cardholder)
    end

    def self.charge_valid_mastercard(amount)
      TestHelper.configure_hps_module()
      service = Hps::HpsChargeService.new()
      service.charge(amount, "usd", TestData.valid_mastercard, TestData.valid_cardholder)
    end

    def self.charge_valid_visa(amount)
      TestHelper.configure_hps_module()
      service = Hps::HpsChargeService.new()
      service.charge(amount, "usd", TestData.valid_visa, TestData.valid_cardholder)
    end

    def self.charge_token(token_value,multi_use=false)
      TestHelper.valid_multi_use_config
      service = Hps::HpsChargeService.new()
      service.charge(50, "usd", token_value, TestData.valid_cardholder,multi_use)
    end

    def self.auth_token(token_value,multi_use=false)
      TestHelper.valid_multi_use_config
      service = Hps::HpsChargeService.new()
      service.authorize(50, "usd", token_value, TestData.valid_cardholder,multi_use)
    end

    def self.verify_token(token_value,multi_use=false)
      TestHelper.valid_multi_use_config
      service = Hps::HpsChargeService.new()
      service.verify(token_value, TestData.valid_cardholder,multi_use)
    end

    def self.refund_token(token_value)
      TestHelper.valid_multi_use_config
      service = Hps::HpsChargeService.new()
      service.refund(50,'usd',token_value, TestData.valid_cardholder)
    end

    def self.reverse_token(token_value)
      TestHelper.valid_multi_use_config
      service = Hps::HpsChargeService.new()
      service.reverse(token_value,50,'usd')
    end

    def self.valid_multi_use_public_key
      'pkapi_cert_MrSafdEKB2dIHQEzDk'
    end

    def self.valid_multi_use_config
      Hps.configure do |config|
        config.secret_api_key ='skapi_cert_MYl2AQAowiQAbLp5JesGKh7QFkcizOP2jcX9BrEMqQ'
      end
    end

  end
end
