part of wimmel;

class RessourceManager {
  var loading = 0;
  var notify = false;
  var notifyFunction;
  
  void registerLoading() {
    loading++;
  }
  
  void registerFinished() {
    loading--;
    checkNotify();
  }
  
  void registerNotifyFunction(fkt) {
    notifyFunction = fkt;
    notify = true;
    checkNotify();
  }
  
  void checkNotify() {
    if (loading < 1 && notify == true) notifyFunction();
  }
}