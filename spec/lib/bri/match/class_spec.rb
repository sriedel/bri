require 'spec_helper'

describe Bri::Match::Class do
  let( :fully_developed_class ) do
    search_instance = Bri::Search::Class.new( "BriDummySpecClassTwo" ) 
    search_instance.search
    search_instance.matches.first
  end

  let( :empty_class ) do
    search_instance = Bri::Search::Class.new( "BriDummySpecClassEmpty" ) 
    search_instance.search
    search_instance.matches.first
  end

  let( :empty_module ) do
    search_instance = Bri::Search::Class.new( "BriDummySpecModule" ) 
    search_instance.search
    search_instance.matches.first
  end

  let( :namespaced_class ) do
    search_instance = Bri::Search::Class.new( "BriDummySpec::Class" ) 
    search_instance.search
    search_instance.matches.first
  end

  describe "#type" do
    it "should be class for a class" do
      empty_class.type.should == "class"
    end

    it "should be module for a module" do
      empty_module.type.should == "module"
    end
  end

  describe "#name" do
    it "should contain the name of a class" do
      empty_class.name.should == "BriDummySpecClassEmpty < Object"
    end

    it "should contain the fully qualified name of a namespaced class" do
      namespaced_class.name.should == "BriDummySpec::Class < Object"
    end
  end

  describe "#description_paragraphs" do
    it "should be empty for an undocumented class" do
      empty_class.description_paragraphs.should == [ '' ]
    end

    it "should contain rendered text for a documented class" do
      fully_developed_class.description_paragraphs.size.should == 1
      fully_developed_class.description_paragraphs.first.should =~ /This is a class description/
    end
  end

  describe "#includes" do
    it "should be empty for a class without includes" do
      empty_class.includes.should be_empty
    end

    it "should contain a list of includes for classes with includes" do
      fully_developed_class.includes.size.should == 1
      fully_developed_class.includes.should include( "BriDummySpecModule" )
    end
  end

  describe "#constants" do
    it "should be empty for a class without constants" do
      empty_class.constants.should be_empty
    end

    it "should contain a list of constants for classes with constants" do
      fully_developed_class.constants.size.should == 2
      fully_developed_class.constants.should include( "CONSTANT" )
      fully_developed_class.constants.should include( "OTHER_CONSTANT" )
    end
  end

  describe "#attributes" do
    it "should be empty for a class without attributes" do
      empty_class.attributes.should be_empty
    end

    it "should contain a list of attributes for classes with attr_* declarations" do
      fully_developed_class.attributes.should_not be_empty
    end

    it "should mark attr_readers as read only" do
      fully_developed_class.attributes.should include( "read_attr (R)" )
    end

    it "should mark attr_writers as write only" do
      fully_developed_class.attributes.should include( "write_attr (W)" )
    end

    it "should mark attr_accessors as read/writeable" do
      fully_developed_class.attributes.should include( "access_attr (RW)" )
    end
  end

  describe "#class_methods" do
    it "should be empty for a class without class methods" do
      empty_class.class_methods.should be_empty
    end

    it "should contain class methods for classes with class methods" do
      fully_developed_class.class_methods.size.should == 1
      fully_developed_class.class_methods.first.should == "bri_dummy_spec_second_singleton_method"
    end
  end

  describe "#instance_methods" do
    it "should be empty for a class without instance methods" do
      empty_class.instance_methods.should be_empty
    end

    it "should contain class methods for classes with class methods" do
      fully_developed_class.instance_methods.size.should == 1
      fully_developed_class.instance_methods.first.should == "bri_dummy_spec_instance_method_with_arguments"
    end
  end
end
