require 'spec_helper'

describe Bri::Renderer::Rule, type: :renderer do
  subject { render_description_for_method( "horizontal_rule" ) }

  it "should be rendered as an indented row of dashes" do
    rule = "-" * Bri.width
    subject.should =~ /\n  #{rule}\n/
  end
end
