require "bundler/capistrano"
load 'deploy/assets'
require "whenever/capistrano"
# This deploy recipe will deploy a project from a GitHub repo to a production server
#
# GitHub settings #######################################################################################
default_run_options[:pty] = true

# Change this to the name of the project.  It should match the name of the Git repo.
# This will set the name of the project directory and become the subdomain
set :application,  "nso"
set :project, 'nso'
set :rails_env, "production"

set :github_user, "marklocklear" # Your GitHub username
set :domain_name, "nso.abtech.edu" # should be something like mydomain.com
set :user, 'johnmlocklear' # server username
set :domain, 'nso.abtech.edu' # Immedion server

#### You shouldn't need to change anything below ########################################################
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :repository,  "git@bitbucket.org:marklocklear/nso.git" #GitHub clone URL
set :scm, "git"
set :scm_passphrase, "" # This is the passphrase for the ssh key on the server deployed to
set :branch, "master"
set :scm_verbose, true
set :subdomain, "#{project}.#{domain_name}"
set :applicationdir, "/home/johnmlocklear/#{project}" # set this to where the application will be deployed

set :keep_releases, 5
after "deploy:migrate", "deploy:restart", "deploy:cleanup"

# Don't change this stuff, but you may want to set shared files at the end of the file ##################
# deploy config
set :deploy_to, applicationdir
#set :deploy_via, :remote_cache

# roles (servers)
role :app, domain
role :web, domain
role :gateway, domain
role :db,  domain, :primary => true

set :whenever_command, "bundle exec whenever"

namespace :deploy do
 	desc "Bundle gems"
		task :bundle_install do
		run "cd #{current_path} && bundle install"
	end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

namespace :seed do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :default do  
    run("cd #{deploy_to}/current; /usr/bin/env bundle exec rake db:seed RAILS_ENV=#{rails_env}")  
  end  
end
