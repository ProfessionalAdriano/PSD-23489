PSD-23489 | RSS | Erro na simulação de revisão de benefícios com incidência de ação judicial aberta.



-- PACKAGE
ATT.PACK_SBF_MEMCALCULO_PLANTIGO

-- PROCEDURE
SP_SBF_MENCALCULO_PLANTIGO


-- FUNCTION
f_ArgumentosCalculus


-- ERRO
 Argumento NumMatricParticipante não declarado...
 

Não está cadastrando os paramentros da sessão no momento que abre a tela de concessão de benefício, 
nao grava nas tabelas do Oracle.

Não hora q o usuario abre a tela executa essa cadeia de função (objetos variados)...

A aplicação amadeu que passa o controle para o objeto Oracle.
Mudar de S pra N


-- Parametrização em tempo e execução:
Cadastra em tempo de execução a sessão, como não encontra nada da erro.


No processamento do NewTst preciso da opção de debug para debugar um procedure


--Tab tipo de aposentadoria
4 - Aposentadoria especial
select * from att.especie_benef_Fss
------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
Justificativa:
Forcei o cadastro dos argumetos, antes de chamar a function que estava dando erro, porque não estava encontrando os argumetos cadastrado 
para a sessão que foi aberta.
A alteração foi para garantir que os argumentos foram cadastrados!

-- Pegar em Dev e subir uma versão em NewTst
PACK_SBF_MEMCALCULO_PLANTIGO


-- Diretório:
J:\Change_Request\Desenvolvimento\Amadeus\Capitalizacao\PSD-23489_20201104_NewTst_ADR

Executar os Scripts abaixo na ordem:
01_Atualiza_Package_Spec
02_Atualiza_package_Body

-- Executado em NewTst!!!

--Aguardando usuário validar.
--Usuário validou ok em NewTst


GMUD-5898 DCR Criada: Aguardando aprovação...
Diretorio:
J:\Change_Request\Desenvolvimento\Amadeus\Capitalizacao\GMUD-5898_20201104_Adriano_Sim_Rev_Beneficio







	


















