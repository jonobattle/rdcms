class SessionController < ApplicationController

  respond_to :json

  def index

    @data = []
    @flash = []
    @page_object = "session"

    @links = []
    @links << { "rel" => "ping", "page_object" => "ping", "href" => @current_domain + "/ping", "prompt" => "Ping Session" }
    
    if has_access

      @links << { "rel" => "logout", "page_object" => "logout", "href" => @current_domain + "/logout", "prompt" => "Logout from Session" }
      @data = current_account.data

    else
      @template_data = []
      @template_data << { "name" => "email", "value" => "", "prompt" => "Email address", "type" => "text" }
      @template_data << { "name" => "password", "value" => "", "prompt" => "Password", "type" => "password" }      
      @template_data << { "name" => "device_slug", "value" => "", "prompt" => "Device", "type" => "option", "options" => ["Web", "Mobile"], "values" => ["web", "mobile"] }
    end

    render_default_item

  end


  def attempt 

    @data = []
    @flash = []
    @links = []
    @page_object = "session_attempt"

    if params[:email] && params[:password] && params[:device_slug]
      account = Account.where(email: params[:email]).first
      
      if account && account.authenticate(params[:password])

        # Kill any current sessions for this account and device
        Session.where(:account_slug => account.slug, :device_slug => params["device_slug"]).destroy

        # Create a new session for the account
        session = Session.new(:account_slug => account.slug, :device_slug => params["device_slug"], :ip_address => request.remote_ip.to_s)
        session.save

        if session.save

          @links << { "rel" => "logout", "page_object" => "logout", "href" => @current_domain + "/logout", "prompt" => "Logout from Session" }
          @flash << { "type" => "success", "title" => "Login Successful", "message" => "Account logged in"}
          @data = session.data

          # @links = []
          # @links << { "page_object" => account.object, "href" => account.href(@root_domain) }
          # @links << { "page_object" => dashboard.object, "href" => dashboard.href(@root_domain) }
          # @links << { "page_object" => navigation.object, "href" => navigation.href(account.slug, @root_domain) }
          # @links << { "page_object" => settings.object, "href" => settings.href(account.slug, @root_domain) }

        else
          @flash << { "type" => "error", "title" => "Session Error", "message" => "There was an issue when trying to create your session."}
        end

      else
        @flash << { "type" => "error", "title" => "Login Attempt Failed", "message" => "There was an issue logging you in."}
      end

    else 
      @flash << { "type" => "error", "title" => "Login Attempt Failed", "message" => "There was an issue logging you in."}
    end

    render_default_item

  end


  def ping

    @data = []
    @flash = []
    @page_object = "session_ping"

    if has_access
      @flash << { "type" => "success", "title" => "Ping Successful", "message" => "Session valid"}
    else
      @flash << { "type" => "error", "title" => "Ping Unsuccessful", "message" => "Session has expired"}
    end

    render_default_item

  end



  def logout

    @page_object = "session"
    @links = []
    @flash = []

    @current_session = current_session

    if @current_session
      @current_session.destroy
    end

    @flash << { "type" => "success", "title" => "Logout Successful", "message" => "Account logged out"}

    render_default_item

  end



end