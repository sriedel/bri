
require 'spec_helper'

describe Bri::Renderer::List::Labeled, type: :renderer do
  subject { render_description_for_method "labeled_list" }

  context "with plain labels" do
    it "should indent the list with two spaces" do
      subject.should =~ %r{\n  \w+: And this is the list item body}
    end

    it "should prefix each list item with its note" do
      subject.should include("First: And this is the list item body")
      subject.should include("Second: Another labled list item")
    end
  end

  context "with aligned labels" do
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
end
