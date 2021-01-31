# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Planned
- Add bin directory to checkout during installation, so it will be possible to use shell scripts.

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