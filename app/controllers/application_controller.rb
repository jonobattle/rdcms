class ApplicationController < ActionController::Base

  before_filter :cors_preflight_check, :build_globals
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.
  def options
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == "OPTIONS"
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  protect_from_forgery  


private

  def root_domain
    
  end


  def current_domain
    
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
