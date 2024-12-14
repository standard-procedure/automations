# frozen_string_literal: true

require_relative "lib/automations/version"

Gem::Specification.new do |spec|
  spec.name = "standard_procedure_automations"
  spec.version = Automations::VERSION
  spec.authors = ["Rahoul Baruah"]
  spec.email = ["rahoulb@echodek.co"]
  spec.homepage = "https://theartandscienceofruby,com/"
  spec.summary = "Standard Procedure: Automations"
  spec.description = "Automations"
  spec.license = "LGPL"

  spec.metadata["allowed_push_host"] = "https://rubygems.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/standard_procedure"
  spec.metadata["changelog_uri"] = "https://github.com/standard_procedure"

  spec.required_ruby_version = ">= 3.2.0"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]
end
