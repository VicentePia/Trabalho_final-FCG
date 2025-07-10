#include "balls.hpp"
#include <glm/glm.hpp>
#include <glm/gtx/norm.hpp>
#include <vector>

glm::mat4 Matrix_Rotate_Y(float angle);

// teste esfera-esfera
bool areBallsColliding( Ball& a,  Ball& b) {
    float dist2 = glm::distance2(a.getPosition(), b.getPosition()); //dist2 vai ser (b-a)²
    float radiusSum = a.radius + b.radius;
    return dist2 < radiusSum * radiusSum;
}

bool areBallsMoving(std::vector<Ball> bolas){
    for (auto bola : bolas){
        if(bola.speed != glm::vec3(0,0,0)) return true;
    }
    return false;
}

void resolveBallCollision(Ball& a, Ball& b) {
    glm::vec3 delta = b.getPosition() - a.getPosition();
    float dist = glm::length(delta);

    if (dist == 0.0f) return;

    glm::vec3 normal = delta / dist;
    glm::vec3 relativeVelocity = a.speed - b.speed;
    float velAlongNormal = glm::dot(relativeVelocity, normal);

    float restitution = 0.9f; // colisão quase perfeitamente elástica
    //FONTE: recebi auxílio do chatgpt no linha abaixo
    float impulse = -(1 + restitution) * velAlongNormal / 2.0f;
    glm::vec3 impulseVec = impulse * normal;

    a.speed += impulseVec;
    b.speed -= impulseVec;

    // Se uma estiver em cima da outra, desloca ambas o suficiente para estarem no máximo se "tocando"
    float overlap = (a.radius + b.radius) - dist;
    glm::vec3 correction = normal * (overlap / 2.0f);
    a.setPosition(a.getPosition() - correction);
    b.setPosition(b.getPosition() + correction);
}

//teste esfera-plano
void resolveWallCollision(Ball& b,float& extraTime){
    if(b.speed == glm::vec3(0)) return;

    glm::vec3 position = b.getPosition();
    glm::vec3 wallNormal;

    if(position.x - b.radius < -2.27f && b.speed.x < 0){
        if(position.z < -1.34f || position.z > 1.28f){
            b.visible = false;
            if(b.tipo == 5){
                if(!b.animation){
                    extraTime += 10;
                    b.visible = true;
                    b.speed = glm::vec3(0);
                    b.animation = true;
                    b.animationStart = true;
                }
            }
        }
        else{
            wallNormal = glm::vec3(1,0,0);
            b.speed = b.speed - 2.0f * glm::dot(b.speed,wallNormal) * wallNormal;
        }
    }
    else if(position.x + b.radius > 3.47f && b.speed.x > 0){
        if(position.z < -1.34f || position.z > 1.28f){
            b.visible = false;
            if(b.tipo == 5){
                if(!b.animation){
                    extraTime += 10;
                    b.visible = true;
                    b.speed = glm::vec3(0);
                    b.animation = true;
                    b.animationStart = true;
                }
            }
        }
        else{
            wallNormal = glm::vec3(-1,0,0);
            b.speed = b.speed - 2.0f * glm::dot(b.speed,wallNormal) * wallNormal;
        }
    }
    if(position.z - b.radius < -1.47f && b.speed.z < 0){
        if((position.x > 0.50f && position.x < 0.72f) || 
        (position.x < -2.15f) || (position.x > 3.35f)){
            b.visible = false;
            if(b.tipo == 5){
                if(!b.animation){
                    extraTime += 10;
                    b.visible = true;
                    b.speed = glm::vec3(0);
                    b.animation = true;
                    b.animationStart = true;
                }
            }
        }
        else{
            wallNormal = glm::vec3(0,0,1);
            b.speed = b.speed - 2.0f * glm::dot(b.speed,wallNormal) * wallNormal;
        }
    }
    else if(position.z + b.radius > 1.405f && b.speed.z > 0){
        if((position.x > 0.50f && position.x < 0.72f) || 
        (position.x < -2.15f) || (position.x > 3.35f)){
            b.visible = false;
            if(b.tipo == 5){
                if(!b.animation){
                    extraTime += 10;
                    b.visible = true;
                    b.speed = glm::vec3(0);
                    b.animation = true;
                    b.animationStart = true;
                }
            }
        }
        else{
            wallNormal = glm::vec3(0,0,-1);
            b.speed = b.speed - 2.0f * glm::dot(b.speed,wallNormal) * wallNormal;
        }
    }
}

// Simula a colisão das bolas entre si e com a parede
void simulateBalls(std::vector<Ball>& balls, float time,float& extraTime) {
    for (auto& ball : balls) {
        ball.speed *= (1 - time);
        if (glm::length(ball.speed) < 0.05){
            ball.speed = glm::vec3(0);
        }
        
        ball.update(time);
    }

    for (size_t i = 0; i < balls.size(); ++i) {
        for (size_t j = i + 1; j < balls.size(); ++j) {
            if (areBallsColliding(balls[i], balls[j])) {
                if(balls[i].visible && balls[j].visible)
                resolveBallCollision(balls[i], balls[j]);
            }
        }
        resolveWallCollision(balls[i],extraTime);
    }
}

//teste ponto-plano
void resolveCamCollision(glm::vec4& pos){
    //cada if statement testa para um plano diferente
    int max = 6;
    int min = -6;
    if(pos.x > max){
        pos.x = max;
    }
    if(pos.y > max){
        pos.y = max;
    }
    if(pos.z > max){
        pos.z = max;
    }
    if(pos.x < min){
        pos.x = min;
    }
    if(pos.y < 0){
        pos.y = 0;
    }
    if(pos.z < min){
        pos.z = min;
    }
}
