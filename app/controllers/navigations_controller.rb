class NavigationsController < ApplicationController

  respond_to :json



  def index

    @page_object = "navigations"

    @links = []
    @links << { "rel" => "settings", "page_object" => "navigations_settings", "href" => @current_domain + "/settings", "prompt" => "Navigations Settings" }

    @items = []
    navigations = Navigation.all

    if !navigations.empty?
      for navigation in navigations 
        @items << { "href" => navigation.href(@root_domain), "page_object" => navigation.object, "data" => navigation.data(@root_domain) }
      end
    end

    # Template for creating to navigations
    blank_navigation = Navigation.new
    @template_data = blank_navigation.template 

    render_default_collection

  end


  def create

    @navigation_object = "navigation"
    @flash = []
    navigation = Navigation.new(name: params[:name], description: params[:description], parent_navigation_slug: params[:parent_navigation_slug], page_slug: params[:page_slug], rank: params[:rank])
    if navigation.save
      @flash << { "type" => "success", "caption" => "Navigation Created Sucessfully", "message" => "New navigation '" + navigation.name + "' created successfully"}
    else
      @flash << { "type" => "error", "caption" => "Navigation Not Created", "message" => "There was an issue creating the new navigation" }
    end

    render_default_item

  end


  def show

    @navigation = Navigation.find_by(slug: params[:navigation_slug])
    @navigation_object = @navigation.object

    @data = @navigation.data
    @template_data = @navigation.template

    render_default_item

  end


  def update

    @navigation = Navigation.find_by(slug: params[:navigation_slug])
    @navigation_object = @navigation.object

    @navigation.name = params[:name] if params[:name]
    @navigation.generate_slug if params[:name]    

    @navigation.description = params[:description] if params[:description]
    @navigation.parent_navigation_slug = params[:parent_navigation_slug] if params[:parent_navigation_slug]
    @navigation.page_slug = params[:page_slug] if params[:page_slug]
    @navigation.rank = params[:rank] if params[:rank]
    @navigation.save!

    @data = @navigation.data 
    @template_data = @navigation.template

    render_default_item

  end


  def destroy

    @navigation_object = "response"
    @flash = []
    if Navigation.where(slug: params[:navigation_slug]).delete
      @flash << { "type" => "success", "caption" => "Navigation Deleted", "message" => "The navigation was deleted successfully" }
    else
      @flash << { "type" => "error", "caption" => "Navigation Not Found", "message" => "The navigation you are trying to delete does not exist" }
    end

    render_default_item

  end


end 