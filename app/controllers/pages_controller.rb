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
    blank_page = Page.new
    @template_data = blank_page.template 

    render_default_collection

  end


  def create

    @page_object = "page"
    @flash = []
    page = Page.new(name: params[:name], description: params[:description], body: params[:body], parent_page_slug: params[:parent_page_slug])
    if page.save
      @flash << { "type" => "success", "caption" => "Page Created Sucessfully", "message" => "New page '" + page.name + "' created successfully"}
    else
      @flash << { "type" => "error", "caption" => "Page Not Created", "message" => "There was an issue creating the new page" }
    end

    render_default_item

  end


  def show

    @page = Page.find_by(slug: params[:page_slug])
    @page_object = @page.object

    @data = @page.data
    @template_data = @page.template

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