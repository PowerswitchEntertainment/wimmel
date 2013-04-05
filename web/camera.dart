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
      ax *= 0.8;
    } else {
      ax = 0;
    }
    if (ay.abs() > 1) {
      ay *= 0.8;
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

