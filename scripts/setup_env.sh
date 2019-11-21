#!/bin/bash

attributes_names_env=('PROJECT_NAME' 'PROJECT_BASE_URL' 'DB_NAME' 'DB_USER' 'DB_PASSWORD' 'DB_ROOT_PASSWORD' 'DB_HOST' 'DB_DRIVER')

data_default_env=('drupal8_test' 'drupal8.test.localhost' 'drupal' 'drupal' 'drupal' 'drupal' 'mariadb' 'mysql')

echo -e "---------------------------------------"
echo -e "| Docker settings project (.env file) |"
echo -e "---------------------------------------\n"

for index in ${!attributes_names_env[*]}
do
	echo -n "${attributes_names_env[$index]} [${data_default_env[$index]}] ? "
	read data_input

	if [ -z "$data_input" ]
	then
		data_input=${data_default_env[$index]}
	fi
	
	sed -i -E "s/(${attributes_names_env[$index]}=).+$/\1$data_input/" ./../.env
done



