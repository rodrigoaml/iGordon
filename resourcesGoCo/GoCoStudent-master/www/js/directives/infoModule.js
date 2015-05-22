app.directive('infoModule', function () {
  return {
    restrict: 'E',
    scope: {
      infoType: '=',
      infoLabel: '=',
      iconClass: '=',
      colorClass: '=',
      infoPrefix: '=',
      infoSuffix: '=',
      fontSize: '=',
      loadCallback: '&'
    },
    templateUrl: 'html/directives/_infomodule.html',
    controllerAs: 'module',
    controller: ['$scope', '$filter', 'DataService', 'StorageService', 'Modules', 'RequestTimeout', function ($scope, $filter, DataService, StorageService, Modules, RequestTimeout) {

      var module = this;
      module.dataType = $scope.infoType;
      module.prefix = $scope.infoPrefix;
      module.suffix = $scope.infoSuffix;
      module.label = $scope.infoLabel;
      module.fullClass = $scope.colorClass;
      module.iconClass = $scope.iconClass;
      module.userCredentials = StorageService.retrieveCredentials();

      if ($scope.fontSize) module.fullClass += ' ' + $scope.fontSize;

      module.load = function () {

        // Do not try to get data if already loading
        if (!module.loading) {

          module.loading = true;
          module.errorMessage = null;
          var startTime = new Date().getTime();

          // Get data from server
          DataService.get(module.dataType, module.userCredentials).
          success(function(response) {

            // Make sure data displays even if value is falsy
            module.data = response.data.toString();

            // Get "out of" amount if provided
            if (response.outof) module.outOf = response.outof;
          }).
          error(function(response, status) {

            var respTime = new Date().getTime() - startTime;

            // Make error message
            if (response.data) {
              module.errorMessage = response.data;
            } else if (respTime >= RequestTimeout.default){
              module.errorMessage = ErrorMessages.timeout;
            } else {
              module.errorMessage = ErrorMessages.unknown;
            }
          }).
          finally(function() {
            module.loading = false;
            $scope.loadCallback();
          });
        }
      };
    }]
  };
});
