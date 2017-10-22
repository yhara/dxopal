# How to start developing DXOpal

## Prerequisites

- Ruby (tested with 2.3.3)
- Node.js (to minify .js)

## Setup

```
$ git clone https://github.com/yhara/dxopal
$ cd dxopal
$ bundle install
$ npm install uglify-es -g
```

Developing dxopal-starter-kit:

```
$ cd dxopal  # Must be cloned into here
$ git clone https://github.com/yhara/dxopal-starter-kit
```

## Build .js

    $ rake build
    $ rake build_min  # Build and minify

## Documents

Build API reference:

    $ rake api

## Directory structure

- build/
  - dxopal.js
  - dxopal.min.js
- doc/
  - api/
  - en/
  - ja/
- examples/
- exe/
  - dxopal
- opal/ : Source code
  - dxopal.rb
  - dxopal/
- template/ : Template files for `dxopal init` command
  - index.html
  - main.rb
- vendor/
  - matter.js
  - pages-themes-dinky-14e8031/
