require 'spec_helper'

describe Bri::Renderer::List, type: :renderer do
  describe "bulleted lists with *" do
    subject { render_description_for_method( "bulleted_list" ) }
    it "should indent the list with one space" do
      subject.should =~ %r{\n .  First item in a bulleted list}
    end

    it "should prefix each list item with a '*' bullet" do
      subject.should =~ %r{\*  First item in a bulleted list}
      subject.should =~ %r{\*  Second item in a bulleted list}
      subject.should =~ %r{\*  Ending a bulleted list}
    end

    it "should wrap long lines" do
      subject.should =~ %r{\n \*  Ending a bulleted list with a really really really really really \n    really really really long line that needs to be wrapped\n}
    end

    it "should start second lines of a list item with the same left alignment as the first list items content" do
      subject.should =~ %r{\n \*  First item in a bulleted list(?:\s*?)\n    With a second line\n}
    end

    context "contained verbatim text" do
      subject { render_description_for_method( "list_containing_verbatim_text" ) }
      
      it "should correctly display verbatim text" do
        subject.should =~ %r{\n    Containing verbatim text\n}
      end
    end

    context "a nested bulleted list" do
      it "should indent the second level with five spaces" do
        subject.should =~ %r{\n     .  First item of a nested bulleted list}
        subject.should =~ %r{\n     .  Second item of a nested bulleted list}
      end
    end

    context "a nested numbered list" do
      subject { render_description_for_method( "mixed_list" ) }
      it "should indent the second level with four spaces" do
        subject.should =~ %r{\n    \d\.  And numbers in a sublist\n}
      end
    end
  end

  describe "bulleted lists with -" do
    subject { render_description_for_method "second_bulleted_list" }
    it "should indent the list with one space" do
      subject.should =~ %r{\n .  A second bulleted list}
    end

    it "should prefix each list item with a '*' bullet" do
      subject.should =~ %r{\*  A second bulleted list}
      subject.should =~ %r{\*  Second item in second bulleted list}
      subject.should =~ %r{\*  Ending the second bulleted list}
    end

    it "should indent the second level with four spaces" do
      subject.should =~ %r{\n     .  Nested bulleted list}
      subject.should =~ %r{\n     .  Second nested bulleted list item}
    end
  end

  describe "numbered lists" do
    subject { render_description_for_method "numbered_list" }

    it "should not indent the list items" do
      subject.should =~ %r{\n\d\.  First numbered list item}
    end

    it "should prefix each list item with a consecutive number" do
      subject.should =~ %r{1\.  First numbered list item}
      subject.should =~ %r{2\.  Second numbered list}
      subject.should =~ %r{3\.  Ending the main numbered list item}
    end

    context "nested numbered lists" do
      it "should indent the second level with four spaces" do
        subject.should =~ %r{\n    \d\.  Nested numbered list item}
        subject.should =~ %r{\n    \d\.  Second nested numbered list item}
      end

      it "should restart the numbering for nested lists" do
        subject.should =~ %r{1\.  Nested numbered list item}
        subject.should =~ %r{2\.  Second nested numbered list item}
      end
    end

    context "nested bulleted lists" do
      subject { render_description_for_method "second_mixed_list" }
      it "should indent the second level with five spaces" do
        subject.should =~ %r{\n     .  Nested bulleted list}
      end

      it "should prefix each nested list item with a '*' bullet" do
        subject.should =~ %r{\*  Nested bulleted list}
      end
    end
  end

  describe "lettered lists" do
    subject { render_description_for_method "lettered_list" }

    it "should not indent the list items" do
      subject.should =~ %r{\n.\.  Some goes for lettered lists}
    end

    it "should prefix each list item with a consecutive letter" do
      subject.should =~ %r{a\.  Some goes for lettered lists}
      subject.should =~ %r{b\.  Second item in a lettered list}
      subject.should =~ %r{c\.  Ending the main lettered list item}
    end

    context "nested lettered lists" do
      it "should indent the second level with four spaces" do
        subject.should =~ %r{\n    .\.  And a nested lettered list item}
      end

      it "should restart the lettering for nested lists" do
        subject.should =~ %r{a\.  And a nested lettered list item}
        subject.should =~ %r{b\.  Second nested lettered list item}
      end
    end
  end

  describe "labeled lists" do
    subject { render_description_for_method "labeled_list" }

    context "with plain labels" do
      it "should indent the list with two spaces" do
        subject.should =~ %r{\n  \w+: And this is the list item body}
      end

      it "should prefix each list item with its note" do
        subject.should =~ %r{First: And this is the list item body}
        subject.should =~ %r{Second: Another labled list item}
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
        subject.should =~ %r{First:       With some text\.}
        subject.should =~ %r{Secondarily: Lets see if this lines up\.}
      end
    end
  end
end
