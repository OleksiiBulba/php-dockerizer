# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Planned
- Add bin directory to check out during installation, so it will be possible to use shell scripts.
- Add GitHub actions for installation tests;

### Changed
- Changed project file structure:
- Install script installs project into .dockerizer folder, all files are kept inside it;
- Only Makefile is changed (or created) outside that to include dockerizer commands;
- Updated nodejs and nvm versions;
- Small changes to Dockerfile: renamed xdebug php extension ini file;
- Changed site root env variable for Nginx in docker-compose.base.yaml file;
- Only .env and .env.local files are created; User should create .env.{ENV} and .env.{ENV}.local files by himself;
- Nginx paths reconfigured;
- Removed port 9003 from docker-compose.dev.yaml;
- Install test refactored;
- Bumped php, nginx and mysql versions;
  Misc:
- Turned on nginx directive `merge_slashes`;

### Fixed
- Small code adjustment;
- Fixed issue-10 when installing dockerizer

## [0.2.0] - 2021-07-19

### Added
- Added more configs *.ini and php-fpm;
  - php writes logs to _/var/www/html/var/log/$pool.access.log_ and _/var/www/html/var/log/$pool.error.log_
  - xdebug writes logs to _/var/www/html/var/xdebug_
- Added Dockerfile for php container;
- Added entrypoint script, .bashrc;
- Added `build` command that forces rebuilding containers in case Dockerfile for php container changed;
- Added `rebuild` command that stops containers, run `build` command and starts containers again;
- Added `run-test-install.sh` shell script, so everyone can run installation tests locally;
- Added some files inside _tests/install_ folder for testing purposes;
- Added docs/COMMANDS.md file with all available commands inside;
- Added crontab;

### Changed
- Changed `ENV` variable to `APP_ENV` so it is the same as env variable in Symfony;
- _docker-compose.*_ files moved to _.docker_ folder;
- Created nginx conf template instead different conf files;
- _.env.dist_ file moved to _.docker_ folder;
- If _.env_ does not exist, it is created from _.docker/.env.dist_ file;
- If _.env.local_, _.env.{APP_ENV}_, and _.env.{APP_ENV}.local_ do not exist, they are created as an empty files;
- `restart` command does not require running project anymore, if project is not running, it just starts it.
- `onlinesetup` script uses remote repository name `origin-install`;

### Fixed
- Fixed project paths inside docker-compose containers;

## [0.1.0] - 2021-01-31

### Added
- This _CHANGELOG.md_ file to keep track of all changes in the project.
- _.gitignore_ file to exclude files and folders from being committed, e.g. folder .idea.
- MIT _LICENSE.md_ file.
- _README.md_ with short project description, usage instructions with requirements and installation, contributing section and licence link.
- _onlinesetup_ file that can be used to install project via a network, this file accepts three useful arguments: repository from which to install dockerizer (helps to debug or install own modification), branch (again, helps to debug or install own modification) and install directory in case your project uses same name as default install folder.
- _Makefile_ file that includes other mk helper files from _.make_ directory.
- _.make/tools.mk_ files for bash constants, _.make/tools/colors.mk_ file for bash colors
- _.make/project.mk_ with targets for project managing:
  - **help** prints list of all available commands;
  - **run**, **stop**, **restart** - containers management;
  - **init** copies .env.dist file;
  - **ps**  shows running containers;
  - **logs** shows container logs;
  - **bash** enters to php container with bash;
- _.env.dist_ file as an example for _.env_ file
