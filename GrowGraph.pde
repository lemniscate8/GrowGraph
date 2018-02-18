import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import java.util.*;

PeasyCam cam;
Graph graph;
Crawler crawler;
boolean run = false;

String test = "108, 1, 6, 110, 2, 2, 15, 3, 6, 89, 4, 1, 54, 5, 7, 83, 6, 7, 26, 7, 5, 92, 8, 2, 67, 9, 5";

void setup()
{
  size(640, 480, P3D);
  colorMode(HSB);
  cam = new PeasyCam(this, 100);
  cam.setWheelScale(.1);
  graph = new Graph();
  graph.cube(10);
  crawler = new Crawler(graph);
  crawler.loadMachine(test);
}

void keyPressed()
{
  if(key == ' ')
    run = !run;
  else if(key == 'c')
    crawler.reinitialize(false);
  else if(key == 'x')
    crawler.reinitialize(true);
  else if(key == 'p')
    println(crawler.states);
}

void draw()
{
  background(0);
  graph.show();
  stroke(0, 0, 255);
  crawler.show();
  if(run)//&& frameCount % 10 == 0)
    crawler.update();
  for(int i = 0; i < 32; i++)
  {
    graph.redistribute();
  }
}