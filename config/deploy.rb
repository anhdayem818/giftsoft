# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'muamely'
set :repo_url, 'git@bitbucket.org:nhpquang/giftshop.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/rails/muamely'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

#Take a look at the load:defaults (bottom of file) task for options you can set. https://github.com/javan/whenever/blob/master/lib/whenever/capistrano/v3/tasks/whenever.rake. For example, to namespace the crontab entries by application and stage do this.

#In your in "config/deploy.rb" file:
#set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles, ["rake"]

# Number of delayed_job workers
# default value: 1
set :delayed_job_workers, 8

# String to be prefixed to worker process names
# This feature allows a prefix name to be placed in front of the process.
# For example:  reports/delayed_job.0  instead of just delayed_job.0
#set :delayed_job_prefix, :reports               

# Delayed_job queue or queues
# Set the --queue or --queues option to work from a particular queue.
# default value: nil
set :delayed_job_queues, ['send_email','default', 'sender_score']

# Specify different pools
# You can use this option multiple times to start different numbers of workers for different queues.
# default value: nil
set :delayed_job_pools, {
    :send_email => 1,
    :sender_score => 1,
    :* => 6
}

# Set the roles where the delayed_job process should be started
# default value: :app
set :delayed_job_roles, [:app, :background]

# Set the location of the delayed_job executable
# Can be relative to the release_path or absolute
# default value 'bin'
set :delayed_job_bin_path, 'script' # for rails 3.x

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :restart, :change_owner do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      #execute "chown -R rails:rails #{release_path}/public/assets"
    end
  end

  task :symlinks do
    on roles(:web, :rake, :delay_job) do
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
      execute "ln -nfs #{shared_path}/public/spree #{release_path}/public/spree"
      execute "ln -nfs #{shared_path}/public/ckeditor_assets #{release_path}/public/ckeditor_assets"
      #execute "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
      #execute "ln -nfs #{shared_path}/config/environments/production.rb #{release_path}/config/environments/production.rb"
      # user avatars
      #execute "mkdir -p #{release_path}/public/system/users/"
      #execute "ln -fs #{shared_path}/system/avatars/ #{release_path}/public/system/users/"
    end
  end

  after :updating, :symlinks
  #after :updating, :migrate
  after :publishing, :restart

	task :restart do
	  on roles(:web), in: :sequence, wait: 5 do

	    execute "/etc/init.d/unicorn restart"  ## -> line you should add
	  end
	end

  on roles(:rake, :delay_job) do
    Rake::Task["deploy:assets:precompile"].clear_actions
  end
end



