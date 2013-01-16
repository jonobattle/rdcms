class SiteController < ApplicationController

  respond_to :json

  def index

    @page_object = "site"
    site = Site.first

    @links = []

    @links << { "rel" => "navigation", "page_object" => "navigation", "href" => @current_domain + "navigations", "prompt" => "Site Navigation" }
    @links << { "rel" => "session", "page_object" => "session", "href" => @current_domain + "session", "prompt" => "Session" }

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

    if has_access
      @template_data = site.template
    end

    render_default_item

  end


  def update

    site = Site.first
    @page_object = site.object
    @flash = []

    site.name = params[:name] if params[:name]
    site.description = params[:description] if params[:description]
    
    homepage = Page.find_by(slug: params[:homepage_slug]) if params[:homepage_slug]
    if homepage
      site.homepage_slug = homepage.slug
    end

    if site.save
      @flash << { "type" => "success", "caption" => "Site Updated successfully", "message" => "The site details have been updated"}      
    end

    render_default_item

  end





end