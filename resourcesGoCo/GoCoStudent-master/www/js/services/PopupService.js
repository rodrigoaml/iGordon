app.service('PopupService', ['$ionicPopup', function ($ionicPopup) {
  var popupService = this;

  /**
   * Show a popup
   * @param {String} popupName Name of popup
   * @param {Object} $event      Contains information from ng-click
   */
  this.showPopup = function (popupName, $event) {

    var popupConfig = {
      configuration: {
        type: 'alert',
        title: 'Configuration',
        templateUrl: 'html/_configurationpopup.html',
        buttons: [{
          text: "I'm ready",
          type: 'button-animated'
        }]
      },
      confirmOptOut: {
        type: 'confirm',
        title: 'Are you sure you want to opt out?',
        cancelText: 'No',
        cancelType: 'button-positive',
        okText: 'Yes',
        okType: 'button-stable'
      }
    };

    var selectedPopup = popupConfig[popupName];

    if (selectedPopup) {
      return $ionicPopup[selectedPopup.type](popupConfig[popupName]);
    }
  };
}]);
