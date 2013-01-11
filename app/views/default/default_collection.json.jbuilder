json.collection do
  json.version "1.0"
  json.page_object @page_object if @page_object
  json.href @current_domain
  json.links @links if @links.length > 0
  json.items @items if @items.length > 0

  if @template_data
    json.template do
      json.data @template_data
    end
  end

  json.flash @flash if @flash && @flash.length > 0
    
end