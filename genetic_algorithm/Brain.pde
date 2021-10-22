class Brain
{
  PVector[] directions; //list of vectors
  int step;
  
  
  Brain(int size)
  {
    directions = new PVector[size];
    step = 0;
    
    Randomize();
  }
  
  void Randomize() //sets every vector in directions to a random vector of length 1
  {
    float randomAngle;
     for(int i=0; i < directions.length;i++)
     {
       randomAngle = random(2*PI);
       directions[i] = PVector.fromAngle(randomAngle);
     }
  }
  
  Brain Clone()
  {
    Brain clone = new Brain(directions.length);
    for(int i=0; i < directions.length;i++)
     {
       clone.directions[i] = directions[i].copy();
     }
     
     return clone;
  }
  
  void Mutate()
  {
    float mutationRate = 0.01;
    float rnd;
    float randomAngle;
    
    for(int i=0; i < directions.length;i++)
     {
       rnd = random(1); 
       if (rnd < mutationRate) //1% chance for a direction to mutate
       {
         randomAngle = random(2*PI);
         directions[i] = PVector.fromAngle(randomAngle);
       }
     }
  }
}
