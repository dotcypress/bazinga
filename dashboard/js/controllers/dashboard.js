define(['app'], function(app) {
  app.controller('DashboardCtrl', ['$scope', '$routeParams', '$location', 'connector',
    function DashboardCtrl($scope, $routeParams, $location, connector) {
      $scope.site = $routeParams.site;
      $scope.servers = connector.getServers(function (sites) {
        $scope.sites = sites;
        if($scope.site =='' && sites.length > 0){
          $location.path('site/' + sites[0]);
        }
        return  $scope.$apply();;
      });
      $scope.logs=[];
      connector.subscribe(function (data) {
        if(data.key !== $scope.site){
          return;
        }
        $scope.logs.push(data);
        $scope.$apply();
      });
    }
  ]);
});
