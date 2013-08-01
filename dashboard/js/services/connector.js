define(['app', 'lodash', 'socketio'], function(app, _, io) {
  app.factory('connector', function() {
    var Connector = function() {
      var self = this;
      var socket = io.connect();

      this.getServers = function(cb){
        socket.emit('sites', 0, cb);
      };

      this.subscribe = function(cb){
        socket.on('log', cb);
      }
    };
    return new Connector();
  });
});
