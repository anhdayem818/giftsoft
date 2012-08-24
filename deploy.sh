export RAILS_ENV=production
bundle exec rake db:migrate
if [ -f tmp/pids/unicorn.pid ];then 
  kill -USR2 `cat tmp/pids/unicorn.pid`; 
else 
  unicorn_rails -c config/unicorn.rb -E production -D; 
fi
