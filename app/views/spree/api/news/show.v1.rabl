object @newsItem
attributes :id, :imgName, :title, :text, :created_at, :updated_at
child :pictures do
  attribute :id, :image_file_name, :image, :title, :image_url_thumb, :image_url
end
