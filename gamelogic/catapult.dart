part of gamelogic;

class Catapult extends GameObject
{
    GameTexture texture;
    Spoon spoon;
    Ball ball;
    bool pulling;
    bool canPull;
    bool launching;
    double pullAngle;
    
    static const double SHOT_ANGLE = 45.0;
    static const double MIN_BALL_SPEED = 200.0;
    static const double MAX_BALL_SPEED = 1600.0; 
    
    Catapult(this.texture, this.spoon, this.ball) 
        : super(new Vector2(50.0, 435.0), 0, 0, new Vector2(40.0, 70.0))
    {
        reset();
    }
    
    void reset()
    {
        pulling = false;
        launching = false;
        canPull = true; 
        
        pullAngle = 0.0;
        
        spoon.reset();
        ball.reset();
        ball.resetTrail();
    }
    
    void beginPull()
    {
        if (canPull)
        {
            pulling = true;
            canPull = false;
        }
    }
    
    void release()
    {
        if (pulling)
        {
            pulling = false;
            launching = true;
            
            pullAngle = spoon.angle;
        }
    }
    
    void shootBall()
    {
        launching = false; 
        ball.onAir = true;
        
        double angleDiference = Spoon.MAX_ANGLE - Spoon.INITIAL_ANGLE;
        double factor = (pullAngle - Spoon.INITIAL_ANGLE) / angleDiference;
        double shotSpeed = lerp(MIN_BALL_SPEED, MAX_BALL_SPEED, factor);
        
        ball.speed.x = shotSpeed * cos(radians(SHOT_ANGLE));
        ball.speed.y = -shotSpeed * sin(radians(SHOT_ANGLE));
        
        ball.resetTrail();
    }
    
    void update(double frameTime)
    {
        if (pulling)
        {
            spoon.angle = clamp(spoon.angle + Spoon.PULL_SPEED * (frameTime / 1000.0), 
                    Spoon.INITIAL_ANGLE, Spoon.MAX_ANGLE);
        }
        else if (launching)
        {
            spoon.angle = clamp(spoon.angle - Spoon.LAUNCH_SPEED * (frameTime / 1000.0), 
                    Spoon.INITIAL_ANGLE, Spoon.MAX_ANGLE);
            
            if (spoon.angle == Spoon.INITIAL_ANGLE)
            {
                shootBall();
            }
        }
        
        if (ball.onAir)
        {
            if (ball.isOutside())
            {
                reset();
                ball.resetTrail();
            }
        }
        else
        {
            setBallPositionToSpoon();
        }
    }
    
    void setBallPositionToSpoon()
    {
        int distance = spoon.width - 25;
        double angle = spoon.angle - 2.0;
        
        ball.position.x = spoon.position.x + distance * cos(radians(angle));
        ball.position.y = spoon.position.y - distance * sin(radians(angle));
    }
    
    void draw(Renderer renderer)
    {
        renderer.drawTexture(texture, position, pivot, 0.0);
    }
}