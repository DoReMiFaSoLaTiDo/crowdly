namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:all) do |host|
      # this will restart passenger server
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Precompile assets locally and then rsync to web servers'
  task :custom_compile_assets do
    # The command inside this block will run in our local machine
    run_locally do
      execute 'RAILS_ENV=production bundle exec rake assets:precompile'
      execute 'tar -zcvf assets.tar.tgz public/assets/'
      execute 'rm -rf public/assets'

       # This command will copy and transfer the assets.tar.tgz to username@servername.com:#{release_path}/
      execute "scp assets.tar.tgz deploy@ec2-54-161-75-180.compute-1.amazonaws.com:#{release_path}/assets.tar.tgz"
      execute 'rm -rf assets.tar.tgz'
    end
    on roles(:all) do |host|
      # this command extracts assets.tar.tgz
      execute "cd #{release_path}; tar zxvf assets.tar.tgz"

      execute "cd #{release_path}; rm -rf assets.tar.tgz"
    end
    invoke 'deploy:restart'
  end
end
