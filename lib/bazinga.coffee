program = require 'commander'
path = require 'path'

run = () ->
  program
    .version('0.0.0')
    .usage('[options]')
    .option('-p, --port [port]', 'Set dashboard port [7373]', '7373')
    .option('-d, --database [directory]', 'Set database directory [%USERPROFILE%/bazinga]', path.join process.env['USERPROFILE'], 'bazinga')
    .parse process.argv

module.exports.run = run