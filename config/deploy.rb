require 'bundler/capistrano'

set :application, "intercity_sample_app"
set :repository, "git@github.com:intercity/intercity_sample_app.git"
set :ssh_options, { forward_agent: true }
set :default_run_options, { pty: true }
set :user, "deploy"
set :use_sudo, false
set :default_environment, {
  "PATH" => "/opt/rbenv/shims:/opt/rbenv/bin:$PATH"
}

server "95.85.61.92", :web, :app, :db, :primary => true

after "deploy:finalize_update", "link:database"

namespace :link do
  task :database do
    run "rm -f #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
