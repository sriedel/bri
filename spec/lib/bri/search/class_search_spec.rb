require 'spec_helper'

describe Bri::ClassSearch do
  describe "#initialize" do
    subject { Bri::ClassSearch.new( "term" ) }
    its( :term ) { should == "term" }
    its( :matches ) { should be_empty }
  end
end
