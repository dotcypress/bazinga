_ = require 'lodash'
colors = require 'colors'
fs = require 'fs'
http = require 'http'
io = require 'socket.io'
path = require 'path'
program = require 'commander'
send = require 'send'
toml = require 'toml-js'
url = require 'url'

instances = []
dashboartRoot = path.resolve(__dirname, '../dashboard')
logger = (data) ->
  console.log data

run = () ->
  program
    .version('0.0.1')
    .usage('[options]')
    .option('-c, --config [file]', 'Set config [%USERPROFILE%/bazinga.toml]', path.join process.env['USERPROFILE'], 'bazinga.toml')
    .option('-p, --port [port]', 'Set dashbord port [7373]', 7373)
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
    config = toml.parse data
    restart config

    dashboard = http.createServer (req, res) ->
      send(req, url.parse(req.url).pathname).root(dashboartRoot).pipe(res)
    dashboard.listen program.port, '127.0.0.1'

    socket = io.listen dashboard, log: false
    socket.on 'connection', (socket) -> connectSocket socket, config

connectSocket = (socket) ->
  socket.on 'sites', (data, cb) ->
    cb _.pluck instances, 'name'

  logger = (data) ->
    socket.emit 'log', data

restart = (config) ->
  _.forEach instances, (instance) -> instance.close
  instances = []
  _.forOwn config.servers, (instanceConfig, key) ->
    app = http.createServer (req, res) ->

      error = (err) ->
        res.statusCode = err.status or 500
        logger {key: key, kind: 'ERROR', url: req.url, code: res.statusCode}
        res.end err.message

      redirect = () ->
        res.statusCode = 301
        res.setHeader 'Location', "#{req.url}/"
        logger {key: key, kind: 'REDIRECT', url: "#{req.url}/", code: res.statusCode}
        res.end 'Redirecting to #{req.url}/'

      logger {key: key, kind: 'REQUEST', url: req.url, code: res.statusCode}
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
