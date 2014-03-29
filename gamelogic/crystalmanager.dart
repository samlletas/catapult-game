part of gamelogic;

class CrystalManager
{
    List<Crystal> crystals;
    List<List<Vector2>> presetPositions;
    int currentPreset;
    Random random;
    
    Ball ball;
    Function scoreHandler;
    
    GameSound breakSound;
    
    static const int CRYSTAL_COUNT = 5;

    CrystalManager(this.ball, this.scoreHandler, this.breakSound)
    {
        currentPreset = -1;
        random = new Random();
    }
    
    void initializeCystals(GameTexture crystalTexture, GameTexture brokenTexture)
    {
        crystals = new List<Crystal>();
    
        for(int i  = 0; i < CRYSTAL_COUNT; i++)
        {
            Crystal c = new Crystal(crystalTexture, brokenTexture);
            crystals.add(c);
        }
    }
    
    void initializePresetPositions()
    {
        presetPositions = new List<List<Vector2>>();
        
        // Posición predefinida: 0
        presetPositions.add([
            new Vector2(319.0, 350.0),
            new Vector2(373.0, 358.0),
            new Vector2(423.0, 381.0),
            new Vector2(464.0, 417.0),
            new Vector2(500.0, 465.0)
        ]);
        
        // Posición predefinida: 1
        presetPositions.add([
            new Vector2(484.0, 304.0),
            new Vector2(553.0, 308.0),
            new Vector2(617.0, 328.0),
            new Vector2(677.0, 356.0),
            new Vector2(728.0, 420.0)
        ]);
        
        // Posición predefinida: 3
         presetPositions.add([
             new Vector2(616.0, 227.0),
             new Vector2(686.0, 242.0),
             new Vector2(752.0, 276.0),
             new Vector2(811.0, 315.0),
             new Vector2(857.0, 365.0)
         ]);
        
        // Posición predefinida: 4
         presetPositions.add([
             new Vector2(678.0, 116.0),
             new Vector2(738.0, 119.0),
             new Vector2(802.0, 132.0),
             new Vector2(855.0, 155.0),
             new Vector2(905.0, 188.0)
         ]);
    }
    
    void reset()
    {
        for(int i  = 0; i < CRYSTAL_COUNT; i++)
        {
            crystals[i].disable;
        }
    }
    
    void spawnNewCrystals()
    {
        int newPreset = random.nextInt(presetPositions.length);
        
        if (newPreset == currentPreset)
        {
            spawnNewCrystals();
        }
        else
        {
            currentPreset = newPreset;
            
            for(int i  = 0; i < CRYSTAL_COUNT; i++)
            {
                Vector2 position = presetPositions[currentPreset][i];
                crystals[i].enable(position.x, position.y);
            }
        }
    }
    
    void updateCrystals(double frameTime)
    {
        int activeCrystals = 0;
        
        for(int i  = 0; i < CRYSTAL_COUNT; i++)
        {
            Crystal crystal = crystals[i];
            crystal.update(frameTime);
            
            if (ball.boundingBox.intersects(crystal.boundingBox))
            {
                crystal.breakCrystal();
                scoreHandler();
                breakSound.play();
            }
            
            if (crystal.isActive)
            {
                activeCrystals++;
            }
        }
        
        if (activeCrystals == 0 && !ball.onAir)
        {
            spawnNewCrystals();
        }
    }
    
    void drawCrystals(Renderer renderer)
    {
        for(int i  = 0; i < CRYSTAL_COUNT; i++)
        {
            crystals[i].draw(renderer);
        }
    }
}