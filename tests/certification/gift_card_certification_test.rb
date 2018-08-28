require File.join( File.dirname(File.dirname(__FILE__)), "test_helper" )

describe "Gift card certification tests" do
  let(:service) do
    Hps::TestHelper.valid_multi_use_config
    Hps::HpsGiftCardService.new
  end

  # Test #96
  it "testActivateSVA1" do
    activation = service.activate( sva1, 6.00 )
    expect( activation.response_code ).to eql("0")
  end

  # Test #97
  it "testActivateSVA2" do
    activation = service.activate( sva2, 7.00 )
    expect( activation.response_code ).to eql("0")
  end

  # Test #98
  it "testAddValueSVA1" do
    add_value = service.add_value( sva1, 8.00 )
    expect( add_value.response_code ).to eql("0")
  end

  # Test #99
  it "testAddValueSVA2" do
    add_value = service.add_value( sva2, 9.00 )
    expect( add_value.response_code ).to eql("0")
  end

  # Test #100
  it "testBalanceSVA1" do
    balance = service.balance( sva1 )
    expect( balance.response_code ).to eql("0")
    expect( balance.balance_amount.to_i ).to eql(10)
  end

  # Test #101
  it "testBalanceSVA2" do
    balance = service.balance( sva2 )
    expect( balance.response_code ).to eql("0")
    expect( balance.balance_amount.to_i ).to eql(10)
  end

  # Test #102
  it "testReplaceSVA1" do
    replace = service.replace(sva1, sva2)
    expect( replace.response_code ).to eql("0")
  end

  # Test #103
  it "testReplaceSVA2" do
    replace = service.replace(sva2, sva1)
    expect( replace.response_code ).to eql("0")
  end

  # Test #104
  it "testSaleSVA1" do
    sale = service.sale(sva1, 1.00)
    expect( sale.response_code ).to eql("0")
  end

  # Test #105
  it "testSaleSVA2" do
    sale = service.sale(sva2, 2.00)
    expect( sale.response_code ).to eql("0")
  end

  # Test #106 & Test #108
  it "testSaleAndVoidSVA1" do
    sale = service.sale(sva1, 3.00)
    expect( sale.response_code ).to eql("0")
    void = service.void(sale.transaction_id)
    expect( void.response_code ).to eql("0")
  end

  # Test #107 & Test # 109
  it "testSaleAndReversalSVA2" do
    sale = service.sale(sva2, 4.00)
    expect( sale.response_code ).to eql("0")
    reverse = service.reverse(sale.transaction_id, 4.00)
    expect( reverse.response_code ).to eql("0")
  end

  # Test #110
  it "testDeactivateSVA1" do
    deactivate = service.deactivate(sva1)
    expect( deactivate.response_code ).to eql("0")
  end

  # Test #111
  it "testDeactivateSVA1" do
    deactivate = service.deactivate(sva2)
    expect( deactivate.response_code ).to eql("0")
  end
end

# Helper methods
def sva1
  Hps::HpsGiftCard.new(5022440000000000098)
end

def sva2
  Hps::HpsGiftCard.new(5022440000000000007)
end