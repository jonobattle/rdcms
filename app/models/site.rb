class Site
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :homepage_slug, type: String


  def href(root_domain)
    root_domain
  end


  def object
    "site"
  end


  def data
    # Find the homepage object
    homepage = Page.find_by(slug: self.homepage_slug)

    data = []
    data << { "name" => "name", "value" => self.name, "prompt" => "Title" }
    data << { "name" => "description", "value" => self.description, "prompt" => "Description" }
    data << { "name" => "homepage", "value" => homepage, "prompt" => "Hompage", "type" => "object" }
  end


  def template
    homepage_options = []
    homepage_values = []
    available_pages = Page.all
    for page in available_pages
      homepage_options << page.name
      homepage_values << page.slug 
    end

    data = []
    data << { "name" => "name", "value" => self.name, "prompt" => "Title" }
    data << { "name" => "description", "value" => self.description, "prompt" => "Description" }
    data << { "name" => "homepage", "value" => homepage, "prompt" => "Hompage", "type" => "option", "options" => homepage_options, "values" => homepage_values }
  end    


end
