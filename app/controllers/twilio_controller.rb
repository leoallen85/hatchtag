class TwilioController < ApplicationController

  def add_user
    if params["Body"]
      body = params["Body"].strip.downcase

      if body == "unsubscribe"
        unsubscribe
      else
        # Save db

        send_unsubscribe_info
      end
    end
  end

  private

  def unsubscribe

  end

  def send_unsubscribe_info
    account_sid = 'AC2b4cb664598184912c0423e1b3aea39e'
    auth_token = '696405a19a07e30697a76061864a902f'

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    # send an sms
    @client.account.sms.messages.create(
      :from => params["To"],
      :to => params["From"],
      :body => "To unsubscribe please reply to this text with UNSUBSCRIBE"
    )
  end
end
