part of wimmel;

/**
 * Tile of the background image
 * The background image is tiled to prevent timeouts and memory overload and to save render time  
 */
class Tile {
  var image = new ImageElement();
  var manager;
  var error=true;
  
  /**
   * Resource was successfully loaded
   */
  void onload(ev) {
    manager.registerFinished();
    error=false;
  }
  
  /**
   * Resource couldn't be loaded
   */
  void onerror(ev) {
    // TODO: create error message
    manager.registerFinished();
  }
  
  /**
   * Constructor
   * @param manager resource manager instance to be notified
   * @param prefix  tile prefix (folder)
   * @param part    tile part (number)
   */
  Tile(manager, prefix, part) {
    this.manager = manager;
    
    image.onLoad.listen(onload);
    image.onError.listen(onerror);
    manager.registerLoading();
    image.src = "${prefix}/${part}.png";
  }
}

