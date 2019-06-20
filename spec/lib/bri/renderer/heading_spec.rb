require 'spec_helper'

describe Bri::Renderer::Heading, type: :renderer  do
  describe " for level one headlines" do
    subject { render_description_for_method( "basic_headline_and_paragraph" ) }

    it "should be marked in green" do
      subject.should include("#{green}This is a headline#{reset}\n")
    end
  end

  describe "for level two headlines" do
    subject { render_description_for_method( "level_two_headline_and_line_wrapping" ) }

    it "should be marked in green" do
      subject.should include("#{green}This is a level two headline#{reset}\n")
    end
  end
end
