class Account
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :account_role_type_slug, type: String
  field :account_type_slug, type: String
  field :email, type: String
  field :password_digest, type: String
  field :title, type: String
  field :display_name, type: String
  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :maiden_name, type: String
  field :slug, type: String

  before_create :generate_slug_and_display_name
  has_secure_password

  def href(root_domain)
    root_domain + "/admin/accounts/" + self.slug
  end

  def object
    "account"
  end

  def data 

    generate_slug if !self.slug

    if !self.display_name
      generate_display_name
      self.save!
    end

    data = []
    data << { "name" => "account_role_type_slug", "value" => self.account_role_type_slug ? self.account_role_type_slug : "", "prompt" => "Account Role Type Slug" }
    data << { "name" => "account_type_slug", "value" => self.account_type_slug ? self.account_type_slug : "", "prompt" => "Account Type Slug" }
    data << { "name" => "email", "value" => self.email ? self.email : "", "prompt" => "Email" }
    data << { "name" => "display_name", "value" => self.display_name, "prompt" => "Display Name" }
    data << { "name" => "title", "value" => self.title ? self.title : "", "prompt" => "Title" }    
    data << { "name" => "first_name", "value" => self.first_name ? self.first_name : "", "prompt" => "First Name" }
    data << { "name" => "middle_name", "value" => self.middle_name ? self.middle_name : "", "prompt" => "Middle Name" }
    data << { "name" => "last_name", "value" => self.last_name ? self.last_name : "", "prompt" => "Last Name" }
    data << { "name" => "maiden_name", "value" => self.maiden_name ? self.maiden_name : "", "prompt" => "Maiden Name" }
    
  end


  def template

    account_role_type_slugs = ["super-admin", "admin", "editor"]
    account_type_slugs = ["staff", "client"]

    data = []
    data << { "name" => "email", "value" => self.email ? self.email : "", "prompt" => "Email", "type" => "text" }
    data << { "name" => "password", "value" => "", "prompt" => "Password", "type" => "password" }
    data << { "name" => "account_role_type_slug", "value" => self.account_role_type_slug ? self.account_role_type_slug : "", "prompt" => "Account Role Type Slug", "options" => account_role_type_slugs }
    data << { "name" => "account_type_slug", "value" => self.account_type_slug ? self.account_type_slug : "", "prompt" => "Account Type Slug", "options" => account_type_slugs }
    data << { "name" => "title", "value" => self.title ? self.title : "", "prompt" => "Title", "type" => "text" }    
    data << { "name" => "first_name", "value" => self.first_name ? self.first_name : "", "prompt" => "First Name", "type" => "text" }
    data << { "name" => "middle_name", "value" => self.middle_name ? self.middle_name : "", "prompt" => "Middle Name", "type" => "text" }
    data << { "name" => "last_name", "value" => self.last_name ? self.last_name : "", "prompt" => "Last Name", "type" => "text" }
    data << { "name" => "maiden_name", "value" => self.maiden_name ? self.maiden_name : "", "prompt" => "Maiden Name", "type" => "text" }
    
  end


  def links(current_domain, show_self)
    links = []

    name = (self.first_name ? self.first_name : "").to_s + " " + (self.last_name ? self.last_name : "").to_s

    if show_self and self.account_type_slug
      links << { "rel" => self.slug, "href" => current_domain + "/" + self.account_type_slug + "/" + self.slug, "prompt" => "View " + name }
    end

  end


  def generate_display_name
    if self.first_name and self.last_name
      self.display_name = self.first_name + " " + self.last_name
    else 
      self.display_name = "First or Last Name Missing"
    end
  end


  # Generate a unique slug for this client
  def generate_slug_and_display_name
    if self.first_name and self.last_name
      generate_display_name
      self.slug = self.first_name.parameterize + "-" + self.last_name.parameterize
    else
      # We don't have the details for the name yet so we'll need to generate a random string 
      self.slug = SecureRandom.urlsafe_base64
    end

        # Check to see if it already exists
    count = 0
    while Account.where(slug: self.slug).first
      count = count + 1
      self.slug = self.slug + "-" + count.to_s
    end
  end

end
