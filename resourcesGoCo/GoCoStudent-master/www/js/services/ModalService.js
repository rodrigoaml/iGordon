app.service('ModalService', ['$ionicModal', '$q', function ($ionicModal, $q) {

  var modalService = this;

  /**
   * Create menu and banner modals
   * @param {object} $scope Scope of controller
   * @return {promise}      Promise fulfilled by object representing
   *                        ModalService, contains methods and modal objects.
   *                        Promise completes when all modals are created.
   */
  this.createModals = function ($scope) {

    var modals = ['banner', 'configuration'],
        modalObjects = [];

    // Create modals
    for (var i = 0; i < modals.length; i++) {
      var modalName = modals[i];
      modalObjects.push(makeModal(modalName, $scope));
    }

    // Return promise that waits for creation of all modals
    return $q.all(modalObjects).then(function () {
      return modalService;
    });
  };

  /**
   * Toggle visibility of modal
   * @param {String} modalName Name of modal
   */
  this.toggleModal = function (modalName) {
    if (modalService[modalName]) {
      if (modalService[modalName].isShown()) {
        modalService[modalName].hide();
      } else {
        modalService[modalName].show();
      }
    }
  };

  /**
   * Show a modal
   * @param {String} modalName Name of modal
   */
  this.showModal = function (modalName) {
    if (modalService[modalName]) {
      modalService[modalName].show();
    }
  };

  /**
   * Hide a modal
   * @param {String} modalName Name of modal
   */
  this.hideModal = function (modalName) {
    if (modalService[modalName]) {
      modalService[modalName].hide();
    }
  };

  /**
   * Make modal and add to modalService object
   * Uses $ionicModal internally
   * Expects html/_modalname.html to exist
   * @param {String} modalName Name of modal
   * @param {Object} $scope    $scope object to pass to modal
   * @return {promise}          Fulfilled by modal object
   */
  function makeModal(modalName, $scope) {
    return $ionicModal.fromTemplateUrl(
      'html/_' + modalName + '.html',
      { scope: $scope }
    ).then(function (modal) {
      modalService[modalName] = modal;
    });
  }
}]);
