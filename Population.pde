class Population
{
  Dot[] dots; //the population of dots is stored in a list
  Goal goal;
  ArrayList<Obstacle> obstacles;
  
  PVector startPoint; //where the dots start from
  
  Colour dotColour;
  
  float fitnessSum;
  
  int genNum = 1; //track the number of generations
  
  int bestDot = 0;
  
  int maxSteps;
  
  int maxIndex;
  
  float meanFitness;
  
  String dotType;
  
  Population(int popSize, Goal _goal, ArrayList<Obstacle> _obstacles, PVector _startPoint, Colour _dotColour, String _dotType)
  {
    dots = new Dot[popSize];
    obstacles = _obstacles;
    startPoint = _startPoint;
    
    dotColour = _dotColour;
    
    dotType = _dotType;
    
    for (int i = 0; i < popSize; i++)
    {
      goal = _goal;
      dots[i] = new Dot(goal, obstacles, startPoint, dotColour, dotType); //generate all the dots in the population
    }
  }
  
  void Show()
  {
    for (int i = 1; i < dots.length; i++)
    {
      dots[i].Show();
    }
    dots[0].Show();
  }
  
  void Update()
  {
    for (int i = 0; i < dots.length; i++)
    {
      if(dots[i].brain.step > maxSteps && maxSteps != 0) //a dot will die if it exceeds the number of steps taken by the previous champion, as it is a worse mutation
      {
        dots[i].isDead = true;
      }
      else
      {
        dots[i].Update();
      }
    }
  }
  
  void calculateFitness()
  {
    for (int i = 0; i < dots.length; i++)
    {
      dots[i].calculateFitness();
    }
  }
  
  boolean areAllDotsDead() //checks if all the dots have died(or succeeded) yet, so that the next generation can begin
  {
    for (int i = 0; i < dots.length; i++)
    {
      if (dots[i].isDead == false && dots[i].reachedGoal ==false)
      {
        return false; 
      }
    }
    
    return true; 
  }
  
  void naturalSelection()
  {
    Dot[] nextGenDots = new Dot[dots.length]; //generate a new generation of dots
    
    setBestDot(); //find the champion dot from the current generation
    calculateFitnessSum();
    
    calculateMeanFitness();
    
    outputResults();
     
    nextGenDots[0] = dots[bestDot].generateChild(); //place the best performing dot directly into the next generation so that negative mutations do not halt progress
    nextGenDots[0].isBest = true;
    for (int i = 1; i < dots.length; i++)
    {
      //select parent based on fitness
      Dot parent = selectParent();
      //generate child from parent
      nextGenDots[i] = parent.generateChild();
    }
    
    dots = nextGenDots; //the new generation replaces the old generation
    genNum++; 
  }
  
  void calculateFitnessSum() //finds the total sum of all dots' fitness
  {
    fitnessSum = 0;
    for (int i = 0; i < dots.length; i++)
    {
      fitnessSum += dots[i].fitness;
      
    }
    
  }
  
  Dot selectParent() //select a parent dot to reproduce. dots with higher fitness are more likely to be chosen
  {
    float rnd = random(fitnessSum); //select a random number within the range of the fitness sum
    
    float runningSum = 0;
    
    for (int i = 0; i < dots.length; i++)
    {
      runningSum += dots[i].fitness;
      
      if(runningSum > rnd)
      {
        return dots[i];
      }
      
    }
    
    //should never get to this point
    return null;
  }
  
  void mutateChild()
  {
    for (int i = 1; i < dots.length; i++)
    {
      dots[i].brain.Mutate();
      
    }
  }
  
  void setBestDot()
  {
    float max = 0;
    maxIndex = 0; //index of the best dot
    
    for (int i = 0; i < dots.length; i++)
    {
      if(dots[i].fitness > max) //cycle through the dots to find the one with the greatest fitness
      {
        max = dots[i].fitness;
        maxIndex = i;
      }
      
    }
    bestDot = maxIndex;
    //print ("Top Fitness:" + dots[maxIndex].fitness + "\n"); //record the top fitness for this generation
    
    if (dots[bestDot].reachedGoal == true)
    {
      maxSteps = dots[bestDot].brain.step; //the maximum number of steps allowed to reach the goal in the next generation will be the number that the best dot of the previous generation required
    }                                      //this encourages dots to become more efficient and optimise their path to the goal
  }
  
  void calculateMeanFitness() //calculate the average fitness of the dots
  {
    meanFitness = (float)fitnessSum/dots.length;
  }
  
  void outputResults()
  {
    print("Generation:"+genNum+"\n");
    print ("Top Fitness:" + dots[maxIndex].fitness + "\n"); //record the top fitness for this generation
    print ("Mean Fitness:" + meanFitness + "\n"); //record the top fitness for this generation
    
    print ("Steps required(top):"+ maxSteps + "\n");
  }
}
