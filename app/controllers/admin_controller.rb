class AdminController < ApplicationController

  respond_to :json


  def index

    @page_object = "admin"
    @links = []
    
    if has_access
      @current_account = current_account
      @links << { "rel" => "account", "page_object" => "account", "href" => @current_account.href(@root_domain), "prompt" => "My Account" }
    end


    render_default_item

  end


end