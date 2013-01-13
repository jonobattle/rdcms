class SiteController < ApplicationController

  respond_to :json

  def index

    @page_object = "site"
    site = Site.first

    @links = []
    @links << { "rel" => "navigation", "page_object" => "navigation", "href" => @current_domain + "navigations", "prompt" => "Site Navigation" }

    # If there is no site we create one with default settings
    if !site
      site = Site.new(name: "My New Website", description: "Welcome to my brand new website!")
      site.save!
    end

    if site 
      if site.homepage_slug
        page = Page.find_by(slug: site.homepage_slug)
      end
      
      if !page 
        # The site doesn't have a default page, so grab the first and create if doesn't exist
        page = Page.first
        if !page 
          page = Page.new(name: "Homepage", description: "Default site page")
          page.save!
        end
      end

      site.homepage_slug = page.slug
      site.save!

      @data = page.data

    end

    render_default_item

  end


end