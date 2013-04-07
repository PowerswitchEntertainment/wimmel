/*
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

library wimmel;

import 'dart:html';
import 'dart:core';
import 'dart:async';
import 'dart:math';
import 'dart:json';

part 'resource_manager.dart';
part 'tile.dart';
part 'game.dart';
part 'camera.dart';
part 'json.dart';
part 'object.dart';
part 'car.dart';

/**
 * Main-Function
 * 
 * load all game resources and prepare to launch game 
 */
void main() {
  var manager = new ResourceManager();
  var tiles = [];                      
  var resources = new Map();          
  
  /* Load tiles */
  for (var a = 1; a < 193; a++) {
    tiles.add(new Tile(manager, "back", into4(a))); 
  }
  resources["images"] = tiles;
  
  /* Load JSON */
  resources["map"] = new Json(manager, "map.json");
  resources["transitions"] = new Json(manager, "transitions.json");
  
  /* Load Objects */
  resources["car"] = new List();
  for (var a = 1; a < 9; a++) {
    resources["car"].add(new Object(manager, "car", into4(a)));
  }
    
  /* init game */
  var game = new Game(resources);
  
  /* start game when all resources are loaded */
  manager.registerNotifyFunction(game.begin);
}

/**
 * printf("%04d");
 */
String into4(var i) {
  if (i < 10)
    return "000$i";
  if (i < 100)
    return "00$i";
  if (i < 1000)
    return "0$i";
  return i;
}
