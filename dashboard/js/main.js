require.config({
  paths: {
    app: 'js/app',
    angular: 'js/vendor/angular.min',
    lodash: 'js/vendor/lodash',
    jquery: 'js/vendor/jquery.min',
    bootstrap: 'js/vendor/bootstrap.min',
    socketio: "js/vendor/socket.io.min"
  },
  shim: {
    'angular': {
      exports: 'angular'
    },
    "bootstrap": ["jquery"],
  },
  baseUrl: '/'
});

(function() {
  require([
    'app',
    'jquery',
    'bootstrap',
    'angular',
    'socketio',

    // services
    'js/services/connector.js',

    // controllers
    'js/controllers/dashboard.js',
    'js/controllers/about.js'
  ], function() {
    angular.bootstrap(document, ['app']);
  });
})();
