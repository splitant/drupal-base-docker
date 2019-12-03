#!/bin/bash

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

if [ -z "$HTTP_PROXY" ]; then
	unset HTTP_PROXY
	unset HTTPS_PROXY_REQUEST_FULLURI
	unset HTTP_PROXY_REQUEST_FULLURI
	unset http_proxy
fi

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


