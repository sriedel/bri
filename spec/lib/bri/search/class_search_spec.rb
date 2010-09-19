require 'spec_helper'

describe Bri::Search::Class do
  describe "#initialize" do
    subject { Bri::Search::Class.new( "term" ) }
    its( :term ) { should == "term" }
    its( :matches ) { should be_empty }
  end
end
