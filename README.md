# PHP (GitLab CI)

Minimal PHP images with the following PHP extensions installed:

- `bcmath`
- `gd`
- `intl`
- `mcrypt`
- `pcntl`
- `pcov`
- `pdo`
- `pdo_mysql`
- `soap`
- `sockets`
- `zip`

The images also comes bundled with [Composer](https://getcomposer.org/) (including [`hirak/prestissimo`](https://github.com/hirak/prestissimo)), and are intended (but not limited) to be used with GitLab CI.

## Versions

All stable versions are based on [the official alpine images](https://hub.docker.com/_/php/), while the development versions are based on [phpdaily/php](https://hub.docker.com/r/phpdaily/php).

The following versions are currently available:

- `5.5`
- `5.6`
- `7.0`
- `7.1`
- `7.1-dev`
- `7.2`
- `7.2-dev`
- `7.3`
- `7.3-dev`
- `7.4-dev`
- `8.0-dev`

### Caveats

- `7.0` and earlier, as well as `8.0-dev`, does not come with `pcov` installed.
- `7.2` and later does not come with `mcrypt` installed.
