part of wimmel;

class Json {
  var data;
  var manager;
  
  Json(manager, url) {
    this.manager = manager;
    var request = HttpRequest.getString(url).then(onDataLoaded);
    manager.registerLoading();
  }
  
  void onDataLoaded(String responseText) {
    data = parse(responseText);
    manager.registerFinished();
  }
}


