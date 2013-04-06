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


