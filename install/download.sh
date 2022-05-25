#!/bin/bash

USER=${1:-Public_key}
PASS=${2:-Private_key}

VERSION=${3:-2.4.4}
EDITION=${4:-community}

exec composer create-project --repository-url=https://repo.magento.com/ magento/project-"${EDITION}"-edition="${VERSION}" ../src/
