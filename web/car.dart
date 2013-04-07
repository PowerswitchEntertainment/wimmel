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
 * car class
 */
class Car {
  var segment;
  var point;
  var pos = new Point(0,0);
  var goal = new Point(0,0);
  
  /**
   * Constructor
   */
  Car() {
    segment = "A1";
    point = 0;
  }
  
  int update(delta) {
    var d = goal - pos;
    if (goal.squaredDistanceTo(pos) > delta*delta) {
      var n = d * (1/goal.distanceTo(pos));
      pos += n * delta;
      return 0;
    } else {
      return 1;
    }
  }
  
  double degrees() {
    var n = (goal - pos) * (1/goal.distanceTo(pos));
    var d = 0;
    if (n.y < 0)
    {
      d = asin(n.x)+PI;
    } else {
      d = -asin(n.x);
    }
    d -= rotation()*PI/4;
    return d;
  }
  
  int rotation() {
    var n = (goal - pos) * (1/goal.distanceTo(pos));
    
    if (n.y < 0) {
      if (n.x < -0.9239) {
        return 2;
      } else if (n.x < -0.3827) {
        return 3;
      } else if (n.x < 0.3827) {
        return 4;
      } else if (n.x < 0.9239) {
        return 5;
      } else {
        return 6;
      }
    } else {
      if (n.x < -0.9239) {
        return 2;
      } else if (n.x < -0.3827) {
        return 1;
      } else if (n.x < 0.3827) {
        return 0;
      } else if (n.x < 0.9239) {
        return 7;
      } else {
        return 6;
      }
    }

    return 0; // TODO: do not turn at all
  }
  
}



