Funcionalidade: visualizar os dados de posição do robô
Eu como avaliador da navegação do robo
Quero visualizar a posição do robô em um dado momento,
Afim de analisar os percursos escolhidos durante o teste

Contexto:
  Dado que eu esteja na interfarce que disponibiliza os dados de posição
  
  Cenario: Um avaliador seleciona momento fora do escopo do teste (triste)
  Dado que o teste durou 5 minutos
  E que eu solicito a posição no momento 6:00
  E que eu clique em "gerar posição"
  Então eu deveria ver uma mensagem na tela dizendo "Não existem dados de posição para esse momento"

  Cenario: A pesquisa de posição retorna coordenadas (feliz)
  Dado que eu solicitei a posição no momento 6:00
  E que esse momento existe no teste
  Então eu deveria ver um conjunto de coodenadas em relação a posição do robo

  Cenario: A pesquisa de posição retorna dados incorretos (triste)
  Dado que eu solicitei a posição no momento 6:00
  E que esse momento existe no teste
  E que os dados recebidos pela aplicação não são númericos
  Então eu deveria ver uma mensagem na tela dizendo "não foi possível concluir a busca pelos dados"