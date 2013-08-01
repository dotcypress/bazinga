define(['angular'], function() {
  function fakeNgModel(initValue){
    //Stolen from https://github.com/Luegg/angularjs-scroll-glue
    return {
      $setViewValue: function(value){
        this.$viewValue = value;
      },
      $viewValue: initValue
    };
  };
  var app = angular
    .module('app', [])
    .directive('scrollGlue', function(){
      return {
        priority: 1,
        require: ['?ngModel'],
        restrict: 'A',
        link: function(scope, $el, attrs, ctrls){
          var el = $el[0],
          ngModel = ctrls[0] || fakeNgModel(true);

          function scrollToBottom(){
            el.scrollTop = el.scrollHeight;
          }

          function shouldActivateAutoScroll(){
            return el.scrollTop + el.clientHeight == el.scrollHeight;
          }

          scope.$watch(function(){
            if(ngModel.$viewValue){
              scrollToBottom();
            }
          });

          $el.bind('scroll', function(){
            scope.$apply(ngModel.$setViewValue.bind(ngModel, shouldActivateAutoScroll()));
          });
        }
      };
    })
    .config(['$routeProvider', function($routeProvider) {
      $routeProvider
        .when('/site/:site', {
          templateUrl: 'views/dashboard.html',
          controller: 'DashboardCtrl'
        })
        .otherwise({
          redirectTo: '/site/'
        });
    }]);

  app.controller('MainCtrl', ['connector', function(){}]);
  return app;
});
