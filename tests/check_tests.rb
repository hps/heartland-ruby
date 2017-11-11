require File.join( File.dirname(__FILE__), "test_helper.rb" )

describe "Check Tests" do
  before(:each) do
    Hps::TestHelper.configure_hps_module_secret_key_with_spaces
    @service = Hps::HpsCheckService.new()
  end

  it "check should decline" do
    expect {
      @service.sale(Hps::TestCheck::decline, 5.00)
    }.to raise_error(Hps::HpsCheckException) { |error|
      expect(error.code).to eql("1")
    }
  end

  it "should throw check exception" do
    expect {
      @service.sale(Hps::TestCheck::invalid_check_holder, 5.00)
    }.to raise_error(Hps::HpsCheckException) { |error|
      expect(error.code).to eql("1")
    }
  end

  it "check should sale" do
    result = @service.sale(Hps::TestCheck::approve, 5.00)
    expect(result).not_to eql(nil)
    expect(result.response_code).to eql("0")
    expect(result.response_text).to eql("Transaction Approved")
  end

  it "check should void" do
    sale_result = @service.sale(Hps::TestCheck::approve, 5.00)
    result = @service.void(sale_result.transaction_id)
    expect(result).not_to eql(nil)
    expect(result.response_code).to eql("0")
  end

  it "sale and void with client_txn_id" do
    client_txn_id = 10244205
    sale_result = @service.sale(Hps::TestCheck::approve, 5.00, client_txn_id)
    expect(sale_result).not_to eql(nil)
    expect(sale_result.response_code).to eql("0")
    expect(sale_result.response_text).to eql("Transaction Approved")

    void_result = @service.void(nil, client_txn_id)
    expect(void_result).not_to eql(nil)
    expect(void_result.response_code).to eql("0")
  end
end
