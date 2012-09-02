export RAILS_ENV=production
bundle install
bundle exec rake db:migrate
rake assets:precompile
if [ -f tmp/pids/unicorn.pid ];then 
  kill -s HUP `cat tmp/pids/unicorn.pid`; 
else 
  unicorn_rails -c config/unicorn.rb -E production -D; 
fi
#unicorn_rails -c config/unicorn.rb -E production -D;
