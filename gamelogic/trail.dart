part of gamelogic;

class Trail
{
    GameTexture texture;
    int pointCount;
    List<Vector2> points;
    List<Vector2> scales;
    Vector2 headPoint;
    Vector2 pivot;
    
    Trail(this.texture, this.pointCount)
    {
        this.points = new List<Vector2>(pointCount);
        this.scales = new List<Vector2>(pointCount);
        this.pivot = new Vector2(16.0, 16.0);

        for (int i = 0; i < pointCount; i++)
        {
            points[i] = new Vector2.zero();
            scales[i] = new Vector2(1.0, 1.0);
        }
        
        this.headPoint = points[0];
    }
    
    static const double FOLLOW_SPEED = 200.0;
    static const double MAX_DISTANCE = 10.0;
    
    void update(double frameTime)
    {
        double dx;
        double dy;
        double angle;
        double distance;
        double scale;

        for (int i = 1; i < pointCount; i++)
        {
            dx = this.points[i - 1].x - this.points[i].x;
            dy = this.points[i - 1].y - this.points[i].y;

            angle = atan2(dy, dx);

            distance = sqrt(pow(dx, 2) + pow(dy, 2));

            if (distance > MAX_DISTANCE)
            {
                this.points[i].x = points[i - 1].x - MAX_DISTANCE * cos(angle);
                this.points[i].y = points[i - 1].y - MAX_DISTANCE * sin(angle);
            }

            this.points[i].x += min(FOLLOW_SPEED, distance) * cos(angle) * (frameTime / 1000.0);
            this.points[i].y += min(FOLLOW_SPEED, distance) * sin(angle) * (frameTime / 1000.0);

            scale = lerp(0.2, 1.0, 1.0 - (i.floorToDouble() / pointCount.floorToDouble()));
            this.scales[i].x = scale;
            this.scales[i].y = scale;
        }
    }
    
    void draw(Renderer renderer)
    {
        for (int i = 0; i < pointCount; i++)
        {
            renderer.drawTexture(texture, points[i], pivot, 0.0, scales[i]);
        }
    }

    void reset()
    {
        for (int i = 1; i < pointCount; i++)
        {
            points[i].x = headPoint.x;
            points[i].y = headPoint.y;
        }
    }
}