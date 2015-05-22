app.service('ModuleService', ['Modules', function (Modules) {

  /**
   * Get selected modules from list of all modules
   * @param {array} allModules List of all modules
   * @return {array}           List of selected modules
   */
  this.getSelectedModules = function (allModules) {
    return allModules.filter(function (module) {
      return module.selected === true;
    });
  };

  /**
   * Make class for modules
   * @param {number} numModules Number of total modules selected
   * @return {String}           Class for modules determining their size
   */
  this.makeModuleClass = function (numModules) {
    if (numModules > 5) return "list-item";
    else if (numModules == 5) return "one-fifth";
    else if (numModules == 4) return "one-fourth";
    else if (numModules == 3) return "one-third";
    else if (numModules == 2) return "one-half";
    else return "";
  };
}]);
