# PHP Dockerizer

This project is intended to help php developers to dockerize their projects. The difference of this project from 
others similar is simplicity: you run single bash command and get power of make commands with set of docker-compose
files for different purposes. After installing php-dockerizer into your project you can commit only files you want
to keep.

## Usage

Usage of the dockerizer is pretty simple: you run online install command, it fetches changes from install repository to your project and you can commit files you want to keep.
Keep in mind that dockerizer will copy the list of the files and directories to the root of your project:
```text
Makefile
.make
```
* In future dockerizer will be able to detect if there is any file conflicts with your existing files, or 

### Requirements

To use dockerizer you need to install [make](https://www.gnu.org/software/make/) and [docker-compose](https://docs.docker.com/compose/install/).

### Installation

To install php-dockerizer simply run command:
```shell
curl -s https://raw.githubusercontent.com/OleksiiBulba/php-dockerizer/master/bin/onelinesetup | bash -s -- https://github.com/OleksiiBulba/php-dockerizer origin/master dockerizer
```

If you cloned repository to your github account, you can install php-dockerizer by a command:
```shell
curl -s https://raw.githubusercontent.com/{you-github-username}/php-dockerizer/master/bin/onelinesetup | bash -s -- https://github.com/{you-github-username}/php-dockerizer origin/master dockerizer
```

You can change `origin/master` to appropriate branch you want to use, and `dockerizer` to any directory name that does not exist in your repo, do not worry, it will be removed after installation.

## Contributing

Please feel free to open pull request or create an issue, they are more than welcome!

## License

[MIT](https://opensource.org/licenses/MIT)