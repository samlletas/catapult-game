part of gamelogic;

class GameObject
{
    int width;
    int height;
    Vector2 position;
    Vector2 pivot;
    
    Rectangle get boundingBox
    {
        return new Rectangle(position.x.floor(), position.y.floor(), width, height);
    }
    
    GameObject(this.position, this.width, this.height, this.pivot);
}