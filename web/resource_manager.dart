part of wimmel;

/**
 * Resource manger
 * supervises ressource loading and call a specific function after all resources have been loaded successfully
 */
class ResourceManager {
  var loading = 0;
  var notify = false;
  var notifyFunction;
  
  /**
   * Register new resource to be loaded
   */
  void registerLoading() {
    loading++;
  }
  
  /**
   * Register finished loading process
   */
  void registerFinished() {
    loading--;
    checkNotify();
  }
  
  /**
   * Register function to be called when all resources have been loaded
   */
  void registerNotifyFunction(fkt) {
    notifyFunction = fkt;
    notify = true;
    checkNotify();
  }
  
  /**
   * check if all resources have been loaded
   */
  void checkNotify() {
    if (loading < 1 && notify == true) notifyFunction();
  }
}