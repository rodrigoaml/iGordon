app.controller('PrivacyPolicyController', ['$state', 'DataService', 'StorageService', 'PopupService', function ($state, DataService, StorageService, PopupService) {

  var privacyPolicy = this;
  privacyPolicy.status = 'checking';
  privacyPolicy.user = {};
  privacyPolicy.timeout = false;
  userCredentials = StorageService.retrieveCredentials();

  // Continue from privacy policy to home
  privacyPolicy.go = function (accepted) {

    // Accept privacy policy
    if (accepted) {
      DataService.setProperty(userCredentials, 'privacyPolicy', 'accepted');
      $state.go('home');

    // Deny privacy policy
    } else {
      PopupService.showPopup('confirmOptOut')
      .then(function (result) {
        if (result) {
          DataService.setProperty(userCredentials, 'privacyPolicy', 'denied');
          $state.go('home');
        }
      });
    }
  };
}]);
