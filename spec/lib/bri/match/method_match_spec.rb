require 'spec_helper'

describe Bri::Match::Method do
  let( :fake_paragraph ) do
    RDoc::Markup::Paragraph.new "This is line one", "This is line two" 
  end

  let( :fake_description ) do
    mock( RDoc::Markup::Document, :parts => [ fake_paragraph ] )
  end

  let( :rdoc_method ) do
    mock( RDoc::AnyMethod, :full_name => "This::IS::My.full_name",
                           :call_seq => "First\nSecond\nThird",
                           :comment => fake_description )
  end

  describe "#initialize" do
    subject { Bri::Match::Method.new( rdoc_method ) }

    its( :full_name ) { should == rdoc_method.full_name }
    its( :call_syntaxes ) { should == "  First\n  Second\n  Third\n" }
    its( :description_paragraphs ) { should == [ "  This is line one This is line two" ] }
  end
end
