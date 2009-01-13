set :application, "speakercal"
set :deploy_to, "/home/sigvei/public_html/railsapps/#{application}"
set :repository,  "http://speakercal.googlecode.com/svn/trunk"

set :use_sudo, true

set :user, 'sigvei'
set :domain, "speakercal.trylle.no"
server domain, :app, :web
role :db, domain, :primary => true

namespace :passenger do
  desc "Restart application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"
