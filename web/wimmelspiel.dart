library wimmel;

import 'dart:html';
import 'dart:core';
import 'dart:async';
import 'dart:math';
import 'dart:json';

part 'ressource_manager.dart';
part 'tile.dart';
part 'game.dart';
part 'camera.dart';
part 'json.dart';

void main() {
  var manager = new RessourceManager();
  var tiles = [];
  var ressources = new Map();
  
  /* Load tiles */
  for (var a = 1; a < 193; a++) {
    tiles.add(new Tile(manager, "back", into4(a))); 
  }
  ressources["images"] = tiles;
  
  /* Load JSON */
  ressources["map"] = new Json(manager, "map.json");
  ressources["transitions"] = new Json(manager, "transitions.json");
  
  var game = new Game(ressources);
  manager.registerNotifyFunction(game.begin);
}

String into4(var i) {
  if (i < 10)
    return "000$i";
  if (i < 100)
    return "00$i";
  if (i < 1000)
    return "0$i";
  return i;
}