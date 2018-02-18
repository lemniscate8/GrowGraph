class Link
{
  Node a;
  Node b;
  int value;
  
  //Val of -1 indicates it exists only to set for links
  Link()
  {
    a = null;
    b = null;
    value = -1;
  }
  
  Link(Node n1, Node n2, int val)
  {
    a = n1;
    b = n2;
    if(val != -1)
    {
      n1.link(n2);
      n2.link(n1);
    }
    value = val;
  }
  
  void set(Node n1, Node n2)
  {
    if(value == -1)
    {
      a = n1;
      b = n2;
    }
  }
  
  boolean has(Node n)
  {
    return (a == n) || (b == n);
  }
  
  Node other(Node n)
  {
    return a == n ? b : a;
  }
  
  void show()
  {
    stroke(255.0*value/3, 255, 255, 255);
    line(a.pos.x, a.pos.y, a.pos.z, b.pos.x, b.pos.y, b.pos.z);
  }
  
  float len()
  {
    return PVector.sub(a.pos, b.pos).mag();
  }
  
  //Allows link checking via an in-the-moment test link
  //between a and b
  @Override
  public boolean equals(Object o)
  {
    Link l = (Link)o;
    return (a.equals(l.a) && b.equals(l.b)) || (a.equals(l.b) && b.equals(l.a));
  }
  
  //Allows link checking via an in-the-moment test link
  //between a and b
  @Override
  public int hashCode()
  {
    return a.hashCode() ^ b.hashCode();
  }
  
  //Always remove link from Graph structure after calling!
  void delink()
  {
    a.delink(b);
    b.delink(a);
  }
}