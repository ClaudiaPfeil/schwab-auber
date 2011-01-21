###############################
#
# Capistrano Deployment on shared Webhosting by avarteq
#
# maintained by support@railshoster.de
#
###############################

# Multistage Environment
require 'capistrano/ext/multistage'

# Stages
set :stages, %w(development staging production)

# repository location
set :repository, "git@github.com:ClaudiaPfeil/schwab-auber.git"

# svn or git
set :scm, :git
set :scm_verbose, true

#submodules
set :git_enable_submodules, 1

#### System Settings
## General Settings ( don't change them please )

# run in pty to allow remote commands via ssh
default_run_options[:pty] = true

# don't use sudo it's not necessary
set :use_sudo, false

## ## ## ## ## ## ## ## ## ## ## ## ## ##
## Dont Modify following Tasks!
##
namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/cloth_app/tmp/restart.txt"
  end


  desc "Overwriten Symbolic link Task, Please dont change this"
  task :symlink, :roles => :app do
    on_rollback do
      if previous_release
      run "rm #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
      else
        logger.important "no previous release to rollback to, rollback of symlink skipped"
      end
    end
    run "cd #{deploy_to} && rm -f #{current_path}                                && ln -s ./releases/#{release_name} #{current_path}"
    run "cd #{deploy_to} && rm -f #{current_path}/cloth_app/config/database.yml  && ln -s ../../../../shared/config/database.yml #{current_path}/cloth_app/config"
    run "cd #{deploy_to} && rm -rf ./current/cloth_app/log                       && ln -s ../../../shared/log #{current_path}/cloth_app/"
    run "cd #{deploy_to} && rm -rf ./current/cloth_app/pids                      && ln -s ../../../shared/pids #{current_path}/cloth_app/"
    run "cd #{deploy_to} && rm -rf ./current/cloth_app/public/system             && ln -s ../../../shared/system #{current_path}/cloth_app/public/"
    run "cd #{deploy_to} && rm -rf ./current/cloth_app/.bundle                   && ln -s ../../../shared/bundle/.bundle #{current_path}/cloth_app/.bundle"
    run "cd #{deploy_to} && rm -rf ./current/cloth_app/export                    && ln -s ../../../shared/export #{current_path}/cloth_app/export"
  end

end


namespace :bundle do
  desc "Bundle install"
  task :install, :roles => :app do
    run "cd #{current_path} && bundle check || bundle install --path=/home/#{user}/.bundle --without=test"
  end
end

