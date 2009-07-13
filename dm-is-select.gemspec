# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-select}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2009-07-13}
  s.description = %q{A DataMapper plugin that makes getting the <tt><select></tt> options from a Model easier.}
  s.email = %q{kematzy@gmail.com}
  s.extra_rdoc_files = [
    "History.txt",
     "LICENSE",
     "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".gitignore",
     "History.txt",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "VERSION",
     "lib/dm-is-select.rb",
     "lib/dm-is-select/is/select.rb",
     "lib/dm-is-select/is/version.rb",
     "spec/integration/select_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/dm-is-select}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A DataMapper plugin that makes getting the <tt><select></tt> options from a Model easier.}
  s.test_files = [
    "spec/integration/select_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_runtime_dependency(%q<dm-more>, [">= 0.10.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.10.0"])
      s.add_dependency(%q<dm-more>, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.10.0"])
    s.add_dependency(%q<dm-more>, [">= 0.10.0"])
  end
end
