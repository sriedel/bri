require 'spec_helper'

describe Bri::TextFormattingUtils do
  let(:described_module) { described_class }

  describe ".wrap_to_width" do
    let(:width) { 10 }

    subject { described_module.wrap_to_width( input, width ) }

    context 'when given an empty string' do
      let(:input) { '' }

      it 'returns a blank row' do
        subject.should == ""
      end
    end

    context 'when given a string with one word' do
      let(:input) { "foobar" }

      context 'and a width larger than the words length' do
        it 'returns the word on a row' do
          subject.should == "foobar\n"
        end
      end

      context 'and a width equal to the words length' do
        let(:width) { 6 }

        it 'returns the word on a row' do
          subject.should == "foobar\n"
        end
      end

      context 'and a width smaller than the words length' do
        let(:width) { 5 }

        it 'returns the word on a row' do
          subject.should == "foobar\n"
        end
      end
    end

    context 'when given an string with multiple words' do
      let(:input) { "foo bar" }

      context 'and a width larger than the elements length' do
        it 'returns the words on a row' do
          subject.should == "foo bar\n"
        end
      end

      context 'and a width equal to the string length' do
        let(:width) { 7 }

        it 'returns the words on a row' do
          subject.should == "foo bar\n"
        end
      end

      context 'and a width smaller than the string length' do
        let(:width) { 5 }

        it 'returns the words on separate rows' do
          subject.should == "foo\nbar\n"
        end
      end
    end

    context 'when the string contains multiple words on multiple rows' do
      let(:width) { 11 }
      let(:input) { "foo bar\nbaz quux\nblart\n" }

      it 'rearranges the text to most densely fit the given width, keeping new lines' do
        subject.should == "foo bar\nbaz quux\nblart\n" # TBD: reearrange new lines?
      end
    end

  end

  describe ".wrap_row" do
    let(:width) { 30 }
    subject { described_module.wrap_row( input, width ) }

    context 'given an empty string' do
      let(:input) { '' }

      it 'returns a single newline' do
        subject.should == "\n"
      end
    end

    context 'given a single word shorter than the given width' do
      let(:input) { "foo" }

      it 'returns the word itself with a newline' do
        subject.should == "foo\n"
      end
    end

    context 'given a single word equal to the given width' do
      let(:width) { 5 }
      let(:input) { "fubar" }

      it 'returns the word itself with a newline' do
        subject.should == "fubar\n"
      end
    end

    context 'given a single word longer than the given width' do
      let(:width) { 4 }
      let(:input) { "fubar" }

      it 'returns the word itself with a newline' do
        subject.should == "fubar\n"
      end
    end

    context 'given multiple words shorter than the given width' do
      let(:input) { "foo bar" }

      it 'returns the words on the same row terminated by a newline' do
        subject.should == "foo bar\n"
      end
    end

    context 'given multiple words equal to the given width' do
      let(:width) { 7 }
      let(:input) { "foo bar" }

      it 'returns the words on the same row terminated by a newline' do
        subject.should == "foo bar\n"
      end
    end

    context 'given multiple words longer than the given width' do
      let(:width) { 6 }
      let(:input) { "foo bar" }

      it 'returns the words on separate rows' do
        subject.should == "foo\nbar\n"
      end
    end
  end

  describe ".indent" do
    subject { described_module.indent( text ) }

    context 'when given an empty string' do
      let(:text) { '' }

      it 'returns an empty string' do
        subject.should == ''
      end
    end

    context 'when given a single row' do
      let(:text) { "foo" }

      it 'returns the row indented' do
        subject.should == "#{Bri::TextFormattingUtils::INDENT}foo"
      end
    end

    context 'when given multiple row' do
      let(:text) { "foo\nbar\n" }

      it 'returns all rows indented' do
        subject.should == "#{Bri::TextFormattingUtils::INDENT}foo\n#{Bri::TextFormattingUtils::INDENT}bar\n"
      end
    end
  end

  describe ".printable_length" do
    subject { described_module.printable_length( input ) }

    context 'for an empty string' do
      let(:input) { '' }

      it 'returns 0' do
        subject.should == 0
      end
    end

    context 'for a string without ansi control characters' do
      let(:input) { "foobar" }

      it 'returns the length of the string' do
        subject.should == input.length
      end
    end

    context 'for a string with ansi control characters' do
      let(:text) { "foobar" }
      let(:input) do
        "#{Term::ANSIColor.green}#{Term::ANSIColor.underline}#{text}#{Term::ANSIColor.reset}\n"
      end

      it 'returns the length of the input without ansi control characters' do
        subject.should == text.length + 1
      end
    end
  end

  describe ".wrap_list" do
    let(:width) { 10 }

    subject { described_module.wrap_list( input, width ) }

    context 'when given an empty array' do
      let(:input) { [] }

      it 'returns a blank row' do
        subject.should == ""
      end
    end

    context 'when given an array with one element' do
      let(:input) { %w[ foobar ] }

      context 'and a width larger than the elements length' do
        it 'returns the element on an indented row' do
          subject.should == "  foobar\n"
        end
      end

      context 'and a width equal to the elements length' do
        let(:width) { 8 }

        it 'returns the element on an indented row' do
          subject.should == "  foobar\n"
        end
      end

      context 'and a width smaller than the elements length' do
        let(:width) { 5 }

        it 'returns the element on an indented row' do
          subject.should == "  foobar\n"
        end
      end
    end

    context 'when given an array with multiple elements' do
      let(:input) { %w[ foo bar ] }

      context 'and a width larger than the elements length' do
        it 'returns the array elements on an indented row separated by two spaces' do
          subject.should == "  foo  bar\n"
        end
      end

      context 'and a width equal to the elements length plus separator' do
        let(:width) { 10 }

        it 'returns the array elements on an indented row separated by two spaces' do
          subject.should == "  foo  bar\n"
        end
      end

      context 'and a width smaller than the elements length plus separator' do
        let(:width) { 7 }

        it 'returns the array elements on separate indented rows' do
          subject.should == "  foo\n  bar\n"
        end
      end
    end
  end

  describe ".hrule" do
    subject { described_module.hrule( input, width ) }

    context 'given an empty string' do
      let(:input) { '' }

      context 'and a width of 0' do
        let(:width) { 0 }

        it 'returns an rule with a single rule character with a newline' do
          Term::ANSIColor.uncolored(subject).should == "-\n"
        end
      end

      context 'and a width greater than 0' do
        let(:width) { 8 }

        it 'returns a rule with the given number of rule characters with a newline' do
          Term::ANSIColor.uncolored(subject).should == "--------\n"
        end
      end
    end

    context 'given a non-empty string' do
      let(:input) { 'foo' }

      context 'and a width of 0' do
        let(:width) { 0 }

        it 'returns a single rule character prepending the input text' do
          Term::ANSIColor.uncolored(subject).should == "- foo\n"
        end
      end

      context 'and a width greater than 0' do
        let(:width) { 8 }

        it 'returns a number of rule characters along with the input and a newline' do
          Term::ANSIColor.uncolored(subject).should == "---- foo\n"
        end
      end
    end
  end

  describe ".print_origin" do
    let(:width) { 8 }

    subject { described_module.print_origin( input, width ) }

    context 'when passed nil' do
      let(:input) { nil }

      it 'returns an empty string' do
        subject.should == ''
      end
    end

    context 'when passed an empty string' do
      let(:input) { '' }

      it 'returns an empty string' do
        subject.should == ''
      end
    end

    context 'when passed a string' do
      let(:input) { "foo" }

      it 'returns the string in brackets, right justified to the given width' do
        subject.should == "   (foo)"
      end
    end
  end

  describe ".section_header" do
    let(:text) { "foo" }

    subject { described_module.section_header( text ) }

    it 'returns the given string green and underlined, followed by a newline' do
      subject.should == "#{Term::ANSIColor.green}#{Term::ANSIColor.underline}#{text}#{Term::ANSIColor.reset}\n"
    end
  end
end
