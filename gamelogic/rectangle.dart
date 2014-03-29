part of gamelogic;

class Rectangle
{
    int x;
    int y;
    int width;
    int height;
    
    int get left   => x;
    int get right  => x + width;
    int get top    => y;
    int get bottom => y + height;
    
    Rectangle(this.x, this.y, this.width, this.height);
    
    bool intersects(Rectangle other)
    {
        if (this.left > other.right)
        {
            return false;
        }
        if (this.right < other.left)
        {
            return false;
        }
        if (this.top > other.bottom)
        {
            return false;
        }
        if (this.bottom < other.top)
        {
            return false;
        }
        
        return true;
    }
}