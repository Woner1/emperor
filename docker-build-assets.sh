set -euo
IFS=$'\n\t'

echo "Building asset for $APP_ENV"

echo "Waiting for consul-template to refresh config files"
RAILS_ENV=production bundle exec rake assets:precompile
