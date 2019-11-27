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

composer create-project drupal-composer/drupal-project:8.x-dev . --no-interaction

if [ "${DRUPAL_VER}" != "latest" ]; then
	sed -E -i 's#"drupal\/core":.+?8\..+?",?#"drupal/core": "'"${DRUPAL_VER}"'",#' composer.json
fi

composer install

for project in "${drupal_projects[@]}"; do
	composer require drupal/$project
done

composer require drush/drush


