#!/usr/bin/env bash

setup_project () {

   if [ -z "$HTTP_PROXY" ]; then
      unset HTTP_PROXY
      unset HTTPS_PROXY_REQUEST_FULLURI
      unset HTTP_PROXY_REQUEST_FULLURI
      unset http_proxy
      unset HTTPS_PROXY
      unset https_proxy
   fi

   cd /var/www/html

   sudo -E bash <<-EOF
      apk update --no-cache && apk add --no-cache zip vim util-linux
      exit
EOF

   drupal_projects=(
        admin_toolbar
        adminimal_theme
        bootstrap
        config_split
        devel
        ds
        facets
        field_group
        fontawesome
        fontawesome_menu_icons
        google_analytics
        metatag
        paragraphs
        pathauto
        recaptcha
        redirect
        robotstxt
        search_api
        simple_sitemap
        token
        views_infinite_scroll
        webform
   )

   if [ "${DRUPAL_VER}" != "latest" ]; then
      composer -n create-project drupal/recommended-project:${DRUPAL_VER} --no-install ./
      composer require drupal/core-recommended:${DRUPAL_VER} drupal/core-dev:${DRUPAL_VER} --update-with-dependencies
   else
      composer create-project drupal/recommended-project ./ 
   fi

   composer install --prefer-dist

   for project in "${drupal_projects[@]}"; do
      composer require drupal/$project
   done

   composer require drush/drush

   git config --global user.name "splitant"
   git config --global user.email "axel.depret.pro@gmail.com"

   drush si standard --db-url=${DB_DRIVER}://root:${DB_ROOT_PASSWORD}@${DB_HOST}/${DB_NAME} -y 
   drush upwd admin admin
}
