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
    data << { "name" => "objects", "value" => self.objects, "prompt" => "Objects" }
  end


  def template
    data = []
    data << { "name" => "name", "value" => self.name ? self.name : "", "prompt" => "Name", "type" => "string" }
    data << { "name" => "description", "value" => self.description ? self.description : "", "prompt" => "Description", "type" => "string" }
    data << { "name" => "object_template", "value" => self.object_template ? self.object_template : nil, "prompt" => "Template", "type" => "array" }
    data << { "name" => "objects", "value" => self.objects ? self.objects : nil, "prompt" => "Objects", "type" => "array" }
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
