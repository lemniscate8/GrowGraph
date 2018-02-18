class Node
{
  PVector pos;
  PVector disp;
  HashSet<Node> links;
  
  Node(float x, float y, float z)
  {
    pos = new PVector(x, y, z);
    disp = new PVector();
    links = new HashSet<Node>(10);
  }
  
  Node(PVector v)
  {
    pos = new PVector(v.x, v.y, v.z);
    disp = new PVector();
    links = new HashSet<Node>(10);
  }
  
  void show(color c)
  {
    strokeWeight(10);
    stroke(c);
    point(pos.x, pos.y, pos.z);
  }
  
  //Do not call, only to be called in constructor of a Link
  void link(Node n)
  {
    links.add(n);
  }
  
  //Do not call, only to be called via Link.delink();
  void delink(Node n)
  {
    links.remove(n);
  }
}