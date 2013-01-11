class Custom

  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :object_template, type: Array
  field :objects, type: Array
  field :slug, type: String

  before_create :generate_slug

  def href(root_domain)
    root_domain + "/objects/customs/" + self.slug
  end


  def object
    "custom"
  end


  def data 
    data = []
    data << { "name" => "name", "value" => self.name, "prompt" => "Name" }
    data << { "name" => "description", "value" => self.description, "prompt" => "Description" }
    data << { "name" => "object_template", "value" => self.object_template, "prompt" => "Template" }
  end


  def template
    data = []
    data << { "name" => "name", "value" => self.name ? self.name : "", "prompt" => "Name", "type" => "string" }
    data << { "name" => "description", "value" => self.description ? self.description : "", "prompt" => "Description", "type" => "string" }
    data << { "name" => "object_template", "value" => self.object_template ? self.object_template : nil, "prompt" => "Template", "type" => "array" }
  end


  def links(current_href)
    data = []
    data << { "name" => "objects", "href" => current_href + "/documents" }
  end


  def custom_object_data

  end


  def custom_object_template
    # Build the template based on the object_template value

    data = []

    if self.object_template
      for object_field in self.object_template
        object_field_parts = object_field.split(":")
        data << { "name" => object_field_parts[0], "value" => "", "prompt" => object_field_parts[0], "type" => object_field_parts[1] }
      end
    end

    data

  end



  def generate_slug
    self.slug = self.name.parameterize

    # Check to see if it already exists
    count = 0
    while Custom.where(slug: self.slug).first
      count = count + 1
      self.slug = self.name.parameterize + "-" + count.to_s
    end
  end


end
