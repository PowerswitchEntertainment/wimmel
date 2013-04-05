part of wimmel;

class Game {
  var canvas;
  CanvasRenderingContext2D context;
  var pause = true;
  var delta = 100;
  var start = 0;
  var images;
  var maus;
  var camera;
  var map;
  var ressources;
  var shiftdown = false;
  var testcar;
  
  
  const MAPWIDTH = 16;
  const MAPHEIGHT = 12;
  const SCREENWIDTH = 4000;
  const SCREENHEIGHT = 3000;


  Game(ressources) {
    canvas = query("#screen");
    context = canvas.getContext('2d');
    images = ressources["images"];
    this.ressources = ressources;
    
    maus = new Maus();
    camera = new Camera(SCREENWIDTH, SCREENHEIGHT);
    testcar = new Car();
    
    window.onResize.listen((ev) {resize();});
    
    window.onMouseDown.listen(mouseDown);
    window.onMouseUp.listen(mouseUp);
    window.onMouseMove.listen(mouseMove);
    
    window.onKeyDown.listen((ev) {
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

    resize();
  }
  
  void mouseDown(ev) {
    maus.pressed = true;
    maus.x = ev.clientX;
    maus.y = ev.clientY;
    camera.move(0,0);
    
    if (shiftdown == true)
    {
      print("{\"x\": ${maus.x+camera.x}, \"y\": ${maus.y+camera.y}},");
      map["segments"][map["segments"].length-1]["coords"].add(new Map());
      map["segments"][map["segments"].length-1]["coords"][map["segments"][map["segments"].length-1]["coords"].length-1]["x"] = (maus.x+camera.x);
      map["segments"][map["segments"].length-1]["coords"][map["segments"][map["segments"].length-1]["coords"].length-1]["y"] = (maus.y+camera.y);
    }
  }
  
  void mouseUp(ev) {
    maus.pressed = false;
  }
  
  void mouseMove(ev) {
    if (maus.pressed == true && shiftdown == false) {
      var dx = maus.x - ev.clientX;
      var dy = maus.y - ev.clientY;
      camera.move(dx, dy);
      maus.x = ev.clientX;
      maus.y = ev.clientY;
    }
  }
  
  void begin() {
    map = ressources["map"].data;
    pause = false;
    request();
  }

  void resize() {
    var can = query("#screen");
    can.height = can.offsetHeight;
    can.width = can.offsetWidth;
    //request(); // don't do this!
  }
  
  void request() {
    window.requestAnimationFrame(loop);
  }
  
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
      
      if (testcar.segment == a["id"])
        context.strokeStyle = "red";
      else
        context.strokeStyle = "yellow";
      context.stroke();
      context.shadowBlur = 0;
      context.fillText(a["id"], a["coords"][(a["coords"].length/2).round()]["x"]-camera.x, a["coords"][(a["coords"].length/2).round()]["y"]-camera.y);
    }
    // print(map["segments"][0]["coords"][0]["x"]);

    
    // request new Frame
  new Timer(new Duration(milliseconds: 50), request);    
  }
}

class Maus {
  var pressed;
  var x, y;
}

class Car {
  var segment;
  Car() {
    segment = "A1";
  }
}

