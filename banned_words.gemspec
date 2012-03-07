# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "banned_words"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Razvan Secara, Sabina Pop"]
  s.date = "2012-03-07"
  s.description = "Detects and masks banned words within a text"
  s.email = ""
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "lib/banned_words.rb", "lib/banned_words/core.rb", "lib/banned_words/storage.rb", "lib/rails/generators/banned_words_generator.rb", "lib/rails/generators/templates/banned_words.yml"]
  s.files = ["CHANGELOG", "README.rdoc", "Rakefile", "banned_words.gemspec", "lib/banned_words.rb", "lib/banned_words/core.rb", "lib/banned_words/storage.rb", "lib/rails/generators/banned_words_generator.rb", "lib/rails/generators/templates/banned_words.yml", "spec/banned_words_spec.rb", "spec/lib/core_spec.rb", "spec/lib/storage_spec.yml", "spec/spec_helper.rb", "spec/yamls/banned_words.yml", "Manifest"]
  s.homepage = "https://github.com/razvan-sv/banned_words"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Banned_words", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "banned_words"
  s.rubygems_version = "1.8.15"
  s.summary = "Detects and masks banned words within a text"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
