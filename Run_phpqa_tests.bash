#!/bin/bash

#parameters
#Project path to be mounted to the phpqa container
proj_path=$1

#Source path/file that will be checked by the container
src=$2

#Check if project and source path/file is existing and valid
#Exit if invalid
echo $proj_path/$src
if [ ! -d $proj_path/$src ] && [ ! -f $proj_path/$src ]
	then 
		echo "Project path or Source Path/File does not exist"
		exit 1
fi

#Execute test
cd $proj_path
echo "Parallel-lint analyzer result"
docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa parallel-lint  $src
echo -e "------\n"

echo "Phpstan analyzer result"
docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa phpstan analyse $src
echo -e "------\n"

echo "Phpcs analyzer result"
docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa phpcs  $src
echo -e "------\n"

echo "Local-php-security-checker analyzer result"
docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa local-php-security-checker  $src
echo -e "------\n"

echo "Phpcpd analyzer result"
docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa phpcpd  $src
echo -e "------\n"