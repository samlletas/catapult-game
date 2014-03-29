part of engine;

class Renderer
{
    CanvasElement canvas;
    RenderingContext context;
    
    Buffer vertexPositionBuffer;  
    Buffer textureCoordBuffer;
    Program shaderProgram;
   
    int viewportWidth;
    int viewportHeight;
   
    Matrix4 modelMatrix;
    Matrix4 orthoMatrix;
   
    int aPosition;
    int aTextureCoord;
   
    UniformLocation uModelMatrix;
    UniformLocation uOrthoMatrix;
    UniformLocation uSampler;
    
    Renderer(CanvasElement canvas)
    {
        this.canvas = canvas;
        this.viewportWidth = canvas.width;
        this.viewportHeight = canvas.height;
       
        context = canvas.getContext("experimental-webgl");
       
        initializeShaders();
        initializeBuffers();
       
        context.clearColor(0, 51.0 / 255.0, 128.0 / 255.0, 1);
        context.enable(RenderingContext.BLEND);
        context.blendFunc(RenderingContext.SRC_ALPHA, RenderingContext.ONE_MINUS_SRC_ALPHA);
    }
    
    void initializeShaders()
    {
        String vertexShaderSource = """
            attribute vec3 position;
            attribute vec2 textureCoord;

            uniform mat4 modelMatrix;
            uniform mat4 orthoMatrix;

            varying vec2 vTextureCoord;

            void main(void)
            {
                gl_Position =  orthoMatrix * modelMatrix * vec4(position, 1.0);
                vTextureCoord = textureCoord;
            }
        """;
        
        String fragmentShaderSource = """
            precision mediump float;

            varying vec2 vTextureCoord;
            uniform sampler2D sampler;

            void main(void)
            { 
                gl_FragColor = texture2D(sampler, vec2(vTextureCoord.s, -vTextureCoord.t));
            }
        """;
       
        // Compilación del Vertex Shader
        Shader vertexShader = context.createShader(
            RenderingContext.VERTEX_SHADER);
        context.shaderSource(vertexShader, vertexShaderSource);
        context.compileShader(vertexShader);
       
        // Compilación del Fragment Shader
        Shader fragmentShader = context.createShader(
            RenderingContext.FRAGMENT_SHADER);
        context.shaderSource(fragmentShader, fragmentShaderSource);
        context.compileShader(fragmentShader);
       
        // Attach de los shaders al programa
        shaderProgram = context.createProgram();
        context.attachShader(shaderProgram, vertexShader);
        context.attachShader(shaderProgram, fragmentShader);
        context.linkProgram(shaderProgram);
        context.useProgram(shaderProgram);
       
        // Revisión de compilación correcta de shaders
        if (!context.getShaderParameter(vertexShader, 
            RenderingContext.COMPILE_STATUS))
        {
            print(context.getShaderInfoLog(vertexShader));
        }
       
        if (!context.getShaderParameter(fragmentShader, 
            RenderingContext.COMPILE_STATUS))
        {
            print(context.getShaderInfoLog(fragmentShader));
        }
       
        if (!context.getProgramParameter(shaderProgram,
            RenderingContext.LINK_STATUS))
        {
            print(context.getProgramInfoLog(shaderProgram));
        }
        
        aPosition = context.getAttribLocation(shaderProgram, "position");
        context.enableVertexAttribArray(aPosition);
        
        aTextureCoord = context.getAttribLocation(shaderProgram, "textureCoord");
        context.enableVertexAttribArray(aTextureCoord);
       
        uModelMatrix = context.getUniformLocation(shaderProgram, "modelMatrix");
        uOrthoMatrix = context.getUniformLocation(shaderProgram, "orthoMatrix");
        uSampler = context.getUniformLocation(shaderProgram, "sampler");
    }
   
    void initializeBuffers()
    {
        List<double> vertices;
        List<double> textureCoords;
       
        // Creación del cuadro
        vertexPositionBuffer = context.createBuffer();
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexPositionBuffer);    
       
        vertices = [
            0.0,  0.0, 0.0,
            100.0,  0.0, 0.0,
            0.0,  100.0, 0.0,
            100.0,  100.0, 0.0
        ];
       
        context.bufferDataTyped(RenderingContext.ARRAY_BUFFER, 
            new Float32List.fromList(vertices),
            RenderingContext.STATIC_DRAW);
        
        // Coordenadas de texturas
        textureCoordBuffer = context.createBuffer();
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, textureCoordBuffer);    
       
        textureCoords = [
            0.0,  0.0,
            1.0,  0.0,
            0.0,  1.0,
            1.0,  1.0
        ];
       
        context.bufferDataTyped(RenderingContext.ARRAY_BUFFER, 
            new Float32List.fromList(textureCoords),
            RenderingContext.STATIC_DRAW);
    }
    
    void setMatrixUniforms()
    {
        Float32List tmpList = new Float32List(16);

        modelMatrix.copyIntoArray(tmpList);
        context.uniformMatrix4fv(uModelMatrix, false, tmpList);
       
        orthoMatrix.copyIntoArray(tmpList);
        context.uniformMatrix4fv(uOrthoMatrix, false, tmpList);
    }
    
    void begin()
    {
        context.viewport(0, 0, viewportWidth, viewportHeight);
        context.clear(RenderingContext.COLOR_BUFFER_BIT | 
            RenderingContext.DEPTH_BUFFER_BIT); 
       
        orthoMatrix = makeOrthographicMatrix(0, viewportWidth, viewportHeight, 
                0, -1000, 1000);
    }
    
    void drawTexture(GameTexture texture, Vector2 position, Vector2 pivot, 
                     double angle, [Vector2 textureScale])
    {
        Matrix4 scale;
        Matrix4 rotation;
        Matrix4 translation;
        
        scale = new Matrix4.identity()
            ..scale(texture.width / 100.0, texture.height / 100.0);
        
        if (textureScale != null)
        {
            scale.scale(textureScale.x, textureScale.y);
        }
        
        rotation = new Matrix4.identity()
            ..translate(pivot.x, pivot.y)
            ..rotateZ(radians(angle))
            ..translate(-pivot.x, -pivot.y);
        
        translation = new Matrix4.identity()
            ..translate(position.x - pivot.x, position.y - pivot.y);
        
        modelMatrix = translation * rotation * scale;
        
        // Dibujar el cuadrado
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexPositionBuffer);
        context.vertexAttribPointer(aPosition, 3, RenderingContext.FLOAT, 
            false, 0, 0);
        
        // texture
        context.bindBuffer(RenderingContext.ARRAY_BUFFER, textureCoordBuffer);
        context.vertexAttribPointer(aTextureCoord, 2, RenderingContext.FLOAT, false, 0, 0);
        
        context.activeTexture(RenderingContext.TEXTURE0);
        context.bindTexture(RenderingContext.TEXTURE_2D, texture.textureID);
        context.uniform1i(uSampler, 0);
        
        setMatrixUniforms();
        context.drawArrays(RenderingContext.TRIANGLE_STRIP, 0, 4);
    }
}