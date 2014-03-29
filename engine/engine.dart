library engine;

import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:web_audio';

part 'gametexture.dart';
part 'renderer.dart';
part 'soundmanager.dart';
part 'gamesound.dart';

typedef void UpdateHandler(double totalTime, double frameTime);
typedef void RenderHandler(Renderer renderer);

class Engine
{   
    Renderer renderer;
    
    UpdateHandler onUpdate;
    RenderHandler onRender;
    
    double previousTotalTime = 0.0;
    
    Engine(CanvasElement canvas, UpdateHandler onUpdate, RenderHandler onRender)
    {
        renderer = new Renderer(canvas);
        
        this.onUpdate = onUpdate;
        this.onRender = onRender;
    } 
 
    void render(double totalTime, double frameTime)
    {       
        onUpdate(totalTime, frameTime);
        onRender(renderer);
        
        renderNextFrame();
    }
    
    void renderNextFrame()
    {
        window.requestAnimationFrame((num time) 
        { 
            render(time, time - previousTotalTime);
            previousTotalTime = time;
        });
    }
    
    void start()
    {
        renderNextFrame();
    }
}