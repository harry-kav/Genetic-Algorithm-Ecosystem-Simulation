class Obstacle
{
  int x;
  int y;
  int w;
  int h;
  
  Obstacle(int _x, int _y, int _width, int _height)
  {
    x = _x;
    y = _y;
    w = _width;
    h = _height; 
  }
  
  void Show() //display the obstacle
  {
    fill(0,0,255);
    rect(x, y, w, h);
  }
  
  boolean isIntersecting(float posX, float posY) //collision detection
  {
    if(posX > x && posX < w + x && posY > y && posY < h + y )
    {
      return true;
    }
    else
    {
      return false;
    }
  }
}
