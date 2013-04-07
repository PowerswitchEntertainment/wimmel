/*   This file is part of wimmel.
 *
 *   Wimmel is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Wimmel is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with wimmel.  If not, see <http://www.gnu.org/licenses/>.
 */

part of wimmel;

/**
 * Tile of the background image
 * The background image is tiled to prevent timeouts and memory overload and to save render time  
 */
class Object {
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
  Object(manager, prefix, part) {
    this.manager = manager;
    
    image.onLoad.listen(onload);
    image.onError.listen(onerror);
    manager.registerLoading();
    image.src = "${prefix}/${part}.png";
  }
}

