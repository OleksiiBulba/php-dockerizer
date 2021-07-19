# PHP Dockerizer

This project is intended to help php developers to dockerize their projects. The difference of this project from 
others similar is simplicity: you run single bash command and get power of make commands with set of docker-compose
files for different purposes. After installing php-dockerizer into your project, you can configure and commit only files you want
to keep.

## Usage

Usage of the dockerizer is pretty simple: you run online install command, it fetches source code from a repository to your project, and you can commit files you want to keep.
Dockerizer will keep all own files in .dockerizer folder, also it will add include directive:
```text
include ./.dockerizer/dockerizer.mk
```
into your Makefile, if it does not exist, it will be created. 

### Requirements

To use dockerizer you need to install [make](https://www.gnu.org/software/make/) and [docker-compose](https://docs.docker.com/compose/install/).

Before installation, you should have already in your project:
* _vendor_, _public_ and _src_ folders (for php packages, index.php file and source files respectfully) -- it is required because dockerizer mounts these folders into containers;
* _composer.json_ and _composer.lock_ files (it ensures the project has been set up correctly);

### Installation

To install php-dockerizer into your project simply run command from its root:
```shell
curl -s https://raw.githubusercontent.com/OleksiiBulba/php-dockerizer/master/bin/onlinesetup | bash -s -- https://github.com/OleksiiBulba/php-dockerizer master
```
The structure of the command above:
```shell
curl -s <onlinesetup-source-file> | bash -s -- <repository> <branch> <relative-or-absolute-path-to-project-root>
```
It allows you clone dockerizer repository, make changes and install it from your repository:
```shell
curl -s https://raw.githubusercontent.com/{you-github-username}/php-dockerizer/master/bin/onelinesetup | bash -s -- https://github.com/{you-github-username}/php-dockerizer master
```

You can change `master` to appropriate branch you want to use and `dockerizer` to any directory name that does not exist in your repo; do not worry, the directory will be removed after installation.
Keep in mind that you do not need to specify origin name before branch name!

## Contributing

Please feel free to open pull request or create an issue, they are more than welcome!

### Running tests

If you cloned the repo, you can run command `./tests/run-test-install.sh` to test installation process.
Command `./tests/clean-test-install.sh` will uninstall dockerizer files from _tests/install_ folder.

## License

[MIT](https://opensource.org/licenses/MIT)