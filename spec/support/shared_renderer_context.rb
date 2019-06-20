shared_context 'common context for render specs', type: :renderer do
  let( :green )     { Term::ANSIColor.green }
  let( :yellow )    { Term::ANSIColor.yellow }
  let( :cyan )      { Term::ANSIColor.cyan }
  let( :bold )      { Term::ANSIColor.bold }
  let( :italic )    { Term::ANSIColor.italic }
  let( :underline ) { Term::ANSIColor.underline }
  let( :reset )     { Term::ANSIColor.reset }
end
