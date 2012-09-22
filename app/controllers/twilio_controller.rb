class TwilioController < ApplicationController

  def add_user
    render :json => {:success => params}
  end

end