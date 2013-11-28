require 'intercity/capistrano'
require 'bundler/capistrano'

set :application, "myapp_production"
set :repository,  "https://github.com/intercity/intercity_sample_app"

role :web, "192.241.165.120"                          # Your HTTP server, Apache/etc
role :app, "192.241.165.120"                          # This may be the same as your `Web` server
role :db,  "192.241.165.120", :primary => true # This is where Rails migrations will run