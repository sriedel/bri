require 'spec_helper'

describe Bri::Renderer do
  def render_description_for_method( method_name )
    search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass##{method_name}_rendering_test_method" ) 
    search_instance.search( :fully_qualified )
    search_instance.matches.first.to_s
  end

  let( :green ) { Regexp.escape( Term::ANSIColor::green ) }
  let( :yellow )  { Regexp.escape( Term::ANSIColor::yellow ) }
  let( :cyan )  { Regexp.escape( Term::ANSIColor::cyan ) }
  let( :bold )  { Regexp.escape( Term::ANSIColor::bold ) }
  let( :italic )  { Regexp.escape( Term::ANSIColor::italic ) }
  let( :underline )  { Regexp.escape( Term::ANSIColor::underline ) }
  let( :reset ) { Regexp.escape( Term::ANSIColor::reset ) }

  describe "headers" do
    context " for level one headlines" do
      subject { render_description_for_method( "basic_headline_and_paragraph" ) }

      it "should be marked in green" do
        subject.should =~ /#{green}This is a headline#{reset}\n/
      end
    end

    context "for level two headlines" do
      subject { render_description_for_method( "level_two_headline_and_line_wrapping" ) }

      it "should be marked in green" do
        subject.should =~ /#{green}This is a level two headline#{reset}\n/
      end
    end
  end

  describe "paragraphs" do
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

  describe "horizontal rules" do
    subject { render_description_for_method( "horizontal_rule" ) }

    it "should be rendered as an indented row of dashes" do
      rule = "-" * Bri.width
      subject.should =~ /\n  #{rule}\n/
    end
  end

  describe "bulleted lists with *" do
    subject { render_description_for_method( "bulleted_list" ) }
    it "should indent the list with one space" do
      subject.should =~ /\n .  First item in a bulleted list/
    end

    it "should prefix each list item with a '*' bullet" do
      subject.should =~ /\*  First item in a bulleted list/
      subject.should =~ /\*  Second item in a bulleted list/
      subject.should =~ /\*  Ending a bulleted list/
    end

    it "should wrap long lines" do
      subject.should =~ /\n \*  Ending a bulleted list with a really really really really really \n    really really really long line that needs to be wrapped\n/
    end

    it "should start second lines of a list item with the same left alignment as the first list items content" do
      pending "FIXME"
      subject.should =~ /\n \*  First item in a bulleted list\n    With a second line\n/
    end

    context "contained verbatim text" do
      subject { render_description_for_method( "list_containing_verbatim_text" ) }
      
      it "should correctly display verbatim text" do
        subject.should =~ /\n  Containing verbatim text\n/
      end
    end

    context "a nested bulleted list" do
      it "should indent the second level with five spaces" do
        subject.should =~ /\n     .  First item of a nested bulleted list/
        subject.should =~ /\n     .  Second item of a nested bulleted list/
      end
    end

    context "a nested numbered list" do
      subject { render_description_for_method( "mixed_list" ) }
      it "should indent the second level with four spaces" do
        subject.should =~ /\n    \d\.  And numbers in a sublist\n/
      end
    end
  end

  describe "bulleted lists with -" do
    subject { render_description_for_method "second_bulleted_list" }
    it "should indent the list with one space" do
      subject.should =~ /\n .  A second bulleted list/
    end

    it "should prefix each list item with a '*' bullet" do
      subject.should =~ /\*  A second bulleted list/
      subject.should =~ /\*  Second item in second bulleted list/
      subject.should =~ /\*  Ending the second bulleted list/
    end

    it "should indent the second level with four spaces" do
      subject.should =~ /\n     .  Nested bulleted list/
      subject.should =~ /\n     .  Second nested bulleted list item/
    end
  end

  describe "numbered lists" do
    subject { render_description_for_method "numbered_list" }

    it "should not indent the list items" do
      subject.should =~ /\n\d\.  First numbered list item/
    end

    it "should prefix each list item with a consecutive number" do
      subject.should =~ /1\.  First numbered list item/
      subject.should =~ /2\.  Second numbered list/
      subject.should =~ /3\.  Ending the main numbered list item/
    end

    context "nested numbered lists" do
      it "should indent the second level with four spaces" do
        subject.should =~ /\n    \d\.  Nested numbered list item/
        subject.should =~ /\n    \d\.  Second nested numbered list item/
      end

      it "should restart the numbering for nested lists" do
        subject.should =~ /1\.  Nested numbered list item/
        subject.should =~ /2\.  Second nested numbered list item/
      end
    end

    context "nested bulleted lists" do
      subject { render_description_for_method "second_mixed_list" }
      it "should indent the second level with five spaces" do
        subject.should =~ /\n     .  Nested bulleted list/
      end

      it "should prefix each nested list item with a '*' bullet" do
        subject.should =~ /\*  Nested bulleted list/
      end
    end
  end

  describe "lettered lists" do
    subject { render_description_for_method "lettered_list" }

    it "should not indent the list items" do
      subject.should =~ /\n.\.  Some goes for lettered lists/
    end

    it "should prefix each list item with a consecutive letter" do
      subject.should =~ /a\.  Some goes for lettered lists/
      subject.should =~ /b\.  Second item in a lettered list/
      subject.should =~ /c\.  Ending the main lettered list item/
    end

    context "nested lettered lists" do
      it "should indent the second level with four spaces" do
        subject.should =~ /\n    .\.  And a nested lettered list item/
      end

      it "should restart the lettering for nested lists" do
        subject.should =~ /a\.  And a nested lettered list item/
        subject.should =~ /b\.  Second nested lettered list item/
      end
    end
  end

  describe "labeled lists" do
    subject { render_description_for_method "labeled_list" }

    context "with plain labels" do
      it "should indent the list with two spaces" do
        subject.should =~ /\n  \w+: And this is the list item body/
      end

      it "should prefix each list item with its note" do
        subject.should =~ /First: And this is the list item body/
        subject.should =~ /Second: Another labled list item/
      end
    end

    context "with aligned labels" do
      subject { render_description_for_method "lined_up_labeled_list" }

      it "should intent the list with two spaces" do
        subject.should =~ /\n  \w+:\s+With some text\./
      end

      it "should prefix each list item with its note" do
        subject.should =~ /First:\s+With some text\./
        subject.should =~ /Secondarily:\s+Lets see if this lines up\./
      end

      it "should have the list item bodies left aligned to the same position" do
        pending "Not yet implemented"
        subject.should =~ /First:       With some text\./
        subject.should =~ /Secondarily: Lets see if this lines up\./
      end
    end
  end

  describe "text stylings" do
    context "for bold text" do
      it "should mark *bold* text with an ANSI bold code" do
        text = render_description_for_method( "simple_styling" )
        text.should =~ /#{bold}bold#{reset},/
      end

      it "should mark <b>bold</b> text with an ANSI bold code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ /#{bold}Bold#{reset},/
      end

      it "should not mark escaped \<b>bold\</b> text" do
        text = render_description_for_method( "escaped_styling" )
        text.should =~ /<b>Not bold<\/b>,/
      end
    end

    context "for emphasized text" do
      it "should mark _emphasized_ text with an ANSI yellow code" do
        text = render_description_for_method( "simple_styling" )
        text.should =~ /, #{yellow}emphasized#{reset} and/
      end

      it "should mark <em>emphasized</em> text with an ANSI yellow code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ /, #{yellow}emphasized#{reset},/
      end

      it "should mark <i>emphasized</i> text with an ANSI yellow code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ /, #{yellow}also emphasized#{reset}/
      end

      it "should not mark escaped \<em>emphasized\</em> text" do
        text = render_description_for_method( "escaped_styling" )
        text.should =~ /<em>not emphasized<\/em>/
      end
    end

    context "for code" do
      it "should mark +code+ with an ANSI cyan code" do
        text = render_description_for_method( "simple_styling" ) 
        text.should =~ /and #{cyan}monospaced#{reset}/
      end

      it "should mark <tt>code</tt> with an ANSI cyan code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ /#{cyan}monospaced tt#{reset}/
      end

      it "should mark <code>code</code> with an ANSI cyan code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ /#{cyan}monospaced code#{reset}/
      end
    end
  end

  describe "links" do
    context "raw links" do
      subject { render_description_for_method "raw_link" }

      it "should underline raw http links" do
        subject.should =~ /#{underline}http:\/\/www.google.com#{reset}/
      end

      it "should underline raw mailto links" do
        subject.should =~ /#{underline}mailto:spamidyspam@spam.com#{reset}/
      end

      it "should underline raw ftp links" do
        subject.should =~ /#{underline}ftp:\/\/warez.teuto.de#{reset}/
      end

      it "should underline plain www links" do
        subject.should =~ /#{underline}www.test.com#{reset}/
      end

      it "should underline local file links" do
        subject.should =~ /#{underline}\/etc\/fstab#{reset}/
      end
    end

    context "labeled links" do
      context "with single word labels" do
        subject { render_description_for_method "labled_link" }

        it "should show the link underlined after the label in brackets" do
          pending "To be implemented"
          subject.should =~ /Labled links SingleWorldLabel \(#{underline}http:\/\/duckduckgo.com#{reset}\)/
        end
      end

      context "with multi word labels" do
        subject { render_description_for_method "" }

        it "should show the link underlined after the label in brackets and remove the rdoc label curly braces" do
          pending "To be implemented"
          subject.should =~ /Multi World Labels \(#{underline}http:\/\/www.github.com#{reset}\)/
        end
      end
    end
  end

  describe "conversion characters" do
    subject { render_description_for_method "conversion_character" }

    it "should leave -- as is" do
      subject.should =~ /this: -- or/
    end

    it "should leave --- as is" do
      subject.should =~ /or --- should/
    end

    it "should leave (c) as is" do
      subject.should =~ /Copyright: \(c\)/
    end

    it "should leave (r) as is" do
      subject.should =~ /registered trademark \(r\)/
    end
  end


end
