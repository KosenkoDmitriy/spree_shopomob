object false
node(:imageName) { @about.imageName }
node(:title) { @about.title }
node(:text) { @about.text }
node(:current_page) { params[:page] || 1 }
