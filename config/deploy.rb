require 'bundler/capistrano'

set :application, "intercity_sample_app"
set :repository, "git@github.com:intercity/intercity_sample_app.git"
set :user, "deploy"
set :use_sudo, false
set :branch, "clean"

default_run_options[:pty] = true
set :default_environment, {
  "PATH" => "/opt/rbenv/shims:/opt/rbenv/bin:$PATH"
}

server "localhost", :web, :app, :db, :primary => true
set :ssh_options, { :forward_agent => true, :port => 2222 }

after "deploy:finalize_update", "symlink:db"

namespace :symlink do
  task :db do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:restart", "deploy:cleanup"