#!/bin/bash

branch=$(git branch --show-current)
echo "Current branch $branch will be used for test"
curl -s https://raw.githubusercontent.com/OleksiiBulba/php-dockerizer/$branch/bin/onlinesetup | bash -s -- https://github.com/OleksiiBulba/php-dockerizer origin-install/$branch
