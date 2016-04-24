## Build
namespace :build do
  def build(env)
    puts "*"*50
    puts "* Building #{env}"
    puts "*"*50
    system "TARGET=#{env} bundle exec middleman build --clean"
  end

  task :nl do
    build :nl
    FileUtils.rm_rf("build/de", verbose: true)
  end

  task :de do
    build :de
    FileUtils.rm_rf("build/nl", verbose: true)
  end
end

## Deploy
namespace :deploy do
  def deploy(env)
    system "bundle exec rake build:#{env}"
    puts "*"*50
    puts "* Deploying #{env}"
    puts "*"*50
    system "TARGET=#{env} bundle exec middleman deploy"
  end

  task :nl do
    deploy :nl
  end

  task :de do
    deploy :de
  end
end

## Default task
task :deploy => ["deploy:nl", "deploy:de"]
