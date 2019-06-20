shared_context 'common context for render specs', type: :renderer do
  let( :green )     { Regexp.escape( Term::ANSIColor::green ) }
  let( :yellow )    { Regexp.escape( Term::ANSIColor::yellow ) }
  let( :cyan )      { Regexp.escape( Term::ANSIColor::cyan ) }
  let( :bold )      { Regexp.escape( Term::ANSIColor::bold ) }
  let( :italic )    { Regexp.escape( Term::ANSIColor::italic ) }
  let( :underline ) { Regexp.escape( Term::ANSIColor::underline ) }
  let( :reset )     { Regexp.escape( Term::ANSIColor::reset ) }
end
