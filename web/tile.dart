part of wimmel;

class Tile {
  var image = new ImageElement();
  var manager;
  var error=true;
  
  void onload(ev) {
    manager.registerFinished();
    error=false;
  }
  
  void onerror(ev) {
    // TODO: create error message
    manager.registerFinished();
  }
  
  Tile(manager, prefix, part) {
    this.manager = manager;
    
    image.onLoad.listen(onload);
    image.onError.listen(onerror);
    manager.registerLoading();
    image.src = "${prefix}/${part}.png";
  }
}

