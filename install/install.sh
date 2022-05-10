#!/bin/bash
set -o errexit

# https://marketplace.magento.com/customer/accessKeys/
USER=${1:-Public_key}
PASS=${2:-Private_key}

DOMAIN=${3:-magento.local:8080}
VERSION=${4:-2.4.4}
EDITION=${5:-community}

bash download.sh "${USER}" "${PASS}" "${VERSION}" "${EDITION}" 
bash setup.sh "${DOMAIN}"


# &&'s are used below otherwise onelinesetup script fails/errors after bin/download
# bin/download "${VERSION}" "${EDITION}" \
#   && bin/setup "${DOMAIN}"

# VERSION_ROOT=$(echo "$VERSION" | cut -b 1-5 | sed -e 's/\.//g')

# echo $USER
# echo $PASS

# echo "$VERSION_ROOT"
# echo "$VERSION"




