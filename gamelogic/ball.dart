part of gamelogic;

class Ball extends GameObject
{
    GameTexture texture;
    Trail trail;
    Vector2 speed;
    bool onAir;
    
    static const double GRAVITY = 2000.0;
    
    Ball(this.texture, this.trail)
        : super(new Vector2.zero(), 46, 46, new Vector2(32.0, 32.0))
    {
        speed = new Vector2.zero();
        
        reset();
    }
    
    void reset()
    {
        speed.x = 0.0;
        speed.y = 0.0;
        onAir = false;
    }
    
    void resetTrail()
    {
        trail.headPoint.x = position.x;
        trail.headPoint.y = position.y;
        
        trail.reset();
    }
    
    bool isOutside()
    {
        Rectangle viewport = new Rectangle(0, 0, 980, 600);
        
        return !viewport.intersects(this.boundingBox);
    }
    
    void update(double frameTime)
    {
        position.x += speed.x * (frameTime / 1000.0);
        position.y += speed.y * (frameTime / 1000.0);
        
        if (onAir)
        {
            speed.y += GRAVITY * (frameTime / 1000.0);
            
            trail.headPoint.x = position.x;
            trail.headPoint.y = position.y;
        }
        
        trail.update(frameTime);
    }
    
    void draw(Renderer renderer)
    {
        if (onAir)
        {
            trail.draw(renderer);
        }
        
        renderer.drawTexture(texture, position, pivot, 0.0);
    }
}