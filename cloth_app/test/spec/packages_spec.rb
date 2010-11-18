require 'Package'

describe Package do
  fixtures :packages

  before :each do
    @package = Package
  end

  #Behaviour
  it "should have an registered user" do
    @package.has_user?
    @package.user.is_registered?
  end

  it "should have necessary data" do
    @package = create_package
  end

  it "should have confirmed by the user" do
    @package.confirmed?
  end

  it "should have accepted the rules of creation" do
    @package.accepted?
  end

  it "should have at minium 10 clothes" do
     @package.enough_clothes?
  end

  it "should be searched by size" do
     
  end

  it "should be searched by sex" do

  end

  it "should be searched by saison" do

  end

  it "should been shown to everyone" do

  end

  it "should been shown new packages during the first 24 hours for premiums" do
    
  end

  it "should be ordered only by premiums" do
    
  end
  
end
