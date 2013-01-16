class ApplicationController < ActionController::Base

  before_filter :build_globals
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  include ActionController::HttpAuthentication::Token

  # For all responses in this controller, return the CORS access control headers.
  def options
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token, Authorization'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == "OPTIONS"
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token, Authorization'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  protect_from_forgery  
  
private


  def has_access
    session = Session.where(auth_token: request.authorization).first
    if session
      true
    else
      false
    end
  end


  def current_account
    if request.authorization
      session = current_session
      if session
        Account.find_by(slug: session.account_slug)
      end
    end
  end


  def current_session
    if request.authorization
      Session.where(auth_token: request.authorization).first
    end
  end


  def render_default_collection
    render :template => 'default/default_collection'
  end


  def render_default_item
    render :template => 'default/default_item'
  end

protected

  def build_globals
    @root_domain = "http://" + request.host.to_s + ":" + request.port.to_s
    @current_domain = "http://" + request.host.to_s + ":" + request.port.to_s + request.fullpath.to_s
  end

end
