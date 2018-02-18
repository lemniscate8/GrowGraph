class Protocol
{
  int a, n1, n2;
  
  Protocol(int s, int states)
  {
    a = (int)random(0, 125);
    n1 = s + 1;
    n2 = (int)random(0, states - 1);
    n2 += (n2 >= s) ? 1 : 0;
  }
  
  Protocol(int action, int next1, int next2)
  {
    a = action;
    n1 = next1;
    n2 = next2;
  }
  
  @Override
  String toString()
  {
    return new String(a + ", " + n1 + ", " + n2);
  }
  
  int action(int c)
  {
    return (int)(a/pow(5, c)) % 5;
  }
  
  int next(boolean success)
  {
    return success ? n1 : n2;
  }
}

ArrayList<Protocol> parseMachine(String s)
{
  ArrayList<Protocol> sm = new ArrayList<Protocol>();
  String[] arr = s.split(", ");
  for(int i = 0; i < arr.length; i += 3)
  {
    sm.add(new Protocol(Integer.parseInt(arr[i]),
                        Integer.parseInt(arr[i + 1]),
                        Integer.parseInt(arr[i + 2])));
  }
  return sm;
}