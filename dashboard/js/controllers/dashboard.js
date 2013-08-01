define(['app'], function(app) {
  app.controller('DashboardCtrl', ['$scope', 'connector',
    function DashboardCtrl($scope, connector) {
      $scope.servers = connector.getServers(function (sites) {
        $scope.sites = sites;
        $scope.$apply();
      });
    }
  ]);
});
