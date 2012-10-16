#!/usr/bin/env ruby
#
# An app for displaying one's resume
# @author Nat Welch - https://github.com/icco/resume

begin
  require "rubygems"
rescue LoadError
  puts "Please install Ruby Gems to continue."
  exit
end

# Check all of the gems we need are there.
[ "sinatra", "less", "yaml", "haml" ].each {|gem|
  begin
    require gem
  rescue LoadError
    puts "The gem #{gem} is not installed.\n"
    exit
  end
}

# Include our configurations from config.yaml
configure do
  set :config, YAML.load_file('config.yaml')['user_config']
end

# Render the main page.
get '/index.html' do
  name  = settings.config['name']
  title = "#{name}'s Resume"
  haml :index, :locals => {
    :title => title,
    :author => name,
    :key => settings.config['gkey'],
  }
end

# We do this for our static site rendering.
get '/' do
  redirect '/index.html'
end

# For the plain text version of our resumes
get '/resume.txt' do
  content_type 'text/plain', :charset => 'utf-8'
  File.read(settings.config['file'])
end
