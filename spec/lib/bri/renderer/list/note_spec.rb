require 'spec_helper'

describe Bri::Renderer::List::Note, type: :renderer do
  subject { render_description_for_method "lined_up_labeled_list" }

  it "should intent the list with two spaces" do
    subject.should =~ %r{\n  \w+:\s+With some text\.}
  end

  it "should prefix each list item with its note" do
    subject.should =~ %r{First:\s+With some text\.}
    subject.should =~ %r{Secondarily:\s+Lets see if this lines up\.}
  end

  it "should have the list item bodies left aligned to the same position" do
    subject.should include("First:       With some text.")
    subject.should include("Secondarily: Lets see if this lines up.")
  end
end
