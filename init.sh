export $(grep -v '^#' .env | xargs)

command="bundle exec rackup --server puma -o 0.0.0.0 -p $PORT"

if [ "$RERUN" = 'true' ]; then
    command="bundle exec rerun -- $command"
fi

if [ "$ENVIRONMENT" != 'development' ]; then
    command="$command --env production"
fi

if [ "$RUN_DANGEROUSLY_AS_SUDO" = 'true' ]; then
    echo "**********************"
    echo "WARNING: You are running as sudo and this can be dangerous!"
    echo "**********************"
    if [ "$RVM" = 'true' ]; then
        command="rvmsudo $command"
    else
        command="sudo $command"
    fi
fi
echo ""
echo $command
echo ""
eval "$command"
