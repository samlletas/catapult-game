part of gamelogic;

class Floor extends GameObject
{
    GameTexture texture;
    
    Floor(this.texture) : super(new Vector2.zero(), 64, 48, new Vector2(0.0, 16.0))
    {
        position.y = 600.0 - height;
    }
    
    draw(Renderer renderer)
    {
        for (int i = 0; i < 960 / texture.width; i++)
        {
            Vector2 tilePosition = new Vector2(position.x + (i * width), position.y);
            renderer.drawTexture(texture, tilePosition, pivot, 0.0);
        }
    }
}