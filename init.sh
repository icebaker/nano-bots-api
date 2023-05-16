export $(grep -v '^#' .env | xargs)

if [ $ENVIRONMENT = 'development' ]; then
  bundle exec rerun -- rackup --server puma -o 0.0.0.0 -p $PORT
else
  bundle exec rackup --server puma -o 0.0.0.0 -p $PORT --env production
fi
