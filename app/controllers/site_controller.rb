class SiteController < ApplicationController

  respond_to :json

  def index

    site = Site.first
    if site 
      @page = Page.find_by(slug: site.homepage_slug)
    end

    render_default_item

  end


end