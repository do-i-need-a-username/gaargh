# frozen_string_literal: true

require_relative "lib/gaargh/version"

Gem::Specification.new do |spec|
  spec.name = "gaargh"
  spec.version = Gaargh::VERSION
  spec.authors = ["ml"]
  # spec.email = ["redacted@redacted"]

  spec.summary = "Helper module for impersonating service accounts on GCP."
  spec.description = "GCP account impersonation helper."
  spec.homepage = "https://github.com/do-i-need-a-username/gaargh"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "google-apis-iamcredentials_v1", "~> 0.17"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
