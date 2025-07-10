# Trabalho_final-FCG
    Trabalho final da disciplina de Fundamentos De Computação Gráfica

O trabalho baseou-se na implementação de um jogo de sinuca, onde o objetivo é encaçapar todas as bolas o mais rápido o possível.

![image](https://github.com/user-attachments/assets/a61371b4-005d-4053-9980-d958549b9d93)

# Relatório
# Uso de ferramentas de IA
Durante a confecção do trabalho, a ferramenta ChatGPT foi utilizada para resolver problemas especíicos e principalmente para Debug.
A principal contribuição dela foi para ajustar o taco na câmera look-at, independente de o quanto eu tentava não estava conseguindo fazer com que ele acompanhasse a rotação em torno da bola branca. Foi muito útil para alguns debugs específicos nas colisões. Fora esses casos ou ela se mostrou limitada, se perdendo ou inventando fórmulas e soluções que não fazem sentido, ou só não foi requisitada mesmo. Do meu ponto de vista, achei muito útil sua utilização, desde que preste muita atenção no que de fato ela está fazendo, assim evitando os erros bobos que ela comete.

# Desenvolvimento do jogo
Para o desenvolvimento do jogo, usei o Git como sistema de controle de versões dos arquivos, em conjunto com o GitHub, que permitia armazenar essas mudanças em nuvem, infelizmente como tive que fazer o projeto solo não foi possível se aproveitar da plataforma para compartilhar o código com mais alguém. O desenvolvimento foi divertido mas porém cansativo, eram diversas features que precisavam ser implementadas e as vezes ao consertar algo, outra coisa acabava quebrando. 
Os conceitos da discplina foram muito úteis e indispensáveis para a execução da tarefa proposta, permitindo, por exemplo, a implementação de TODOS os requisitos mínimos, algo que me deixou muito satisfeito. Por exemplo a lógica da câmera spotlight do Lab 03, que foi crucial para a implementação da iluminação da mesa e das bolas, que possuem tanto iluminação difusa quanto Blinn-Phong. Outra coisa que foi possível implementar apenas lendo os slides foi a curva de Bézier cúbica, responsável por levar a bola branco da caçapa que ela caiu até o ponto inicial dela.


![image](https://github.com/user-attachments/assets/b526af43-3e1e-4555-a489-9b42f3106307)
a imagem mostra a bola voltando, por meio de uma curva de Bézier, até sua posição inicial


![image](https://github.com/user-attachments/assets/329a6abe-d80c-4c8c-b49c-1ee8f610b53d)
posição das bolas após a bola branca colidir com elas

# Breve descrição do funcionamento
O jogo começa com a visão ortográfica de cima da mesa, a partir daí o jogador pode fazer uma das várias ações listadas abaixo, seu objetivo é encaçapar todas as bolas o quanto antes.

- tecla C = alterna entre as câmeras look-at e free-cam
- tecla ESPAÇO = entra no modo jogada, uma camera look-at com a bola branca no centro
- botão esquerdo do mouse = gira a cãmera em todas as direções
- botão direito do mouse = carrega o taco, aumentando a força quanto mais tempo ficar segurando (exclusivo modo jogada)
- teclas W,A,S,D = movimenta a câmera para à frente, para à esquerda, para atrás e para à direita (exclusivo free-cam)
- Scroll do mouse = para frente diminui o zoom, para trás aumenta o zoom. Respectivamente aproxima a câmera ou afasta ela.
- tecla U = finaliza o jogo, encaçapando todas as bolas (cheat)
- ESC = fecha a aplicação

# Compilação
O jogo foi desenvolvido e compilado em uma máquina Linux, portanto só consigo garantir o seu funcionamente no mesmo ambiente.

Idealmente basta apenas executar o arquivo binário bin/Linux/main partindo da pasta principal.

Caso não funcione, use o comando: "make clean run" para compilar e executar a aplicação.

Todas as dependências são as mesmas do lab 05, o qual serviu de base para o trabalho.

De resto, basta aproveitar o jogo. Muito obrigado!
