require 'spec_helper'

describe Bri::Renderer::Paragraph, type: :renderer do
  subject { render_description_for_method( "basic_headline_and_paragraph" ) }

  it "should be indented by two spaces" do
    subject.should =~ /^  Followed by some introduction text.\s*\n/
  end

  context "containing long rows" do
    subject { render_description_for_method( "level_two_headline_and_line_wrapping" ) }

    it "should be wrapped" do
      subject.should =~ /\n  This is a paragraph with a really really really really really really\s*\n  really really really really long line that needs to be wrapped\.\n/
    end
  end
end
