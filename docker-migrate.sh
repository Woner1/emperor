export RAILS_ENV=${RAILS_ENV:-"production"}
echo "Running db migration..."
RAILS_ENV=production bundle exec rake db:migrate

