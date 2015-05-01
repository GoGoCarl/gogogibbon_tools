$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gogogibbon_tools/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gogogibbon_tools"
  s.version     = GogogibbonTools::VERSION
  s.authors     = ["GoGoCarl"]
  s.email       = ["carl.scott@solertium.com"]
  s.homepage    = "https://github.com/GoGoCarl/gogogibbon_tools"
  s.summary     = "Engine exposing quick utilities for Mailchimp run through GoGoGibbon."
  s.description = "Engine exposing quick utilities for Mailchimp run through GoGoGibbon."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "slim"
  s.add_dependency "rails", "~>4.2"
  s.add_dependency "gogogibbon", "~> 1.1.1"
  s.add_dependency "bootstrap-sass"
  s.add_dependency "sass-rails"
  s.add_dependency "protected_attributes"
  # s.add_dependency "jquery-rails"

end
