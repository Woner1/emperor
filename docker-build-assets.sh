set -euo pipefail
IFS=$'\n\t'

echo "Building asset for $APP_ENV"

echo "Waiting for consul-template to refresh config files"
echo "$CMD"
eval "$CMD"
RAILS_ENV=production DISABLE_RESQUE_SCHEDULE=true bundle exec rake assets:precompile
