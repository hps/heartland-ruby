require File.join( File.dirname(__FILE__), "test_helper" )

describe "Giftcard Tests" do

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

  # Check the balance on a card
  it "When card is ok, it should return valid response" do
    response = Hps::TestHelper.balance_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Deactivate a card
  it "When card is ok, it should deactivate and return a valid response" do
    response = Hps::TestHelper.deactivate_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Replace a card
  it "When card is ok, it should replace it and return a valid response" do
    response = Hps::TestHelper.replace_valid_gift_card
    expect( response.response_code ).to eql("0")
  end

  # Add rewards to a card
  it "When card is ok, it should add rewards and return a valid response" do
    ["USD", "POINTS"].each do |currency|
      response = Hps::TestHelper.reward_valid_gift_card(10, currency)
      expect( response.response_code ).to eql("0")
    end
  end

end # Giftcard Tests