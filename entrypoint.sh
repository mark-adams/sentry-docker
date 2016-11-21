#!/bin/bash
set -e

if [ -n "$PG_SENTRY_HOST" ]; then
    export SENTRY_POSTGRES_HOST="$PG_SENTRY_HOST"
    export SENTRY_POSTGRES_PORT="$PG_SENTRY_PORT"
    export SENTRY_DB_NAME="$PG_SENTRY_SCHEMA"
    export SENTRY_DB_USER="$PG_SENTRY_ROLE"
    export SENTRY_DB_PASSWORD="$PG_SENTRY_PASSWORD"
fi

if [ -n "$REDIS_SENTRY_HOST" ]; then
    export SENTRY_REDIS_HOST="$REDIS_SENTRY_HOST"
    export SENTRY_REDIS_PORT="$REDIS_SENTRY_PORT"
fi

if [ "$AUTOMIGRATE" = "1" ]; then
    sentry upgrade --noinput
fi

if [[ -n "$ADMIN_EMAIL" && -n "$ADMIN_PASSWORD" ]]; then
    set +e
    sentry createuser --no-input --email "$ADMIN_EMAIL" --password "$ADMIN_PASSWORD" --superuser
    set -e
fi

exec "$@"
