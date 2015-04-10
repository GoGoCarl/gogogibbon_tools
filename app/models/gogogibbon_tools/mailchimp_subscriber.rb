module GogogibbonTools
  class MailchimpSubscriber
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    include ActiveModel::AttributeMethods
    include ActiveModel::Conversion

    attr_accessor :email, :first_name, :last_name

    def initialize values={}
      @email      = values[:email]
      @first_name = values[:first_name]
      @last_name  = values[:last_name]
    end

    def valid?
      !@email.blank?
    end

    def persisted?
      false
    end

  end
end
