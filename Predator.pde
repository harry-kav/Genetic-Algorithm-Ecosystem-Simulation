class Predator extends Dot//dots that attack other dot species, simulating a predator - they are similar in behaviour to dots, but their fitness depends on how many dots they can capture
{
  
  
  Predator(Goal _goal, ArrayList<Obstacle> _obstacles, PVector _startPoint, Colour _dotColour, String _dotType) //constructor
  {
    super(_goal, _obstacles, _startPoint,  _dotColour, _dotType);
    brain = new Brain(1000);
    goal = _goal;
    obstacles = _obstacles;
    
    dotType = _dotType;
    
    dotsEaten = 0;
    
    dotColour = _dotColour;
    
    startPoint = _startPoint;
    
    position = new PVector(startPoint.x, startPoint.y); //starting position
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }
  
  void Show()
  {
    super.Show();
  }
  
  void Move()
  {
    super.Move(); //movement rules are the smaame for dots and predators
  }
  
  void Update() //predators do not stop upon reaching the goal, as they do not seek it
  {
   if (isDead == false)
   {
     Move();
     
     if (position.x < 2 || position.y < 2 || position.x > width - 2 || position.y > height - 2)
     {
       isDead = true; //if the dot is at the edge of the screen it will die;
     }
     else if(isColliding() == true)
     {
       isDead = true; //die if colliding with a rectangle
     }
   }
  }
  
  boolean isColliding()
  {
    if(super.isColliding() == true)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  void calculateFitness() //fitness is based on how many dots the predator captures
  {
    super.calculateFitness();
  }
  
  //Predator generateChild()
  //{
  //  super.generateChild();
  //}
}
