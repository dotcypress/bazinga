_ = require 'lodash'
fs = require 'fs'
http = require 'http'
path = require 'path'
program = require 'commander'
send = require 'send'
toml = require 'toml-js'
url = require 'url'
colors = require 'colors'

instances = []

run = () ->
  program
    .version('0.0.0')
    .usage('[options]')
    .option('-c, --config [file]', 'Set config [%USERPROFILE%/bazinga.toml]', path.join process.env['USERPROFILE'], 'bazinga.toml')
    .parse process.argv

  colors.setTheme
    silly: 'rainbow',
    input: 'grey',
    verbose: 'cyan',
    prompt: 'grey',
    info: 'green',
    data: 'grey',
    help: 'cyan',
    warn: 'yellow',
    debug: 'blue',
    error: 'red'

  fs.readFile program.config, (err, data) ->
    return console.log err if err
    restart toml.parse data

restart = (config) ->
  _.forEach instances, (instance) -> instance.close
  instances = []
  _.forOwn config.servers, (instanceConfig, key) ->
    app = http.createServer (req, res) ->

      error = (err) ->
        res.statusCode = err.status or 500
        console.log "[#{key}] <ERROR> #{req.url} : #{res.statusCode}".error
        res.end err.message

      redirect = () ->
        res.statusCode = 301
        res.setHeader 'Location', "#{req.url}/"
        console.log "[#{key}] <REDIRECT> #{req.url} -> #{req.url}/".info
        res.end 'Redirecting to #{req.url}/'

      console.log "[#{key}] <REQUEST> #{req.url}".verbose
      path = url.parse(req.url).pathname
      send(req, path)
      .root(instanceConfig.directory)
      .on('error', error)
      .on('directory', redirect)
      .pipe(res)

    app.listen instanceConfig.port, instanceConfig.host
    app.name = key
    instances.push app

module.exports.run = run
