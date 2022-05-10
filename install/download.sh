#!/bin/bash

USER=${1:-Public_key}
PASS=${2:-Private_key}

VERSION=${3:-2.4.4}
EDITION=${4:-community}

exec composer create-project --repository-url=https://repo.magento.com/ magento/project-"${EDITION}"-edition="${VERSION}" ../src/
echo
echo "Composer authentication required (repo.magento.com public and private keys):"
read -r -p "    Username: " ${USER}
read -r -p "    Password: " ${PASS}
