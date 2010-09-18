require 'spec_helper'

describe Bri::Matcher do
  describe "#type" do

    context "the query term begins with a capital" do
      subject { Bri::Matcher.new( "Foo" ) }
      its( :type ) { should == :fully_qualified }
    end

    context "the query term begins with a lower case letter" do
      subject { Bri::Matcher.new( "foo" ) }
      its( :type ) { should == :unqualified }
    end

    context "the query term begins with a _" do
      subject { Bri::Matcher.new( "_foo" ) }
      its( :type ) { should == :unqualified }
    end

    context "the query begins with a ." do
      subject { Bri::Matcher.new( ".foo" ) }
      its( :type ) { should == :partially_qualified }
    end

    context "the query begins with a #" do
      subject { Bri::Matcher.new( "#foo" ) }
      its( :type ) { should == :partially_qualified }
    end

    context "it begins with a character other than _, ., #, or a letter" do
      subject { Bri::Matcher.new( "2134" ) }
      its( :type ) { should == :error }
    end
  end

  describe "#subject" do
    context "the term begins with a capital letter" do
      context "and the term contains a ." do
        subject { Bri::Matcher.new( "Foo.bar" ) }
        its( :subject ) { should == :class_method }
      end

      context "and the term contains a #" do
        subject { Bri::Matcher.new( "Foo#bar" ) }
        its( :subject ) { should == :instance_method }
      end

      context "and the term contains neither . nor #" do
        subject { Bri::Matcher.new( "FooBar" ) }
        its( :subject ) { should == :module }
      end
    end
  end

  context "the term begins with a ." do
    subject { Bri::Matcher.new( ".foo" ) }
    its( :subject ) { should == :class_method }
  end

  context "the term begins with a #" do
    subject { Bri::Matcher.new( "#foo" ) }
    its( :subject ) { should == :instance_method }
  end

  context "the term begins with neither a capital letter nor . or #" do
    subject { Bri::Matcher.new( "foo" ) }
    its( :subject ) { should == :method }
  end
end
