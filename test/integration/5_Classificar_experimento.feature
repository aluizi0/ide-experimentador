Funcionalidade: Classificar experimentos com uma tag

**Contexto:**
Dado que sou um usuário
E estou logado na plataforma
E estou na tela de lista dos experimentos

**Cenário: Classificar um experimento (Happy)**
Dado que eu desejo classificar um novo experimento
Quando seleciono o experimento desejado e atribuo o nome da tag
Então o experimento é classificado com sucesso e a cor é atribuída ao experimento.

**Cenário: Classificar um experimento (Sad)**
Dado que eu desejo classificar um novo experimento
Quando seleciono o experimento desejado e atribuo o nome da tag
Então o experimento não pode ser classificado, pois a tag não existe.

**Cenário: Classificar um experimento (Sad)**
Dado que eu desejo classificar um novo experimento
Quando tento classificar um experimento que não existe
Então o sistema informa que o experimento não pode ser encontrado.

**Cenário: Classificar um experimento (Sad)**
Dado que eu desejo classificar um novo experimento
Quando seleciono o experimento desejado e atribuo um nome de tag inválido
Então o experimento não pode ser classificado devido à tag inválida.
