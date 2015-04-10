module GogogibbonTools
  class ApplicationController < ActionController::Base

    class MailchimpConfigurationException < Exception
    end

    rescue_from MailchimpConfigurationException, :with => :render_403

    def not_configured!
      raise MailchimpConfigurationException
    end

    def render_403
      render 'gogogibbon_tools/mailchimp_subscribers/error', :status => 403
    end


  end
end
