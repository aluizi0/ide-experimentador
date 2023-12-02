Funcionalidade: Criar um experimento baseado em planos locais

Contexto:
Dado que sou um usuário
E estou logado na plataforma
E estou na tela para adicionar um novo experimento
E não existe nenhum robô

Cenário: Registrar um novo robô (Happy)
Dado que o usuário clique no botão adicionar um novo robô
Quando clico para registra o  parâmetro nome e confirmo
Então um novo robô é registrado com sucesso.

Cenário: Registrar um novo robô (Sad)
Dado que o usuário clique no botão adicionar um novo robô
Quando clico para adicionar o parâmetro nome e confirmo
Então o robô não é adicionado devido a um erro ou à sintaxe inválida dos parâmetros.

Contexto:
Dado que sou um usuário
E estou logado na plataforma
E estou na tela para adicionar um novo experimento
E já existem um ou mais robôs

Cenário: Registrar um novo robô (Sad - Robô Existente)
Dado que o usuário deseja registrar um novo robô
Quando clico para adicionar o parâmetro nome e confirmo
Então o robô não é adicionado devido a um erro ou ao fornecimento de um nome já existente.

Contexto:
Dado que sou um usuário
E estou logado na plataforma
E estou na tela para adicionar um novo experimento
E um robô já existe.

Cenário: Registrar um novo experimento (Happy)
Dado que o usuário deseja adicionar um novo experimento
Quando forneço os parâmetros corretamente e especifico a quantidade de robôs
Então os testes são gerados como esperado.

Cenário: Registrar um novo experimento (Sad)
Dado que o usuário deseja adicionar um novo experimento
Quando forneço os parâmetros de forma inválida e especifico a quantidade de robôs
Então os testes não são gerados como esperado.
