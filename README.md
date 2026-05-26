---
layout: default
title: Home
nav_order: 1
description: "Deprecated — see https://uithemer.github.io/sailfishos-uithemer/"
permalink: /
---

> **Deprecated documentation.** This site is no longer maintained. Please use the current docs: [UI Themer documentation](https://uithemer.github.io/sailfishos-uithemer/).

# Theme pack support for Sailfish OS

The script works by replacing default elements with custom ones and enables safe backup/restore. A GUI is available [here](https://uithemer.github.io/sailfishos-uithemer/).

[![GitHub license](https://img.shields.io/github/license/uithemer/themepacksupport-sailfishos.svg)](https://github.com/uithemer/themepacksupport-sailfishos/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/uithemer/themepacksupport-sailfishos.svg)](https://github.com/uithemer/themepacksupport-sailfishos/issues) [![GitHub releases](https://img.shields.io/github/release/uithemer/themepacksupport-sailfishos.svg)](https://github.com/uithemer/themepacksupport-sailfishos/releases/latest) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/fravaccaro)

## Features

- Icon theming.
- Icon overlay.
- Font theming.
- Sound theming.
- Change device pixel ratio.
- Change DPI for Alien Dalvik.
- Change icon size.
- Recovery tools.
- Auto-update icon theme.

## Create custom theme packs

Documentation on how to create theme packs available [here](docs/getstarted.md).

## Builds

Builds available on [OpenRepos](https://openrepos.net/content/fravaccaro/themepacksupport-sailfishos).

## Side notes

I chose this approach as no proper documentation on theming support in Sailfish OS has been found yet.

However, a rudimentary theme support may have been already built-in, since I found sailfish-default folders to have an index.theme package and dconf to have values for those themes. Further investigation is needed.

## Roadmap

Roadmap and features will be tracked on the [Trello dashboard](https://trello.com/b/yrXVjXbL).

## Credits

App icon inspired by [Freepik](http://www.freepik.com) from [www.flaticon.com](http://www.flaticon.com) is licensed by [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/).

## Contributors

* Engine design and bash scripting by fravaccaro.
* One-click restore service by Eugenio_g7.
* Fix for Android icons on the XA2 by Eugenio_g7.
