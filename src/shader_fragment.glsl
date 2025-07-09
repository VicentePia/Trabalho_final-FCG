#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define TABLE  0
#define STICK  1
#define PLANE  2
#define LAMP   3
#define G_BALL 4
#define W_BALL 5

uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0; //Piso madeira
uniform sampler2D TextureImage1; //Mesa e taco
uniform sampler2D TextureImage2; //Luz
uniform sampler2D TextureImage3; //Luz emissiva
uniform sampler2D TextureImage4; //Bolas verdes
uniform sampler2D TextureImage5; //Bola branca

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.

    ////////
    vec4 p = position_world; //MUITO IMPORTANTE trocar para posição do modelo
    ///

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(vec4(0.0,1.0,0.0,0.0));

    //posição das 3 lâmpadas
    vec4 pos1 = vec4(-2.0f,-2.5f,0.0f,0.0f);
    vec4 pos2 = vec4(0.0f,-2.5f,0.0f,0.0f);
    vec4 pos3 = vec4(2.0f,-2.5f,0.0f,0.0f);

    vec4 lp[3] = vec4[](normalize(p - pos1),normalize(p - pos2),normalize(p - pos3));


    float cone = cos(radians(25));
    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    // Vetor que define o sentido da reflexão especular ideal.
    vec4 h = vec4(0);

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    vec3 Ks0 = vec3(0); //indíce de refração
    vec3 Kd0 = vec3(0);
    vec3 emmisive = vec3(0);
    float q = 0;

    if ( object_id == TABLE || object_id == STICK)
    {
        Kd0 = texture(TextureImage1, texcoords).rgb;
        Ks0 = vec3(0);

    }
    else if ( object_id == PLANE)
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
        Kd0 = texture(TextureImage0, vec2(U,V)).rgb;
        Ks0 = vec3(0.1,0.1,0.1);
        q = 200;
    }
    else if (object_id == LAMP){
        Kd0 = texture(TextureImage2, texcoords).rgb;
        emmisive = texture(TextureImage3, texcoords).rgb;
    }
    else if (object_id == G_BALL){
        Kd0 = texture(TextureImage4, texcoords).rgb;
        q = 30;
        Ks0 = vec3(0.7,0.7,0.7);
        // as texcoords dá bola não foram bem definidas, mas não tem problema
        // pois a ideia é a bola ter uma única cor mesmo
    }
    else if (object_id == W_BALL){
        Kd0 = texture(TextureImage5, vec2(0.5,0.5)).rgb;
        q = 50;
        Ks0 = vec3(0.7,0.7,0.7);
        // peguei um ponto qualquer da textura, pois ela é completamente branca
    }

    vec3 cores[3] = vec3[](vec3(0.0),vec3(0.0),vec3(0.0));
    float lambert = 0;
    vec3 blinn_phong_specular_term = vec3(0.0);
    // Equação de Iluminação
    for (int i = 0; i <3; i++){
        lambert = 0;
        blinn_phong_specular_term = vec3(0.0);
        if(dot(lp[i],l) > cone){
            h = normalize(v + lp[i]);
            lambert = max(0,dot(n,lp[i]));
            blinn_phong_specular_term  = Ks0 * max(0,pow(dot(n,h),q));
            cores[i] = Kd0 * (lambert + 0.1) + blinn_phong_specular_term + emmisive;
        }
        else{
            cores[i] = Kd0 * 0.05;
        }
        
    }
    //color.rgb = Kd0 * (lambert + 0.01) + blinn_phong_specular_term;

    color.rgb = cores[0] + cores[1] + cores[2];

    // NOTE: Se você quiser fazer o rendering de objetos transparentes, é
    // necessário:
    // 1) Habilitar a operação de "blending" de OpenGL logo antes de realizar o
    //    desenho dos objetos transparentes, com os comandos abaixo no código C++:
    //      glEnable(GL_BLEND);
    //      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // 2) Realizar o desenho de todos objetos transparentes *após* ter desenhado
    //    todos os objetos opacos; e
    // 3) Realizar o desenho de objetos transparentes ordenados de acordo com
    //    suas distâncias para a câmera (desenhando primeiro objetos
    //    transparentes que estão mais longe da câmera).
    // Alpha default = 1 = 100% opaco = 0% transparente
    color.a = 1;

    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color.rgb = pow(color.rgb, vec3(1.0,1.0,1.0)/2.2);
} 

