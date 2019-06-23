require 'spec_helper'

describe Bri::Renderer::List::Note, type: :renderer do
  subject { render_description_for_method "lined_up_labeled_list" }

  it "should prefix each list item an indent and with its note" do
    subject.lines.should include( "  First:       With some text\.\n" )
    subject.lines.should include( "  Secondarily: Lets see if this lines up\.\n")
  end
end
