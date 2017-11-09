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

  # Complete a sale
  it "When card is ok, it should complete a sale and return a valid response" do
    response = Hps::TestHelper.sale_valid_gift_card(10)
    expect( response.response_code ).to eql("0")
  end

  # Void a transaction
  it "Should void a transaction" do
    response = Hps::TestHelper.sale_valid_gift_card(10)
    expect( response.response_code ).to eql("0")
    void_response = Hps::TestHelper.void_gift_card_sale( response.transaction_id )
    expect( void_response.response_code ).to eql("0")
  end

  # Reverse a transaction using transaction id
  it "Should reverse a gift card transaction using the transaction id" do
    response = Hps::TestHelper.sale_valid_gift_card(10)
    expect( response.response_code ).to eql("0")
    reverse_response = Hps::TestHelper.reverse_gift_card_sale( 10, response.transaction_id )
    expect( reverse_response.response_code ).to eql("0")
  end

  # Reverse transaction using giftcard
  it "Should reverse a giftcard transaction using the card" do
    response = Hps::TestHelper.sale_valid_gift_card(10, "USD", nil, nil, false)
    expect( response.response_code ).to eql("0")
    reverse_response = Hps::TestHelper.reverse_gift_card_sale(10)
    expect( reverse_response.response_code ).to eql("0")
  end

end # Giftcard Tests