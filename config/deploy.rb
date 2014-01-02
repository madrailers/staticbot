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
