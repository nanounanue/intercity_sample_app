require 'intercity/capistrano'
require 'bundler/capistrano'

set :application, "myapp_production"
set :repository,  "https://github.com/intercity/intercity_sample_app"

default_run_options[:shell] = '/bin/bash --login'

role :web, "192.241.165.120"                          # Your HTTP server, Apache/etc
role :app, "192.241.165.120"                          # This may be the same as your `Web` server
role :db,  "192.241.165.120", :primary => true # This is where Rails migrations will run

set :bluepill_bin, "/opt/chef/embedded/bin/bluepill"

namespace :deploy do
  desc "Start bluepill daemon"
  task :start do
    run "sudo #{bluepill_bin} load /etc/bluepill/#{application}.pill"
  end
  desc "Stop bluepill daemon"
  task :stop do
    run "sudo #{bluepill_bin} #{application} stop"
  end
  desc "Restart bluepill daemon"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo #{bluepill_bin} #{application} restart"
  end
  desc "Show status of the bluepill daemon"
  task :status do
    run "sudo #{bluepill_bin} #{application} status"
  end
end