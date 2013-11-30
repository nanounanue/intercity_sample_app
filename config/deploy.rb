require 'bundler/capistrano'
require 'intercity/capistrano'

set :application, "intercity_sample_app_production"
set :repository,  "git@github.com:intercity/intercity_sample_app.git"

role :web, "146.185.174.79"                          # Your HTTP server, Apache/etc
role :app, "146.185.174.79"                          # This may be the same as your `Web` server
role :db,  "146.185.174.79", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"