default_run_options[:pty] = true
set :application, "go.tida"
set :repository,  "git@github.com:babaru/hati.git"
set :domain, "42.121.56.31"

set :rvm_ruby_string, '1.9.3-p429'
set :rvm_type, :system

set :scm, :git
set :scm_passphrase, "Mbi800716"

set :user, "app"
set :password, "Mbi800707"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

ssh_options[:forward_agent] = true
set :branch, "master"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/app/www_root/go.sptida.com/rails"

set :use_sudo, false

namespace :deploy do

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    command = "if [ -e /tmp/unicorn.hati.pid ]; then \
              #{try_sudo} kill -s QUIT `cat /tmp/unicorn.hati.pid` ; \
              fi;"
    run command
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

end

require 'bundler/capistrano'
set :bundle_flags, "--deployment --without development test"

after "deploy:update_code", "deploy:migrate"
# after "deploy:migrate", "deploy:seed"
after "deploy:create_symlink", "deploy:restart"
# after "deploy:restart", "resque:restart"

require 'rvm/capistrano'
