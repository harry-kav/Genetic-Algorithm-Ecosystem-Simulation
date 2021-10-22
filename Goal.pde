class Goal //a goal for the dots to try and reach - this could be interpreted as food in a simulation
{
  PVector position;
  
  Goal(PVector _position)
  {
    position = _position;
  }
  
  void Show()
  {
    fill(255,0,0); //draw the goal
    ellipse(position.x, position.y, 12, 12);
  }
}
