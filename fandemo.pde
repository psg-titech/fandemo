// FanController animation
// by Takuo Watanabe

PFont node_font;
PFont value_font;
PFont label_font;

float t;
float tmp, hmd, di, th;
boolean fan;

float rotation = 0.0;

void setup() {
  size(640, 400);
  node_font = loadFont("Courier-24.vlw");
  value_font = loadFont("Courier-20.vlw");
  label_font = loadFont("Helvetica-16.vlw");
  t = 0.0;
  fan = false;
}

void draw() {
  background(255);

  // draw sensors
  noFill();
  triangle(80, 110, 105, 125, 80, 140);
  triangle(80, 210, 105, 225, 80, 240);
  textFont(label_font);
  textAlign(CENTER);
  fill(0);
  text("temperature sensor", 50, 67, 90, 40);
  text("humidity sensor", 50, 170, 90, 40);

  // draw nodes
  noFill();
  square(160, 100, 50);  // tmp node
  square(160, 200, 50);  // hmd node
  square(260, 150, 50);  // di node
  square(360, 100, 50);  // fan node
  square(360, 200, 50);  // th node
  textFont(node_font);
  textAlign(CENTER); 
  fill(0);
  text("tmp", 185, 130);
  text("hmd", 185, 230);
  text("di", 285, 180);
  text("fan", 385, 130);
  text("th", 385, 230);

  // draw fan
  noFill();
  ellipseMode(CENTER);
  circle(520, 125, 80);
  if (fan) {
    rotation += TWO_PI / 15;
    if (rotation > TWO_PI) rotation -= TWO_PI;
  }
  for (int i = 0; i < 4; i++) {
    float blade = rotation + (TWO_PI / 4) * i;
    triangle(520, 125, 
      520 + 30 * sin(blade - PI / 4), 125 + 30 * cos(blade - PI / 4), 
      520 + 36 * sin(blade), 125 + 36 * cos(blade));
  }
  textFont(label_font);
  text("fan", 515, 75);

  // draw device-node links
  line(105, 125, 160, 125);  // tmp sensor -> tmp node
  line(105, 225, 160, 225);  // hmd sensor -> hmd node
  line(410, 125, 480, 125);  // fan node -> fan

  // draw edges
  fill(0);
  // tmp -> di
  line(210, 125, 235, 125);
  line(235, 125, 235, 165);
  line(235, 165, 260, 165);
  triangle(250, 160, 260, 165, 250, 170);
  // hmd -> di
  line(210, 225, 235, 225);
  line(235, 225, 235, 185);
  line(235, 185, 260, 185);
  triangle(250, 180, 260, 185, 250, 190);
  // di -> fan
  line(310, 175, 335, 175);
  line(335, 175, 335, 125);
  line(335, 125, 360, 125);
  triangle(350, 120, 360, 125, 350, 130);
  // th -> fan
  line(395, 200, 395, 150);
  triangle(390, 160, 395, 150, 400, 160);

  // draw past edges
  fill(255);
  // fan -> th (past edge)
  line(375, 150, 375, 200);
  triangle(370, 190, 375, 200, 380, 190);

  // draw legends  
  fill(0);
  line(80, 300, 130, 300);
  triangle(120, 295, 130, 300, 120, 305);
  fill(255);
  line(80, 320, 130, 320);
  triangle(120, 315, 130, 320, 120, 325);
  line(80, 340, 130, 340);
  textFont(label_font);
  textAlign(LEFT);
  fill(0);
  text("present dependency", 140, 305);
  text("past dependency", 140, 325);
  text("connection to external device", 140, 345);

  // simulate Emfrp code8
  boolean fan_at_last = fan;
  tmp = getTmp(t);
  hmd = getHmd(t);
  di = 0.85 * tmp + 0.01 * hmd * (0.99 * tmp - 14.3) + 46.3;
  th = 75.0 + (fan_at_last ? -1.0 : 1.0); 
  fan = di >= th;
  t = t + 0.1;

  // draw current values
  textFont(value_font);
  textAlign(LEFT);
  fill(0);
  text(nf(tmp, 2, 1), 160, 90);
  text(nf(hmd, 2, 1), 160, 190);
  text(nf(di, 2, 1), 260, 140);
  text(fan ? "true" : "false", 355, 90);
  text(nf(th, 2, 1), 360, 270);

  delay(100);
}

float getTmp(float t) {
  return 22.0 + 10.0 * sin(0.24 * t + 0.5);
}

float getHmd(float t) {
  return 50.0 + 30.0 * sin(0.10 * t - 0.2);
}
