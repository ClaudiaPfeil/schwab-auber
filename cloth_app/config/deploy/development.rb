############################
# Stage: development
# Hosting: railshoster Shared Hosting
############################


## User credentials
set :user, "user13811513"
set :password, "EjeB58GLiM"

## application
set :application, "rails2"

# set the location where to deploy the new project
set :deploy_to, "/home/#{user}/#{application}"

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


  after "deploy:rollback" do
    if previous_release
      run "rm #{current_path}; ln -s ./releases/#{releases[-2]} #{current_path}"
    else
      abort "could not rollback the code because there is no prior release"
    end
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

