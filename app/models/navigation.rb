class Navigation

  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :page_slug, type: String
  field :rank, type: Integer
  field :slug, type: String
  field :parent_navigation_slug, type: String

  before_create :generate_slug


  def href(root_domain)
    root_domain + "/navigations/" + self.slug
  end


  def object
    "navigation"
  end


  def data(root_domain)
    data = []
    data << { "name" => "name", "value" => self.name, "prompt" => "Name" }
    data << { "name" => "description", "value" => self.description, "prompt" => "Description" }
    data << { "name" => "rank", "value" => self.rank, "prompt" => "Rank" }

    # find the parent page if there is one
    if self.parent_navigation_slug
      parent_navigation = Navigation.find_by(slug: self.parent_navigation_slug)
      if parent_navigation
        data << { "name" => "parent_navigation", "value" => parent_navigation, "prompt" => "Parent Navigation", "type" => "object" }
      end
    end

    # find the parent page if there is one
    if self.page_slug
      page = Page.find_by(slug: self.page_slug)
      if page
        data << { "name" => "page", "value" => page.href(root_domain), "prompt" => "Page", "type" => "object" }
      end
    end

    data

  end




  def template
    parent_navigation_options = ["No Parent"]
    parent_navigation_values = [nil]

    page_options = ["No Page"]
    page_values = [nil]

    available_parents = self.available_parents
    if available_parents
      for page in available_parents
        parent_navigation_options << page.name
        parent_navigation_values << page.slug
      end
    end

    pages = Page.all
    if pages
      for page in pages
        page_options << page.name
        page_values << page.slug
      end
    end

    data = []
    data << { "name" => "name", "value" => self.name ? self.name : "", "prompt" => "Name", "type" => "text" }
    data << { "name" => "description", "value" => self.description ? self.description : "", "prompt" => "Description", "type" => "textarea" }
    data << { "name" => "rank", "value" => self.rank ? self.rank : "", "prompt" => "Rank", "type" => "integer" }
    data << { "name" => "parent_navigation_slug", "value" => self.parent_navigation_slug ? self.parent_navigation_slug : "", "prompt" => "parent_navigation_slug", "type" => "option", "options" => parent_navigation_options, "values" => parent_navigation_values }
    data << { "name" => "page_slug", "value" => self.page_slug ? self.page_slug : "", "prompt" => "page_slug", "type" => "option", "options" => page_options, "values" => page_values }
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
    Navigation.find_by(slug: self.parent_navigation_slug) if self.parent_navigation_slug.present?
  end


  def available_parents

    available_navigations = Navigation.where(:slug.ne => self.slug) if self.slug.present?
    available_navigations = Navigation.all if !self.slug.present?

    valid_pages = []

    if available_navigations
      available_navigations.each do |sl|
        
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
