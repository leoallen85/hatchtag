require 'open-uri'

class TwilioController < ApplicationController

  def add_user
    if params["Body"]
      @address = params["Body"].strip.downcase
      @tel     = params["From"]

      if @address == "unsubscribe"
        unsubscribe
      else
        add_address
      end
    end
  end

  private

  def add_address

    res = open(URI(URI::encode "http://maps.googleapis.com/maps/api/geocode/json?address=#{@address}, UK&sensor=false&region=gb"))
    dat = JSON.parse(res.read)["results"][0]["geometry"]["location"]

    if dat
      lat = dat['lat']
      lng = dat['lng']

      @sql = "INSERT INTO eggs (the_geom, address, telephone) VALUES (ST_GeomFromText('POINT(#{lng} #{lat})', 4326),'#{@address}','#{@tel}') RETURNING cartodb_id"
      res = open(URI(URI::encode "http://eggsellence.cartodb.com/api/v2/sql?q=#{@sql}&api_key=a990bfe1d952be1de34e22a55b74d5e0e83b8d30"))

      send_message "You've now been added to Farm Finder! To unsubscribe please reply to this text with UNSUBSCRIBE"
    else
      send_message "Sorry we couldn't find that address, please send again"
    end
  end

  def unsubscribe
    send_message "You've now been removed"
  end

  def send_message(message_body)
    account_sid = 'AC2b4cb664598184912c0423e1b3aea39e'
    auth_token = '696405a19a07e30697a76061864a902f'

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    # send an sms
    @client.account.sms.messages.create(
      :from => params["To"],
      :to => @tel,
      :body => message_body
    )
  end
end
