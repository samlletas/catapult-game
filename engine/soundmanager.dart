part of  engine;

class SoundManager
{
    AudioContext context;
    List<GameSound> sounds;
    int loadCount = 0;
    Function onLoadCompleteHandler;
    
    SoundManager(this.onLoadCompleteHandler)
    {
        context = new AudioContext();
        sounds = new List<GameSound>();
    }
    
    void addSound(GameSound sound)
    {
        sounds.add(sound);
    }
    
    void loadSounds()
    {
        for(int i = 0; i < sounds.length; i++)
        {
            loadBuffer(sounds[i].url, i);
        }
    }
    
    void loadBuffer(String url, int index)
    {
        HttpRequest request = new HttpRequest();
        request.open("GET", url, async: true);
        request.responseType = "arraybuffer";
        request.onLoad.listen((e) => onLoad(request, url, index));
        request.onError.listen((e) => print("BufferLoader: XHR error"));

        request.send();
    }
    
    void onLoad(HttpRequest request, String url, int index)
    {
        context.decodeAudioData(request.response).then((AudioBuffer buffer) 
        {
              if (buffer == null) 
              {
                print("Error al decodificar: $url");

                return;
              }
              
              sounds[index].initialize(context, buffer);
              loadCount++;
              
              if (loadCount == sounds.length)
              {
                  onLoadCompleteHandler();
              }
        });
    }
}