#!/usr/bin/env bash

if [ -z "$HTTP_PROXY" ]; then
        unset HTTP_PROXY
        unset HTTPS_PROXY_REQUEST_FULLURI
        unset HTTP_PROXY_REQUEST_FULLURI
        unset http_proxy
fi

cd /var/www/html

sudo apk update --no-cache && sudo apk add --no-cache git zip vim curl util-linux

echo 'alias ll="ls -alF"' >> ~/.bashrc
echo 'alias la="ls -A"' >> ~/.bashrc
echo 'alias l="ls -CF"' >> ~/.bashrc
echo 'bak() { cp "$1"{,.bak};}' >> ~/.bashrc
echo 'mcd() { mkdir -p "$1"; cd "$1";}' >> ~/.bashrc

drupal_projects=(
	webform
	admin_toolbar
	google_analytics
	config_split
	devel
	ds
	fontawesome
	linkit
	field_group
	paragraphs
	inline_entity_form
	fontawesome_menu_icons
	search_api
	search_api_solr
	facets
	metatag
	pathauto
	token
	redirect
	robotstxt
	simple_sitemap
	sharethis
	recaptcha
	better_exposed_filters
	views_infinite_scroll
	emulsify
	bootstrap
)

composer create-project drupal-composer/drupal-project:8.x-dev . --no-interaction --prefer-dist

if [ "${DRUPAL_VER}" != "latest" ]; then
	composer create-project drupal-composer/drupal-project:8.x-dev . --no-interaction --prefer-dist --no-install
	sed -E -i 's#"drupal\/core":.+?8\..+?",?#"drupal/core": "'"${DRUPAL_VER}"'",#' composer.json
	composer install --prefer-dist
else
	composer create-project drupal-composer/drupal-project:8.x-dev . --no-interaction --prefer-dist
fi

for project in "${drupal_projects[@]}"; do
	composer require drupal/$project
done

composer require drush/drush

git config --global user.name "splitant"
git config --global user.email "axel.depret.pro@gmail.com"

drush si standard --db-url=${DB_DRIVER}://root:${DB_ROOT_PASSWORD}@${DB_HOST}/${DB_NAME} -y
drush upwd admin admin


