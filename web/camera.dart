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

class Camera {
  var x = 0, y = 0;
  var width, height;
  var ax = 0, ay = 0;
  
  Camera(width, height) {
    this.width = width;
    this.height = height;
  }
  
  void update(delta) {
    if (ax.abs() > 1) {
      ax *= 0.9;
    } else {
      ax = 0;
    }
    if (ay.abs() > 1) {
      ay *= 0.9;
    } else {
      ay = 0;
    }
    x += ax * delta / 100;
    y += ay * delta / 100;
    borders();
  }
  
  void move(dx, dy) {
    x += dx;
    y += dy;
    
    ax = dx;
    ay = dy;
    borders();
  }
  
  void borders() {
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > width - window.innerWidth) x = width - window.innerWidth;
    if (y > height - window.innerHeight) y = width - window.innerHeight;
  }
}

