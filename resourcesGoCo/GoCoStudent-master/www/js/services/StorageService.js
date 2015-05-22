app.service('StorageService', ['$window', '$sce', 'AppVersion', function ($window, $sce, AppVersion) {

  // String to prefix all keys in localStorage with
  var storagePrefix = "GoCoStudent.";

  /**
   * Store data in localStorage
   * @param  {String} key   Key to store
   * @param  {any}    value Value to store
   */
  this.store = function (key, value) {
    $window.localStorage[storagePrefix + key] = value;
  };

  /**
   * Get data from localStorage
   * @param  {String} key Key to get
   * @return {String}     Retrieved data or null if data is not in localStorage
   */
  this.get = function (key) {
    return $window.localStorage[storagePrefix + key] || null;
  };

  /**
   * Delete data from localStorage
   * @param  {String} key Key to delete
   */
  this.delete = function (key) {
    delete $window.localStorage[storagePrefix + key];
  };

  /**
   * Store user credentials in localStorage
   * @param {object} userCredentials Contains username and password
   */
  this.storeCredentials = function (userCredentials) {
    this.store('username', userCredentials.username);
    this.store('password', $window.btoa(userCredentials.password));
  };

  /**
   * Get user credentials from localStorage
   * @return {object}       Contains username and password
   */
  this.retrieveCredentials = function () {

    var username = this.get('username'),
        password = this.get('password');

    if (username && password) {
      return {
        "username": username,
        "password": password
      };
    } else {
      return false;
    }
  };

  /**
   * Erase user credentials from localStorage
   */
  this.eraseCredentials = function () {
    this.delete('username');
    this.delete('password');
  };

  /**
   * Store user-selected modules in localStorage
   * @param {array} allModules List of module objects, each contains name
   */
  this.storeModules = function (allModules) {
    this.store('version', AppVersion);
    this.store('modules', angular.toJson(allModules));
  };

  /**
   * Retrieve modules from localStorage
   * @return {array}    List of modules
   */
  this.retrieveModules = function () {

    var modules = this.get('modules');

    if (modules)
      return JSON.parse(modules);
    else
      return null;
  };

  /**
   * Retrieve date from localStorage
   * @param {String} key Key of stored date
   * @return {Date}      Retrieved Date
   */
  this.retrieveDate = function (key) {
    return Date.parse(this.get(key));
  };
}]);
