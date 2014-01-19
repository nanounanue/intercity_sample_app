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

after "deploy:finalize_update", "symlink:all"

namespace :symlink do
  task :db do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :unicorn do
    run "mkdir -p #{release_path}/tmp"
    run "ln -nfs #{shared_path}/sockets #{release_path}/tmp/sockets"
    run "ln -nfs #{shared_path}/pids #{release_path}/tmp/pids"
  end
  task :all do
    symlink.db
    symlink.unicorn
  end
end

namespace :deploy do

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end


  # task :start do
  #   run "#{current_path}/bin/unicorn -Dc #{shared_path}/config/unicorn.rb -E #{rails_env} #{current_path}/config.ru"
  # end

  # task :restart do
  #   run "kill -USR2 $(cat #{shared_path}/pids/unicorn.pid)"
  # end
end

after "deploy:restart", "deploy:cleanup"