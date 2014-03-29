part of engine;

typedef void SuccessHandler();

class GameTexture
{
    Texture textureID;
    
    int width;
    int height;
    
    void load(RenderingContext context, String imageSource, 
              [SuccessHandler handler])
    {
        textureID = context.createTexture();
        ImageElement image = new Element.tag('img');
          
        image.onLoad.listen((e) 
        {
            handleLoadedTexture(context, image);
            
//            print("width: " + image.width.toString());
//            print("height: " + image.height.toString());
            
            width = image.width;
            height = image.height;
            textureID = textureID;
            
            if (handler != null)
            {
                handler();
            }
        });
        
        image.src = imageSource;
    }
    
    void handleLoadedTexture(RenderingContext context, ImageElement img) 
    {
        context.bindTexture(RenderingContext.TEXTURE_2D, textureID);
        context.pixelStorei(RenderingContext.UNPACK_FLIP_Y_WEBGL, 1);
        context.texImage2DImage(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, img);
        context.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.LINEAR);
        context.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.LINEAR);     
        context.bindTexture(RenderingContext.TEXTURE_2D, null);
    }
}