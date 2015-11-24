require File.join( File.dirname(File.dirname(__FILE__)), "test_helper" )

describe "Card Present Certification Tests" do
  let(:test_descriptor)  { "Heartland, Inc." }
  let(:visa_swipe)       { '%B4012002000060016^VI TEST CREDIT^251210118039000000000396?;4012002000060016=25121011803939600000?' }
  let(:mastercard_swipe) { '%B5473500000000014^MC TEST CARD^251210199998888777766665555444433332?;5473500000000014=25121019999888877776?' }
  let(:discover_swipe)   { '%B6011000990156527^DIS TEST CARD^25121011000062111401?;6011000990156527=25121011000062111401?' }
  let(:amex_swipe)       { '%B3727 006992 51018^AMEX TEST CARD^2512990502700?;372700699251018=2512990502700?' }

  it "should close batch ok" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsBatchService.new

    response = service.close_batch()

    expect(response).to_not be_nil
  end

  it "should verify with visa swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = visa_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    verify = service.verify_swipe(track_data)

    expect(verify).to_not be(nil)
    expect(verify.response_code).to eql("85")
  end

  it "should verify with mastercard swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = mastercard_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    verify = service.verify_swipe(track_data)

    expect(verify).to_not be(nil)
    expect(verify.response_code).to eql("85")
  end

  it "should verify with discover swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = discover_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    verify = service.verify_swipe(track_data)

    expect(verify).to_not be(nil)
    expect(verify.response_code).to eql("85")
  end

  it "should verify with amex swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = amex_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    verify = service.verify(Hps::TestData.valid_amex, Hps::TestData.cert_cardholder_shortzip)

    expect(verify).to_not be(nil)
    expect(verify.response_code).to eql("00")
  end

  it "should charge with token req and visa swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = visa_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.01, "usd", track_data, nil, 0, false, true)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with token req and mastercard swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = mastercard_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.02, "usd", track_data, nil, 0, false, true)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with token req and discover swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = discover_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.03, "usd", track_data, nil, 0, false, true)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with token req and amex swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = amex_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.04, "usd", track_data, nil, 0, false, true)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with visa swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = visa_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.01, "usd", track_data)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with mastercard swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = mastercard_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.02, "usd", track_data)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with discover swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = discover_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.03, "usd", track_data)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with amex swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = amex_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.04, "usd", track_data)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with discover jcb swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = "%B6011000990156527^DIS TEST CARD^25121011000062111401?;6011000990156527=25121011000062111401?"
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.04, "usd", track_data)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with visa swipe" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    track_data = Hps::HpsTrackData.new
    track_data.value = visa_swipe
    track_data.method_obtained = Hps::HpsTrackDataMethod::SWIPE

    charge = service.charge_swipe(15.06, "usd", track_data)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card present and visa manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_visa
    card.card_present = true

    charge = service.charge(16.01, "usd", card, Hps::TestData.cert_cardholder_shortzip)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card present and mastercard manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_mastercard
    card.card_present = true

    charge = service.charge(16.02, "usd", card, Hps::TestData.cert_cardholder_shortzip_no_street)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card present and discover manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_discover
    card.card_present = true

    charge = service.charge(16.03, "usd", card, Hps::TestData.cert_cardholder_longzip_no_street)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card present and amex manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_amex
    card.card_present = true

    charge = service.charge(16.04, "usd", card, Hps::TestData.cert_cardholder_shortzip)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge card present and with jcb manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_jcb
    card.card_present = true

    charge = service.charge(16.05, "usd", card, Hps::TestData.cert_cardholder_longzip)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card not present and visa manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_visa
    card.card_present = true

    charge = service.charge(17.01, "usd", card, Hps::TestData.cert_cardholder_shortzip)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card not present and mastercard manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_mastercard
    card.card_present = true

    charge = service.charge(17.02, "usd", card, Hps::TestData.cert_cardholder_shortzip_no_street)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card not present and discover manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_discover
    card.card_present = true

    charge = service.charge(17.03, "usd", card, Hps::TestData.cert_cardholder_longzip_no_street)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge with card not present and amex manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_amex
    card.card_present = true

    charge = service.charge(17.04, "usd", card, Hps::TestData.cert_cardholder_shortzip)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end

  it "should charge card not present and with jcb manual" do
    Hps::TestHelper.valid_multi_use_config
    service = Hps::HpsChargeService.new
    card = Hps::TestData.valid_jcb
    card.card_present = true

    charge = service.charge(17.05, "usd", card, Hps::TestData.cert_cardholder_longzip)

    expect(charge).to_not be_nil
    expect(charge.response_code).to eql("00")
  end
end
