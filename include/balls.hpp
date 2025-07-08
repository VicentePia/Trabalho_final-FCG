#pragma once
#include <glm/glm.hpp>

struct Ball
{
    glm::mat4 model;
    int tipo = 4; //4 = G_BALL 5 = W_BALL
    bool visible = true;
    float radius = 0.1f;
    glm::vec3 speed = glm::vec3(0);

    glm::vec3 getPosition(){
        return glm::vec3(model[3]); //auxilia para os cálculos de colisão
    }

    void setPosition(glm::vec3 pos){
        model[3] = glm::vec4(pos,1.0f);
    }

    void update(float time){
        setPosition(getPosition() + speed * time);
    }

};