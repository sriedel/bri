Gem::Specification.new do |s|
  s.name = "bri"
  s.version = "0.1.4"

  s.required_ruby_version = ">= 1.9.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sven Riedel"]
  s.date = %q{2010-10-06}
  s.description = %q{An alternative to the ri command}
  s.add_dependency( 'term-ansicolor', '>= 1.0.5' )
  s.add_dependency( 'rdoc',           '>= 2.5.0' )

  s.summary = %q{Beautified RI in the spirit of fastri/qri. Unlike fastri, bri builds on top of the rdoc 2.x backend, only output and formatting is handled by bri}
  s.email = %q{sr@gimp.org}
  s.homepage = %q{http://github.com/sriedel/bri}

  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}

  s.bindir = 'bin'
  s.executables = [ 'bri' ]

  s.extra_rdoc_files = %W{ README }
  s.files = %W{ README
                TODO
                Changelog
                bin/bri
                lib/bri.rb
                lib/bri/mall.rb
                lib/bri/matcher.rb
                lib/bri/match.rb
                lib/bri/match/base.rb
                lib/bri/match/class.rb
                lib/bri/match/method.rb
                lib/bri/search.rb
                lib/bri/search/base.rb
                lib/bri/search/class.rb
                lib/bri/search/method.rb
                lib/bri/search/class_method.rb
                lib/bri/search/instance_method.rb
                lib/bri/templates.rb
                lib/bri/renderer.rb
                spec/spec_helper.rb
                spec/lib/bri/mall_spec.rb
                spec/lib/bri/matcher_spec.rb
                spec/lib/bri/match/class_match_spec.rb
                spec/lib/bri/match/method_match_spec.rb
                spec/lib/bri/search/class_spec.rb
                spec/lib/bri/search/class_method_search_spec.rb
                spec/lib/bri/search/instance_method_spec.rb
                spec/lib/bri/search/method_spec.rb
              }
end
