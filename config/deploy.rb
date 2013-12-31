#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '2.1.0'

set :application, "staticbot"
set :repo_url,  "git@github.com:madrailers/staticbot.git"

set :scm, :git

# do not use sudo
set :use_sudo, false

# This is needed to correctly handle sudo password prompt
#default_run_options[:pty] = true

set :user, "buildbot"
set :group, fetch(:user)
set :runner, fetch(:user)

set :ip, '162.243.90.117'
set :host, "#{fetch(:user)}@#{fetch(:ip)}"
role :web, fetch(:host)
role :app, fetch(:host)

set :rails_env, :production

# Where will it be located on a server?
set :deploy_to, "/home/buildbot/apps/#{fetch(:application)}"
set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    on roles(:web) do |host|
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        info "Sending USR2 to Unicorn"
        execute "kill -USR2 `cat #{fetch(:unicorn_pid)}`"
      else
        within current_path do
          execute "bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D"
        end
      end
    end
  end

  task :start do
    on roles(:web) do |host|
      info "Starting Unicorn"
      execute "cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D"
    end
  end

  task :stop do
    on roles(:web) do |host|
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        info "Stopping Unicorn"
        execute "kill -QUIT `cat #{fetch(:unicorn_pid)}`"
      else
        error "Unicorn PID did not exist"
      end
    end
  end
end
