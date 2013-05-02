require 'bundler/capistrano'
require 'capistrano-rbenv'

set :user, ##FIXME '<username>'
set :ssh_key, ##FIXME '<path/to/.ssh/private-key>'
set :domain, ##FIXME '<server-address>'

set :rbenv_ruby_version, "1.9.3-p448"
set :keep_releases, 2
set :bundle_flags, "--deployment --binstubs"
set :application, "hemlock-frontend"
set :repository,  "https://github.com/Lab41/Hemlock-Frontend.git"

# multistage deployment (Note: require must come last)
set :stages, %w(production staging)
set :default_stage, 'staging'
set :stage_dir, 'config/staging'
require 'capistrano/ext/multistage'

# roles (servers)
set :current_user, "#{user}"
set :use_sudo, false
set :sudo_prompt, ""

# deploy config
set :scm, 'git'
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]
set :scm_verbose, true
set(:deploy_to)         { "/var/www/#{application}" }
set(:releases_path)     { File.join(deploy_to, version_dir) }
set(:shared_path)       { File.join(deploy_to, shared_dir) }
set(:current_path)      { File.join(deploy_to, current_dir) }
set(:release_path)      { File.join(releases_path, release_name) }
set(:rbenv_version)     { `rbenv version |cut -d' ' -f1`.strip }
#set :git_enable_submodules, 1 # if you have vendored rails
#set :branch, 'master'
#set :git_shallow_clone, 1
#set :scm_passphrase, ""


set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
  'RUBY_VERSION' => '1.9.3',#
  'RBENV_VERSION' => '1.9.3-p448',#
  #'GEM_HOME'     => "$HOME/.rbenv/versions/#{rbenv_version}/lib/ruby/gems/1.9.1/gems",
  #'GEM_PATH'     => "$HOME/.rbenv/versions/#{rbenv_version}/bin/gem",
  #'BUNDLE_PATH'  => "$HOME/.rbenv/versions/#{rbenv_version}/bin/bundle"
}


# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
#ssh_options[:keys] = %w(/root/.ssh/id_rsa)            # If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false
 



# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set(:taskname)     { "-T" }
set(:rails_env)     { "production" }

namespace :deploy do

  namespace :rake do
    task :migrate do
      run "cd #{current_path}; rake #{taskname}"
    end
  end
  
  task :setup_server do
      deploy.db.create
      deploy.db.migrate
      deploy.db.seed
  end
  
  namespace :db do  
    task :seed do
      run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    end

    task :migrate do
      run "cd #{current_path}; bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
    end

    task :create do
      run "cd #{current_path}; bundle exec rake db:create RAILS_ENV=#{rails_env}"
    end
  end

  desc "Make sure the symlink will be from the right directory"
  task :change_correct_dir, roles: :web do
    set :current_path, File.join(deploy_to, current_dir)
  end
  
  desc "Start the Thin processes"
  task :start do
      run "cd #{current_path}; authbind --deep bundle exec thin start -C config/custom/thin.yml"
  end

  desc "Stop the Thin processes"
  task :stop do
    run "cd #{current_path}; authbind --deep bundle exec thin stop -C config/custom/thin.yml"
  end

  desc "Restart the Thin processes"
  task :restart do
    run "cd #{current_path}; authbind --deep bundle exec thin restart -C config/custom/thin.yml"
  end

  desc "Updating gems"
  task :update_gems do
    run "cd #{current_path}; bundle install --no-deployment"
  end

  task :restart_daemons, :roles => :app do
    #sudo "monit restart all -g daemons"
  end

  desc "precompile assets for production"
  task :precompile do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end

  desc "Installs required gems"  
  task :gems do#, :roles => :web do  
    run "cd #{current_path} && rake gems:install RAILS_ENV=#{rails_env}"  
  end 

  desc "Ensure destination directory exists with correct permissions"
  task :setup_deployment_destination_permissions do
    run "sudo mkdir --parents #{deploy_to} && sudo chown #{current_user}: #{deploy_to}"
  end
 
  #before "deploy:db:create", "deploy:gems"  
  before "deploy:setup", "deploy:setup_deployment_destination_permissions"
  after "deploy:setup", "deploy:setup_server"  
  before "deploy:create_symlink", "deploy:change_correct_dir"
  after "deploy:update", "deploy:precompile" 
  after "deploy:update", "deploy:cleanup"   
end
