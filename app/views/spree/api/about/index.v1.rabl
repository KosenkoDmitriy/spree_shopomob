object false
node(:current_page) { params[:page] || 1 }
node(:imageName) { @about.imageName }
node(:title) { @about.title }
node(:text) { @about.text }

child(@about.pictures => :pictures) do
  attribute :id, :image_file_name, :image, :title, :image_url_thumb, :image_url
end
