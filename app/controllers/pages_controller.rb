class PagesController < ApplicationController

  respond_to :json

  def index

    @page_object = "pages"

    @links = []
    @links << { "rel" => "settings", "page_object" => "pages_settings", "href" => @current_domain + "/settings", "prompt" => "Pages Settings" }

    @items = []
    pages = Page.all

    if !pages.empty?
      for page in pages 
        @items << { "href" => page.href(@root_domain), "page_object" => page.object, "data" => page.data }
      end
    end

    # Template for creating to pages
    if has_access
      blank_page = Page.new
      @template_data = blank_page.template 
    end

    render_default_collection

  end


  def create
    @page_object = "page"
    @flash = []

    if has_access
      page = Page.new(name: params[:name], description: params[:description], body: params[:body], parent_page_slug: params[:parent_page_slug])
      if page.save
        @flash << { "type" => "success", "caption" => "Page Created Sucessfully", "message" => "New page '" + page.name + "' created successfully"}
      else
        @flash << { "type" => "error", "caption" => "Page Not Created", "message" => "There was an issue creating the new page" }
      end

    else
      @flash << { "type" => "error", "caption" => "Not Logged In", "message" => "You need to be logged in to create new pages" }
    end

    render_default_item

  end


  def show

    @flash = []

    page = Page.find_by(slug: params[:page_slug])
    @page_object = page.object
    
    if has_access or (page.is_live == true)
      @data = page.data
    else

      # Either the page isn't found or the page isn't live and the user isn't logged in
      page_not_found = Page.new(name: "Page Not Found", body: "The page cannot be found")
      @data = page_not_found.data

    end

    if has_access
      @template_data = page.template
    end

    render_default_item

  end


  def update

    @page = Page.find_by(slug: params[:page_slug])
    @page_object = @page.object

    @page.name = params[:name] if params[:name]
    @page.generate_slug if params[:name]    

    @page.description = params[:description] if params[:description]
    @page.body = params[:body] if params[:body]
    @page.parent_page_slug = params[:parent_page_slug] if params[:parent_page_slug]
    @page.save!

    @data = @page.data 
    @template_data = @page.template

    render_default_item

  end


  def destroy

    @page_object = "response"
    @flash = []
    if Page.where(slug: params[:page_slug]).delete
      @flash << { "type" => "success", "caption" => "Page Deleted", "message" => "The page was deleted successfully" }
    else
      @flash << { "type" => "error", "caption" => "Page Not Found", "message" => "The page you are trying to delete does not exist" }
    end

    render_default_item

  end


end 