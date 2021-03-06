#!/bin/bash

DOMAIN=${1:-magento.local:8080}

# shellcheck source=../env/db.env
source ../env/db.env
# shellcheck source=../env/elasticsearch.env
source ../env/elasticsearch.env
# shellcheck source=../env/magento.env
source ../env/magento.env
# shellcheck source=../env/rabbitmq.env
source ../env/rabbitmq.env

cd ../ && docker-compose up -d

echo "Waiting for connection to RabbitMQ..."
docker-compose exec -T phpfpm timeout $RABBITMQ_HEALTHCHECK_TIMEOUT bash -c "
  until curl --silent --output /dev/null http://$RABBITMQ_DEFAULT_USER:$RABBITMQ_DEFAULT_PASS@$RABBITMQ_HOST:$RABBITMQ_MANAGEMENT_PORT/api/aliveness-test/%2F; do
      printf '.'
      sleep 2
  done"
  [ $? != 0 ] && echo "Failed to connect to RabbitMQ" && exit

docker-compose exec -T phpfpm bin/magento setup:install \
  --db-host="$MYSQL_HOST" \
  --db-name="$MYSQL_DATABASE" \
  --db-user="$MYSQL_USER" \
  --db-password="$MYSQL_PASSWORD" \
  --base-url=http://"$DOMAIN"/ \
  --backend-frontname="$MAGENTO_ADMIN_FRONTNAME" \
  --admin-firstname="$MAGENTO_ADMIN_FIRST_NAME" \
  --admin-lastname="$MAGENTO_ADMIN_LAST_NAME" \
  --admin-email="$MAGENTO_ADMIN_EMAIL" \
  --admin-user="$MAGENTO_ADMIN_USER" \
  --admin-password="$MAGENTO_ADMIN_PASSWORD" \
  --language="$MAGENTO_LOCALE" \
  --currency="$MAGENTO_CURRENCY" \
  --timezone="$MAGENTO_TIMEZONE" \
  --amqp-host="$RABBITMQ_HOST" \
  --amqp-port="$RABBITMQ_PORT" \
  --amqp-user="$RABBITMQ_DEFAULT_USER" \
  --amqp-password="$RABBITMQ_DEFAULT_PASS" \
  --amqp-virtualhost="$RABBITMQ_DEFAULT_VHOST" \
  --cache-backend=redis \
  --cache-backend-redis-server=redis \
  --cache-backend-redis-db=0 \
  --page-cache=redis \
  --page-cache-redis-server=redis \
  --page-cache-redis-db=1 \
  --session-save=redis \
  --session-save-redis-host=redis \
  --session-save-redis-log-level=4 \
  --session-save-redis-db=2 \
  --search-engine=elasticsearch7 \
  --elasticsearch-host=$ES_HOST \
  --elasticsearch-port=$ES_PORT \
  --use-rewrites=1 \
  --no-interaction

docker-compose exec -T phpfpm bin/magento setup:static-content:deploy -f

docker-compose exec -T phpfpm bin/magento indexer:reindex

docker-compose exec -T phpfpm bin/magento module:disable Magento_TwoFactorAuth

docker-compose exec -T phpfpm bin/magento cache:flush

docker-compose exec -T phpfpm bin/magento cron:install

docker-compose exec -T phpfpm bin/magento deploy:mode:set developer

echo "Docker development environment setup complete."
echo "You may now access your Magento instance at http://${DOMAIN}/"
echo "Admin Panel http://${DOMAIN}/admin"
