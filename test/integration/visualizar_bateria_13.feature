Funcionalidade: Visualizar os dados de bateria do robô
Eu como Engenheiro de Sistemas Robóticos
Quero visualizar o status da bateria do robô em um dado momento
A fim de monitorar e otimizar o consumo de energia durante o funcionamento contínuo do robô

Contexto:
  Dado que eu esteja na interface que disponibiliza os dados de bateria
  E o sistema de teste de bateria está ativo

Cenário: Consulta de dados de bateria após o término do teste (triste)
  Dado que eu solicite o status da bateria em um determinado instante
  E que esse instante não existe no teste
  Então deverá ser exibida uma mensagem informando que foi possível concluir a visualização do teste de bateria, porque o instante solicitado está fora do intervalo do teste

Cenário: Status de bateria retorna dados incorretos (triste)
  Dado que eu solicite o status da bateria em um determinado instante
  E que o nível de bateria recebido pela aplicação não é um valor percentual decimal entre 0% e 100%
  Então deverá ser exibida uma mensagem informando que não foi possível concluir a visualização do teste de bateria, porque o formato dos dados é inválido

Cenário: A pesquisa de status da bateria retorna porcentagem (feliz)
  Dado que eu solicite o status da bateria em um determinado instante
  E que esse instante existe no teste
  E que o nível de bateria recebido pela aplicação é um valor percentual decimal entre 0% e 100%
  Então eu deveria ver a porcentagem da bateria correspondente desse instante