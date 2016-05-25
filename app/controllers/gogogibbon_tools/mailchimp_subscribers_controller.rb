module GogogibbonTools
  class MailchimpSubscribersController < ApplicationController
    layout 'gogogibbon_tools/mailchimp'

    before_filter :ensure_mailchimp_configured!, :except => [:init]

    # Subscribe all users in database to mailing list
    def init
      if GoGoGibbon::Config.api_key.blank?
        @error = "MailChimp not installed on this server."
      elsif params[:key].blank?
        @error = "Please supply your MailChimp API key for verification."
      elsif params[:key] != GoGoGibbon::Config.api_key
        @error = "Supplied MailChimp API key does not match server key."
      else
        @result = GoGoGibbon::Commands.subscribe_set User.Mailable
      end
    end

    # List all users/subscribers
    def index
      list_id  = GoGoGibbon::Commands.list GoGoGibbon::Config.subscribed
      status   = params[:status] || 'subscribed'
      sub_hash = {}

      @subscriptions = GoGoGibbon::Commands.chimp.lists(list_id).members.retrieve(params: { "status" => status, "count" => 15000, "fields" => 'total_items,members.email_address' })
      @subscriptions['members'].each do |item|
        sub_hash[item['email_address']] = true
      end

      @subscribed = []
      @missing    = []
      User.Mailable.order(:email).each do |user|
        if sub_hash.key?(user.email)
          @subscribed << user
        else
          @missing << user
        end
        sub_hash.delete user.email
      end

      @others = sub_hash.keys.collect { |email| User.new :email => email }
      @others.sort! { |x,y| x.email <=> y.email }
    end

    # Form to add a new subscriber manually
    def new
      @subscriber = MailchimpSubscriber.new
    end

    # Add a new subscriber manually
    def create
      @subscriber = MailchimpSubscriber.new params[:mailchimp_subscriber]

      respond_to do |format|
        if @subscriber.valid? && GoGoGibbon::Commands.subscribe(@subscriber)
          format.html { redirect_to(mailchimp_subscribers_path, :notice => 'User was successfully subscribed.') }
        else
          format.html { render :action => "new" }
        end
      end
    end

    # Unsubscribe a user manually
    def unsubscribe
      @subscriber = MailchimpSubscriber.new params[:mailchimp_subscriber]

      if @subscriber.valid?
        GoGoGibbon::Commands.unsubscribe @subscriber, GoGoGibbon::Config.subscribed
      end

      respond_to do |format|
        format.html { redirect_to(mailchimp_subscribers_url, :notice => 'User was successfully unsubscribed.') }
      end
    end

    # Add new subscribers via batch manually
    def batch
      @users = []
      @csv   = params[:csv]
      @csv.lines.each do |line|
        data  = {}
        index = 0
        line.split(',').each do |text|
          if index == 0
            data[:email] = text
          elsif index == 1
            data[:first_name] = text
          elsif index == 2
            data[:last_name] = text
          end
          index += 1
        end
        if index == 3
          @users << MailchimpSubscriber.new(data)
        end
      end

      if params[:confirmed] == 'true'
        @results = GoGoGibbon::Commands.subscribe_set @users
      else
        @results = nil
      end
    end

    def details
      md5     = Digest::MD5.new
      list_id = GoGoGibbon::Commands.list GoGoGibbon::Config.subscribed
      email   = params[:email]

      md5.update email.downcase

      @details  = GoGoGibbon::Commands.chimp.lists(list_id).members(md5.hexdigest).retrieve
      @activity = GoGoGibbon::Commands.chimp.lists(list_id).members(md5.hexdigest).activity.retrieve
    end

    private

    def ensure_mailchimp_configured!
      not_configured! if GoGoGibbon::Config.api_key.blank?
    end

    def User
      GogogibbonTools::Config.Model
    end

  end
end
