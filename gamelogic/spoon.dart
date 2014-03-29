part of gamelogic;

class Spoon extends GameObject
{
    GameTexture texture;
    double angle;
    
    static const double INITIAL_ANGLE = 125.0;
    static const double MAX_ANGLE = 210.0;
    static const double PULL_SPEED = 100.0;
    static const double LAUNCH_SPEED = 800.0;
    
    Spoon(this.texture) 
        : super (new Vector2(150.0, 445.0), 110, 25, new Vector2(112.0, 58.0))
    {
        reset();
    }
    
    void reset()
    {
        angle = INITIAL_ANGLE;
    }
    
    void draw(Renderer renderer)
    {
        renderer.drawTexture(texture, position, pivot, 180.0 - angle);
    }
}