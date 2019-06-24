module Bri
  module TextFormattingUtils
    RULE_CHARACTER = '-'.freeze
    INDENT = '  '.freeze

    def wrap_to_width( styled_text, width )
      styled_text.split( "\n" ).map { |row| wrap_row( row, width ) }.join
    end
    module_function :wrap_to_width

    def wrap_row( physical_row, width )
      output_text = ''
      logical_row = ''
      printable_row_length = 0
      tokens_in_row = 0

      scanner = StringScanner.new( physical_row )

      while( !scanner.eos? ) 
        token = scanner.scan( /\S+/ ).to_s
        printable_token_length = printable_length( token )

        if printable_token_length + printable_row_length > width && tokens_in_row > 0
          output_text << logical_row.rstrip << "\n"
          logical_row.clear
          printable_row_length = 0
          tokens_in_row = 0
        end

        logical_row << token
        printable_row_length += printable_token_length
        tokens_in_row += 1

        # TODO: Instead of using rstrip when appending the logical row,
        #       identify here if the whitespace token will be the last 
        #       on the row, and if so, don't add it in the first place.
        #       (sr 2019-06-23)
        token = scanner.scan( /\s+/ ).to_s
        logical_row << token
        printable_row_length += token.length
      end

      output_text << logical_row.rstrip << "\n"
    end
    module_function :wrap_row

    def indent( text )
      text.lines.map { |row| "#{INDENT}#{row}" }.join
    end
    module_function :indent

    def printable_length( text )
      Term::ANSIColor.uncolored( text ).length
    end
    module_function :printable_length

    def wrap_list( array, width = Bri.width )
      return '' if array.empty?

      indent( wrap_to_width( array.join( "  " ), width - 2 ) )
    end
    module_function :wrap_list

    def hrule( text = '', width = Bri.width )
      text.prepend( " " ) unless text.empty?

      rule_length = width - text.length
      rule_length = 1 if rule_length < 1

      rule = RULE_CHARACTER * rule_length
      "#{rule}#{Term::ANSIColor::bold( text )}\n"
    end
    module_function :hrule

    def print_origin( origin_text, width = Bri.width )
      return '' if !origin_text || origin_text.empty?

      "(#{origin_text})".rjust( width )
    end
    module_function :print_origin

    def section_header( text )
      "#{Term::ANSIColor.green}#{Term::ANSIColor.underline}#{text}#{Term::ANSIColor.reset}\n"
    end
    module_function :section_header
  end
end
