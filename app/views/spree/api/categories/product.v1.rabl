object @product
attribute :id, :name, :description, :price
child :images do
  attribute :id, :attachment_file_name
end

