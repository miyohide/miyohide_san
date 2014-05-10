# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'miyohide_san/version'

Gem::Specification.new do |spec|
  spec.name          = "miyohide_san"
  spec.version       = MiyohideSan::VERSION
  spec.authors       = ["TAKAHASHI Kazunari"]
  spec.email         = ["takahashi@1syo.net"]
  spec.summary       = %q{MiyohideSan is a bot that announces one-week before a start of yokohamarb by e-mail or Twitter.}
  spec.description   = %q{MiyohideSan is a bot that announces one-week before a start of yokohamarb by e-mail or Twitter.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "actionmailer"
  spec.add_runtime_dependency "twitter"
  spec.add_runtime_dependency "settingslogic"
  spec.add_runtime_dependency "clockwork"
  spec.add_runtime_dependency "dotenv"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "email_spec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "forgery"
  spec.add_development_dependency "named_let"
  spec.add_development_dependency "timecop"
end
