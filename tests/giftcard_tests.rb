require File.join( File.dirname(__FILE__), "test_helper" )

describe "Giftcard Tests" do

  # Balance
  it "When card is ok, it should return valid response" do
    response = Hps::TestHelper.balance_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

end # Giftcard Tests