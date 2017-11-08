require File.join( File.dirname(__FILE__), "test_helper" )

describe "Giftcard Tests" do

  # Check the balance on a card
  it "When card is ok, it should return valid response" do
    response = Hps::TestHelper.balance_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Activate a card
  it "When card is ok, it should activate and return valid response" do
    response = Hps::TestHelper.activate_valid_gift_card(100.00)
    expect( response.response_code ).to eql("0")
  end

  # Add value to a card
  it "When card is ok, it should add value and return a valid response" do
    response = Hps::TestHelper.add_value_to_valid_gift_card(100.00)
    expect( response.response_code ).to eql("0")
  end

end # Giftcard Tests