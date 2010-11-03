
###############################
#
# Capistrano Deployment on shared Webhosting by avarteq
#
# maintained by support@railshoster.de
#
###############################

#### Personal Settings
## User and Password ( this values are prefilled )

# user to login to the target server
set :user, "user13811513"

# password to login to the target server
set :password, "EjeB58GLiM"

##

## Application name and repository

# application name ( should be rails1 rails2 rails3 ... )
set :application, "rails2"

# repository location
set :repository, "git@github.com:ClaudiaPfeil/schwab-auber.git"

# svn or git
set :scm, :git
set :scm_verbose, true

#submodules
set :git_enable_submodules, 1

##

####

#### System Settings
## General Settings ( don't change them please )

# run in pty to allow remote commands via ssh
default_run_options[:pty] = true

# don't use sudo it's not necessary
set :use_sudo, false

# set the location where to deploy the new project
set :deploy_to, "/home/#{user}/#{application}"

# live
role :app, "zeta.railshoster.de"
role :web, "zeta.railshoster.de"
role :db,  "zeta.railshoster.de", :primary => true



## ## ## ## ## ## ## ## ## ## ## ## ## ##
## Dont Modify following Tasks!
##
namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
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
    run "cd #{deploy_to} && rm -f #{current_path}                      && ln -s ./releases/#{release_name} #{current_path}"
    run "cd #{deploy_to} && rm -f #{current_path}/config/database.yml   && ln -s ../../../shared/config/database.yml #{current_path}/config/"
    run "cd #{deploy_to} && rm -f ./current/log                        && ln -s ../../shared/log #{current_path}/"
    run "cd #{deploy_to} && rm -f ./current/pids                       && ln -s ../../shared/pids #{current_path}/"
    run "cd #{deploy_to} && rm -f ./current/public/system              && ln -s ../../shared/system #{current_path}/public/"
  end


  after "deploy:rollback" do
    if previous_release
      run "rm #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
    else
      abort "could not rollback the code because there is no prior release"
    end
  end

end


namespace :bundle do
  desc "Bundle install"
  task :install, :roles => :app do
    run "cd #{current_path} && bundle check || bundle install --path=/home/#{user}/.bundle --without=test"
  end
end



namespace :rollback do

  desc "overwrite rollback because of relative symlink paths"
  task :revision, :except => { :no_release => true } do
    if previous_release
      run "rm -f #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
    else
      abort "could not rollback the code because there is no prior release"
    end
  end

end

