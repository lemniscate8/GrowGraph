class Crawler
{
  Graph substrate;
  Link vector;
  ArrayList<Protocol> states;
  int state;
  
  Crawler(Graph g)
  {
    substrate = g;
    vector = g.links.keySet().iterator().next();
    states = new ArrayList<Protocol>();
  }
  
  void loadMachine(String dna)
  {
    states = parseMachine(dna);
  }
  
  void randomStates(int num)
  {
    states.clear();
    for(int i = 0; i < num; i++)
    {
      states.add(new Protocol(i, num));
    }
    state = 0;
  }
  
  void reinitialize(boolean newStates)
  {
    substrate.cube(10);
    vector = substrate.links.keySet().iterator().next();
    if(newStates)
      randomStates(states.size());
  }
  
  void update()
  {
    //println(state);
    Protocol cur = states.get(state % states.size());
    boolean outcome = true;
    int curVal = substrate.links.get(vector);
    switch(cur.action(curVal))
    {
      case 0:
        move(0);
        break;
      case 1:
        move(1);
        break;
      case 2:
        move(2);
        break;
      case 3:
        truncate();
        break;
      case 4:
        outcome = pinchtwist();
        break;
    }
    state = cur.next(outcome);
  }
  
  void show()
  {
    vector.a.show(0);
    vector.b.show(255);
  }
  
  void move(int dir)
  {
    int nextVal = (substrate.links.get(vector) + dir) % 3;
    for(Node n: vector.a.links)
    {
      Link next = new Link(n, vector.a, -1);
      if(substrate.links.get(next) == nextVal)
      {
        vector = next;
        return;
      }
    }
  }
  
  void truncate()
  {
    float ratio = .66;
    Node pt = vector.a;
    Link next = null;
    ArrayList<Node> outer = new ArrayList<Node>(pt.links);
    ArrayList<Node> inner = new ArrayList<Node>();
    for(int i = 0; i < 3; i++)
    {
      Node o = outer.get(i);
      inner.add(new Node((1 - ratio)*o.pos.x + ratio*pt.pos.x,
                         (1 - ratio)*o.pos.y + ratio*pt.pos.y,
                         (1 - ratio)*o.pos.z + ratio*pt.pos.z));
      if(vector.b == o)
        next = new Link(inner.get(i), vector.b, 0);
    }
    
    substrate.nodes.addAll(inner);
    for(int i = 0; i < 3; i++)
    {
      Node out = outer.get(i);
      Node n1 = inner.get(i);
      Node n2 = inner.get((i + 1) % 3);
      Node n3 = inner.get((i + 2) % 3);
      Link test = new Link(out, pt, -1);
      int val = substrate.links.get(test);
      substrate.links.put(new Link(out, n1, val), new Integer(val));
      substrate.links.put(new Link(n2, n3, val), new Integer(val));
      test.delink();
      substrate.links.remove(test);
    }
    substrate.nodes.remove(pt);
    vector = next;
  }
  
  boolean pinchtwist()
  {
    for(Node n: vector.a.links)
    {
      for(Node m: vector.b.links)
      {
        if(n == m)
          return true;
      }
    }
    
    int refVal = (substrate.links.get(vector) + 1) % 3;
    Link va = new Link();
    for(Node n: vector.a.links)
    {
      va.set(vector.a, n);
      Integer i = substrate.links.get(va);
      if(i != null && i == refVal)
        break;
    }
    Link vb = new Link();
    for(Node n: vector.b.links)
    {
      vb.set(vector.b, n);
      Integer i = substrate.links.get(vb);
      if(i != null && i == refVal)
        break;
    }
    Link na = new Link(va.a, vb.b, refVal);
    Link nb = new Link(vb.a, va.b, refVal);
    substrate.links.put(na, refVal);
    substrate.links.put(nb, refVal);
    substrate.links.remove(va);
    substrate.links.remove(vb);
    va.delink();
    vb.delink();
    return false;
  }
}