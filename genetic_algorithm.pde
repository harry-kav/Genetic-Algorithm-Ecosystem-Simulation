Population testPop;
Population oppPop; //opposition

Population predatorPop; //predators

public Dot[] allDots;

ArrayList<Obstacle> obstacles;

Goal goal;

//team colours
Colour purple;
Colour yellow;
Colour orange;

//species strings
String predator;
String dot;

void setup()
{
  size(800,600);
  frameRate(100);
  
  purple = new Colour(255,50,255);
  yellow = new Colour(255,255,0);
  orange = new Colour(255,165,0);
  
  predator = "predator";
  dot = "dot";
  
  goal = new Goal(new PVector(400,10));
  
  obstacles = new ArrayList<Obstacle>();
  
  //course 1 - easy
  
  obstacles.add(new Obstacle(0, 300, 600, 10));
  obstacles.add(new Obstacle(400, 100, 400, 10));
  
  //course 2 - advanced
  
  //obstacles.add(new Obstacle(360, 400, 10, 200));
  //obstacles.add(new Obstacle(440, 500, 10, 100));
  
  //obstacles.add(new Obstacle(370, 400, 200, 10));
  //obstacles.add(new Obstacle(450, 500, 250, 10));
  
  //obstacles.add(new Obstacle(570, 260, 10, 150));
  //obstacles.add(new Obstacle(700, 150, 10, 360));
  
  //obstacles.add(new Obstacle(200, 100, 400, 10));
  //obstacles.add(new Obstacle(700, 150, 10, 360));
  
  
  testPop = new Population(500, goal, obstacles, new PVector(width/2, height/10 *9.5), purple, dot);
  
  oppPop = new Population(500, goal, obstacles, new PVector(width/3, height/10 *9.5), yellow, dot);
  
  predatorPop = new Population(100, goal, obstacles, new PVector(width/1.5, height/10 *2), orange, predator);

}

void draw()
{
  background(200);
  
  if (testPop.areAllDotsDead() == true && oppPop.areAllDotsDead() == true && predatorPop.areAllDotsDead() == true)
  {
    
    //genetic algorithm
    testPop.calculateFitness();
    testPop.naturalSelection();    
    testPop.mutateChild();
    
    oppPop.calculateFitness();
    oppPop.naturalSelection();    
    oppPop.mutateChild();
    
    predatorPop.calculateFitness();
    predatorPop.naturalSelection();    
    predatorPop.mutateChild(); 
  }
  else
  {
    if (testPop.areAllDotsDead() == false)
    {
      testPop.Update();
      testPop.Show();
    }
    if (oppPop.areAllDotsDead() == false)
    {
      oppPop.Update();
      oppPop.Show();
    }
    if (predatorPop.areAllDotsDead() == false)
    {
      predatorPop.Update();
      predatorPop.Show();
    }

  }
  
  
  goal.Show();
  
  for (int i = 0; i < obstacles.size(); i++)
    {
      obstacles.get(i).Show();
    }
}
