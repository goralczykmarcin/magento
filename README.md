# Magento local

## Instalacja
**Przed rozpoczęciem trzeba stworzyć klucze dostępu**
Instrukcja: [connection authentications](https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html)
Link działający po zalogowaniu: [access keys page](https://marketplace.magento.com/customer/accessKeys/)

**Po sklonowaniu repo odpalamy skrypt**
 `cd install/ && ./install.sh [Public_key] [Private_key]`

**Dodanie localhosta dla instancji sklepu**
`sudo nano /etc/hosts`
host: magento.local
