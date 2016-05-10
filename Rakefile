## Serve
namespace :serve do
  def serve(env)
    puts "*"*50
    puts "* Serving #{env.upcase}"
    puts "*"*50
    system "LOCALE=#{env} bundle exec middleman"
  end

  desc "Serve NL"
  task :nl do
    serve :nl
  end

  desc "Serve DE"
  task :de do
    serve :de
  end
end

## Build
namespace :build do
  def build(env)
    puts "*"*50
    puts "* Building #{env.upcase}"
    puts "*"*50
    system "LOCALE=#{env} bundle exec middleman build --clean"
  end

  desc "Build NL"
  task :nl do
    build :nl
  end

  desc "Build DE"
  task :de do
    build :de
    FileUtils.rm_rf("build/nl", verbose: true)
  end
end

## Deploy
namespace :deploy do
  def deploy(env)
    Rake::Task["build:#{env}"].invoke
    puts "*"*50
    puts "* Deploying #{env.upcase}"
    puts "*"*50
    system "LOCALE=#{env} bundle exec middleman deploy"
  end

  desc "Deploy NL"
  task :nl do
    deploy :nl
  end

  desc "Deploy DE"
  task :de do
    deploy :de
  end
end

desc "Deploy all locales"
task :deploy => ["deploy:nl", "deploy:de"]
