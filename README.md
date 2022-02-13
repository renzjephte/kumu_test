#kumu_test
# Bash script for Running phpqa analyzers

Bash scripts that executes multiple php analyzers using the phpqa docker image. The script executes a docker run command that mounts the provided first script parameter to the container. The second parameter is the src which will be check by the phpqa container. 

**Docker Image used**
(https://hub.docker.com/r/jakzal/phpqa/)

**Analyzers triggered**
 - Parallel lint 
 - Phpstan 
 - Phpcs 
 - Local-php-security-checker 
 - Phpcpd

**Input**
Script expects two parameters. First parameter is the project path which will be mounted on the container. Second parameter is the source path/file which will be tested by the container. Inputs are validated by concatenating the two parameters and checking if the file/path exits. 

**Output**
The container will display the results of the analyzers.

Example with php src file

    ./Run_phpqa_tests.sh /home/centos/blog/ server.php

Example with folder for source path

    ./Run_phpqa_tests.sh /home/centos/ blog
