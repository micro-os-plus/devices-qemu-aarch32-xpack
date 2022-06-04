[![license](https://img.shields.io/github/license/micro-os-plus/devices-qemu-cortexa-xpack)](https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/blob/xpack/LICENSE)
[![CI on Push](https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/workflows/CI%20on%20Push/badge.svg)](https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/actions?query=workflow%3A%22CI+on+Push%22)
[![GitHub issues](https://img.shields.io/github/issues/micro-os-plus/devices-qemu-cortexa-xpack.svg)](https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/issues/)
[![GitHub pulls](https://img.shields.io/github/issues-pr/micro-os-plus/devices-qemu-cortexa-xpack.svg)](https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/pulls)

# Maintainer info

## Project repository

The project is hosted on GitHub:

- <https://github.com/micro-os-plus/devices-qemu-cortexa-xpack.git>

To clone the stable branch (`xpack`), run the following commands in a
terminal (on Windows use the _Git Bash_ console):

```sh
rm -rf ~/Work/device-qemu-cortexa-xpack.git && \
mkdir -p ~/Work && \
git clone \
  https://github.com/micro-os-plus/devices-qemu-cortexa-xpack.git \
  ~/Work/device-qemu-cortexa-xpack.git
```

For development purposes, clone the `xpack-develop` branch:

```sh
rm -rf ~/Work/device-qemu-cortexa-xpack.git && \
mkdir -p ~/Work && \
git clone \
  --branch xpack-develop \
  https://github.com/micro-os-plus/devices-qemu-cortexa-xpack.git \
  ~/Work/device-qemu-cortexa-xpack.git
```

## Prerequisites

A recent [xpm](https://xpack.github.io/xpm/), which is a portable
[Node.js](https://nodejs.org/) command line application.

## Code formatting

Code formatting is done using `clang-format --style=file`, either manually
from a script, or automatically from Visual Studio Code, or the Eclipse
CppStyle plug-in.

## Publish on the npmjs.com server

- select the `xpack-develop` branch
- commit all changes
- update versions in `README.md` and `README-MAINTAINER.md`
- update `CHANGELOG.md`
- commit with a message like _prepare v1.0.0_
- `npm pack` and check the content of the archive, which should list
  only `package.json`, `README.md`, `LICENSE`, `CHANGELOG.md`,
  the sources and CMake/meson files;
  possibly adjust `.npmignore`
- `npm version patch`, `npm version minor`, `npm version major`
- push the `xpack-develop` branch to GitHub
- the `postversion` npm script should also update tags via `git push origin --tags`
- wait for the CI job to complete
  (<https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/actions/workflows/CI.yml>)
- `npm publish --tag next` (use `npm publish --access public` when
  publishing for the first time)

The version is visible at:

- <https://www.npmjs.com/package/@micro-os-plus/devices-qemu-cortexa?activeTab=versions>

## Testing

The project includes unit tests.

To run them, run:

```sh
cd device-qemu-cortexa-xpack.git
xpm run install-all
xpm run test
```

## Continuous Integration

The CI tests are performed on GitHub Actions, as the
[CI on Push](https://github.com/micro-os-plus/devices-qemu-cortexa-xpack/actions?query=workflow%3A%22CI+on+Push%22)
workflow.

## Update the repo

When the package is considered stable:

- with Sourcetree
- merge `xpack-develop` into `xpack`
- push to GitHub
- select `xpack-develop`

## Tag the npm package as `latest`

When the release is considered stable, promote it as `latest`:

- `npm dist-tag ls @micro-os-plus/devices-qemu-cortexa`
- `npm dist-tag add @micro-os-plus/devices-qemu-cortexa@1.0.0 latest`
- `npm dist-tag ls @micro-os-plus/devices-qemu-cortexa`

## Share on Twitter

- in a separate browser windows, open [TweetDeck](https://tweetdeck.twitter.com/)
- using the `@micro_os_plus` account
- paste the release name like **µOS++ device-qemu-cortexa v1.0.0 released**
- paste the link to the Web page release
- click the **Tweet** button