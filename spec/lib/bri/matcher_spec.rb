require 'spec_helper'

describe Bri::Matcher do
  describe "#match_type" do
    context "the query term begins with a capital" do
      it "should return :fully_qualified" do
        subject.match_type( "Foo" ).should == :fully_qualified
      end
    end

    context "the query term begins with a lower case letter" do
      it "should return :unqualified" do
        subject.match_type( "foo" ).should == :unqualified
      end
    end

    context "the query term begins with a _" do
      it "should return :unqualified" do
        subject.match_type( "_foo" ).should == :unqualified
      end
    end

    context "the query begins with a ." do
      it "should return :partially_qualified" do
        subject.match_type( ".foo" ).should == :partially_qualified
      end
    end

    context "the query begins with a #" do
      it "should return :paritally_qualified" do
        subject.match_type( "#foo" ).should == :partially_qualified
      end
    end

    context "it begins with a character other than _, ., #, or a letter" do
      it "should return :unknown" do
        subject.match_type( "1234" ).should == :error
      end
    end
  end

  describe "#match_subject" do
    context "the term begins with a capital letter" do
      context "and the term contains a ." do
        it "should return :class_method" do
          subject.match_subject( "Foo.bar" ).should == :class_method
        end
      end

      context "and the term contains a #" do
        it "should return :instance_method" do
          subject.match_subject( "Foo#bar" ).should == :instance_method
        end
      end

      context "and the term contains neither . nor #" do
        it "should return :module" do
          subject.match_subject( "FooBar" ).should == :module
        end
      end
    end
  end

  context "the term begins with a ." do
    it "should return :class_method" do
      subject.match_subject( ".foo" ).should == :class_method
    end
  end

  context "the term begins with a #" do
    it "should return :instance_method" do 
      subject.match_subject( "#foo" ).should == :instance_method
    end
  end

  context "the term begins with neither a capital letter nor . or #" do
    it "should return :method" do
      subject.match_subject( "foo" ).should == :method
    end
  end
end
