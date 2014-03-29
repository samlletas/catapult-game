import 'dart:html';
import 'dart:async';
import 'engine/engine.dart';
import 'gamelogic/gamelogic.dart';
import 'package:vector_math/vector_math.dart';

GameTexture ballTexture = new GameTexture();
GameTexture catapultTexture = new GameTexture();
GameTexture crystalTexture = new GameTexture();
GameTexture floorTexture = new GameTexture();
GameTexture spoonTexture = new GameTexture();
GameTexture overlayTexture = new GameTexture();
GameTexture brokenTexture = new GameTexture();
GameTexture trailTexture = new GameTexture();
GameSound music = new GameSound("content/music.ogg");
GameSound breakSound = new GameSound("content/break.wav");

Timer gameTimer;
const int MAX_GAME_TIME = 45;
int currentGameTime = 0;
int score = 0;

Engine engine;
SoundManager soundManager;

Spoon spoon;
Catapult catapult;
Ball ball;
Trail trail;
Floor floor;
CrystalManager crystalManager;

CanvasElement canvas = querySelector("#drawArea");
ButtonElement startButton = querySelector("#start");
var timeElement = querySelector("#time");
var scoreElement = querySelector("#score");

void main() 
{
    engine = new Engine(canvas, update, draw);
    loadTextures(1);
}

void loadTextures(int textureIndex)
{
    switch(textureIndex)
    {
        case 1:
            ballTexture.load(engine.renderer.context, "content/ball.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 2:
            catapultTexture.load(engine.renderer.context, "content/catapult.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 3:
            crystalTexture.load(engine.renderer.context, "content/crystal.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 4:
            floorTexture.load(engine.renderer.context, "content/floor.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 5:
            spoonTexture.load(engine.renderer.context, "content/spoon.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 6:
            overlayTexture.load(engine.renderer.context, "content/overlay.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 7:
            brokenTexture.load(engine.renderer.context, "content/broken.png", 
                    () =>  loadTextures(textureIndex + 1));
            break;
        case 8:
            trailTexture.load(engine.renderer.context, "content/trail.png", 
                    () =>  loadSounds());
            break;
    }
}

void loadSounds()
{
    soundManager = new SoundManager(() => initialize());
    soundManager.addSound(music);
    soundManager.addSound(breakSound);
    
    soundManager.loadSounds();
}

void initialize()
{
    spoon = new Spoon(spoonTexture);
    trail = new Trail(trailTexture, 20);
    ball = new Ball(ballTexture, trail);
    catapult = new Catapult(catapultTexture, spoon, ball);   
    floor = new Floor(floorTexture);
    crystalManager = new CrystalManager(ball, updateScore, breakSound);
    
    startButton.style.display = "inline";
    startButton.onClick.listen((MouseEvent) => 
            startGame()); 
    canvas.onMouseDown.listen((MouseEvent) => 
            catapult.beginPull());  
    canvas.onMouseUp.listen((MouseEvent) => 
            catapult.release());
    
    crystalManager.initializeCystals(crystalTexture, brokenTexture);
    crystalManager.initializePresetPositions();
    
    displayTime();
    displayScore();
    
    music.loop = true;
    music.play();
    
    engine.start();   
}

void startGame()
{
    if (currentGameTime == 0)
    {
        crystalManager.spawnNewCrystals();
        catapult.reset();
        
        score = 0;
        currentGameTime = MAX_GAME_TIME;
        
        displayScore();
        displayTime();    
        
        gameTimer = new Timer.periodic(new Duration(seconds: 1), 
                (Timer) => handleGameTime());
        
        startButton.setAttribute("disabled", "disabled");
    }
}

void stopGame()
{
    gameTimer.cancel();
    
    if (startButton.attributes.containsKey("disabled"))
    {
        startButton.attributes.remove("disabled");
    }
}

void handleGameTime()
{
    currentGameTime--;
    displayTime();
    
    if (currentGameTime == 0)
    {
        stopGame();   
    }
}

void displayTime()
{
    if (currentGameTime < 10)
    {
        timeElement.text = "Tiempo: 0" + currentGameTime.toString();
    }
    else
    {
        timeElement.text = "Tiempo: " + currentGameTime.toString();
    }
}

void updateScore()
{
    score++;
    displayScore();
}

void displayScore()
{
    scoreElement.text = "Puntos: " + score.toString();
}

void update(double totalTime, double frameTime)
{
    if (currentGameTime != 0)
    {
        catapult.update(frameTime);
        ball.update(frameTime);
        crystalManager.updateCrystals(frameTime);
    }
}

void draw(Renderer renderer)
{
    renderer.begin();
    
    ball.draw(renderer);
    spoon.draw(renderer);
    catapult.draw(renderer);
    floor.draw(renderer);
    crystalManager.drawCrystals(renderer);

    if (currentGameTime == 0)
    {
        renderer.drawTexture(overlayTexture, new Vector2.zero(), 
                new Vector2.zero(), 0.0, new Vector2(960.0, 600.0));
    }
}