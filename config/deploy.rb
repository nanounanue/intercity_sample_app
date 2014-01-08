require 'bundler/capistrano'

set :application, "docker_test"
set :repository, "git@github.com:intercity/intercity_sample_app.git"
set :user, "deploy"
set :shell, "/bin/bash --login"
set :use_sudo, false

default_run_options[:pty] = true
default_run_options[:shell] = "/bin/bash --login"

server "95.85.61.92", :web, :app, :db, :primary => true
set :ssh_options, { :forward_agent => true, :port => 2222 }

after "deploy:finalize_update", "symlink:db"

namespace :symlink do
  task :db do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  task :start do
    run "#{current_path}/bin/unicorn #{current_path}/config.ru -Dc #{shared_path}/config/unicorn.rb -E production"
  end

  task :restart do
    run "kill -SIGUSR2 $(cat #{shared_path}/pids/unicorn.pid)"
  end
end

# after "deploy:restart", "deploy:cleanup"