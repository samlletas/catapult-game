part of gamelogic;

class Crystal extends GameObject
{
    GameTexture texture;
    GameTexture brokenTexture;
    bool isActive;
    bool onBreakAnimation;
    
    List<Vector2> brokenPositions;
    Vector2 brokenScale;
    Vector2 brokenPivot;
    
    static const double FLOAT_DISTANCE = 10.0;
    
    Crystal(this.texture, this.brokenTexture) 
        : super(new Vector2.zero(), 24, 38, new Vector2(32.0, 32.0))
    {
        brokenPositions = new List<Vector2>(5);
        brokenScale = new Vector2.zero();
        brokenPivot = new Vector2(16.0, 16.0);
        
        disable();
    }
    
    void enable(double x, double y)
    {
        this.position.x = x;
        this.position.y = y;
        isActive = true;
        
        resetBrokenPieces();
    }
    
    void breakCrystal()
    {
        disable();
        onBreakAnimation = true;
    }
    
    void disable()
    {
        this.position.x = 0.0;
        this.position.y = 0.0;
        isActive = false;
        onBreakAnimation = false;
    }
    
    void resetBrokenPieces()
    {
        for(int i = 0; i < 5; i++)
        {
            if (brokenPositions[i] == null)
            {
                brokenPositions[i] = new Vector2(position.x, position.y);
            }
            else
            {
                brokenPositions[i].x = position.x;
                brokenPositions[i].y = position.y;
            }
        }
        
        brokenScale.x = 1.0;
        brokenScale.y = 1.0;
    }
    
    void update(double frameTime)
    {
        if (onBreakAnimation)
        {
            if (brokenScale.x < 0.8)
            {
                onBreakAnimation = false;
            }
            else
            {
                double angleDiff = 360.0 / 5.0;
                
                for(int i = 0; i < 5; i++)
                {
                    brokenPositions[i].x += 200.0 * cos(radians(angleDiff * i)) * (frameTime / 1000.0);
                    brokenPositions[i].y -= 200.0 * sin(radians(angleDiff * i)) * (frameTime / 1000.0);
                    brokenScale.x -= 0.3 * (frameTime / 1000.0);
                    brokenScale.y -= 0.3 * (frameTime / 1000.0);
                }
            }
        }
    }
    
    void draw(Renderer renderer)
    {
        if (isActive)
        {
            renderer.drawTexture(texture, position, pivot, 0.0);
        }
        else if(onBreakAnimation)
        {
            for(int i = 0; i < 5; i++)
            {
                renderer.drawTexture(brokenTexture, brokenPositions[i],
                        pivot, 0.0, brokenScale);
            }
        }
    }
}