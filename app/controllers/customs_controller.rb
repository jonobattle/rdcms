class CustomsController < ApplicationController

  respond_to :json

  def index

    @page_object = "customs"

    @links = []
    @links << { "rel" => "settings", "page_object" => "pages_settings", "href" => @current_domain + "/settings", "prompt" => "Pages Settings" }

    @items = []
    customs = Custom.all

    if !customs.empty?
      for custom in customs
        @items << { "href" => custom.href(@root_domain), "page_object" => custom.object, "data" => custom.data }
      end
    end

    blank_custom = Custom.new
    @template_data = blank_custom.template

    render_default_collection

  end


  def create

    @page_object = "custom"
    @flash = []
    custom = Custom.new(name: params[:name], description: params[:description], object_template: params[:object_template])
    if custom.save
      @flash << { "type" => "success", "caption" => "Custom Object Created", "message" => "The custom object has been created successfully" }
    else
      @flash << { "type" => "error", "caption" => "Custom Object Not Created", "message" => "There was an issue creating the custom object" }  
    end

    render_default_item

  end


  def show

    @page_object = "custom"
    custom = Custom.find_by(slug: params[:custom_slug])
    @page_object = custom.object 

    @data = custom.data
    @template_data = custom.template

    render_default_item
  end


end