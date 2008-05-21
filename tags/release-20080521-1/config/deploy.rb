set :application, "speakercal"
set :repository,  "http://speakercal.googlecode.com/svn/trunk"
set :user, 'sigvei'
set :use_sudo, false
set :runner, :user

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/users/home/sigvei/railsapps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "sigvei@trylle.no"
role :web, "sigvei@trylle.no"
role :db,  "sigvei@trylle.no", :primary => true
