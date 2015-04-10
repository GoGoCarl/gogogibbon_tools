require 'slim'
require 'gogogibbon'
require 'bootstrap-sass'
require 'sass-rails'

module GogogibbonTools
  class Engine < ::Rails::Engine
    isolate_namespace GogogibbonTools
  end
end
