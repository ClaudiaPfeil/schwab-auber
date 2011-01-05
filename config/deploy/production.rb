############################
# Stage: production
# Hosting: dedicated Server
############################


## User credentials
set :user, "kidskarton"
set :password, "M0P6zrKdg8Oo"

## application
set :application, "kidskarton"

# set the location where to deploy the new project
set :deploy_to, "/var/www/#{application}"

role :app, "188.40.38.70"
role :web, "188.40.38.70"
role :db,  "188.40.38.70", :primary => true
