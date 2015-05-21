##
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
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload
# activate :livereload, host: "127.0.0.1"

activate :i18n, mount_at_root: :nl, langs: [:nl, :en]
activate :directory_indexes

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :relative_links, true

# Middleman syntax (https://github.com/middleman/middleman-syntax)
activate :syntax #, line_numbers: true

set :markdown_engine, :kramdown
set :markdown, input: 'GFM', auto_ids: false

#set :markdown_engine, :redcarpet
#set :markdown, fenced_code_blocks: true, smartypants: true

# Blog
Time.zone = "CET"

activate :blog do |blog|
  blog.prefix = "blog"
  blog.permalink = ":title"
  blog.tag_template = "blog/tag.html"
  blog.calendar_template = "blog/calendar.html"
  blog.paginate = false
  # blog.per_page = 10
end

page "blog/*", layout: :blog_post_layout
page "blog/index.html", layout: :blog_layout
page "blog/feed.xml", layout: false

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

###
# Helpers
###

helpers do
  # Prevent page_classes from prefixing locales
  def page_classes(path=current_path.dup, options={})
    super(path.sub(/^[a-z]{2}\//, ''), options)
  end

  def markitdown(string)
    Kramdown::Document.new(string, config[:markdown]).to_html
    # Redcarpet::Markdown.new(Redcarpet::Render::HTML, config[:markdown]).render(string)
  end

  def nav_link_to(link_text, url, options={})
    options[:class] ||= ""
    options[:class] << " active" if url_for(url, relative: false) == url_for(current_page.url, relative: false)
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

  def local_path(path, options={})
    return "/#{path}" if I18n.locale == extensions[:i18n].options.mount_at_root
    lang = options[:language] ? options[:language] : I18n.locale.to_s
    "/#{lang}/#{path}"
  end

  # Get blog author hash
  def blog_author(article)
    data.team.find{ |person| person[:firstname] == article.data.author }
  end
end
