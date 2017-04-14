namespace :deploy do
  desc 'Runs rake db:seed for SeedMigrations data'
  task :seed => [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  after 'deploy:migrate', 'deploy:seed'

  desc 'Set config/puma.rb-symlink for upstart'
    task :pumaconfigln do
      on roles(:app) do
        execute "ln -s #{sharedpath}/puma.rb #{fetch(:deployto)}/current/config/puma.rb"
      end
    end

  after :finishing, :pumaconfigln

end
