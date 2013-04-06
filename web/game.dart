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
 * Game main class
 * contains the render loop
 */
class Game {
  var canvas;
  CanvasRenderingContext2D context; // render context
  var pause = true; // pause the game
  var delta = 100; // speed variable for frame rate independent programming
  var start = 0; // timestamp of the last frame
  var images; // background image list
  var maus; // mouse instance
  var camera; // camera instance
  var map; // 
  var resources;
  var shiftdown = false;
  var testcar;
  
  /* consts */
  const MAPWIDTH = 16;
  const MAPHEIGHT = 12;
  const SCREENWIDTH = 4000;
  const SCREENHEIGHT = 3000;

  /**
   * Constructor
   * @param resources loaded game resources
   */
  Game(resources) {
    /* get the html canvas */
    canvas = query("#screen");
    context = canvas.getContext('2d');
    // extract images from resources
    images = resources["images"];
    this.resources = resources;
    
    maus = new Maus(); // new mouse instance
    camera = new Camera(SCREENWIDTH, SCREENHEIGHT); // new camera instance
    testcar = new Car(); // new car instance TODO: remove it
    
    /* window listener */
    window.onResize.listen((ev) {resize();});
    window.onMouseDown.listen(mouseDown);
    window.onMouseUp.listen(mouseUp);
    window.onMouseMove.listen(mouseMove);
    window.onKeyDown.listen((ev) {
      /* map editor hack */
      if (ev.keyCode == 17)
        shiftdown = true;
      if (ev.keyCode == 65)
      {
        print("      { \"id\": \"test2\",");
        print("        \"coords\": [");
        map["segments"].add(new Map()); 
        map["segments"][map["segments"].length-1]["coords"] = new List();
      }
    });
    window.onKeyUp.listen((ev) {shiftdown = false;});

    /* initial canvas resize */
    resize();
  }
  
  /**
   * mouse down handler
   */
  void mouseDown(ev) {
    /* save coords for future movements */
    maus.pressed = true;
    maus.x = ev.clientX;
    maus.y = ev.clientY;
    camera.move(0,0); // stop camera motion
    
    /* Map editor hack */
    if (shiftdown == true)
    {
      print("{\"x\": ${maus.x+camera.x}, \"y\": ${maus.y+camera.y}},");
      map["segments"][map["segments"].length-1]["coords"].add(new Map());
      map["segments"][map["segments"].length-1]["coords"][map["segments"][map["segments"].length-1]["coords"].length-1]["x"] = (maus.x+camera.x);
      map["segments"][map["segments"].length-1]["coords"][map["segments"][map["segments"].length-1]["coords"].length-1]["y"] = (maus.y+camera.y);
    }
  }
  
  /**
   *  mouse button release handler
   */
  void mouseUp(ev) {
    maus.pressed = false;
  }
  
  /**
   * mouse movement handler
   */
  void mouseMove(ev) {
    /* camera movement */
    if (maus.pressed == true && shiftdown == false) {
      var dx = maus.x - ev.clientX;
      var dy = maus.y - ev.clientY;
      camera.move(dx, dy);
      maus.x = ev.clientX;
      maus.y = ev.clientY;
    }
  }
  
  /** game start */
  void begin() {
    map = resources["map"].data;
    pause = false;
    request();
  }

  /** resize layout */
  void resize() {
    var can = query("#screen");
    can.height = can.offsetHeight;
    can.width = can.offsetWidth;
    //request(); // don't do this!
  }
  
  /** request new animation frame */
  void request() {
    window.requestAnimationFrame(loop);
  }
  
  /** MAIN LOOP */
  void loop(time) {
   
    // calculate game speed
    if (start == 0) start = time - 200;
    delta = time - start;
    start = time;
    
    // update camera
    camera.update(delta);
    
    // draw screen
    for (var y = 0; y < MAPHEIGHT; y++) {
      for (var x = 0; x < MAPWIDTH; x++) {
        if (images[x+y*16].error == false) {
          context.drawImage(images[x+y*16].image, x*250-camera.x, y*250-camera.y);
        }
      }
    }
    
    /* RENDER */
    context.shadowOffsetX = 0;
    context.shadowOffsetY = 0;
    context.strokeStyle = "yellow";
    context.lineWidth = 4;
    
    for (var a in map["segments"])
    {
      context.beginPath();
      context.moveTo(a["coords"][0]["x"]-camera.x, a["coords"][0]["y"]-camera.y);
      for (var b in a["coords"])
      {
        //context.fillText("x", b["x"]-camera.x, b["y"]-camera.y);
        context.lineTo(b["x"]-camera.x, b["y"]-camera.y);
      }
      context.shadowBlur = 2;
      
      
      // TESTCAR TODO
      if (testcar.segment == a["id"]) {
        context.strokeStyle = "red";
        
        // Testcar update
        if (testcar.update(delta/10) == 1) {
          testcar.goal = new Point(a["coords"][testcar.point]["x"], a["coords"][testcar.point]["y"]);

          testcar.point++;
          if (testcar.point == a["coords"].length) {
            if (resources["transitions"].data["transitions"].containsKey(testcar.segment))
            {
              //context.fillText(resources["transitions"].data["transitions"][testcar.segment]["follow"][0]["segment"],20,20);
              testcar.segment = resources["transitions"].data["transitions"][testcar.segment]["follow"][0]["segment"];
            }
            /*else {
              //context.fillText(testcar.segment, 20,40);
            }*/
            testcar.point = 0;
          }          
        }      
      } else
        context.strokeStyle = "yellow";
      context.stroke();
      context.shadowBlur = 0;
      context.fillText(a["id"], a["coords"][(a["coords"].length/2).floor()]["x"]-camera.x, a["coords"][(a["coords"].length/2).floor()]["y"]-camera.y);
    }
    // print(map["segments"][0]["coords"][0]["x"]);


    
    // TESTCAR DISPLAY
    context.strokeStyle = "blue";
    context.beginPath();
    context.moveTo(testcar.pos.x-5 - camera.x, testcar.pos.y-5 - camera.y);
    context.lineTo(testcar.pos.x+5 - camera.x, testcar.pos.y+5 - camera.y);
    //context.lineTo(testcar.goal.x, testcar.goal.y);
    context.stroke();

    
    //print(resources["transitions"].data["transitions"]);
    
    // request new Frame
    new Timer(new Duration(milliseconds: 20), request); // TODO check millisecond value    
  }
}

/**
 * Mouse class
 */
class Maus {
  var pressed;
  var x, y;
}

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
}

