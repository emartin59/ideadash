require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '138.197.36.199'
set :repository, 'git@github.com:ermartin86/ideadash.git'
case ENV['to']
when 'staging'
  set :deploy_to, '/var/www/staging.ideadash.com'
  set :branch, 'master'
when 'production'
  set :deploy_to, '/var/www/ideadash.com'
  set :branch, 'production'
else
  puts "Specify an environment please"
  exit
end

set :stage, ENV['to']

# Optional settings:
set :user, 'deployer'          # Username in the server to SSH to.
set :port, '4567'           # SSH port number.
set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []).push("tmp/puma", "tmp/sockets")
set :shared_files, fetch(:shared_files, []).push('.env')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
#   invoke :'rvm:use', 'ruby-2.3.1@ideadash'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  invoke :'rvm:use', 'ruby-2.3.1@ideadash'
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    invoke :'rvm:use', 'ruby-2.3.1@ideadash'
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke 'deploy:restart'
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run :local { say 'done' }
end

namespace :deploy do
  task :restart do
    comment %{Restarting Ideadash #{fetch(:stage)}...}
    command %{sudo /bin/systemctl restart ideadash-#{fetch(:stage)}.service}
    comment %{Restarted}
  end
end

namespace :env do
  desc "Downloads .env file"
  task :download do
    run :local do
      command %{scp -P #{fetch(:port)} #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:deploy_to)}/shared/.env ./.env.#{fetch(:stage)}}
    end
  end
  desc "Uploads .env file"
  task :upload do
    comment %{Uploading .env.#{fetch(:stage)} file to shared/.env...}
    run :local do
      command %{scp -P #{fetch(:port)} ./.env.#{fetch(:stage)} #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:deploy_to)}/shared/.env}
    end
    comment %{Uploaded}

    invoke 'deploy:restart'
  end
end


# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
