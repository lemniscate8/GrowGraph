class Graph
{
  float avedist;
  HashSet<Node> nodes;
  HashMap<Link, Integer> links;
  HashMap<Link, Float> dists;
  
  Graph()
  {
    nodes = new HashSet<Node>();
    links = new HashMap<Link, Integer>();
    dists = new HashMap<Link, Float>();
    avedist = 10;
  }
  
  void show()
  {
    strokeWeight(2);
    for(Link l: links.keySet())
    {
      l.show();
    }
  }
  
  void redistribute()
  {
    dists.clear();
    int count = 0;
    float mean = 0;
    for(Link l: links.keySet())
    {
      float len = l.len();
      mean += len;
      dists.put(l, new Float(len));
      count++;
    }
    mean /= count;
    float sd = 0;
    for(Link l: dists.keySet())
    {
      sd += pow(dists.get(l) - mean, 2);
    }
    sd /= count - 1;
    sd = sqrt(sd);
    if(sd != 0)
    {
      for(Link l: dists.keySet())
      {
        PVector dir = PVector.sub(l.a.pos, l.b.pos);
        dir.setMag((dists.get(l) - mean)*2/sd + avedist/log(links.size()) - dists.get(l));
        //sqrt(links.size())
        dir.mult(.5);
        l.a.disp.add(dir);
        dir.mult(-1);
        l.b.disp.add(dir);
      }
    }
    
    count = 0;
    PVector centroid = new PVector();
    for(Node n: nodes)
    {
      centroid.add(n.pos);
      count++;
    }
    centroid.mult(1.0/count);
    //mean = 0;
    //for(Node n: nodes)
    //{
    //  mean += PVector.sub(
    //}
    for(Node n: nodes)
    {
      PVector dir = PVector.sub(n.pos, centroid);
      dir.setMag(2*avedist/(1 + dir.magSq()));
      n.disp.add(dir);
    }
    
    for(Node p: nodes)
    {
      p.pos.sub(centroid);
      p.pos.add(p.disp);
      p.disp.set(0, 0, 0);
    }
  }
  
  void cube(int size)
  {
    avedist = 12*size;
    nodes.clear();
    links.clear();
    ArrayList<Node> ls = new ArrayList<Node>();
    for(int i = 0; i < 8; i++)
    {
      ls.add(new Node(i/1%2 == 0 ? -size/2: size/2,
                         i/2%2 == 0 ? -size/2: size/2,
                         i/4%2 == 0 ? -size/2: size/2));
    }
    int index = 6;
    for(int i = 0; i < 4; i++)
    {
      index -= i;
      Node n1 = ls.get(index);
      for(int j = 0; j < 3; j++)
      {
        int dif = index ^ (int)pow(2, j);
        Node n2 = ls.get(dif);
        Link l = new Link(n1, n2, j);
        links.put(l, new Integer(j));
      }
    }
    nodes.addAll(ls);
  }
}