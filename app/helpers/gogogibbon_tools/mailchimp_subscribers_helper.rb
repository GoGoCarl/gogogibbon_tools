module GogogibbonTools
  module MailchimpSubscribersHelper

    def to_mailchimp_subscriber user
      MailchimpSubscriber.new({ :email => user.email, :first_name => user.first_name, :last_name => user.last_name })
    end

  end
end
