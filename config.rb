##
# Compass
###

# Determine root locale
root_locale = (ENV["LOCALE"] ? ENV["LOCALE"].to_sym : :nl)
# Accessible as `root_locale` in helpers and `config[:root_locale]` in templates
set :root_locale, root_locale

activate :i18n, mount_at_root: root_locale, langs: [:nl, :de]

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
# page "/path/to/file.html", layout: :otherlayout

# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

if root_locale == :nl
  # Redirect :de pages
  with_layout :redirect do
    page "/de/*"
  end
end

# Ignore blog for other languages other than :nl
if root_locale != :nl
  ignore "/blog/*"
end

# # Prevent other locales from building (breaks page_classes)
# if root_locale == :nl
#   (langs - [root_locale, :de]).each do |locale|
#     ignore "/#{locale}/*"
#   end
# else
#   (langs - [root_locale]).each do |locale|
#     ignore "/#{locale}/*"
#   end
# end

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

ignore "/fonts/icons/selection.json"

redirect "workshop-convenant-mt.html", to: "convenant-medische-technologie.html"

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload
# activate :livereload, host: "127.0.0.1"

# Blog
Time.zone = "CET"

activate :blog do |blog|
  blog.prefix = "blog"
  blog.permalink = ":title"
  # blog.tag_template = "blog/tag.html"
  # blog.calendar_template = "blog/calendar.html"
  blog.paginate = false
  # blog.per_page = 10
end

page "blog/*", layout: :blog_post_layout
page "blog/index.html", layout: :blog_layout
page "blog/feed.xml", layout: false

activate :directory_indexes

set :relative_links, true
set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

# Middleman syntax (https://github.com/middleman/middleman-syntax)
activate :syntax #, line_numbers: true

set :markdown_engine, :kramdown
set :markdown, input: "GFM", auto_ids: false

#set :markdown_engine, :redcarpet
#set :markdown, fenced_code_blocks: true, smartypants: true

###
# Build
###

configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash #, ignore: [%r{^blog}]

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

###
# Deploy
###

# Deploy for each locale
case root_locale
when :nl
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "git@github.com:DefactoSoftware/website-nl.git"
  end
when :de
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "git@github.com:DefactoSoftware/website-de.git"
  end
end

###
# Ready callback
###

ready do
  # validate data/downloads.yml
  validate_downloads(data.downloads)
end

after_build do
  # rename CNAME for gh-pages after build
  File.rename "build/CNAME.html", "build/CNAME"
end

###
# Helpers
###

helpers do
  # Get full locale (eg. nl_NL)
  def full_locale(lang=I18n.locale.to_s)
    case lang
      when "en"
        "en_US"
      else
        "#{lang.downcase}_#{lang.upcase}"
    end
  end

  # Get full url
  def full_url(url, locale=I18n.locale)
    URI.join("http://#{I18n.t('CNAME', locale: locale)}", url).to_s
  end

  # Use frontmatter for I18n titles
  def page_title(page, appendCompanyName=true)
    appendTitle = appendCompanyName ? " - Defacto" : ""
    return page.data.title.send(I18n.locale) + appendTitle if
      page.data.title.is_a?(Hash) && page.data.title[I18n.locale]
    return page.data.title + appendTitle if page.data.title
    "Defacto - Developing People"
  end

  # Localize page_classes
  def page_classes(path=current_path.dup, options={})
    # Prevent page classes from being translated
    unless I18n.locale == :nl
      default_path = sitemap.resources.select do |resource|
        resource.proxied_to == current_page.proxied_to &&
          resource.metadata[:options][:lang] == :nl
      end.first
      path = default_path.destination_path.dup if default_path
    end
    # Create classes from path
    classes = super(path.sub(/^[a-z]{2}\//, ""), options)
    # Add class if blog post
    classes += " blog_article" if is_blog_article?
    # Prepend language class
    classes.prepend("#{I18n.locale} ")
  end

  # Localized link_to
  def locale_link_to(*args, &block)
    url_arg_index = block_given? ? 0 : 1
    options_index = block_given? ? 1 : 2
    args[options_index] ||= {}
    options = args[options_index].dup
    args[url_arg_index] = locale_url_for(args[url_arg_index], options)
    link_to(*args, &block)
  end

  # Localized url_for
  def locale_url_for(url, options={})
    locale = options[:locale] || I18n.locale
    options[:relative] = false
    url_parts = url.split("#")
    url_parts[0] = extensions[:i18n].localized_path(url_parts[0], locale) ||
                   url_parts[0]
    url = url_parts.join("#")
    url = url_for(url, options)
    # Replace leading locale url segment with domain
    url.sub("/#{locale}/", full_url("/", locale))
  end

  # Link_to with active class if current_page
  def nav_link_to(text, url, options={})
    is_active = url_for(url.split("#")[0], relative: false) ==
                url_for(current_page.url, relative: false)
    options[:class] ||= ""
    options[:class] << " active" if is_active
    link_to(text, url, options)
  end

  # Country flags
  def country_flags
    flag_titles = { nl: "Nederlands", de: "Deutsch", en: "English" }
    html = ""
    (langs - [I18n.locale]).each do |lang|
      img = image_tag("flags/#{lang}.gif", alt: flag_titles[lang])
      locale_root_path = current_page.locale_root_path
      url = locale_root_path ? locale_root_path : "/"
      html << locale_link_to(img, url, title: flag_titles[lang], locale: lang)
    end
    html
  end

  # String to markdown
  def markitdown(string)
    # Kramdown::Document.new(string, config[:markdown]).to_html
    # Redcarpet::Markdown.new(Redcarpet::Render::HTML, config[:markdown]).render(string)
    Tilt['markdown'].new { string }.render(scope=self)
  end

  # Get avatar url for team members
  def team_avatar_url(person)
    return person.avatar if person.avatar
    avatar = gravatar_for(person.email)
    return avatar if avatar
    avatar = "/images/team/#{person.firstname.downcase}.jpg"
    return avatar if sitemap.find_resource_by_path(avatar)
    false
  end

  # Email to gravatar
  def gravatar_for(email)
    return false unless email
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    url = "http://www.gravatar.com/avatar/#{hash}.png?d=404"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.code.to_i == 404 ? false : url
  end

  # Get blog author
  def blog_author(article)
    author = article.data.author
    author = author.present? ? author.capitalize : author
    data.team.find{ |person| person[:firstname] == author }
  end

  # Used to validate data/downloads.yml
  def validate_downloads(hash)
    hash.each do |key, value|
      if value.is_a?(Hash)
        validate_downloads(value)
      elsif value.is_a?(String)
        unless sitemap.find_resource_by_path(value)
          hash[key] = false
          puts "\033[31mWARNING: Download link does not exist '#{value}'\033[0m"
        end
      end
    end
  end
end
