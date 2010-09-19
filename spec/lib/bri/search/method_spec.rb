require 'spec_helper'

describe Bri::Search::Method do
  describe "#initialize" do
    context "the searchterm is a class" do
      subject { Bri::Search::Method.new( "Class" ) }
      its( :class_term ) { should == "Class" }
      its( :method_term ) { should be_nil }
    end

    context "the search term is a fully qualified class method" do
      subject { Bri::Search::Method.new( "Class.method" ) }
      its( :class_term ) { should == "Class" }
      its( :method_term ) { should == "method" }
    end

    context "the search term is a fully qualified instance method" do
      subject { Bri::Search::Method.new( "Class#method" ) }
      its( :class_term ) { should == "Class" }
      its( :method_term ) { should == "method" }
    end

    context "the search term begins with a ." do
      subject { Bri::Search::Method.new( ".method" ) }
      its( :class_term ) { should be_nil }
      its( :method_term ) { should == "method" }
    end

    context "the search term begins with a #" do
      subject { Bri::Search::Method.new( "#method" ) }
      its( :class_term ) { should be_nil }
      its( :method_term ) { should == "method" }
    end

    context "the search term is not a class and does not contain a . or #" do
      subject { Bri::Search::Method.new( "method" ) }
      its( :class_term ) { should be_nil }
      its( :method_term ) { should == "method" }
    end
  end
end
