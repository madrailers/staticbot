set :user, 'buildbot'
set :group, fetch(:user)
set :runner, fetch(:user)

set :chruby_ruby, 'ruby-2.0.0'

set :application, 'staticbot'
set :repo_url, 'git@github.com:madrailers/staticbot.git'

set :deploy_to, "/var/www/apps/#{fetch :application}"
set :unicorn_pid, "#{fetch :deploy_to}/shared/unicorn.pid"
set :unicorn_conf, "#{fetch :deploy_to}/current/config/unicorn.rb"

desc 'Check that we can access everything'
task :check_write_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch :deploy_to} ]")
      info "#{fetch :deploy_to} is writable on #{host}"
    else
      error "#{fetch :deploy_to} is not writable on #{host}"
    end
  end
end

namespace :deploy do
  task :restart do
    on roles(:app) do
      if test("[ -f #{fetch :unicorn_pid} ]")
        info "Sending USR2 to Unicorn"
        execute "kill -USR2 `cat #{fetch :unicorn_pid}`"
      else
        within current_path do
          info "Starting Unicorn"
          execute :bundle, "exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rack_env)} -D"
        end
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        info "Starting Unicorn"
        execute :bundle, "exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rack_env)} -D"
      end
    end
  end
end

=begin
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'pry'
require 'rvm/capistrano'
require 'bundler/capistrano'
set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs
set :rvm_type, :system

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

set :rack_env, :production

# Where will it be located on a server?
set :deploy_to, "/home/buildbot/apps/#{fetch(:application)}"
set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/unicorn.pid"

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
      execute "cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rack_env)} -D"
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
=end
