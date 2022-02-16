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
result1=$(docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa parallel-lint $src)
echo $result1
if [[ $result1=*"No syntax error found"* ]]
then
     err_cnt=0
else
     err_cnt=1
     echo "with error"
fi
echo -e "------\n"

echo "Phpstan analyzer result"
result2=$(docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa phpstan analyse $src)
echo $result2
if [[ $result2=*" [ERROR] Found "* ]]
then
     let err_cnt++
     echo "with error"
fi
echo -e "------\n"

echo "Phpcs analyzer result"
result3=$(docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa phpcs  $src)
echo $result3
if [[ $result3=*"ERROR AFFECTING"* ]]
then
     let err_cnt++
     echo "with error"
fi

echo -e "------\n"

echo "Local-php-security-checker analyzer result"
result5=$(docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa local-php-security-checker  $src)
echo $result5
if [[ $result5=*"composer.lock is not a valid lock file"* ]]
then
     let err_cnt++
     echo "with error"
fi
echo -e "------\n"

echo "Phpcpd analyzer result"
result4=$(docker run --init -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa phpcpd  $src)
echo $result4
if [[ !  $result4=*"No clones found."* ]]
then
     let err_cnt++
     echo "with error"
fi


echo -e "------\n"

echo "total Errors " $err_cnt " out of five"
