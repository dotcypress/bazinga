# Bazinga [![Build Status](https://secure.travis-ci.org/dotCypress/bazinga.png?branch=master)](https://travis-ci.org/dotCypress/bazinga)

Bazinga is awesome static web server, that's all ;)

## Installation

    $ npm install bazinga

## Usage

    Usage: bazinga [options]

    Options:

    -h, --help           output usage information
    -V, --version        output the version number
    -c, --config [file]  Set config [%USERPROFILE%/bazinga.toml]
    -p, --port [port]    Set dashbord port [7373]

## Sample config
```
[servers]

[servers.desktop]
directory = "/work/sites/site1/"
port = 8081

[servers.client]
directory = "/work/sites/site2/"
host = "localhost"
port = 8082

[servers.mobile]
directory = "/work/sites/site3/"
port = 8083
```
