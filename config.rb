###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  # Prevent page_classes from prefixing locales
  def page_classes(path=current_path.dup, options={})
    super(path.sub(/^[a-z]{2}\//, ''), options)
  end

  def nav_link_to(link_text, url, options = {})
    options[:class] ||= ""
    options[:class] << " active" if url_for(url, :relative => false) == url_for(current_page.url, :relative => false)
    link_to(link_text, url, options)
  end

  def team_avatar_url(person)
    return person.avatar if person.avatar
    avatar = gravatar_for(person.email)
    return avatar if avatar
    avatar = "/images/team/#{person.firstname.downcase}.jpg"
    return avatar if sitemap.find_resource_by_path(avatar)
    return false
  end

  def gravatar_for(email)
    return false unless email
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    url = "http://www.gravatar.com/avatar/#{hash}.png?d=404"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    return response.code.to_i == 404 ? false : url
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :relative_links, true

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload
activate :livereload, :host => "127.0.0.1"

activate :i18n, :mount_at_root => :nl # Mount dutch at root instead
activate :directory_indexes

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = "custom-remote" # remote name or git url, default: origin
  # deploy.branch   = "custom-branch" # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
end
