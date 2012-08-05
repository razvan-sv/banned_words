# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "banned_words"
  s.version     = "0.1.1"
  s.authors     = ["Razvan Secara", "Pop Sabina"]
  s.email       = ["secara.razvan@yahoo.com"]
  s.homepage    = "https://github.com/razvan-sv/banned_words"
  s.summary     = %q{Detects and masks banned words within a text}
  s.description = %q{Detects and masks banned words within a text}

  s.rubyforge_project = "banned_words"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rails", ">= 3.0"
  s.add_runtime_dependency     "rails", ">= 3.0"
end
