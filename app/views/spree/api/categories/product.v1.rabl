object @product
attribute :id, :name, :description, :price
child :images => "images" do |images|
  attribute :id, :attachment_file_name #, :mini_url
  node(:url) { images.first.attachment.url }
  child :attachment => "image" do |a|
    #attribute :url
    #available params for url : mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>'
    #node(:url_small) { a.url("small") }
    #node(:url_large) { a.url("large") }
    #node(:url_mini) { a.url("mini") }
    node(:product_url) { a.url("product") }
  end
end

