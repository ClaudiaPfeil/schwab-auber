require 'orders'

describe Orders do
  fixtures :orders
  
  before(:each) do
    @orders = Orders.new
  end

  it "should created by an registered user" do
    # TODO
  end

  it "should created by an registered user with packages" do
    # TODO
  end

  it "should followed by an evaluation" do
    # TODO
  end

  it "should have an receipt" do
    # TODO
  end

  it "should have a billing" do
    # TODO
  end
  
end

