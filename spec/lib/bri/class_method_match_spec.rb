require 'spec_helper'

describe Bri::ClassMethodMatch do
  let( :fake_paragraph ) do
    mock( RDoc::Markup::Paragraph, :parts => [ "This is line one",
                                               "This is line two" ] )
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
    subject { Bri::ClassMethodMatch.new( rdoc_method ) }

    its( :full_name ) { should == rdoc_method.full_name }
    its( :call_syntaxes ) { should == "  First\n  Second\n  Third\n" }
    its( :description_paragraphs ) { should == rdoc_method.comment.parts.collect{ |part| part.parts.join(" " ) } }
  end
end
