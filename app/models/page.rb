class Page

  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :parent_page_slug, type: String
  field :body, type: String
  field :slug, type: String


  before_create :generate_slug


  def href(root_domain)
    # Check if the current page is the homepage, if so get rid of the slug in the url
    site = Site.first
    if site.homepage_slug == self.slug
      root_domain
    else
      root_domain + "/" + self.slug
    end

  end


  def object
    "page"
  end


  def data 

    data = []
    data << { "name" => "name", "value" => self.name, "prompt" => "Name" }
    data << { "name" => "description", "value" => self.description, "prompt" => "Description" }
    data << { "name" => "body", "value" => self.body, "prompt" => "Body" }

    # find the parent page if there is one
    if self.parent_page_slug
      parent_page = Page.find_by(slug: self.parent_page_slug)
      if parent_page
        data << { "name" => "parent_page", "value" => parent_page, "prompt" => "Parent Page", "type" => "object" }
      end
    end

    data

  end



  def template
    parent_page_options = ["No Parent"]
    parent_page_values = [nil]

    available_parents = self.available_parents
    if available_parents
      for page in available_parents

        puts "PAGE!" + page.inspect
        parent_page_options << page.name
        parent_page_values << page.slug
      end
    end

    data = []
    data << { "name" => "name", "value" => self.name ? self.name : "", "prompt" => "Name", "type" => "text" }
    data << { "name" => "description", "value" => self.description ? self.description : "", "prompt" => "Description", "type" => "textarea" }
    data << { "name" => "body", "value" => self.body ? self.body : "", "prompt" => "Body", "type" => "textarea" }
    data << { "name" => "parent_page_slug", "value" => self.parent_page_slug ? self.parent_page_slug : "", "prompt" => "parent_page_slug", "type" => "option", "options" => parent_page_options, "values" => parent_page_values }
  end



  def generate_slug
    self.slug = self.name.parameterize

    # Check to see if it already exists
    count = 0
    while Page.where(slug: self.slug).first
      count = count + 1
      self.slug = self.name.parameterize + "-" + count.to_s
    end
  end


  def parent
    Page.find_by(slug: self.parent_page_slug) if self.parent_page_slug.present?
  end


  def available_parents

    available_pages = Page.where(:slug.ne => self.slug) if self.slug.present?
    available_pages = Page.all if !self.slug.present?

    valid_pages = []

    if available_pages
      available_pages.each do |sl|
        
        if sl.valid_heirachy(self)
          valid_pages << sl
        end
    
      end
    end

    valid_pages
  end


  def valid_heirachy(original)
    if self.parent.present? && self.parent.slug != original.slug
      self.parent.valid_heirachy(original)
    elsif self.parent.present? && self.parent.slug == original.slug
      false
    else 
      true
    end
  end



end
