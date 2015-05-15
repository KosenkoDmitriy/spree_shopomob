object @contact
#attributes :id, :key, :value, :prefix, :contact_type
attributes :imageName, :key, :value, :prefix, :contact_type
#node(:key) { @contact.key }
#node(:value) { @contact.value }
#node(:prefix) { @contact.prefix }
#node(:type) { @contact.contact_type }

child :picture do
  attribute :id, :image_file_name, :image, :title, :image_url_thumb, :image_url
end