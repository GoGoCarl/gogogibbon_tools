require "gogogibbon_tools/engine"

module GogogibbonTools
  module Config
    class << self
      def Model
        @model || User
      end

      def Model= model
        @model = model
      end
    end
  end

end
