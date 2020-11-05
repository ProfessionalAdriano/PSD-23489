-- ATT.EXECUTA_PACK_SBF_PLANT
-- ATT.SP_FCESP_SIMULA_BD_AC
-- ATT.SP_FCESP_SIMULA_BD
-- OWN_PORTAL.SF_FCESP_APOSENTAVEL
--
-- ATT_CALCULUS_ARGUMENTO_SP
-- busca as dependencias da tabela: ATT_CALCULUS_ARGUMENTO_SP
-- e dentro dessas dependencias buscas referencia de incidencias
-- de inserts do argumento "num matricula"
--
   SELECT ASR.*
     FROM ALL_DEPENDENCIES AD
         ,ALL_SOURCE ASR
    WHERE AD.REFERENCED_NAME = 'ATT_CALCULUS_ARGUMENTO_SP'
      --
      AND AD.OWNER = ASR.OWNER
      AND AD.NAME  = ASR.NAME
      AND AD.TYPE  = ASR.TYPE
      --
      --AND UPPER(ASR.TEXT) LIKE '%INSERT%ATT_CALCULUS_ARGUMENTO_SP%';
      AND UPPER(ASR.TEXT) LIKE '%VALUES%NUM%MATR%';
      -- AND UPPER(ASR.TEXT) LIKE '%Lei_8880%';
      
      -- ----------------------------------------------------------------------------------------
      SELECT * FROM ALL_SOURCE ASR WHERE ASR.TEXT LIKE '%SP_FCESP_SIMULA_BD%'
      
      SELECT * FROM ALL_DEPENDENCIES AD
      WHERE UPPER(AD.name) IN ('EXECUTA_PACK_SBF_PLANT','SP_FCESP_SIMULA_BD_AC','SP_FCESP_SIMULA_BD')
      AND AD.OWNER = 'ATT'
      AND AD.REFERENCED_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
      
-- -----------------------------------------------------------------------------------------------
-- ATT.EXECUTA_PACK_SBF_PLANT
-- ATT.PACK_SBF_MEMCALCULO_PLANTIGO
   -- f_Executa_SBF_MemCal_PlAntigo - teste 1
      -- sp_SBF_MemCalculo_PlAntigo
         --
         -- f_ArgumentosCalculus - teste 2
            -- att.PACK_CALCULUS.GetArgumentoNumerico
               -- SetaArgumento
                  -- TipoDadosArgumento - X (ERRO)
                     SELECT TipoDados
                           ,CodSessao
                         --INTO lc_TipoDados
                       FROM att_calculus_argumento_SP
                      WHERE 0 = 0
                        AND CodSessao = 77800953 -- gi_Session
                        AND NomeArgumento = 'NumMatricParticipante';
                         
                     SELECT ValorInteiro
                           ,CodSessao
                               --INTO li_ValorNumerico
                       FROM ATT_CALCULUS_ARGUMENTO_SP
                      WHERE 0= 0
                      --         AND CodSessao = gi_Session AND
                        AND NomeArgumento = 'NumMatricParticipante'; --as_Nome;
                  
                  select * from dba_objects do where do.object_name = 'PACK_CALCULUS';
-- -------------------------------------------------------------------------------------------
declare
  r_return number := 0;
begin
  -- teste - 1
  -- simula a chamada do inicio do processo, considerando os parametros passados como hardcode
  --
  -- EXECUTA_PACK_SBF_PLANT -- cadastra o argumento "NumMatricParticipante" para a sessao aberta
  -- invocar a procedure que cadastra o argumento "lei8880"
  --
  -- r_return := ATT.PACK_SBF_MEMCALCULO_PLANTIGO.f_Executa_SBF_MemCal_PlAntigo;
  --
  -- observação: foi possível reproduzir o erro e ficou constatado que a exceção é levantada
  --             devido a problemas na parametrização da tabela: att_calculus_argumento_SP
  --
  --             neste caso, estamos respeitando os parametros "chumbados" no código que subentende-se
  --             que seja a forma que a aplicação invoque essa função
  --
  -- -------------------------------------------------------------------------------------------------
  -- teste - 2
  -- simular a chamada a partir da função que queremos analisar alterando os parametros de entrada
  --
/*  r_return := ATT.PACK_SBF_MEMCALCULO_PLANTIGO.f_ArgumentosCalculus(  as_CallInterno           => 'N'
                                                                     ,an_NumMatricParticipante => 711161 -- '711161-8'
                                                                     ,an_PlanoParticipante     => 6      -- 'PSAP/Eletropaulo Alternativo'
                                                                     ,an_CodEmpresa            => 40
                                                                     ,an_NumMatricEmpregado    => 39634
                                                                     ,an_CodBenef              => 4
                                                                     ,ad_DIB                   => TO_DATE('19/08/1997','DD/MM/YYYY')
                                                                     ,ac_lei8880               => ''
                                                                    );*/
  --
  -- observação: executado sem erro. A função: f_ArgumentosCalculus, retorna 0, carrega as variáveis
  --             globais e encerra o processo;
  --
  -- --------------------------------------------------------------------------------------------------
end;

-- -----------------------------------------------------------------------------------------------------------------------
-- SIMULACAO_BD_RODAPE_FSS (PK: NUM_MATR_PARTF, NUM_SQNCL_SMLBNF, NUM_SQNCL_SMLRDP)
   SELECT * FROM ATT.SIMULACAO_BD_RODAPE_FSS SBRF WHERE SBRF.NUM_MATR_PARTF = 711161;
   
   -- SIMULACAO_BENEF_FSS (PK: NUM_MATR_PARTF, NUM_SQNCL_SMLBNF)
      SELECT * FROM ATT.SIMULACAO_BENEF_FSS SBF WHERE SBF.NUM_MATR_PARTF = 711161;
--
-- TB_RECALC_DADOS (PK: COD_EMPRS, NUM_RGTRO_EMPRG)
   SELECT * FROM ATT.TB_RECALC_DADOS TRD WHERE TRD.NUM_RGTRO_EMPRG = 39634;
--
-- ASSISTIDO_INSS_FSS (PK: NUM_SQNCL_ASINSS)
   SELECT * FROM ATT.ASSISTIDO_INSS_FSS AIF;
   
   -- SCRTBLSBNSITUACAOBENEF
      -- SELECT * FROM ATT.SCRTBLSBNSITUACAOBENEF; -- 0
      
   -- PARTICIPANTE_FSS (PK: NUM_MATR_PARTF)
      SELECT * FROM ATT.PARTICIPANTE_FSS PF WHERE PF.NUM_MATR_PARTF = 711161;
      
   -- BENEFICIO_INSS_FSS (COD_BNFINS)
      SELECT * FROM ATT.BENEFICIO_INSS_FSS BIF;
      
   -- ESPECIE_BENEF_FSS (PK: COD_ESPBNF)
      SELECT * FROM ATT.ESPECIE_BENEF_FSS EBF;
--
-- LIMITE_INSS_FSS (PK: ANO_INIVIG_LIMINS, MES_INIVIG_LIMINS)
   SELECT * FROM ATT.LIMITE_INSS_FSS;
--
-- TMP_SAL_CONTRIB_FSS (PK: NUM_MATR_PARTF, DAT_REFER_SLRCTR, MRC_FSSINS_SLRCTR)
   SELECT * FROM ATT.TMP_SAL_CONTRIB_FSS;

-- -----------------------------------------------------------------------------------------------
SELECT * FROM DBA_OBJECTS DO
WHERE DO.OBJECT_NAME LIKE '%CALCULU%'
AND DO.OWNER = 'ATT'
AND DO.OBJECT_TYPE = 'TABLE';
   
select * from dba_tab_cols dtc
where dtc.owner = 'ATT'
and upper(dtc.column_name) like upper('%lei%');

select * from ATT_CALCULUS_ARGUM a
where upper(a.s_nome) like upper('%lei%')






















