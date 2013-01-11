class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :build_globals


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
