#!/bin/bash

branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "Current branch $branch will be used for test"
curl -s https://raw.githubusercontent.com/OleksiiBulba/php-dockerizer/master/bin/onlinesetup | bash -s -- https://github.com/OleksiiBulba/php-dockerizer origin/$branch dockerizer