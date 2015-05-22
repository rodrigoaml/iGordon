app.controller('HomeController', ['$rootScope', '$scope', '$state', '$window', '$filter', '$ionicScrollDelegate', 'Modules', 'DataService', 'ModalService', 'ModuleService', 'PopoverService', 'PopupService', 'StorageService', 'ApiUrl', 'AppInfoRefreshTime', 'AppVersion', function ($rootScope, $scope, $state, $window, $filter, $ionicScrollDelegate, Modules, DataService, ModalService, ModuleService, PopoverService, PopupService, StorageService, ApiUrl, AppInfoRefreshTime, AppVersion) {

  var home = this;
  StorageService.store('lastAppInfoRefresh', new Date(0));

  // Disable scroll dynamically
  document.addEventListener("dragstart", function( event ) {
    $ionicScrollDelegate.freezeAllScrolls(!home.scrollEnabled);
  }, false);

  // Refresh app info including banner
  home.refreshAppInfo = function () {
    var request = DataService.refreshAppInfo();

    // If request is a promise
    if (request !== false) {
      request.then(function (appInfo) {
        home.appInfo = appInfo;

        // Set banner if it exists
        if (home.appInfo.banner.title){
          home.hasBanner = true;
          $scope.banner = home.appInfo.banner;
        }
      });
    }
  };

  // Instantiate/reset scope variables
  home.resetScope = function () {

    home.loading = {};
    home.errorMessage = {};
    home.mealPoints = null;
    home.chapelCredits = {};
    home.userCredentials = StorageService.retrieveCredentials();
    home.hasBanner = false;
    home.scrollEnabled = false;

    // Retrieved stored modules or null if no stored modules
    $scope.modules = StorageService.retrieveModules();

    if (home.userCredentials) {

      var storedAppVersion = StorageService.get('version');
      if (storedAppVersion != AppVersion || !$scope.modules) {
        $scope.modules = Modules;
        $scope.modal.showModal('configuration');
        if (!$scope.modules) $scope.popup.showPopup('configuration');
      }
      $scope.updateModules();

    } else {
      $state.go('login');
    }
  };

  // Reset scope variables and log user out
  $scope.logout = function () {
    home.resetScope();
    PopoverService.hidePopover('menu');
    StorageService.eraseCredentials();
    $state.go('login');
  };

  // Update selected modules
  $scope.updateModules = function () {
    $scope.selectedModules = ModuleService.getSelectedModules($scope.modules);
    home.moduleClass = ModuleService.makeModuleClass($scope.selectedModules.length);
    home.scrollEnabled = $scope.selectedModules.length > 5;
    StorageService.storeModules($scope.modules);
  };

  // Handle reordering of modules in configuration modal
  $scope.reorderModule = function(item, fromIndex, toIndex) {
    $scope.modules.splice(fromIndex, 1);
    $scope.modules.splice(toIndex, 0, item);
    $scope.updateModules();
  };

  // Initialize popover and popup services
  $scope.popover = PopoverService.createPopovers($scope);
  $scope.popup = PopupService;

  // Wait for modals to be created before initializing controller
  ModalService.createModals($scope).then(function (modalService) {
    $scope.modal = modalService;
    home.refreshAppInfo();
    home.resetScope();
  });
}]);
