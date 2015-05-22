var app = angular.module('gocostudent', ['ionic', 'ngMessages']);

app.run(['$ionicPlatform', 'StorageService', 'AppVersion', function($ionicPlatform, StorageService, AppVersion) {
  $ionicPlatform.ready(function() {

    var storedAppVersion = StorageService.get('version'),
        analyticsID;

    // Reset stored data and force user to re-login if app is updated
    if (storedAppVersion != AppVersion) {
      StorageService.eraseCredentials();
      StorageService.delete('modules');
    }

    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }

    if (ionic.Platform.isIOS()) {
      analyticsId = "UA-60428326-3";
    } else {
      analyticsId = "UA-60428326-2";
    }

    if (window.analytics) {
      window.analytics.startTrackerWithId(analyticsID);
    }
  });
}]).

config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
  $stateProvider
    .state('login', {
      url: '/login',
      templateUrl: 'html/login.html',
      controller: 'LoginController as login'
    })
    .state('privacyPolicy', {
      url: '/privacypolicy',
      templateUrl: 'html/privacypolicy.html',
      controller: 'PrivacyPolicyController as privacyPolicy'
    })
    .state('home', {
      url: '/',
      templateUrl: 'html/home.html',
      controller: 'HomeController as home'
    });

  $urlRouterProvider.otherwise('/');
}]);
