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
    @links = custom.links(@current_domain)
    @template_data = custom.template

    render_default_item
  end


  def documents_index

    @page_object = "customs"

    @items = []
    custom = Custom.find_by(slug: params[:custom_slug])

    @links = []
    @links << { "rel" => "settings", "page_object" => "pages_settings", "href" => @current_domain + "/settings", "prompt" => custom.name + " Settings" }

    if custom and custom.objects and !custom.objects.empty?
      for object in custom.objects
        @items << { "href" => object.href(@root_domain), "page_object" => object.object, "data" => object.data }
      end
    end

    @template_data = custom.custom_object_template

    render_default_collection

  end


  def documents_create

    custom = Custom.find_by(slug: params[:custom_slug])
    
    if custom and custom.object_template and !custom.object_template.empty?
      document = DynamicCustom.new(params)
      document.save!
    end

    render_default_item

  end








end