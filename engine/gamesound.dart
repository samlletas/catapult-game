part of engine;

class GameSound
{
    String url;
    bool loop;
    
    AudioContext context;
    AudioBuffer buffer;
    
    GameSound(this.url)
    {
        loop = false;
    }
    
    void initialize(AudioContext context, AudioBuffer buffer)
    {
        this.context = context;
        this.buffer = buffer;
    }
    
    void play()
    {
        AudioBufferSourceNode source = context.createBufferSource();
        source.buffer = buffer;
        
        BiquadFilterNode filter = context.createBiquadFilter();
        filter.type = "lowpass";
        filter.frequency.value = 5000;

        source.connectNode(filter, 0, 0);
        filter.connectNode(context.destination, 0, 0); 
        
        source.start(0);
        source.loop = loop;
        
    }
}