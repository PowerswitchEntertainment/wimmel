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