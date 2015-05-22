app.service('PopoverService', ['$ionicPopover', function ($ionicPopover) {
  var popoverService = this;

  /**
   * Create menu popover
   * @param {object} $scope Scope of controller
   */
  this.createPopovers = function ($scope) {
    $ionicPopover.fromTemplateUrl('html/_menu.html', {
      scope: $scope,
    }).then(function(popover) {
      popoverService.menu = popover;
    });

    return popoverService;
  };

  /**
   * Show a popover
   * @param {String} popoverName Name of popover
   * @param {Object} $event      Contains information from ng-click
   */
  this.showPopover = function (popoverName, $event) {
    if (popoverService[popoverName]) {
      popoverService[popoverName].show($event);
    }
  };

  /**
   * Hide a popover
   * @param {String} popoverName Name of popover
   */
  this.hidePopover = function (popoverName) {
    if (popoverService[popoverName]) {
      popoverService[popoverName].hide();
    }
  };
}]);
