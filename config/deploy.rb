default_run_options[:pty] = true
set :application, "Hati"
set :repository,  "git@bitbucket.org:babaru/hati.git"
set :domain, "106.187.93.197"

set :rvm_ruby_string, '1.9.3-head'
require "rvm/capistrano"
set :rvm_type, :system

set :scm, :git
set :scm_passphrase, "Mbi800716"

set :user, "app"
set :password, "Mbi800716"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

ssh_options[:forward_agent] = true
set :branch, "master"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :deploy_to, "~/www_root/hati.tfocusclub.com/app/hati"

# load 'deploy/assets'

set :use_sudo, false

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  
  task :start, :roles => :app, :except => { :no_release => true } do 
	invoke_command "cd #{current_path};./script/ferret_server -e production start"
    invoke_command "service thin start"
  end

  task :stop do
  	invoke_command "cd #{current_path};./script/ferret_server -e production stop"
    invoke_command "service thin stop"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    invoke_command "cd #{current_path};./script/ferret_server -e production stop"
    invoke_command "service thin stop"

    invoke_command "cd #{current_path};./script/ferret_server -e production start"
    invoke_command "service thin start"
  end
  
  task :seed, :roles => :app do
    run "cd #{current_path} && /usr/bin/env rake db:seed RAILS_ENV=production"
  end

end

require 'bundler/capistrano'

after "deploy:update_code", "deploy:migrate"
after "deploy:migrate", "deploy:seed"
after "deploy:create_symlink", "deploy:restart"
