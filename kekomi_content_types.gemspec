# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "kekomi_content_types"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mihael Konjevic"]
  s.date = "2012-07-07"
  s.description = "Content types library for Kekomi CMS"
  s.email = "konjevic@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "kekomi_content_types.gemspec",
    "lib/kekomi/content_types.rb",
    "lib/kekomi/content_types/atom.rb",
    "lib/kekomi/content_types/atoms/integer.rb",
    "lib/kekomi/content_types/atoms/markdown.rb",
    "lib/kekomi/content_types/atoms/string.rb",
    "lib/kekomi/content_types/base.rb",
    "lib/kekomi/content_types/block.rb",
    "lib/kekomi/content_types/collection.rb",
    "lib/kekomi/content_types/compound.rb",
    "lib/kekomi/content_types/errors.rb",
    "lib/kekomi/content_types/extensions/coerced_array.rb",
    "lib/kekomi/content_types/store.rb",
    "lib/kekomi_content_types.rb",
    "test/helper.rb",
    "test/test_kekomi_content_types.rb"
  ]
  s.homepage = "http://github.com/retro/kekomi_content_types"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Content types library for Kekomi CMS"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["~> 2.4.11"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.2.6"])
      s.add_runtime_dependency(%q<kramdown>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.4"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
    else
      s.add_dependency(%q<mongoid>, ["~> 2.4.11"])
      s.add_dependency(%q<activesupport>, ["~> 3.2.6"])
      s.add_dependency(%q<kramdown>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.1.4"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    end
  else
    s.add_dependency(%q<mongoid>, ["~> 2.4.11"])
    s.add_dependency(%q<activesupport>, ["~> 3.2.6"])
    s.add_dependency(%q<kramdown>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.1.4"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
  end
end

