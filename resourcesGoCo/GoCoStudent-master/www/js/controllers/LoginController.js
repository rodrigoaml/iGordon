app.controller('LoginController', ['$state', '$q', '$timeout', '$filter', 'StorageService', 'DataService', function ($state, $q, $timeout, $filter, StorageService, DataService) {

  var login = this,
      loginCheckTimeout = 7500,
      timeoutPromise = null;
  login.user = null;
  login.status = false;
  login.userCredentials = {
    "username": "",
    "password": ""
  };

  /* Process credentials, create user in database, redirect to next view */
  login.loginUser = function () {

    login.userCredentials.username = $filter('username')(login.userCredentials.username);
    StorageService.storeCredentials(login.userCredentials);

    // Create user in database
    DataService.get('createuser', StorageService.retrieveCredentials());

    checkLogin();
  };

  // Check if user login is valid or not
  function checkLogin() {

    login.status = 'status-loading';

    return DataService.get('checklogin',
      StorageService.retrieveCredentials(),
      loginCheckTimeout).
    success(function (response) {
      login.status = false;
      login.user = response.data;
      
      if (seenPrivacyPolicy(login.user)) {
        $state.go('home');
      } else {
        $state.go('privacyPolicy');
      }

    }).
    error(function (response, status) {
      if (status == 401) {
        login.status = 'status-invalid';
        login.userCredentials.password = '';
      } else {
        $state.go('home');
      }
    });
  }

  // Check whether user has seen privacy policy
  function seenPrivacyPolicy(user) {
    return user.hasOwnProperty('privacyPolicy');
  }
}]);
