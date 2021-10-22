class Dot
{
  String dotType;
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  PVector startPoint;
  
  Colour dotColour;
  
  Brain brain;
  Goal goal;
  ArrayList<Obstacle> obstacles;
  
  boolean isDead = false;
  boolean reachedGoal = false; //true if the dot reaches the goal
  boolean isBest = false; //true for only the best dot from the previous generation
  
  int dotsEaten;
  
  float fitness = 0;
  
  Dot(Goal _goal, ArrayList<Obstacle> _obstacles, PVector _startPoint, Colour _dotColour, String _dotType) //constructor
  {
    brain = new Brain(1000);
    goal = _goal;
    obstacles = _obstacles;
    
    dotColour = _dotColour;
    
    startPoint = _startPoint;
    
    dotType = _dotType;
    
    dotsEaten = 0; //predator success metric
    
    position = new PVector(startPoint.x, startPoint.y); //starting position
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }
  
  
  void Show() //display the dots
  {
    if(isBest == true)
    {
      fill(0,255,0);
      ellipse(position.x, position.y, 8, 8);
    }
    else
    {
      fill(dotColour.r, dotColour.g, dotColour.b); //erase and draw a new ellipse on every update based on the current position of the dot
      
      
      if(dotType == "dot")
      {
        ellipse(position.x, position.y, 6, 6);
      }
      else if(dotType == "predator")
      {
        ellipse(position.x, position.y, 8, 8); //predators are bigger
      }
    }
  }
  
  void Move()
  {
    if(brain.directions.length > brain.step) //if there are still directions to be received, then continue to send them
    {
      acceleration = brain.directions[brain.step]; 
      brain.step++;
    }
    else
    {
      isDead = true; //die once out of directions
    }
   
    velocity.add(acceleration);
    velocity.limit(5); //the dot must have a terminal velocity
    position.add(velocity);
  }
  
  void Update() //calls move function and checks for collisions
  {
   if (isDead == false && reachedGoal == false)
   {
     Move();
     
     if (position.x < 2 || position.y < 2 || position.x > width - 2 || position.y > height - 2)
     {
       isDead = true; //if the dot is at the edge of the screen it will die;
     }
     else if (dist(position.x, position.y, goal.position.x, goal.position.y) < 5 && dotType == "dot")
     {
       reachedGoal = true; //the goal has been reached
     }
     else if(isColliding() == true)
     {
       isDead = true; //die if colliding with a rectangle
     }
     else if(isEaten() == true) //die if eaten by a predator
     {
       isDead = true;
     }
   }
  }
  
  boolean isColliding() //checks each obstacle to see if the dot is colliding with it
  {    
    for (int i = 0; i < obstacles.size(); i++)
    {
      if (obstacles.get(i).isIntersecting(position.x, position.y) == true)
      {
        return true; 
      }
    }
    return false;
  }
  
  boolean isEaten() //checks if the dot has been eaten by a predator - this happens when a dot and a predator occupy the same space
  {
    if(dotType == "dot")
    {
      for(int i = 0; i < predatorPop.dots.length; i++)
      {
        if( dist(position.x, position.y, predatorPop.dots[i].position.x, predatorPop.dots[i].position.y) <5)
        {
          predatorPop.dots[i].dotsEaten++; //the predator has eaten the dot
          return true;
        }
      }
    }    
    return false;
  }
  
  void calculateFitness()
  {
    if(dotType == "dot")
    {
      if(reachedGoal == true) //if the dot reached the goal the fitness is determined by how many steps it required to get there
      {
        fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
      }
      else //if the dot failed to reach the goal its score is determined by how close it got
      {
        float DistanceToGoal = dist(position.x, position.y, goal.position.x, goal.position.y);
      
        fitness = 1.0/(DistanceToGoal * DistanceToGoal); //dots with smallest distance to goal get the greatest fitness- distance is squared so small gains are rewarded highly 
      } 
    }
    else if(dotType == "predator") //predator fitness is determined predominantly by how many dots are eaten, as well as lifespan
    {
      fitness = 0.0001*(dotsEaten * dotsEaten) + 0.00001/(brain.step* brain.step); 
      //fitness = 0.0001*(dotsEaten * dotsEaten) //more aggressive
    }
  }
  
  Dot generateChild() //generate a child from this dot
  {
    if(dotType == "dot")
    {
      Dot child = new Dot(goal, obstacles, new PVector(startPoint.x, startPoint.y), dotColour, dotType);
      child.brain = brain.Clone(); //asexual reproduction
    
      return child;
    }
    else
    {
      Predator child = new Predator(goal, obstacles, new PVector(startPoint.x, startPoint.y), dotColour, dotType);
      child.brain = brain.Clone(); //asexual reproduction
    
      return child;
    }
  }
}
