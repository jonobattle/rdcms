class AccountsController < ApplicationController

  before_filter :has_access
  respond_to :json


  def index
    
    @page_object = "accounts"

    @links = []
    @flash = []

    @items = []

    if has_access
      
      @links << { "rel" => "settings", "page_object" => "accounts_settings", "href" => @current_domain + "/settings", "prompt" => "Account Settings" }

      # Grab all available accounts
      accounts = Account.all 

      if !accounts.empty?
        for account in accounts
          @items << { "href" => account.href(@root_domain), "page_object" => account.object, "data" => account.data } 
        end  
      end

      # Template for creating new accounts
      blank_account = Account.new
      @template_data = blank_account.template

    else

      @flash << { "type" => "error", "caption" => "No Access", "message" => "You need to be logged in to access the admin" }

    end

    render_default_collection

  end



  def show(account_type_slug = nil)
    @links = nil
    @data = nil
    @flash = nil

    account = Account.find_by(slug: params["account_slug"]) if params["account_slug"]

    if account

      if account_type_slug and (account_type_slug != account.account_type_slug)
        @flash = { "title" => "Wrong URL", "message" => "You cannot access this account type from this url."}
      elsif (account_type_slug and (account_type_slug == account.account_type_slug)) or !account_type_slug
        @current_domain = @root_domain + "/accounts/" + account.account_type_slug + "/" + account.slug
        @page_object = account.object
        @data = account.data 
        @template_data = account.template 
      end

    else 
      @flash = { "title" => "Account Not Found", "message" => "The Account you are looking for could not be found." }

    end

    render_default_item
  end



  def create 
    account = Account.new
    account.email = params["email"]
    account.password = params["password"]
    account.account_role_type_slug = params["account_role_type_slug"]

    account.save
      
    render_default_item
  end


  # Update the account details
  def update
    
    @items = []
    @flash = []

    account = Account.find_by(slug: params["account_slug"]) if params["account_slug"]

    if account
      current_slug = account.slug 
      account.name = params["name"] if params["name"]
      account.generate_slug_and_display_name if params["name"]
      
      account.email = params["email"] if params["email"]
      account.title = params["title"] if params["title"]
      account.first_name = params["first_name"] if params["first_name"]
      account.middle_name = params["middle_name"] if params["middle_name"]
      account.last_name = params["last_name"] if params["last_name"]
      account.maiden_name = params["maiden_name"] if params["maiden_name"]


      # Update the account type 
      account_type = AccountType.find_by(slug: params["account_type_slug"]) if params["account_type_slug"]
      if account_type
        account.account_type_slug = account_type.slug 
      end

      # Update the account role type slug
      system_role = SystemRole.find_by(slug: params["account_role_type_slug"]) if params["account_role_type_slug"]
      if system_role
        account.account_role_type_slug = system_role.slug 
      end
      
      if account.save!
        if current_slug != account.slug
          current_slug = account.slug
          account = Account.find_by(slug: current_slug)
        end

        @items << [account.data, account.links(@current_domain, false)]
      else
        @flash << { "title" => "Account Type Update Failed", "message" => "There was an issue when trying to save changes to this account." }
      end

      @template_data = [account.template]

    else
      @flash << { "title" => "Account Type Not Found", "message" => "The Account Type you are trying to update could not be found."}
    end

    render_default_item
  end



  def destroy
    @current_domain = current_domain
    @flash = []

    account = Account.find_by(slug: params["account_slug"]) if params["account_slug"]

    if account
      # Found the account, so make sure to remove all related information.
      # If there is related information then the account cannot be deleted
      account.destroy
    else 
      @flash << { "title" => "Account Type Delete Failed", "message" => "There was an issue when trying to delete this account type." }
    end

    render_default_item
  end



  def settings
    @current_domain = current_domain
    @page_object = "account_settings"

    account = Account.find_by(slug: params["account_slug"])

    if account
    else 
      @flash = { "type" => "error", "title" => "Account Not Found", "message" => "The account you are looking for could not be found."}
    end

    render_default_item
  end



end

























