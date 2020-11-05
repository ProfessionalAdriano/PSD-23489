CREATE OR REPLACE PACKAGE BODY ATT.PACK_SBF_MEMCALCULO_PLANTIGO AS
   --======================================================================================
   --                                                                                    --
   --                               Parte comum do pack                                  --
   --                                                                                    --
   --======================================================================================
-- 1. Conteúdo = Memória de Cálculo PlAntigo do FileMaker (FBF)
-- 2. Utiliza:
--    PACK_SBF_MEMCALCULO_GERAL Para gravação na tabela simulacao_bd_rodape_fss
--    PACK_CALCULUS Para acessar os argumentos da tabela att_calculus_argumento_sp
-- 3. Argumentos identificados ==> Criar via SBF, se ainda não existir
--    33 + 28 NumMatricParticipante
--    37 PlanoParticipante
--    37 DIB
--    36 CodEmpresa
--    24 NumMatricEmpregado
--    59 CodBenef
--    SeqMemCalculo
-- ==========================>>>   Controle de Alterações   <<<============================
-- DATA       Descrição das alterações                                            Nome   --
-- ---------- ------------------------------------------------------------------- ---------
-- 12/06/2003 Disponibilizado para teste da Funcesp                               Nélio.
-- 25/06/2003 Incluido NVL nas sp´s que faltavam                                  Nélio.
--            f_ArgumentosCalculus Incluída (Argumentos globais)
   --======================================================================================
   -- = Nome:      sp_Cal_MinDat_Averb_Ant
   -- = Descrição: Calcula data de início da averbação.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_MinDat_Averb_Ant (ad_DatIniAverb  OUT incidencia_empregado.dat_inivig_incemp%TYPE) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
 SELECT nvl(MIN(incidencia_empregado.dat_inivig_incemp), TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_DatIniAverb
   FROM INCIDENCIA_EMPREGADO
  WHERE incidencia_empregado.cod_emprs  = gn_CodEmpresa_Ant AND
        incidencia_empregado.num_rgtro_emprg = gn_NumMatricEmpregado_Ant AND
        incidencia_empregado.cod_incdpc = 11 ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DatIniAverb := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_MinDat_Averb_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_MinDat_Averb_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_MinDat_Averb_Ant', TRUE);
    END sp_Cal_MinDat_Averb_Ant;
   --======================================================================================
   -- = Nome:      sp_Cal_Tem_Averb_Ant
   -- = Descrição: Calcula tempo de averbação.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_Tem_Averb_Ant (an_QtdDiaSemCtb  OUT number) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
 SELECT nvl(sum(MONTHS_BETWEEN(incidencia_empregado.dat_fimvig_incemp,incidencia_empregado.dat_inivig_incemp)), 0)
   INTO an_QtdDiaSemCtb
   FROM INCIDENCIA_EMPREGADO
  WHERE incidencia_empregado.cod_emprs = gn_CodEmpresa_Ant AND
        incidencia_empregado.num_rgtro_emprg = gn_NumMatricEmpregado_Ant AND
        incidencia_empregado.cod_incdpc = 11 ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_QtdDiaSemCtb := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_Averb_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_Averb_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_Tem_Averb_Ant', TRUE);
    END sp_Cal_Tem_Averb_Ant;
   --======================================================================================
   -- = Nome:      sp_Cal_Tem_ExperProfEsp_Ant
   -- = Descrição: Calcula tempo de experiência profissional especial.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_Tem_ExperProfEsp_Ant (an_QtdMesExperProf  OUT number) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;

   BEGIN

        an_QtdMesExperProf := (SF_CALCTEMPOSERVICOANTERIOR(gn_NumMatricParticipante_Ant,'E')/30);

--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
-- SELECT nvl(sum(MONTHS_BETWEEN (dat_saicar_htpser,dat_efecar_htpser)), 0)
--   INTO an_QtdMesExperProf
--   FROM HISTOR_TPOSER_FSS
--  WHERE histor_tposer_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
--        histor_tposer_fss.tip_aposen_htpser = 'E' ;
        -- Tratamento de erro
--        EXCEPTION
--           WHEN No_Data_Found THEN
--                an_QtdMesExperProf := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_ExperProfEsp_Ant não retornou nenhum valor');
--            WHEN too_many_rows THEN
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_ExperProfEsp_Ant mais de uma linha');
--            WHEN OTHERS THEN
--                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_Tem_ExperProfEsp_Ant', TRUE);
    END sp_Cal_Tem_ExperProfEsp_Ant;
   --======================================================================================
   -- = Nome:      sp_Cal_Tem_ExperProfNorm_Ant
   -- = Descrição: Calcula tempo de experiência profissional normal.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_Tem_ExperProfNorm_Ant (an_QtdMesExperProf  OUT number) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN

   an_QtdMesExperProf := (SF_CALCTEMPOSERVICOANTERIOR(gn_NumMatricParticipante_Ant,'N')/30);
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
-- SELECT nvl(sum(MONTHS_BETWEEN (dat_saicar_htpser,dat_efecar_htpser)), 0)
--   INTO an_QtdMesExperProf
--   FROM HISTOR_TPOSER_FSS
--  WHERE histor_tposer_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
--        histor_tposer_fss.tip_aposen_htpser = 'N';
        -- Tratamento de erro
--        EXCEPTION
--            WHEN No_Data_Found THEN
--                an_QtdMesExperProf     := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_ExperProfNorm_Ant não retornou nenhum valor');
--            WHEN too_many_rows THEN
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_ExperProfNorm_Ant mais de uma linha');
--            WHEN OTHERS THEN
--                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_Tem_ExperProfNorm_Ant', TRUE);
    END sp_Cal_Tem_ExperProfNorm_Ant;

       --======================================================================================
   -- = Nome:      sp_Cal_Tem_ExperProfNorm_Ant
   -- = Descrição: Calcula tempo de experiência profissional normal.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_Tem_ExperProfEspConc_A (an_QtdMesExperProf  OUT number) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN

   an_QtdMesExperProf := (SF_CalcTSAnteriorEmpresa(gn_NumMatricParticipante_Ant,'E') / 30);
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
-- SELECT nvl(sum(MONTHS_BETWEEN (dat_saicar_htpser,dat_efecar_htpser)), 0)
--   INTO an_QtdMesExperProf
--   FROM HISTOR_TPOSER_FSS
--  WHERE histor_tposer_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
--        histor_tposer_fss.tip_aposen_htpser = 'N';
        -- Tratamento de erro
--        EXCEPTION
--            WHEN No_Data_Found THEN
--                an_QtdMesExperProf     := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_ExperProfNorm_Ant não retornou nenhum valor');
--            WHEN too_many_rows THEN
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_ExperProfNorm_Ant mais de uma linha');
--            WHEN OTHERS THEN
--                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_Tem_ExperProfNorm_Ant', TRUE);
    END sp_Cal_Tem_ExperProfEspConc_A;
   --======================================================================================
   -- = Nome:      sp_Cal_Tem_SemCTB_Ant
   -- = Descrição: Calcula tempo Sem Contruibuição.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_Tem_SemCTB_Ant (an_QtdDiaSemCtb  OUT number) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
 SELECT nvl(sum(incidencia_empregado.dat_fimvig_incemp - incidencia_empregado.dat_inivig_incemp), 0)
   INTO an_QtdDiaSemCtb
   FROM INCIDENCIA_EMPREGADO, EMPREGADO
  WHERE incidencia_empregado.cod_emprs = empregado.COD_EMPRS AND
        incidencia_empregado.num_rgtro_emprg = empregado.NUM_RGTRO_EMPRG AND
        incidencia_empregado.cod_incdpc = 30 AND
        empregado.num_matr_partf       = gn_NumMatricParticipante_Ant ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_QtdDiaSemCtb  := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_SemCTB_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_Tem_SemCTB_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_Tem_SemCTB_Ant', TRUE);
    END sp_Cal_Tem_SemCTB_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_AdesPln_Ant
   -- = Descrição: Seleciona dados da adesão do participante.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_AdesPln_Ant (ad_DatVicPlano       OUT participante_fss.dat_vncfdc_partf%TYPE,
                                       ad_DatFimInscrPlano  OUT adesao_plano_partic_fss.dat_fim_adplpr%TYPE,
                                       ad_DatIniInscrPlano  OUT adesao_plano_partic_fss.dat_ini_adplpr%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
--        gn_PlanoParticipante_Ant       number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
 SELECT nvl(participante_fss.dat_vncfdc_partf, TO_DATE('01/01/1900','DD/MM/YYYY')),
        nvl(adesao_plano_partic_fss.dat_fim_adplpr, TO_DATE('01/01/1900','DD/MM/YYYY')),
        nvl(adesao_plano_partic_fss.dat_ini_adplpr, TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_DatVicPlano,
        ad_DatFimInscrPlano,
        ad_DatIniInscrPlano
   FROM ADESAO_PLANO_PARTIC_FSS, PARTICIPANTE_FSS
  WHERE adesao_plano_partic_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
        adesao_plano_partic_fss.num_plbnf = gn_PlanoParticipante_Ant AND
        adesao_plano_partic_fss.num_matr_partf = participante_fss.NUM_MATR_PARTF ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DatVicPlano      := TO_DATE('01/01/1900','DD/MM/YYYY');
                ad_DatFimInscrPlano := TO_DATE('01/01/1900','DD/MM/YYYY');
                ad_DatFimInscrPlano := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_AdesPln_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_AdesPln_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_AdesPln_Ant', TRUE);
    END sp_Sel_Dados_AdesPln_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_Afast_Ant
   -- = Descrição: Seleciona dados de afastamento do empregado.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_Afast_Ant (ad_DatIni     OUT afastamento.dat_inaft_afast%TYPE) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
 SELECT nvl(max(afastamento.dat_inaft_afast + 15), TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_DatIni
   FROM AFASTAMENTO
  WHERE afastamento.cod_emprs = gn_CodEmpresa_Ant AND
        afastamento.num_rgtro_emprg = gn_NumMatricEmpregado_Ant AND
        afastamento.cod_tipaft = 6 ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DatIni      := TO_DATE('01/01/1900','DD/MM/YYYY');
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_Afast_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_Afast_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_Afast_Ant', TRUE);
    END sp_Sel_Dados_Afast_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_AssisInss_Ant
   -- = Descrição: Seleciona dados da tabela Assistido Inss - Antigo.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_AssisInss_Ant (an_RendaInssAtual  OUT assistido_inss_fss.vlr_apinss_asinss%TYPE,
                                         ad_DIBINSS         OUT assistido_inss_fss.dat_apinss_asinss%TYPE) IS
        -- Declaração de variáveis locais
--         gn_NumMatricParticipante_Ant   number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
 SELECT nvl(assistido_inss_fss.vlr_apinss_asinss, 0),
        nvl(assistido_inss_fss.dat_apinss_asinss, TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO an_RendaInssAtual,
        ad_DIBINSS
   FROM ASSISTIDO_INSS_FSS
  WHERE assistido_inss_fss.num_matr_partf = gn_NumMatricParticipante_Ant
    AND assistido_inss_fss.num_sqncl_asinss IN(SELECT MAX(num_sqncl_asinss)
                                                FROM ASSISTIDO_INSS_FSS
                                               WHERE num_matr_partf = gn_NumMatricParticipante_Ant
                                               and   cod_espbnf = gn_CodBenef_Ant);
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_RendaInssAtual := 0;
                ad_DIBINSS        := TO_DATE('01/01/1900','DD/MM/YYYY');
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_AssisInss_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_AssisInss_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_AssisInss_Ant', TRUE);
    END sp_Sel_Dados_AssisInss_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_Emprg_Ant
   -- = Descrição: Seleciona dados do empregado.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_Emprg_Ant (an_BancoEmprg       OUT empregado.cod_banco%TYPE,
                                     an_AgenciaEmprg     OUT empregado.cod_agbco%TYPE,
                                     as_ContaCorrEmprg   OUT empregado.num_ctcor_emprg%TYPE,
                                     an_SexoEmprg        OUT empregado.cod_sexo_emprg%TYPE,
                                     ad_DataAdmissEmprg  OUT empregado.dat_admss_emprg%TYPE,
                                     ad_DataDesligEmprg  OUT empregado.dat_deslg_emprg%TYPE,
                                     ad_DataFalecEmprg   OUT empregado.dat_falec_emprg%TYPE,
                                     ad_DataNascEmprg    OUT empregado.dat_nascm_emprg%TYPE,
                                     as_EnderEmprg       OUT empregado.dcr_ender_emprg%TYPE,
                                     as_BairroEmprg      OUT empregado.nom_bairro_emprg%TYPE,
                                     as_MunicEmprg       OUT empregado.cod_munici%TYPE,
                                     as_EstadoEmprg      OUT empregado.cod_estado%TYPE,
                                     an_CEPEmprg         OUT empregado.cod_cep_emprg%TYPE,
                                     an_EstCivEmprg      OUT empregado.cod_estcv_emprg%TYPE,
                                     as_CIEmprg          OUT empregado.num_ci_emprg%TYPE,
                                     an_CPFEmprg         OUT empregado.num_cpf_emprg%TYPE,
                                     an_ValorSalario     OUT empregado.vlr_salar_emprg%TYPE) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
 SELECT NVL(empregado.cod_banco, 0),
        NVL(empregado.cod_agbco, 0),
        NVL(empregado.num_ctcor_emprg, ' '),
        NVL(empregado.cod_sexo_emprg, 0),
        NVL(empregado.dat_admss_emprg, TO_DATE('01/01/1900','DD/MM/YYYY')),
        NVL(empregado.dat_deslg_emprg, TO_DATE('01/01/1900','DD/MM/YYYY')),
        NVL(empregado.dat_falec_emprg, TO_DATE('01/01/1900','DD/MM/YYYY')),
        NVL(empregado.dat_nascm_emprg, TO_DATE('01/01/1900','DD/MM/YYYY')),
        NVL(empregado.dcr_ender_emprg, ' '),
        NVL(empregado.nom_bairro_emprg, ' '),
        NVL(empregado.cod_munici, ' '),
        NVL(empregado.cod_estado, ' '),
        NVL(empregado.cod_cep_emprg, 0),
        NVL(empregado.cod_estcv_emprg, 0),
        NVL(empregado.num_ci_emprg, ' '),
        NVL(empregado.num_cpf_emprg, 0),
        NVL(empregado.vlr_salar_emprg, 0)
   INTO an_BancoEmprg,
        an_AgenciaEmprg,
        as_ContaCorrEmprg,
        an_SexoEmprg,
        ad_DataAdmissEmprg,
        ad_DataDesligEmprg,
        ad_DataFalecEmprg,
        ad_DataNascEmprg,
        as_EnderEmprg,
        as_BairroEmprg,
        as_MunicEmprg,
        as_EstadoEmprg,
        an_CEPEmprg,
        an_EstCivEmprg,
        as_CIEmprg,
        an_CPFEmprg,
        an_ValorSalario
   FROM EMPREGADO
  WHERE empregado.cod_emprs            = gn_CodEmpresa_Ant AND
        empregado.num_rgtro_emprg      = gn_NumMatricEmpregado_Ant ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_BancoEmprg          := 0;
                an_AgenciaEmprg        := 0;
                as_ContaCorrEmprg      := ' ';
                an_SexoEmprg           := 0;
                ad_DataAdmissEmprg     := TO_DATE('01/01/1900','DD/MM/YYYY');
                ad_DataDesligEmprg     := TO_DATE('01/01/1900','DD/MM/YYYY');
                ad_DataFalecEmprg      := TO_DATE('01/01/1900','DD/MM/YYYY');
                ad_DataNascEmprg       := TO_DATE('01/01/1900','DD/MM/YYYY');
                as_EnderEmprg          := ' ';
                as_BairroEmprg         := ' ';
                as_MunicEmprg          := ' ';
                as_EstadoEmprg         := ' ';
                an_CEPEmprg            := 0;
                an_EstCivEmprg         := 0;
                as_CIEmprg             := ' ';
                an_CPFEmprg            := 0;
                an_ValorSalario        := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_Emprg_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_Emprg_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_Emprg_Ant', TRUE);
    END sp_Sel_Dados_Emprg_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_PercenConces_Ant
   -- = Descrição: Seleciona dados do percentual de concessão.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_PercenConces_Ant (an_PercenConcesFam  OUT percent_conc_benef_fss.pct_famili_pcccbf%TYPE,
                                            an_PercenConcesDep  OUT percent_conc_benef_fss.pct_depend_pcccbf%TYPE) IS
        -- Declaração de variáveis locais
--        gn_PlanoParticipante_Ant       number;
--        gn_CodBenef_Ant                number;
--        gd_DIB_Ant                     date;
   BEGIN
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
 SELECT nvl(percent_conc_benef_fss.pct_famili_pcccbf, 0),
        nvl(percent_conc_benef_fss.pct_depend_pcccbf, 0)
   INTO an_PercenConcesFam,
        an_PercenConcesDep
   FROM PERCENT_CONC_BENEF_FSS
  WHERE percent_conc_benef_fss.num_plbnf  = gn_PlanoParticipante_Ant AND
        percent_conc_benef_fss.cod_espbnf = gn_CodBenef_Ant     AND
        percent_conc_benef_fss.dat_inivig_bnfpln <= gd_DIB_Ant AND
        (percent_conc_benef_fss.dat_fmvgpc_pcccbf is null OR
         percent_conc_benef_fss.dat_fmvgpc_pcccbf >= gd_DIB_Ant);
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_PercenConcesFam  := 0;
                an_PercenConcesDep  := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_PercenConces_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_PercenConces_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_PercenConces_Ant', TRUE);
    END sp_Sel_Dados_PercenConces_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_TabTempSRCINSS_An
   -- = Descrição: Seleciona dados da tabela temp. de SRC - INSS.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_TabTempSRCINSS_An (an_SomaVerbasFixas  OUT tmp_sal_contrib_fss.vlr_slrctr%TYPE,
                                             an_QtdeVerbasFixas  OUT number,
                                             an_MediaVerbasFixas OUT tmp_sal_contrib_fss.vlr_slrctr%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
 SELECT nvl(sum(tmp_sal_contrib_fss.vlr_slrctr*tmp_sal_contrib_fss.ind_slrctr), 0),
        nvl(count(tmp_sal_contrib_fss.vlr_slrctr), 0),
        nvl(sum(tmp_sal_contrib_fss.vlr_slrctr*tmp_sal_contrib_fss.ind_slrctr)/count(tmp_sal_contrib_fss.vlr_slrctr), 0)
   INTO an_SomaVerbasFixas,
        an_QtdeVerbasFixas,
        an_MediaVerbasFixas
   FROM TMP_SAL_CONTRIB_FSS
  WHERE tmp_sal_contrib_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
        tmp_sal_contrib_fss.mrc_fssins_slrctr = 'I' ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_SomaVerbasFixas  := 0;
                an_QtdeVerbasFixas  := 0;
                an_MediaVerbasFixas := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_TabTempSRCINSS_An não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_TabTempSRCINSS_An mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_TabTempSRCINSS_An', TRUE);
    END sp_Sel_Dados_TabTempSRCINSS_An;
   --======================================================================================
   -- = Nome:      sp_Sel_Dib_Inss_Ant
   -- = Descrição: Seleciona Dib Inss.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Sel_Dib_Inss_Ant (ad_DibInss  OUT assistido_inss_fss.dat_apinss_asinss%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
--        gn_CodBenef_Ant                number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
 SELECT nvl(assistido_inss_fss.dat_apinss_asinss, TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_DibInss
   FROM ASSISTIDO_INSS_FSS
  WHERE assistido_inss_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
        assistido_inss_fss.cod_espbnf     = gn_CodBenef_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DibInss      := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dib_Inss_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dib_Inss_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dib_Inss_Ant', TRUE);
    END sp_Sel_Dib_Inss_Ant;
   --======================================================================================
   -- = Nome:      sp_SelMax_Data_SRCINSS_Ant
   -- = Descrição: Seleciona maior data do SRC - INSS.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_SelMax_Data_SRCINSS_Ant (ad_MaxDataRefer OUT tmp_sal_contrib_fss.dat_refer_slrctr%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
 SELECT nvl(max(tmp_sal_contrib_fss.dat_refer_slrctr), TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_MaxDataRefer
   FROM TMP_SAL_CONTRIB_FSS
  WHERE tmp_sal_contrib_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
        tmp_sal_contrib_fss.mrc_fssins_slrctr = 'I' ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_MaxDataRefer  := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_SelMax_Data_SRCINSS_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_SelMax_Data_SRCINSS_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_SelMax_Data_SRCINSS_Ant', TRUE);
    END sp_SelMax_Data_SRCINSS_Ant;
   --======================================================================================
   -- = Nome:      sp_SelMax_Data_SRCVerbaFixa_An
   -- = Descrição: Seleciona maior data do SRC - Verba Fixa.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_SelMax_Data_SRCVerbaFixa_An (ad_MaxDataRefer OUT tmp_sal_contrib_fss.dat_refer_slrctr%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
 SELECT nvl(max(tmp_sal_contrib_fss.dat_refer_slrctr), TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_MaxDataRefer
   FROM TMP_SAL_CONTRIB_FSS
  WHERE tmp_sal_contrib_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
        tmp_sal_contrib_fss.mrc_fssins_slrctr = 'F' ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_MaxDataRefer      := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_SelMax_Data_SRCVerbaFixa_An não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_SelMax_Data_SRCVerbaFixa_An mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_SelMax_Data_SRCVerbaFixa_An', TRUE);
    END sp_SelMax_Data_SRCVerbaFixa_An;
   --======================================================================================
   -- = Nome:      sp_Ver_Dat_FimExperProfEsp_Ant
   -- = Descrição: Verifica data fim exp. profissional especial atual.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Ver_Dat_FimExperProfEsp_Ant (ad_DatFim  OUT histor_tposer_fss.dat_saicar_htpser%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
 SELECT nvl(max(histor_tposer_fss.dat_saicar_htpser), TO_DATE('01/01/1900','DD/MM/YYYY'))
   INTO ad_DatFim
   FROM HISTOR_TPOSER_FSS
  WHERE histor_tposer_fss.num_matr_partf = gn_NumMatricParticipante_Ant AND
        histor_tposer_fss.tip_aposen_htpser = 'E' AND
        (histor_tposer_fss.mrc_empext_htpser <> 'S' OR
         histor_tposer_fss.mrc_empext_htpser is null) ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DatFim      := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Ver_Dat_FimExperProfEsp_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Ver_Dat_FimExperProfEsp_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Ver_Dat_FimExperProfEsp_Ant', TRUE);
    END sp_Ver_Dat_FimExperProfEsp_Ant;
   --======================================================================================
   -- = Nome:      sp_Ver_Num_TabuaAtuar_Ant
   -- = Descrição: Verifica o número da tábua atuarial.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Ver_Num_TabuaAtuar_Ant (an_NumTabAtuar  OUT tabua_atuarial.num_sqncl_tabatr%TYPE) IS
        -- Declaração de variáveis locais
--        gn_PlanoParticipante_Ant       number;
   V_plano_wk                            number;
--        gd_DIB_Ant                     date;
   BEGIN
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
---
  if     gn_CodEmpresa_Ant in (1,43,44,45,50) then
         V_plano_wk   := 4;
  elsif  gn_CodEmpresa_Ant in (3,40,41,42) then
         V_plano_wk   := 6;
  elsif  gn_CodEmpresa_Ant in(2,62,66) then
         v_plano_wk   := 5;
  else
         v_plano_wk   := 9;
  end if;
---
 SELECT nvl(tabua_atuarial.num_sqncl_tabatr, 0)
   INTO an_NumTabAtuar
   FROM TABUA_ATUARIAL, INFO_ATUARIAL_PLANO
  WHERE tabua_atuarial.num_sqncl_tabatr = info_atuarial_plano.NUM_SQNCL_TABATR AND
        tabua_atuarial.cod_nattab       = 1 AND
        info_atuarial_plano.num_plbnf   = v_plano_wk             AND
        ((info_atuarial_plano.dat_inivig_infatpl  <= gd_DIB_Ant) AND
        ((info_atuarial_plano.dat_fimvig_infatpl >= gd_DIB_Ant) OR
          (info_atuarial_plano.dat_fimvig_infatpl is null))) ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_NumTabAtuar  := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Ver_Num_TabuaAtuar_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Ver_Num_TabuaAtuar_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Ver_Num_TabuaAtuar_Ant', TRUE);
    END sp_Ver_Num_TabuaAtuar_Ant;
   --======================================================================================
   -- = Nome:      sp_Ver_Qtd_DepPrevid_Ant
   -- = Descrição: Verifica a quantidade de depend. previdenciários.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Ver_Qtd_DepPrevid_Ant (an_QdtDepPrevid  OUT number) IS
        -- Declaração de variáveis locais
--        gd_DIB_Ant                     date;
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
 SELECT nvl(count(*), 0)
   INTO an_QdtDepPrevid
   FROM REPRES_DEPEND_FSS, EMPRG_DPDTE, DEPENDENTE
  WHERE emprg_dpdte.cod_emprs          = gn_CodEmpresa_Ant AND
        emprg_dpdte.num_rgtro_emprg    = gn_NumMatricEmpregado_Ant AND
        emprg_dpdte.num_idntf_dpdte    = repres_depend_fss.NUM_IDNTF_DPDTE AND
        dependente.num_idntf_dpdte     = emprg_dpdte.NUM_IDNTF_DPDTE AND
        repres_depend_fss.mrc_dircot_repdep = 'S' AND
        repres_depend_fss.dat_inivig_repdep  <= gd_DIB_Ant AND
        (repres_depend_fss.dat_fimvig_repdep >= gd_DIB_Ant OR
         repres_depend_fss.dat_fimvig_repdep is null) AND
        repres_depend_fss.mrc_dircot_repdep  = 'S' AND
        repres_depend_fss.num_plbnf          = gn_PlanoParticipante_Ant  AND
        (((emprg_dpdte.cod_gradpc  in (02, 13, 01, 12, 11, 21, 09, 03, 08) AND
           dependente.cod_sitdep   in (01, 02, 03)) OR
          (emprg_dpdte.cod_gradpc  in (05, 04, 10, 07) AND
           dependente.cod_sitdep   = 02)) OR
         (((emprg_dpdte.cod_gradpc = 06 AND
            dependente.cod_sitdep  in (01, 02, 03)) OR
           (emprg_dpdte.cod_gradpc in (05, 04, 10, 07) AND
            dependente.cod_sitdep  in (01, 03))) AND
          MONTHS_BETWEEN (gd_DIB_Ant, dependente.dat_nasct_dpdte) <= 252));
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_QdtDepPrevid  := 0;
--              RAISE_APPLICATION_ERROR (-20020, 'Ver_Qtd_DepPrevid_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'Ver_Qtd_DepPrevid_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar Ver_Qtd_DepPrevid_Ant', TRUE);
    END sp_Ver_Qtd_DepPrevid_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Ano_DIB_Ant
   -- = Descrição: Calcula ano da DIB.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Ano_DIB_Ant RETURN number IS
        -- Declaração de variáveis locais
--        gd_DIB_Ant                     date;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        RETURN TO_NUMBER(TO_CHAR(gd_DIB_Ant,'YYYY'));
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ano_DIB_Ant', TRUE);
   END f_Cal_Ano_DIB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Mes_DIB_Ant
   -- = Descrição: Calcula mês da DIB.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Mes_DIB_Ant RETURN number IS
        -- Declaração de variáveis locais
--        gd_DIB_Ant                     date;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        RETURN TO_NUMBER(TO_CHAR(gd_DIB_Ant,'MM'));
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Mes_DIB_Ant', TRUE);
   END f_Cal_Mes_DIB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_RI_Ant
   -- = Descrição: Calcula Fator RI.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Fator_RI_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Fator_RI_Ant                number;
--        gn_PlanoParticipante_Ant       number;
   BEGIN
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
-- Retorna zero caso não se enquadre em nenhuma das alternativas.
        ln_Fator_RI_Ant                := 0;

        if    gn_CodEmpresa_Ant in(1,43,45,50) THEN ln_Fator_RI_Ant := 0.0254;
        ELSIF gn_CodEmpresa_Ant in(2,62)    THEN ln_Fator_RI_Ant := 0.0227;
        ELSIF gn_CodEmpresa_Ant in(3,40,41,42,66) THEN ln_Fator_RI_Ant := 0.0236;
        ELSIF gn_CodEmpresa_Ant = 4            THEN ln_Fator_RI_Ant := 0.0130;
        END IF;
        IF (gd_DIB_Ant < TO_DATE('08/12/1994','DD/MM/YYYY')) THEN
           IF    gn_CodEmpresa_Ant in(1,43,45,50)  THEN ln_Fator_RI_Ant := 0.0254;
           ELSIF gn_CodEmpresa_Ant in(2,62)     THEN ln_Fator_RI_Ant := 0.0227;
           ELSIF gn_CodEmpresa_Ant in(3,40,41,42,66)  THEN ln_Fator_RI_Ant := 0.0236;
           ELSIF gn_CodEmpresa_Ant = 4             THEN ln_Fator_RI_Ant := 0.0130;
           END IF;
        END IF;
        IF (gd_DIB_Ant < TO_DATE('01/03/1994','DD/MM/YYYY')) THEN
            IF    gn_CodEmpresa_Ant in(1,43,45,50) THEN ln_Fator_RI_Ant := 0.0215;
            ELSIF gn_CodEmpresa_Ant in(2,62)    THEN ln_Fator_RI_Ant := 0.0196;
            ELSIF gn_CodEmpresa_Ant in(3,40,41,42,66) THEN ln_Fator_RI_Ant := 0.0196;
            ELSIF gn_CodEmpresa_Ant = 4            THEN ln_Fator_RI_Ant := 0.0105;
            END IF;
        END IF;
        IF (gd_DIB_Ant < TO_DATE('01/03/1993','DD/MM/YYYY')) THEN
            IF    gn_CodEmpresa_Ant in(1,43,45,50)  THEN ln_Fator_RI_Ant := 0.0182;
            ELSIF gn_CodEmpresa_Ant in(2,62)     THEN ln_Fator_RI_Ant := 0.0186;
            ELSIF gn_CodEmpresa_Ant in(3,40,41,42,66)  THEN ln_Fator_RI_Ant := 0.0185;
            ELSIF gn_CodEmpresa_Ant = 4             THEN ln_Fator_RI_Ant := 1;
            END IF;
        END IF;

        RETURN ln_Fator_RI_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_RI_Ant', TRUE);
   END f_Cal_Fator_RI_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_RT_Ant
   -- = Descrição: Calcula Fator RT.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Fator_RT_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Fator_RT_Ant                number;
--        gd_DIB_Ant                     date;
--        gn_PlanoParticipante_Ant       number;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
-- Retorna zero caso não se enquadre em nenhuma das alternativas.
        ln_Fator_RT_Ant := 0;
        IF     gn_CodEmpresa_Ant in(1,43,45,50)  THEN ln_Fator_RT_Ant := 2.2204;
        ELSIF  gn_CodEmpresa_Ant in(2,62)     THEN ln_Fator_RT_Ant := 2.1674;
        ELSIF  gn_CodEmpresa_Ant in(3,40,41,42,66)  THEN ln_Fator_RT_Ant := 2.2906;
        ELSIF  gn_CodEmpresa_Ant = 4             THEN ln_Fator_RT_Ant := 2.0693;
        END IF;
        IF (gd_DIB_Ant < TO_DATE('08/12/1994','DD/MM/YYYY')) THEN
            IF    gn_CodEmpresa_Ant in(1,43,45,50)  THEN ln_Fator_RT_Ant := 2.2204;
            ELSIF gn_CodEmpresa_Ant in(2,62)     THEN ln_Fator_RT_Ant := 3.1942;
            ELSIF gn_CodEmpresa_Ant in(3,40,41,42,66)  THEN ln_Fator_RT_Ant := 2.9274;
            ELSIF gn_CodEmpresa_Ant = 4             THEN ln_Fator_RT_Ant := 2.2651;
            END IF;
        END IF;
        IF (gd_DIB_Ant < TO_DATE('01/03/1994','DD/MM/YYYY')) THEN
           IF     gn_CodEmpresa_Ant in(1,43,45,50)  THEN ln_Fator_RT_Ant := 2.5797;
           ELSIF  gn_CodEmpresa_Ant in(2,62)     THEN ln_Fator_RT_Ant := 3.6412;
           ELSIF  gn_CodEmpresa_Ant in(3,40,41,42,66)  THEN ln_Fator_RT_Ant := 3.3995;
           ELSIF  gn_CodEmpresa_Ant = 4             THEN ln_Fator_RT_Ant := 2.7647;
           END IF;
        END IF;
        IF (gd_DIB_Ant < TO_DATE('01/03/1993','DD/MM/YYYY')) THEN
            IF    gn_CodEmpresa_Ant in(1,43,45,50)  THEN ln_Fator_RT_Ant := 2.9503;
            ELSIF gn_CodEmpresa_Ant in(2,62)     THEN ln_Fator_RT_Ant := 3.8886;
            ELSIF gn_CodEmpresa_Ant in(3,40,41,42,66)  THEN ln_Fator_RT_Ant := 3.5938;
            ELSIF gn_CodEmpresa_Ant = 4             THEN ln_Fator_RT_Ant := 1;
            END IF;
        END IF;

        RETURN ln_Fator_RT_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_RT_Ant', TRUE);
   END f_Cal_Fator_RT_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Ano_AntDIB_Ant
   -- = Descrição: Calcula o ano de um mês antes da DIB.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Ano_AntDIB_Ant RETURN number IS
        -- Declaração de variáveis locais
--        gd_DIB_Ant                     date;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        RETURN TO_NUMBER(TO_CHAR(ADD_MONTHS(gd_DIB_Ant,-1),'YYYY'));
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ano_AntDIB_Ant', TRUE);
   END f_Cal_Ano_AntDIB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Mes_AntDIB_Ant
   -- = Descrição: Calcula o mês de um mês antes da DIB.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Mes_AntDIB_Ant RETURN number IS
        -- Declaração de variáveis locais
--        gd_DIB_Ant                     date;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        RETURN TO_NUMBER(TO_CHAR(ADD_MONTHS(gd_DIB_Ant,-1),'MM'));
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Mes_AntDIB_Ant', TRUE);
   END f_Cal_Mes_AntDIB_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_TabTempSRCVFixa_A
   -- = Descrição: Seleciona dados da tabela temp. de SRC - VFixa.
   -- = Nível:     2.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_TabTempSRCVFixa_A (an_SomaVerbasFixas   OUT tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE,
                                             an_QtdeVerbasFixas   OUT tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE,
                                             an_MediaVerbasFixas  OUT tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
        ld_MaxDataRefer                date;
   BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
        sp_SelMax_Data_SRCVerbaFixa_An (ld_MaxDataRefer);
 SELECT nvl(tmp_sal_contrib_fss.vlr_somcor_slrctr, 0),
        nvl(tmp_sal_contrib_fss.qtd_ctbins_slrctr, 0),
        nvl(tmp_sal_contrib_fss.vlr_sbb_slrctr, 0)
   INTO an_SomaVerbasFixas,
        an_QtdeVerbasFixas,
        an_MediaVerbasFixas
   FROM TMP_SAL_CONTRIB_FSS
  WHERE tmp_sal_contrib_fss.num_matr_partf    = gn_NumMatricParticipante_Ant AND
        tmp_sal_contrib_fss.dat_refer_slrctr  = ld_MaxDataRefer AND
        tmp_sal_contrib_fss.mrc_fssins_slrctr = 'F' ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_SomaVerbasFixas  := 0;
                an_QtdeVerbasFixas  := 0;
                an_MediaVerbasFixas := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_TabTempSRCVFixa_A não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_TabTempSRCVFixa_A mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_TabTempSRCVFixa_A', TRUE);
    END sp_Sel_Dados_TabTempSRCVFixa_A;
       --======================================================================================
   -- = Nome:      sp_Sel_Saldo_Ant
   -- = Descrição: Seleciona Saldo de Poupança.
   -- = Nível:     2.
   --======================================================================================
   PROCEDURE sp_Sel_Saldo_Ant (an_saldo   OUT number) IS
        -- Declaração de variáveis locais
--        gn_NumMatricParticipante_Ant   number;
      BEGIN
--        gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');

 select round(nvl(sum((s.vlr_sdant_sdctpr+s.vlr_entmes_sdctpr-s.vlr_saimes_sdctpr)*cd.vlr_cdiaum),0),2) Saldo_total
        into an_saldo
        from sld_conta_partic_fss s, conta_fss c, cotacao_dia_um cd
        where s.num_matr_partf = gn_NumMatricParticipante_Ant
        and s.ano_movim_sdctpr*100+s.mes_movim_sdctpr =
           (select max(ss.ano_movim_sdctpr*100+ss.mes_movim_sdctpr)
            from sld_conta_partic_fss ss
            where ss.num_matr_partf = s.num_matr_partf
            and ss.num_ctfss = s.num_ctfss
            and ss.ano_movim_sdctpr*ss.mes_movim_sdctpr <= to_char(gd_dib_ant,'YYYYMM'))
            and exists
             (select '' from regra_mov_conta_fss r
               where r.num_ctfss = s.num_ctfss
               and r.num_tpeven = 35)
               and c.num_ctfss = s.num_ctfss
               and c.cod_umarmz_ctfss = cd.cod_um
               and cd.dat_cdiaum = (select max(cotacao_dia_um.dat_cdiaum) from cotacao_dia_um
                   where cotacao_dia_um.cod_um = c.cod_umarmz_ctfss
                   and cotacao_dia_um.dat_cdiaum <= last_day(add_months(gd_dib_ant,-1)));
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_Saldo  := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_TabTempSRCVFixa_A não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Saldo_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Saldo_Ant', TRUE);
    END sp_Sel_Saldo_Ant;
   --======================================================================================
   -- = Nome:      sp_Ver_Val_LimINSS_Ant
   -- = Descrição: Verifica valor limite do INSS (teto).
   -- = Nível:     2.
   --======================================================================================
   PROCEDURE sp_Ver_Val_LimINSS_Ant (an_ValLimINSS  OUT limite_inss_fss.vlr_maximo_limins%TYPE,
                                     an_ValMinINSS  OUT limite_inss_fss.vlr_Minimo_limins%type) IS
        -- Declaração de variáveis locais
        ln_Ano_DIB_Ant                 number;
        ln_Mes_DIB_Ant                 number;
   BEGIN
        ln_Ano_DIB_Ant                 := f_Cal_Ano_DIB_Ant();
        ln_Mes_DIB_Ant                 := f_Cal_Mes_DIB_Ant();
 SELECT nvl(limite_inss_fss.vlr_maximo_limins, 0),
        nvl(limite_inss_fss.vlr_minimo_limins, 0)
   INTO an_ValLimINSS,
        an_ValMinINSS
   FROM LIMITE_INSS_FSS
  WHERE (limite_inss_fss.ano_inivig_limins < ln_Ano_DIB_Ant OR
         (limite_inss_fss.ano_inivig_limins = ln_Ano_DIB_Ant AND
          limite_inss_fss.mes_inivig_limins <= ln_Mes_DIB_Ant)) AND
        (limite_inss_fss.ano_fimvig_limins > ln_Ano_DIB_Ant OR
         (limite_inss_fss.ano_fimvig_limins = ln_Ano_DIB_Ant AND
          limite_inss_fss.mes_fimvig_limins >= ln_Mes_DIB_Ant) OR
         limite_inss_fss.ano_fimvig_limins is null) ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_ValLimINSS    := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Ver_Val_LimINSS_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Ver_Val_LimINSS_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Ver_Val_LimINSS_Ant', TRUE);
    END sp_Ver_Val_LimINSS_Ant;
--======================================================================================
   -- = Nome:      f_Cal_Fator_Cont_Ant
   -- = Descrição: Calcula fator de Contribuiçao para Especial
   -- = Nível:     2.
--======================================================================================
FUNCTION f_Cal_Fator_Cont_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Cal_Fator_Cont_Ant        number;

   BEGIN
       IF  gd_DIB_Ant  < to_date('01/feb/1994')  then
           if    gn_PlanoParticipante_Ant  = 4  then
                 ln_Cal_Fator_Cont_Ant    := 3.580;
           elsif gn_PlanoParticipante_Ant  = 5  then
                 ln_Cal_Fator_Cont_Ant    := 3.471;
           elsif gn_PlanoParticipante_Ant  = 6  then
                 ln_Cal_Fator_Cont_Ant    := 3.660;
           elsif gn_PlanoParticipante_Ant  = 7  then
                 ln_Cal_Fator_Cont_Ant    := 3.660;
           elsif gn_PlanoParticipante_Ant  = 9  then
                 ln_Cal_Fator_Cont_Ant    := 3.526;
           end if;
       else
           if    gn_PlanoParticipante_Ant  = 4  then
                 ln_Cal_Fator_Cont_Ant    := 3.220;
           elsif gn_PlanoParticipante_Ant  = 5  then
                 ln_Cal_Fator_Cont_Ant    := 3.167;
           elsif gn_PlanoParticipante_Ant  = 6  then
                 ln_Cal_Fator_Cont_Ant    := 3.291;
           elsif gn_PlanoParticipante_Ant  = 7  then
                 ln_Cal_Fator_Cont_Ant    := 3.291;
           elsif gn_PlanoParticipante_Ant  = 9  then
                 ln_Cal_Fator_Cont_Ant    := 3.069;
           end if;
        end if;
        RETURN ln_Cal_Fator_Cont_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_Cont_Ant', TRUE);
   END f_Cal_Fator_Cont_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_Pensao_Ant
   -- = Descrição: Calcula coeficiente de pensao.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Cal_Coe_Pensao_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_Pensao_Ant              number;
--        gn_CodBenef_Ant                number;
        ln_PercenConcesFam             number;
        ln_PercenConcesDep             number;
        ln_QdtDepPrevid                number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        sp_Sel_Dados_PercenConces_Ant (ln_PercenConcesFam,ln_PercenConcesDep);
        sp_Ver_Qtd_DepPrevid_Ant (ln_QdtDepPrevid);
        IF    gn_CodBenef_Ant     =  18 THEN ln_Coe_Pensao_Ant := 1;
        ELSIF gn_CodBenef_Ant     =  19 THEN ln_Coe_Pensao_Ant := (ln_PercenConcesFam / 100) + ((ln_PercenConcesDep / 100) * ln_QdtDepPrevid);
        ELSIF gn_CodBenef_Ant     <> 19 THEN ln_Coe_Pensao_Ant := 0;
        END IF;
        -- Máximo = 1.
        IF  ln_Coe_Pensao_Ant > 1 THEN ln_Coe_Pensao_Ant := 1;
        END IF;
        RETURN ln_Coe_Pensao_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_Pensao_Ant', TRUE);
   END f_Cal_Coe_Pensao_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_Pensao_INSS_Ant
   -- = Descrição: Calcula coeficiente de pensao INSS.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Cal_Coe_Pensao_INSS_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_Pensao_INSS_Ant         number;
--        gn_CodBenef_Ant                number;
        ld_DibInss                     assistido_inss_fss.dat_apinss_asinss%TYPE;
        ln_QdtDepPrevid                number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        sp_Sel_Dib_Inss_Ant (ld_DibInss);
        sp_Ver_Qtd_DepPrevid_Ant (ln_QdtDepPrevid);
        IF      gn_CodBenef_Ant           =  18 THEN
                ln_Coe_Pensao_INSS_Ant := 1;
        ELSIF   gn_CodBenef_Ant           =  19 THEN
                IF    ld_DibInss         >  TO_DATE('28/04/1995','DD/MM/YYYY') THEN
                      ln_Coe_Pensao_INSS_Ant := 1;
                ELSE
                      ln_Coe_Pensao_INSS_Ant :=  (80 + (ln_QdtDepPrevid * 10))/100;
                END IF;
        ELSIF   gn_CodBenef_Ant          <>  19 THEN
                ln_Coe_Pensao_INSS_Ant := 1;
        END IF;
        -- Máximo = 1.
        IF  ln_Coe_Pensao_INSS_Ant > 1 THEN ln_Coe_Pensao_INSS_Ant := 1;
        END IF;
        RETURN ln_Coe_Pensao_INSS_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_Pensao_INSS_Ant', TRUE);
   END f_Cal_Coe_Pensao_INSS_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Idade_Emprg_Ant
   -- = Descrição: Calcula idade do empregado.
   -- = Nível:     1.
   --======================================================================================
   FUNCTION f_Cal_Idade_Emprg_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Idade_Emprg_Ant             number;
--        gd_DIB_Ant                     date;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Idade_Emprg_Ant             := TRUNC(MONTHS_BETWEEN(gd_DIB_Ant, ld_DataNascEmprg)/12, 0);
        RETURN ln_Idade_Emprg_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Idade_Emprg_Ant', TRUE);
   END f_Cal_Idade_Emprg_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Per_SemCtb_Ant
   -- = Descrição: Calcula Percentual Sem Contribuição.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Cal_Per_SemCtb_Ant RETURN number IS
         -- Declaração de variáveis locais
        ln_Per_SemCtb_Ant              number;
        ln_QtdDiaSemCtb                number;
   BEGIN
        sp_Cal_Tem_SemCTB_Ant (ln_QtdDiaSemCtb);
        ln_Per_SemCtb_Ant              := 1 -  ( ln_QtdDiaSemCtb / 10800);
        ln_Per_SemCtb_Ant              := 1;

        /*IF ln_Per_SemCtb_Ant<=0  THEN  ln_Per_SemCtb_Ant := 1; END IF;*/
        RETURN ln_Per_SemCtb_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Per_SemCtb_Ant', TRUE);
   END f_Cal_Per_SemCtb_Ant;
      --======================================================================================
   -- = Nome:      sp_Sel_Dados_LimINSS_Ant
   -- = Descrição: Seleciona os dados do limite INSS.
   -- = Nível:     2.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_LimINSS_Ant (an_VlrMin  OUT limite_inss_fss.vlr_minimo_limins%TYPE,
                                   an_VlrMax  OUT limite_inss_fss.vlr_maximo_limins%TYPE) IS
        -- Declaração de variáveis locais
        ln_Cal_Ano_DIB_Ant            number;
        ln_Cal_Mes_DIB_Ant            number;
   BEGIN
        ln_Cal_Ano_DIB_Ant            := f_Cal_Ano_DIB_Ant();
        ln_Cal_Mes_DIB_Ant            := f_Cal_Mes_DIB_Ant();
    SELECT NVL(limite_inss_fss.vlr_minimo_limins, 0),
               NVL(limite_inss_fss.vlr_maximo_limins, 0)
          INTO an_VlrMin,
               an_VlrMax
          FROM LIMITE_INSS_FSS
         WHERE (limite_inss_fss.ano_inivig_limins * 100) + limite_inss_fss.mes_inivig_limins <= (ln_Cal_Ano_DIB_Ant * 100) + ln_Cal_Mes_DIB_Ant AND
               ((limite_inss_fss.ano_fimvig_limins * 100) + limite_inss_fss.mes_fimvig_limins >= (ln_Cal_Ano_DIB_Ant * 100) + ln_Cal_Mes_DIB_Ant OR
                limite_inss_fss.ano_fimvig_limins is null);
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_VlrMin := 0;
                an_VlrMax := 0;
                --RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_LimINSS não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_LimINSS retornou mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_LimINSS', TRUE);
    END sp_Sel_Dados_LimINSS_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_ValINSS_Ant
   -- = Descrição: Calcula valor real do INSS.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Cal_ValINSS_Ant RETURN number IS
         -- Declaração de variáveis locais
        ln_ValINSS_Ant                 number;
        ln_RendaInssAtual              assistido_inss_fss.vlr_apinss_asinss%TYPE;
        ld_DIBINSS                     assistido_inss_fss.dat_apinss_asinss%TYPE;
--   BEGIN
--        sp_Sel_Dados_AssisInss_Ant (ln_RendaInssAtual, ld_DIBINSS);
--        ln_ValINSS_Ant                 := ln_RendaInssAtual;
--        RETURN ln_ValINSS_Ant;
        -- Tratamento de erro
--        EXCEPTION
--            WHEN OTHERS THEN
--                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_ValINSS_Ant', TRUE);
--               FUNCTION f_Cal_ValINSS_Cor RETURN number IS
        -- Declaração de variáveis locais
--        gd_DIB_4819                    date;
        ln_VlrMin                      number;
        ln_VlrMax                      number;
        ln_Retorno                     number;
    BEGIN
--        gd_DIB_4819                    := PACK_CALCULUS.GetArgumentoData ('DIB');
        sp_Sel_Dados_AssisInss_Ant(ln_RendaInssAtual, ld_DIBINSS);
        sp_Sel_Dados_LimINSS_Ant(ln_VlrMin, ln_VlrMax);
        ln_Retorno := PACK_SBF_MEMCALCULO_GERAL.f_CorrigeValorINSS(ld_DIBINSS, ld_DIBINSS, gd_DIB_Ant, ln_RendaInssAtual);
       /* IF (TO_CHAR(gd_DIB_Ant, 'YYYYMM') >= '199404') and
           (TO_CHAR(gd_DIB_Ant, 'YYYYMM') <= '199407') THEN
            ln_Retorno := ln_Retorno / 2750;
        END IF;*/
        -- Valor máximo = ln_VlrMax
        IF  ln_Retorno > ln_VlrMax THEN ln_Retorno := ln_VlrMax;
        END IF;
        ln_ValINSS_Ant                 := ln_Retorno;
        RETURN ln_ValINSS_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_ValINSS_Ant', TRUE);

   END f_Cal_ValINSS_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Dat_FimExperProfEspAtu_A
   -- = Descrição: Define data fim da exp. prof. especial atual.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Def_Dat_FimExperProfEspAtu_A RETURN date IS
        -- Declaração de variáveis locais
        ld_Dat_FimExperProfEspAtu_A    date;
        ld_DatFim                      histor_tposer_fss.dat_saicar_htpser%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
   BEGIN
        sp_Ver_Dat_FimExperProfEsp_Ant (ld_DatFim);
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        IF  ld_DatFim > TO_DATE ('01/01/1900','DD/MM/YYYY') THEN
            ld_Dat_FimExperProfEspAtu_A := ADD_MONTHS(ld_DatFim, 1);
        ELSE
            ld_Dat_FimExperProfEspAtu_A := ld_DataAdmissEmprg;
        END IF;
        RETURN ld_Dat_FimExperProfEspAtu_A;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Dat_FimExperProfEspAtu_A', TRUE);
   END f_Def_Dat_FimExperProfEspAtu_A;
   --======================================================================================
   -- = Nome:      f_Def_Partic_FundCesp_Ant
   -- = Descrição: Define participante fundador - Cesp e cindidas.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Def_Partic_FundCesp_Ant RETURN varchar2 IS
        -- Declaração de variáveis locais
        ls_Partic_FundCesp_Ant         varchar2(1);
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ld_DatVicPlano                 participante_fss.dat_vncfdc_partf%TYPE;
        ld_DatFimInscrPlano            adesao_plano_partic_fss.dat_fim_adplpr%TYPE;
        ld_DatIniInscrPlano            adesao_plano_partic_fss.dat_ini_adplpr%TYPE;
        ld_DatIniAverb                 incidencia_empregado.dat_inivig_incemp%TYPE;
   BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        sp_Sel_Dados_AdesPln_Ant (ld_DatVicPlano, ld_DatFimInscrPlano,ld_DatIniInscrPlano);
        sp_Cal_MinDat_Averb_Ant (ld_DatIniAverb);
        IF   ld_DataAdmissEmprg <= TO_DATE ( '01/11/1977', 'DD/MM/YYYY') AND
           ( ld_DatVicPlano     <= TO_DATE ( '28/01/1978', 'DD/MM/YYYY') OR
           ( ld_DatIniAverb     <= TO_DATE ( '28/01/1978', 'DD/MM/YYYY') AND
             ld_DatIniAverb     <> TO_DATE ( '01/01/1900', 'DD/MM/YYYY') ) ) THEN
           ls_Partic_FundCesp_Ant      := 'S';
        ELSE
           ls_Partic_FundCesp_Ant      := 'N';
        END IF;
-----        ls_Partic_FundCesp_Ant      := 'N';
        RETURN ls_Partic_FundCesp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Partic_FundCesp_Ant', TRUE);
   END f_Def_Partic_FundCesp_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Partic_FundEletrop_Ant
   -- = Descrição: Define participante fundador - Eletrop. e cindidas.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Def_Partic_FundEletrop_Ant RETURN varchar2 IS
        -- Declaração de variáveis locais
        ls_Partic_FundEletrop_Ant      varchar2(1);
        ld_DatVicPlano                 participante_fss.dat_vncfdc_partf%TYPE;
        ld_DatFimInscrPlano            adesao_plano_partic_fss.dat_fim_adplpr%TYPE;
        ld_DatIniInscrPlano            adesao_plano_partic_fss.dat_ini_adplpr%TYPE;
        ld_DatIniAverb                 incidencia_empregado.dat_inivig_incemp%TYPE;
   BEGIN
        sp_Sel_Dados_AdesPln_Ant (ld_DatVicPlano, ld_DatFimInscrPlano,ld_DatIniInscrPlano);
        sp_Cal_MinDat_Averb_Ant (ld_DatIniAverb);
        IF ( ld_DatVicPlano   >= TO_DATE ( '01/10/1974', 'DD/MM/YYYY' )   AND
             ld_DatVicPlano   <= TO_DATE ( '14/11/1974', 'DD/MM/YYYY' ) ) OR
           ( ( ld_DatIniAverb >= TO_DATE ( '01/10/1974', 'DD/MM/YYYY' )   AND
               ld_DatIniAverb <> TO_DATE ( '01/01/1900', 'DD/MM/YYYY' ) ) AND
           (ld_DatIniAverb    <= TO_DATE ( '14/11/1974', 'DD/MM/YYYY' )   AND
            ld_DatIniAverb    <> TO_DATE ( '01/01/1900', 'DD/MM/YYYY' ) ) ) THEN
           ls_Partic_FundEletrop_Ant   := 'S';
        ELSE
           ls_Partic_FundEletrop_Ant   := 'N';
        END IF;
        RETURN ls_Partic_FundEletrop_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Partic_FundEletrop_Ant', TRUE);
   END f_Def_Partic_FundEletrop_Ant;
     --======================================================================================
   -- = Nome:      sp_Cal_MinDat_PerSemContrib_An
   -- = Descrição: Calcula data de início do periodo sem contribuição.
   -- = Nível:     1.
   --======================================================================================
   PROCEDURE sp_Cal_MinDat_PerSemContrib_An (ad_DatInipsc_Ant  OUT incidencia_empregado.dat_inivig_incemp%TYPE) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
SELECT nvl(MIN(incidencia_empregado.dat_inivig_incemp), TO_DATE('01/01/1900','DD/MM/YYYY'))
  INTO ad_DatInipsc_Ant
  FROM incidencia_empregado
 WHERE incidencia_empregado.cod_emprs       = gn_CodEmpresa_Ant AND
       incidencia_empregado.num_rgtro_emprg = gn_NumMatricEmpregado_Ant AND
       incidencia_empregado.cod_incdpc      = 39 ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DatInipsc_Ant     := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_MinDat_PerSemContrib_An não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_MinDat_PerSemContrib_An mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_MinDat_PerSemContrib_An', TRUE);
    END sp_Cal_MinDat_PerSemContrib_An;

     --======================================================================================
   -- = Nome:      sp_Cal_DatFim_PerSemContrib_An
   -- = Descrição: Calcula data Final do periodo sem Contribuição.
   -- = Nível:     2.
   --======================================================================================
   PROCEDURE sp_Cal_DatFim_PerSemContrib_An (ad_Datfimpsc_Ant  OUT incidencia_empregado.dat_fimvig_incemp%TYPE) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
        ld_DatInipsc_Ant               incidencia_empregado.dat_inivig_incemp%TYPE;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
        sp_Cal_MinDat_PerSemContrib_An (ld_DatInipsc_Ant);
SELECT nvl(incidencia_empregado.dat_fimvig_incemp, TO_DATE('01/01/1900','DD/MM/YYYY'))
  INTO ad_Datfimpsc_Ant
  FROM incidencia_empregado
 WHERE incidencia_empregado.cod_emprs         = gn_CodEmpresa_Ant AND
       incidencia_empregado.num_rgtro_emprg   = gn_NumMatricEmpregado_Ant AND
       incidencia_empregado.cod_incdpc        = 39 AND
       incidencia_empregado.dat_inivig_incemp = ld_DatInipsc_Ant ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_Datfimpsc_Ant     := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_DatFim_PerSemContrib_An não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_DatFim_PerSemContrib_An mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_DatFim_PerSemContrib_An', TRUE);
    END sp_Cal_DatFim_PerSemContrib_An;
     --======================================================================================
   -- = Nome:      f_Periodo_SemContrib_Ant
   -- = Descrição: Periodo sem contribuição.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Periodo_SemContrib_Ant RETURN VARCHAR2 IS
           -- Declaração de variáveis locais
        ls_Periodo_SemContrib_Ant      VARCHAR2(8);
        ld_DatInipsc_Ant               incidencia_empregado.dat_inivig_incemp%TYPE;
        ld_Datfimpsc_Ant               incidencia_empregado.dat_fimvig_incemp%TYPE;
   BEGIN
        sp_Cal_MinDat_PerSemContrib_An (ld_DatInipsc_Ant);
        sp_Cal_DatFim_PerSemContrib_An (ld_Datfimpsc_Ant);
        ls_Periodo_SemContrib_Ant      := PACK_SBF_MEMCALCULO_GERAL.f_PeriodoEntreDatas (ld_DatInipsc_Ant, ld_Datfimpsc_Ant);
        RETURN ls_Periodo_SemContrib_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Periodo_SemContrib_Ant', TRUE);
   END f_Periodo_SemContrib_Ant;
   --======================================================================================
   -- = Nome:      f_Ver_Num_TabuaAtuar_Ant
   -- = Descrição: Verifica o número da tábua atuarial.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Ver_Num_TabuaAtuar_Ant RETURN tabua_atuarial.num_sqncl_tabatr%TYPE IS
        -- Declaração de variáveis locais
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
   BEGIN
        sp_Ver_Num_TabuaAtuar_Ant (ln_NumTabAtuar);
        RETURN ln_NumTabAtuar;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_Num_TabuaAtuar_Ant', TRUE);
   END f_Ver_Num_TabuaAtuar_Ant;
   --======================================================================================
   -- = Nome:      f_Ver_Tem_FiliacaoPl_Ant
   -- = Descrição: Verifica Tempo de Filiação ao Plano.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Ver_Tem_FiliacaoPl_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_FiliacaoPl_Ant          number;
        ld_DatVicPlano                 participante_fss.dat_vncfdc_partf%TYPE;
        ld_DatFimInscrPlano            adesao_plano_partic_fss.dat_fim_adplpr%TYPE;
        ld_DatIniInscrPlano            adesao_plano_partic_fss.dat_ini_adplpr%TYPE;
        ln_QtdDiaSemCtb                number;
--        gd_DIB_Ant                     date;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        sp_Sel_Dados_AdesPln_Ant (ld_DatVicPlano, ld_DatFimInscrPlano,ld_DatIniInscrPlano);
        sp_Cal_Tem_Averb_Ant (ln_QtdDiaSemCtb);
        IF ld_DatFimInscrPlano > TO_DATE('01/01/1900', 'DD/MM/YYYY') THEN
           ln_Tem_FiliacaoPl_Ant       := MONTHS_BETWEEN (ld_DatFimInscrPlano, ld_DatVicPlano) + ln_QtdDiaSemCtb;

        ELSE
           ln_Tem_FiliacaoPl_Ant       := MONTHS_BETWEEN (gd_DIB_Ant, ld_DatVicPlano) + ln_QtdDiaSemCtb;
        END IF;
           ln_Tem_FiliacaoPl_Ant       := (trunc ((ln_Tem_FiliacaoPl_Ant/12),0)) * 12;
        RETURN ln_Tem_FiliacaoPl_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_Tem_FiliacaoPl_Ant', TRUE);
   END f_Ver_Tem_FiliacaoPl_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_InfoAtuar_x_Ant
   -- = Descrição: Seleciona dados das informações atuariais (x).
   -- = Nível:     3.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_InfoAtuar_x_Ant (an_ax12  OUT info_atuarial.vlr_ax12_infatr%TYPE,
                                           an_axh12 OUT info_atuarial.vlr_axh12_infatr%TYPE,
                                           an_Dx    OUT info_atuarial.vlr_dxaa_infatr%TYPE,
                                           an_Nx    OUT info_atuarial.vlr_nxaa_infatr%TYPE) IS
        -- Declaração de variáveis locais
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
        ln_Idade_Emprg_Ant             number;
   BEGIN
        -- Poderia ter utilizado a sp_Ver_Num_TabuaAtuar_Ant
        ln_NumTabAtuar                 := f_Ver_Num_TabuaAtuar_Ant();
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
SELECT nvl(info_atuarial.vlr_ax12_infatr, 0),
       nvl(info_atuarial.vlr_axh12_infatr, 0),
       nvl(info_atuarial.vlr_dxaa_infatr, 0),
       nvl(info_atuarial.vlr_nxaa_infatr, 0)
  INTO an_ax12,
       an_axh12,
       an_Dx,
       an_Nx
  FROM INFO_ATUARIAL
 WHERE info_atuarial.vlr_idade_infatr = ln_Idade_Emprg_Ant AND
       info_atuarial.num_sqncl_tabatr = ln_NumTabAtuar ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_ax12     := 0;
                an_axh12    := 0;
                an_Dx       := 0;
                an_Nx       := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_x_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_x_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_InfoAtuar_x_Ant', TRUE);
    END sp_Sel_Dados_InfoAtuar_x_Ant;

     --======================================================================================
   -- = Nome:      f_Cal_Val_PensaoINSS_Ant
   -- = Descrição: Calcula valor da pensão INSS.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Val_PensaoINSS_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Fator_SB_Ant          number;
        ln_Val_PensaoINSS_Ant          number;
--        gn_CodBenef_Ant                number;
        ln_RendaInssAtual              assistido_inss_fss.vlr_apinss_asinss%TYPE;
        ld_DIBINSS                     assistido_inss_fss.dat_apinss_asinss%TYPE;
        ln_Coe_Pensao_INSS_Ant         number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        sp_Sel_Dados_AssisInss_Ant (ln_RendaInssAtual, ld_DIBINSS);
        ln_Coe_Pensao_INSS_Ant         := f_Cal_Coe_Pensao_INSS_Ant();
        IF  gn_CodBenef_Ant     = 18 or gn_CodBenef_Ant     = 19 THEN
            ln_Val_PensaoINSS_Ant      := ln_RendaInssAtual  *  ln_Coe_Pensao_INSS_Ant;
        ELSE
            ln_Val_PensaoINSS_Ant      := 0;
        END IF;
        RETURN ln_Val_PensaoINSS_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_PensaoINSS_Ant', TRUE);
   END f_Cal_Val_PensaoINSS_Ant;
   --======================================================================================
    -- = Nome:      f_Periodo_Sem_Contrib_dia_Ant
    -- = Descrição: Periodo Sem contribuição em dias
    -- = Nível:     4.
    --======================================================================================
    FUNCTION f_Periodo_Sem_Contrib_dia_Ant RETURN NUMBER IS
        -- Declaração de variáveis locais
        ln_Periodo_Sem_Contrib_dia_Ant number;
        ls_Periodo_SemContrib_Ant      VARCHAR2(8);
    BEGIN
        ls_Periodo_SemContrib_Ant      := f_Periodo_SemContrib_Ant();
        ln_Periodo_Sem_Contrib_dia_Ant := to_number( substr( ls_Periodo_SemContrib_Ant, 1, 4 )) * 360 +
                                          to_number( substr( ls_Periodo_SemContrib_Ant, 5, 2 )) * 30  +
                                          to_number( substr( ls_Periodo_SemContrib_Ant, 7, 2 ));
        RETURN ln_Periodo_Sem_Contrib_dia_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Periodo_Sem_Contrib_dia_Ant', TRUE);
    END f_Periodo_Sem_Contrib_dia_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Tem_ExperProfNormTot_Ant
   -- = Descrição: Calcula tempo de exper. profissional normal total.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Tem_ExperProfNormTot_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ExperProfNormTot_Ant    number;
        ld_Dat_FimExperProfEspAtu_A    date;
        ln_QtdMesExperProf             number;
        ln_QtdMesExperProfEmp             number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Periodo_Sem_Contrib_dia_Ant number;
   BEGIN
        ld_Dat_FimExperProfEspAtu_A    := f_Def_Dat_FimExperProfEspAtu_A();
        sp_Cal_Tem_ExperProfNorm_Ant (ln_QtdMesExperProf);
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_QtdMesExperProfEmp := (calc_difdias(ld_DataAdmissEmprg,ld_DataDesligEmprg)/30);
        ln_Tem_ExperProfNormTot_Ant := ln_QtdMesExperProf + ln_QtdMesExperProfEmp;
        sp_Cal_Tem_ExperProfEspConc_A (ln_QtdMesExperProf);
        ln_Periodo_Sem_Contrib_dia_Ant := f_Periodo_Sem_Contrib_dia_Ant();
        ln_Tem_ExperProfNormTot_Ant := ln_Tem_ExperProfNormTot_Ant - ln_QtdMesExperProf
                                     - round((ln_Periodo_Sem_Contrib_dia_Ant / 30),0) ;
 --               ln_Tem_ExperProfNormTot_Ant := ln_QtdMesExperProf + MONTHS_BETWEEN (ld_DataDesligEmprg, ld_Dat_FimExperProfEspAtu_A);
        RETURN ln_Tem_ExperProfNormTot_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Tem_ExperProfNormTot_Ant', TRUE);
   END f_Cal_Tem_ExperProfNormTot_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Partic_Fund_Ant
   -- = Descrição: Define participante fundador.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Def_Partic_Fund_Ant RETURN varchar2 IS
        -- Declaração de variáveis locais
        ls_Partic_Fund_Ant             varchar2(1);
--        gn_PlanoParticipante_Ant       number;
        ls_Partic_FundCesp_Ant         varchar2(1);
        ls_Partic_FundEletrop_Ant      varchar2(1);
   BEGIN
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
        ls_Partic_FundCesp_Ant         := f_Def_Partic_FundCesp_Ant();
        ls_Partic_FundEletrop_Ant      := f_Def_Partic_FundEletrop_Ant();
        IF  gn_PlanoParticipante_Ant = 4 or gn_PlanoParticipante_Ant = 5    THEN
            ls_Partic_Fund_Ant         := ls_Partic_FundCesp_Ant;
        ELSE
            IF gn_PlanoParticipante_Ant = 6 or gn_PlanoParticipante_Ant = 7 THEN
               ls_Partic_Fund_Ant      := ls_Partic_FundEletrop_Ant;
            ELSE
               ls_Partic_Fund_Ant      := 'N';
            END IF;
        END IF;
        RETURN ls_Partic_Fund_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Partic_Fund_Ant', TRUE);
   END f_Def_Partic_Fund_Ant;
   --======================================================================================
   -- = Nome:      f_Ver_k_IdadeINSS_Ant
   -- = Descrição: Verifica tempo faltante carência - Idade INSS.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Ver_k_IdadeINSS_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_IdadeINSS_Ant             number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Idade_Emprg_Ant             number;
   BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
        IF ln_SexoEmprg = 'M' THEN
           ln_k_IdadeINSS_Ant          := 780 - (ln_Idade_Emprg_Ant * 12);
        ELSE
           ln_k_IdadeINSS_Ant          := 720 - (ln_Idade_Emprg_Ant * 12);
        END IF;
        ---
        if ln_k_IdadeINSS_Ant  < 0 then
           ln_k_IdadeINSS_Ant := 0;
        end if;
        RETURN ln_k_IdadeINSS_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_k_IdadeINSS_Ant', TRUE);
   END f_Ver_k_IdadeINSS_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_ResNec_Ant
   -- = Descrição: Calcula coeficiente Reserva Necessária.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Cal_Coe_ResNec_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_ResNec_Ant              number;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_ResNec_Ant              := ln_ax12 + ln_axh12;
        RETURN ln_Coe_ResNec_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_ResNec_Ant', TRUE);
   END f_Cal_Coe_ResNec_Ant;

   --======================================================================================
   -- = Nome:      f_Def_AtivFund_Emprg_Ant
   -- = Descrição: Define a atividade fundamental do empregado.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Def_AtivFund_Emprg_Ant RETURN varchar2 IS
        -- Declaração de variáveis locais
        ls_AtivFund_Emprg_Ant          varchar2(1);
--        gn_CodBenef_Ant                number;
        ln_QtdMesExperProf             number;
        ln_Tem_ExperProfNormTot_Ant    number;
        v_Count                        number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ls_AtivFund_Emprg_Ant     := 'N';
---
        select  count(*)
          into  v_count
          from  tb_recalc_dados
         where  cod_Emprs       = gn_CodEMpresa_Ant
           and  num_rgtro_emprg = gn_NumMatricEmpregado_Ant
           and  ativ_fund       = 'E';
---

        if v_count > 0 then
            ls_AtivFund_Emprg_Ant     := 'E';
        else
            sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
            ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
            IF gn_CodBenef_Ant     = 7 THEN
               ls_AtivFund_Emprg_Ant       := 'E';
            ELSE
               IF (ln_QtdMesExperProf * 1.2) = ln_Tem_ExperProfNormTot_Ant THEN
                   IF (ln_Tem_ExperProfNormTot_Ant * 0.83) > ln_QtdMesExperProf THEN
                      ls_AtivFund_Emprg_Ant := 'N';
                   ELSE
                      ls_AtivFund_Emprg_Ant := 'E';
                   END IF;
               ELSE
                   IF (ln_QtdMesExperProf * 1.2) > ln_Tem_ExperProfNormTot_Ant THEN
                       ls_AtivFund_Emprg_Ant := 'E';
                   ELSE
                       ls_AtivFund_Emprg_Ant := 'N';
                   END IF;
               END IF;
             END IF;
          end if;
        RETURN ls_AtivFund_Emprg_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_AtivFund_Emprg_Ant', TRUE);
   END f_Def_AtivFund_Emprg_Ant;
   --======================================================================================
   -- = Nome:      f_Ver_k_Filiacao_Ant
   -- = Descrição: Verifica tempo faltante carência - Filiação.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Ver_k_Filiacao_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_Filiacao_Ant              number;
--        gn_CodEmpresa_Ant              number;
        ln_Tem_FiliacaoPl_Ant          number;
        ls_Partic_Fund_Ant             varchar2(1);
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
        ln_Tem_FiliacaoPl_Ant          := f_Ver_Tem_FiliacaoPl_Ant();
        ls_Partic_Fund_Ant             := f_Def_Partic_Fund_Ant();
        IF gn_CodEmpresa_Ant = 4 THEN
           ln_k_Filiacao_Ant           := 180 - ln_Tem_FiliacaoPl_Ant;
        ELSE
           IF  ls_Partic_Fund_Ant = 'S' THEN
               ln_k_Filiacao_Ant       := 0;
           ELSE
               ln_k_Filiacao_Ant       := 180 - ln_Tem_FiliacaoPl_Ant;
           END IF;
        END IF;
        -- Valor mínimo = 0
        IF  ln_k_Filiacao_Ant < 0 THEN ln_k_Filiacao_Ant := 0;
        END IF;
        RETURN ln_k_Filiacao_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_k_Filiacao_Ant', TRUE);
   END f_Ver_k_Filiacao_Ant;
     --======================================================================================
   -- = Nome:      f_Ver_Filiacao_Anos_Ant
   -- = Descrição: Verifica  Filiação em anos.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Ver_Filiacao_Anos_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Filiacao_Anos_Ant              number;
--        gn_CodEmpresa_Ant              number;
        ln_Tem_FiliacaoPl_Ant          number;

   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
        ln_Tem_FiliacaoPl_Ant          := f_Ver_Tem_FiliacaoPl_Ant();
        ln_Filiacao_Anos_Ant := trunc((ln_Tem_FiliacaoPl_Ant /12),0);
        RETURN ln_Filiacao_Anos_Ant ;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_Filiacao_Anos_Ant', TRUE);
   END f_Ver_Filiacao_Anos_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Tem_ExperProf_Ant
   -- = Descrição: Calcula Tempo de Experiencia Profissional(Serviço).
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Cal_Tem_ExperProf_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ExperProf_Ant           number;
        ln_Tem_ExperProf_Ant_mod           number;
        ln_Tem_ExperProf_Tmp           number;
        ln_Tem_ExperProfNormTot_Ant    number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_QtdMesExperProf             number;
   BEGIN
        ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        IF  ls_AtivFund_Emprg_Ant = 'E' OR gn_CodBenef_Ant =  4 THEN
            ln_Tem_ExperProf_Tmp       := ln_QtdMesExperProf;
        ELSE
            ln_Tem_ExperProf_Tmp       := ln_QtdMesExperProf * 1.2;
        END IF;
        ln_Tem_ExperProf_Ant_mod       := mod(((ln_Tem_ExperProfNormTot_Ant + ln_Tem_ExperProf_Tmp )/12),1);
        IF   ln_Tem_ExperProf_Ant_mod >= 0.999  then
        ln_Tem_ExperProf_Ant           := round((ln_Tem_ExperProfNormTot_Ant + ln_Tem_ExperProf_Tmp )/12, 0);
        else
        ln_Tem_ExperProf_Ant           := TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_Tem_ExperProf_Tmp )/12, 0);
        end if;
        RETURN ln_Tem_ExperProf_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Tem_ExperProf_Ant', TRUE);
   END f_Cal_Tem_ExperProf_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Tem_ExperProf_INSS
   -- = Descrição: Calcula Tempo de Experiencia INSS.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Cal_Tem_ExperProf_Inss RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ExperProf_Ant           number;
        ln_Tem_ExperProf_Ant_mod       number;
        ln_Tem_ExperProf_Tmp           number;
        ln_Tem_ExperProfNormTot_Ant    number;
        ln_QtdMesExperProf             number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        ln_Tem_ExperProfNormTot_Ant  := f_Cal_Tem_ExperProfNormTot_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        IF  ln_SexoEmprg     = 'M' THEN
            ln_Tem_ExperProf_Tmp := ln_QtdMesExperProf * 1.4;
        ELSE
            ln_Tem_ExperProf_Tmp := ln_QtdMesExperProf * 1.2;
        END IF;
        ---
        ln_Tem_ExperProf_Ant_mod  := mod(((ln_Tem_ExperProfNormTot_Ant + ln_Tem_ExperProf_Tmp )/12),1);
        IF   ln_Tem_ExperProf_Ant_mod >= 0.999  then
             ln_Tem_ExperProf_Ant           := round((ln_Tem_ExperProfNormTot_Ant + ln_Tem_ExperProf_Tmp )/12, 0);
        else
             ln_Tem_ExperProf_Ant           := TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_Tem_ExperProf_Tmp )/12, 0);
        end if;
        RETURN ln_Tem_ExperProf_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Tem_ExperProf_Inss', TRUE);
   END f_Cal_Tem_ExperProf_Inss;
   --======================================================================================
   -- = Nome:      f_Ver_k_Idade_Ant
   -- = Descrição: Verifica tempo faltante carência - Idade.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Ver_k_Idade_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_Idade_Ant                 number;
--        gn_CodEmpresa_Ant              number;
--        gn_PlanoParticipante_Ant       number;
        ls_Partic_Fund_Ant             varchar2(1);
        ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_Idade_Emprg_Ant             number;
        ld_DatVicPlano                 participante_fss.dat_vncfdc_partf%TYPE;
        ld_DatFimInscrPlano            adesao_plano_partic_fss.dat_fim_adplpr%TYPE;
        ld_DatIniInscrPlano            adesao_plano_partic_fss.dat_ini_adplpr%TYPE;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
        ls_Partic_Fund_Ant             := f_Def_Partic_Fund_Ant();
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
        sp_Sel_Dados_AdesPln_Ant (ld_DatVicPlano, ld_DatFimInscrPlano, ld_DatIniInscrPlano);
    IF gn_CodEmpresa_Ant = 03 OR gn_CodEmpresa_Ant = 40 OR gn_CodEmpresa_Ant = 41 OR gn_CodEmpresa_Ant = 42 OR gn_CodEmpresa_Ant = 60 OR gn_CodEmpresa_Ant = 66 or (gn_CodEmpresa_Ant = 43 and gn_PlanoParticipante_Ant = 18) THEN
   IF  ls_Partic_Fund_Ant = 'S' THEN
       ln_k_Idade_Ant                  := 0;
   ELSE
       IF  ls_AtivFund_Emprg_Ant = 'E' THEN
           ln_k_Idade_Ant              := 636 - (ln_Idade_Emprg_Ant * 12);
       ELSE
           ln_k_Idade_Ant              := 660 - (ln_Idade_Emprg_Ant * 12);
       END IF;
   END IF;
ELSE
   IF  (ls_Partic_Fund_Ant = 'N' AND
        ld_DatVicPlano < TO_DATE ('31/12/1977', 'DD/MM/YYYY') ) or
        ls_Partic_Fund_Ant = 'S' then
        ln_k_Idade_Ant      := 0;
   ELSE
       IF  ls_AtivFund_Emprg_Ant = 'E' THEN
           ln_k_Idade_Ant              := 636 - (ln_Idade_Emprg_Ant * 12);
       ELSE
           ln_k_Idade_Ant              := 660 - (ln_Idade_Emprg_Ant * 12);
       END IF;
   END IF;
END IF;
        if ln_k_Idade_Ant   < 0 then
           ln_k_Idade_Ant := 0;
        end if;
        RETURN ln_k_Idade_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_k_Idade_Ant', TRUE);
   END f_Ver_k_Idade_Ant;
   --======================================================================================
   -- = Nome:      f_Ver_k_Tem_Serv_94_Ant
   -- = Descrição: Verifica tempo faltante carência - Tempo Serviço.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Ver_k_Tem_Serv_94_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_Tem_Serv_Ant              number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ExperProfNormTot_Ant    number;
        ln_Tem_ExperProf_mod           number;
        ln_QtdMesExperProf             number;
        ln_Tem_ExperProf_Inss          NUMBER;
        ln_Tem_ExperProf_Ant           NUMBER;
   BEGIN
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        IF  ls_AtivFund_Emprg_Ant = 'E'  OR gn_CodBenef_Ant  =  4  THEN
            ln_Tem_ExperProf_mod   := MOD(((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf )/12),1);
        else
            ln_Tem_ExperProf_mod   := MOD(((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf  )/12),1);
        end if;
        IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
        AND gn_PlanoParticipante_Ant = 4 AND
        ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0)< 25 THEN
         IF  ln_SexoEmprg = 'F' THEN
                IF   ln_Tem_ExperProf_mod >= 0.999  then
                     ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf )/12,0));
                ELSE
                     ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
                END IF;
            ELSE
                IF   ln_Tem_ExperProf_mod >= 0.999  then
                     ln_k_Tem_Serv_Ant      := 12 * (35 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf )/12,0));
                ELSE
                     ln_k_Tem_Serv_Ant      := 12 * (35 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf )/12,0));
                END IF;
               END IF;
        ELSE
        IF  ls_AtivFund_Emprg_Ant = 'E' or gn_CodBenef_Ant =  4  THEN
           IF  ln_SexoEmprg = 'F' THEN
               IF   ln_Tem_ExperProf_mod >= 0.999  then
                    ln_k_Tem_Serv_Ant      := 12 * (25 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
               ELSE
                    ln_k_Tem_Serv_Ant      := 12 * (25 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
               END IF;
           ELSE
              IF   ln_Tem_ExperProf_mod >= 0.999  then
                   ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
              ELSE
                   ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
              END IF;
           END IF;
        ELSE
            IF  ln_SexoEmprg = 'F' THEN
                IF   ln_Tem_ExperProf_mod >= 0.999  then
                     ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                ELSE
                     ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                END IF;
            ELSE
                IF   ln_Tem_ExperProf_mod >= 0.999  then
                     ln_k_Tem_Serv_Ant      := 12 * (35 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                ELSE
                     ln_k_Tem_Serv_Ant      := 12 * (35 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                END IF;
                ln_Tem_ExperProf_Inss   := f_Cal_Tem_ExperProf_Inss();
                ln_Tem_ExperProf_Ant    := f_Cal_Tem_ExperProf_Ant();
                IF   gn_CodBenef_Ant =  2  THEN
                     if  ln_Tem_ExperProf_Ant  < 30  and
                         ln_Tem_ExperProf_Inss >= 30 then
                          IF   ln_Tem_ExperProf_mod >= 0.999  then
                               ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                          ELSE
                               ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                          END IF;
                     end if;
                 end if;
             END IF;
           END IF;
        END IF;
        -- Valor mínimo = 0
        IF  ln_k_Tem_Serv_Ant < 0 THEN ln_k_Tem_Serv_Ant := 0;
        END IF;
        RETURN ln_k_Tem_Serv_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_k_Tem_Serv_94_Ant', TRUE);
   END f_Ver_k_Tem_Serv_94_Ant;
    --======================================================================================
   -- = Nome:      f_Ver_k_Tem_Serv__Fu_Ant
   -- = Descrição: Verifica tempo faltante carência - Tempo Serviço.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Ver_k_Tem_Serv_Fu_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_Tem_Serv_Ant              number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ExperProfNormTot_Ant    number;
        ln_Tem_ExperProf_mod           number;
        ln_QtdMesExperProf             number;
   BEGIN
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        IF  ls_AtivFund_Emprg_Ant = 'E'  OR
            gn_CodBenef_Ant       =  4  THEN
            ln_Tem_ExperProf_mod   := MOD(((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf )/12),1);
        else
            ln_Tem_ExperProf_mod   := MOD(((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2 )/12),1);
        end if;

        IF  ls_AtivFund_Emprg_Ant = 'E' or
            gn_CodBenef_Ant       =  4  THEN
           IF  ln_SexoEmprg = 'F' THEN
               IF   ln_Tem_ExperProf_mod >= 0.999  then
                    ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
               ELSE
                    ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
               END IF;
           ELSE
              IF   ln_Tem_ExperProf_mod >= 0.999  then
                   ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
              ELSE
                   ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0));
              END IF;
           END IF;
        ELSE
            IF  ln_SexoEmprg = 'F' THEN
                IF   ln_Tem_ExperProf_mod >= 0.999  then
                     ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                ELSE
                     ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
                END IF;
            ELSE
               IF   ln_Tem_ExperProf_mod >= 0.999  then
                    ln_k_Tem_Serv_Ant      := 12 * (30 - ROUND((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
               ELSE
                    ln_k_Tem_Serv_Ant      := 12 * (30 - TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf * 1.2)/12,0));
               END IF;
            END IF;
        END IF;
        -- Valor mínimo = 0
        IF  ln_k_Tem_Serv_Ant < 0 THEN ln_k_Tem_Serv_Ant := 0;
        END IF;
        RETURN ln_k_Tem_Serv_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_k_Tem_Serv_Fu_Ant', TRUE);
   END f_Ver_k_Tem_Serv_Fu_Ant;
   --======================================================================================
   -- = Nome:      f_Ver_k_Tem_Serv_Ant
   -- = Descrição: Verifica tempo faltante carência - Tempo Serviço.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Ver_k_Tem_Serv_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_Tem_Serv_Ant              number;
   BEGIN
        IF   gd_Dib_ant  < to_date('07-dec-1994') then
             ln_k_Tem_Serv_Ant := f_Ver_k_Tem_Serv_94_Ant();
        else
             ln_k_Tem_Serv_Ant := f_Ver_k_Tem_Serv_Fu_Ant();
        end if;
        -- Valor mínimo = 0
        IF  ln_k_Tem_Serv_Ant < 0 THEN ln_k_Tem_Serv_Ant := 0;
        END IF;
        RETURN ln_k_Tem_Serv_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Ver_k_Tem_Serv_Ant', TRUE);
   END f_Ver_k_Tem_Serv_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Per_TemServ_Ant
   -- = Descrição: Calcula Percentual Tempo de Serviço.
   -- = Nível:     6.
   --======================================================================================
   FUNCTION f_Cal_Per_TemServ_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Per_TemServ_Ant             number;
        ln_Tem_ExperProf_Ant           number;
        ln_Per_TemServ_Tmp             number;
   BEGIN
        ln_Tem_ExperProf_Ant   := f_Cal_Tem_ExperProf_Ant();
        ln_Per_TemServ_Tmp     := 0.70 + (0.01 * ln_Tem_ExperProf_Ant);
        IF ln_Per_TemServ_Tmp > 1 THEN
           ln_Per_TemServ_Ant  := 1;
        ELSE
           ln_Per_TemServ_Ant  := 1;
        END IF;
        RETURN ln_Per_TemServ_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Per_TemServ_Ant', TRUE);
   END f_Cal_Per_TemServ_Ant;
   --======================================================================================
   -- = Nome:      f_VerMax_k_Ant
   -- = Descrição: Verifica maior tempo faltante carência.
   -- = Nível:     6.
   --======================================================================================
   FUNCTION f_VerMax_k_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Max_k_Ant                   number;
        ln_Max_k_Tmp                   number;
--        gn_CodBenef_Ant                number;
        ln_k_Filiacao_Ant              number;
        ln_k_Tem_Serv_Ant              number;
        ln_k_Idade_Ant                 number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_k_Filiacao_Ant              := f_Ver_k_Filiacao_Ant();
        ln_k_Tem_Serv_Ant              := f_Ver_k_Tem_Serv_Ant();
        ln_k_Idade_Ant                 := f_Ver_k_Idade_Ant();
        IF  gn_CodBenef_Ant = 02 OR
            gn_CodBenef_Ant = 04 OR
            gn_CodBenef_Ant = 07 THEN
            IF  ln_k_Tem_Serv_Ant > ln_k_Idade_Ant THEN
                ln_Max_k_Tmp           := ln_k_Tem_Serv_Ant;
            ELSE
                ln_Max_k_Tmp           := ln_k_Idade_Ant;
            END IF;
            IF  ln_k_Filiacao_Ant > ln_Max_k_Tmp THEN
                ln_Max_k_Ant           := ln_k_Filiacao_Ant;
            ELSE
                ln_Max_k_Ant           := ln_Max_k_Tmp;
            END IF;
        ELSE
            IF  ln_k_Filiacao_Ant > ln_k_Idade_Ant THEN
                ln_Max_k_Ant               := ln_k_Filiacao_Ant;
            ELSE
                ln_Max_k_Ant               := ln_k_Idade_Ant;
            END IF;
        END IF;
        RETURN ln_Max_k_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_VerMax_k_Ant', TRUE);
   END f_VerMax_k_Ant;
    --======================================================================================
   -- = Nome:      f_VerMax_kppts_Ant
   -- = Descrição: Verifica maior tempo faltante tempo serviço.
   -- = Nível:     6.
   --======================================================================================
   FUNCTION f_VerMax_kppts_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Max_kppts_Ant               number;
        ln_Max_k_Tmp                   number;
        ln_k_Tem_Serv_Ant              number;
        ln_k_Idade_Ant                 number;
   BEGIN
        ln_k_Tem_Serv_Ant              := f_Ver_k_Tem_Serv_Ant();
        ln_k_Idade_Ant                 := f_Ver_k_Idadeinss_Ant();
        ---
---        IF  gn_CodBenef_Ant = 02 OR gn_CodBenef_Ant = 04 OR gn_CodBenef_Ant = 07 THEN
        IF  ln_k_Tem_Serv_Ant > ln_k_Idade_Ant THEN
            ln_Max_k_Tmp  := ln_k_Idade_Ant;
        ELSE
            ln_Max_k_Tmp  := ln_k_Tem_Serv_Ant;
        END IF;
        ln_Max_kppts_Ant  := ln_Max_k_Tmp;
        RETURN ln_Max_kppts_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_VerMax_kppts_Ant', TRUE);
   END f_VerMax_kppts_Ant;
    --======================================================================================
   -- = Nome:      f_VerMax_kpp_Ant
   -- = Descrição: Verifica maior tempo faltante entre idade filiacao
   -- = Nível:     6.
   --======================================================================================
   FUNCTION f_VerMax_kpp_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Max_kpp_Ant                   number;
        ln_Max_kpp_Tmp                   number;
--        gn_CodBenef_Ant                number;
        ln_kpp_Filiacao_Ant              number;
        ln_kpp_Idade_Ant                 number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_kpp_Filiacao_Ant              := f_Ver_k_Filiacao_Ant();
        ln_kpp_Idade_Ant                 := f_Ver_k_Idade_Ant();
        IF  gn_CodBenef_Ant = 02 OR gn_CodBenef_Ant = 04 OR gn_CodBenef_Ant = 07 THEN
            IF  ln_kpp_Filiacao_Ant > ln_kpp_Idade_Ant THEN
                ln_Max_kpp_Ant           := ln_kpp_Filiacao_Ant;
            ELSE
                ln_Max_kpp_Ant           := ln_kpp_Idade_Ant;
            END IF;
        ELSE
            IF  ln_kpp_Filiacao_Ant > ln_kpp_Idade_Ant THEN
                ln_Max_kpp_Ant           := ln_kpp_Filiacao_Ant;
            ELSE
                ln_Max_kpp_Ant           := ln_kpp_Idade_Ant;
            END IF;
        END IF;
        RETURN ln_Max_kpp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_VerMax_kpp_Ant', TRUE);
   END f_VerMax_kpp_Ant;
   --======================================================================================
   -- = Nome:      f_VerMax_kf_Ant
   -- = Descrição: Verifica maior tempo faltante tempo serviço.
   -- = Nível:     6.
   --======================================================================================
   FUNCTION f_VerMax_kf_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Max_kf_Ant                  number;
        ln_Max_kpp_Ant                 number;
        ln_Max_k_Tmp                   number;
        ln_k_Tem_Serv_Ant              number;
        ln_k_Idade_Ant                 number;
   BEGIN
        ln_Max_kpp_Ant                 := f_VerMax_kpp_Ant();
        ln_k_Tem_Serv_Ant              := f_Ver_k_Tem_Serv_Ant();
        ln_k_Tem_Serv_Ant              := ln_k_Tem_Serv_Ant - ln_Max_kpp_Ant;
        ---
        if ln_k_Tem_Serv_Ant < 0 then
           ln_k_Tem_Serv_Ant := 0;
        end if;
        ---
        ln_k_Idade_Ant                 := f_Ver_k_Idadeinss_Ant();
        ---
---        IF  gn_CodBenef_Ant = 02 OR gn_CodBenef_Ant = 04 OR gn_CodBenef_Ant = 07 THEN
        IF  ln_k_Tem_Serv_Ant > ln_k_Idade_Ant THEN
            ln_Max_k_Tmp  := ln_k_Idade_Ant;
        ELSE
            ln_Max_k_Tmp  := ln_k_Tem_Serv_Ant;
        END IF;
        ln_Max_kf_Ant  := ln_Max_k_Tmp;
        RETURN ln_Max_kf_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_VerMax_kf_Ant', TRUE);
   END f_VerMax_kf_Ant;

   --======================================================================================
   -- = Nome:      f_Cal_k_Ant
   -- = Descrição: Calcula k.
   -- = Nível:     7.
   --======================================================================================
   FUNCTION f_Cal_k_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_k_Ant                       number;
        ln_Max_k_Ant                   number;
        ln_k_Filiacao_Ant              number;
        ln_k_IdadeINSS_Ant             number;
   BEGIN
        ln_Max_k_Ant                   := f_VerMax_k_Ant();
        ln_k_Filiacao_Ant              := f_Ver_k_Filiacao_Ant();
        ln_k_IdadeINSS_Ant             := f_Ver_k_IdadeINSS_Ant();
        IF  ln_Max_k_Ant  = ln_k_Filiacao_Ant THEN
            ln_k_Ant                   := ln_Max_k_Ant;
        ELSE
            IF  TRUNC (ln_k_IdadeINSS_Ant, 0) < TRUNC (ln_Max_k_Ant, 0) THEN
                ln_k_Ant               := TRUNC (ln_k_IdadeINSS_Ant, 0);
                if  TRUNC (ln_k_IdadeINSS_Ant, 0) <= TRUNC (ln_k_Filiacao_Ant, 0) THEN
                    ln_k_Ant           := TRUNC (ln_k_Filiacao_Ant, 0);
                end if;
            ELSE
                ln_k_Ant               := TRUNC (ln_Max_k_Ant, 0);
            END IF;
        END IF;
        -- Valor mínimo = 0
        IF  ln_k_Ant < 0 THEN ln_k_Ant := 0;
        END IF;
        RETURN ln_k_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_k_Ant', TRUE);
   END f_Cal_k_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Tem_ExperProf_k_Ant
   -- = Descrição: Calculo tempo de exper. prof. + K.
   -- = Nível:     8.
   --======================================================================================
   FUNCTION f_Cal_Tem_ExperProf_k_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ExperProf_k_Ant         number;
        ln_Tem_ExperProf_Ant           number;
        ln_k_Ant                       number;
   BEGIN
        ln_Tem_ExperProf_Ant           := f_Cal_Tem_ExperProf_Ant();
        ln_k_Ant                       := f_Cal_k_Ant();
        ln_Tem_ExperProf_k_Ant         := ln_Tem_ExperProf_Ant + ROUND(ln_k_Ant/12,0);
---        ln_Tem_ExperProf_k_Ant         := mod((ln_Tem_ExperProf_Ant  + ln_k_Ant/12),1);
---        IF   ln_Tem_ExperProf_K_Ant    >= 0.999  then
---             ln_Tem_ExperProf_K_Ant         := round((ln_Tem_ExperProf_Ant  + ln_k_Ant )/12,0);
---        else
---             ln_Tem_ExperProf_K_Ant         := TRUNC((ln_Tem_ExperProf_Ant  + ln_k_Ant )/12,0);
---        end if;
        RETURN ln_Tem_ExperProf_k_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Tem_ExperProf_k_Ant', TRUE);
   END f_Cal_Tem_ExperProf_k_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_xk_Ant
   -- = Descrição: Calcula x+k.
   -- = Nível:     8.
   --======================================================================================
   FUNCTION f_Cal_xk_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_xk_Ant                      number;
        ln_Idade_Emprg_Ant             number;
        ln_k_Ant                       number;
   BEGIN
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
        ln_k_Ant                       := f_Cal_k_Ant();
        ln_xk_Ant                      := ln_Idade_Emprg_Ant + ROUND(ln_k_Ant/12,0);
        RETURN ln_xk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_xk_Ant', TRUE);
   END f_Cal_xk_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_xkpp_Ant
   -- = Descrição: Calcula x+k. para fins de fator pp
   -- = Nível:     8.
   --======================================================================================
   FUNCTION f_Cal_xkpp_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_xkpp_Ant                    number;
        ln_Idade_Emprg_Ant             number;
        ln_kpp_Ant                     number;
   BEGIN
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
        ln_kpp_Ant                     := f_Vermax_Kpp_Ant();
        ln_xkpp_Ant                    := ln_Idade_Emprg_Ant + ROUND(ln_kpp_Ant/12,0);
        RETURN ln_xkpp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_xkpp_Ant', TRUE);
   END f_Cal_xkpp_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_xkf_Ant
   -- = Descrição: Calcula x+kts. para fins de fator pp
   -- = Nível:     8.
   --======================================================================================
   FUNCTION f_Cal_xkf_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_xkf_Ant                     number;
        ln_Idade_Emprg_Ant             number;
        ln_kff_Ant                     number;
        ln_xkpp_Ant                    number;
   BEGIN
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
        ln_xkpp_Ant                    := f_Vermax_kpp_Ant();
        ln_xkf_Ant                     := f_Vermax_Kf_Ant();
        ln_kff_Ant                     := ln_Idade_Emprg_Ant
                                        + ROUND(ln_xkf_Ant/12,0)
                                        + ROUND(ln_xkpp_Ant/12,0);
        RETURN ln_kff_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_xkppts_Ant', TRUE);
   END f_Cal_xkf_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_xkppts_Ant
   -- = Descrição: Calcula x+kts. para fins de fator pp
   -- = Nível:     8.
   --======================================================================================
   FUNCTION f_Cal_xkppts_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_xkppts_Ant                  number;
        ln_Idade_Emprg_Ant             number;
        ln_kpp_Ant                     number;
   BEGIN
        ln_Idade_Emprg_Ant             := f_Cal_Idade_Emprg_Ant();
        ln_xkppts_Ant                  := f_Vermax_Kppts_Ant();
        ln_xkppts_Ant                  := ln_Idade_Emprg_Ant + ROUND(ln_xkppts_Ant/12,0);
        RETURN ln_xkppts_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_xkppts_Ant', TRUE);
   END f_Cal_xkppts_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_SRB_Ant
   -- = Descrição: Calcula Coeficiente SB.
   -- = Nível:     9.
   --======================================================================================
   FUNCTION f_Cal_Coe_SRB_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_fund                        varchar2(1);
        ln_Coe_SRB_Ant                 number;
        ln_Ver_Max_kppts_Ant           number;
        ln_Ver_k_IdadeInss_Ant         number;
        ln_Ver_k_Tem_Serv_Ant          number;
--        gn_CodBenef_Ant                number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ExperProf_Ant           number;
        ln_Tem_ExperProf_Wk            number;
        ln_Tem_ExperProf_Inss          number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Tem_ExperProf_Inss   := f_Cal_Tem_ExperProf_Inss();
        ln_fund                 := f_Def_Partic_Fund_Ant();
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Ver_Max_kppts_Ant    := f_Vermax_Kppts_Ant();
        ln_Ver_k_IdadeInss_Ant  := f_Ver_k_IdadeInss_Ant();
        ln_Ver_k_Tem_Serv_Ant   := f_Ver_k_Tem_Serv_Ant();

        if    gn_CodBenef_Ant  =  4 and  gd_dib_ant < to_date('07-dec-1994') then
              ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
              ln_Tem_ExperProf_wk  := ln_Tem_ExperProf_wk + round(ln_Ver_Max_kppts_Ant/12,0);
        else
              if   gd_dib_ant < to_date('07-dec-1994') then
                  ln_Tem_ExperProf_Wk := f_Cal_Tem_ExperProf_Ant();
              else
                  ln_Tem_ExperProf_wk := f_Cal_Tem_ExperProf_K_Ant();
              end if;
        end if;

        ---

        IF  gn_CodBenef_Ant IN( 3, 5, 6, 7, 18, 19, 21 ) THEN
            ln_Coe_SRB_Ant  := 1;
        ELSE
            IF  ln_SexoEmprg = 'F' THEN
                 ln_Coe_SRB_Ant        := 1;
            ELSE
                IF  ln_Tem_ExperProf_Wk < 30 THEN
                    ln_Coe_SRB_Ant        := 0;
                ELSE
                    IF    ln_Tem_ExperProf_Wk = 30 Then ln_Coe_SRB_Ant := 0.80;
                    ELSIF ln_Tem_ExperProf_Wk = 31 Then ln_Coe_SRB_Ant := 0.83;
                    ELSIF ln_Tem_ExperProf_Wk = 32 Then ln_Coe_SRB_Ant := 0.86;
                    ELSIF ln_Tem_ExperProf_Wk = 33 Then ln_Coe_SRB_Ant := 0.89;
                    ELSIF ln_Tem_ExperProf_Wk = 34 Then ln_Coe_SRB_Ant := 0.92;
                    ELSE  ln_Coe_SRB_Ant  := 1;
                    END IF;
                END IF;
            END IF;
        END IF;
        -- Máximo = 1.
        IF  ln_Coe_SRB_Ant > 1 THEN ln_Coe_SRB_Ant := 1;
        END IF;
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();


        IF  gn_CodBenef_Ant in (2,4) and
            ln_Ver_k_IdadeInss_Ant < ln_Ver_k_Tem_Serv_Ant THEN
            ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
            IF ln_Tem_ExperProf_wk+round(ln_Ver_k_IdadeInss_Ant/12,0) <= 30  THEN
                ln_Coe_SRB_Ant := 1;
            end if;
        else
            IF  gn_CodBenef_Ant         =  2  and
                ln_Tem_ExperProf_wk     < 30  and
                ln_Tem_ExperProf_Inss  >= 30  then
                ln_Coe_SRB_Ant := 0.80;
            end if;
        end if;
        ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
         IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_wk< 25 AND gd_dib_ant < to_date('07-dec-1994') THEN
            ln_Coe_SRB_Ant   := 1.00;
        END IF;
        RETURN ln_Coe_SRB_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_SRB_Ant', TRUE);
   END f_Cal_Coe_SRB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_SRBx_Ant
   -- = Descrição: Calcula Coeficiente SB em x pafa fins de fator pp
   -- = Nível:     9.
   --======================================================================================
   FUNCTION f_Cal_Coe_SRBx_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_SRBx_Ant                number;
--        gn_CodBenef_Ant                number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ExperProf_Ant           number;
         ln_Tem_ExperProf_wk           number;
         ls_AtivFund_Emprg_Ant          varchar2(1);
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Tem_ExperProf_Ant         := f_Cal_Tem_ExperProf_Ant();
        IF  gn_CodBenef_Ant IN(3) THEN
            ln_Coe_SRBx_Ant := 1;
        ELSE
            ln_Coe_SRBx_Ant := ln_Tem_ExperProf_Ant / 35;
        END IF;
---
        -- Máximo = 1.
        IF  ln_Coe_SRBx_Ant > 1 THEN
            ln_Coe_SRBx_Ant := 1;
        else
            if ln_Coe_SRBx_Ant <= 0.8571 then
               ln_Coe_SRBx_Ant := 0.8571;
            end if;
        END IF;
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
        IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_wk < 25 AND gd_dib_ant < to_date('07-dec-1994') THEN
            ln_Coe_SRBX_Ant   := 1.00;
       END IF;
        RETURN ln_Coe_SRBx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_SRBx_Ant', TRUE);
   END f_Cal_Coe_SRBx_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_SRBxk_Ant
   -- = Descrição: Calcula Coeficiente SB em xk pafa fins de fator pp
   -- = Nível:     9.
   --======================================================================================
   FUNCTION f_Cal_Coe_SRBxk_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_SRBxk_Ant               number;
--        gn_CodBenef_Ant                number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ExperProf_Ant           number;
         ln_Tem_ExperProf_wk           number;
         ls_AtivFund_Emprg_Ant          varchar2(1);
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Tem_ExperProf_Ant         := f_Cal_Tem_ExperProf_Ant();
        IF  gn_CodBenef_Ant IN(3) THEN
            ln_Coe_SRBxk_Ant := 1;
        ELSE
            ln_Coe_SRBxk_Ant := (ln_Tem_ExperProf_Ant + f_Vermax_Kpp_Ant / 12)
                                      / 35;
        END IF;
---
        -- Máximo = 1.
        IF  ln_Coe_SRBxk_Ant > 1 THEN
            ln_Coe_SRBxk_Ant := 1;
        else
            if ln_Coe_SRBxk_Ant <= 0.8571 then
               ln_Coe_SRBxk_Ant := 0.8571;
            end if;
        END IF;
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
        IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_wk < 25 AND gd_dib_ant < to_date('07-dec-1994') THEN
            ln_Coe_SRBxk_Ant   := 1.00;
       END IF;
        RETURN ln_Coe_SRBxk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_SRBxk_Ant', TRUE);
   END f_Cal_Coe_SRBxk_Ant;
   --======================================================================================
   -- = Nome:      sp_Sel_Dados_InfoAtuar_xk_Ant
   -- = Descrição: Seleciona dados das informações atuariais (x+k).
   -- = Nível:     9.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_InfoAtuar_xk_Ant (an_axk12  OUT info_atuarial.vlr_ax12_infatr%TYPE,
                                            an_axkh12 OUT info_atuarial.vlr_axh12_infatr%TYPE,
                                            an_Dxk    OUT info_atuarial.vlr_dxaa_infatr%TYPE,
                                            an_Nxk    OUT info_atuarial.vlr_nxaa_infatr%TYPE) IS
        -- Declaração de variáveis locais
        ln_xk_Ant                      number;
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
   BEGIN
        -- Poderia ter utilizado a sp_Ver_Num_TabuaAtuar_Ant
        ln_xk_Ant                      := f_Cal_xk_Ant();
        ln_NumTabAtuar                 := f_Ver_Num_TabuaAtuar_Ant();
SELECT nvl(info_atuarial.vlr_ax12_infatr, 0),
       nvl(info_atuarial.vlr_axh12_infatr, 0),
       nvl(info_atuarial.vlr_dxaa_infatr, 0),
       nvl(info_atuarial.vlr_nxaa_infatr, 0)
  INTO an_axk12,
       an_axkh12,
       an_Dxk,
       an_Nxk
  FROM INFO_ATUARIAL
 WHERE info_atuarial.vlr_idade_infatr = ln_xk_Ant AND
       info_atuarial.num_sqncl_tabatr = ln_NumTabAtuar ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_axk12     := 0;
                an_axkh12    := 0;
                an_Dxk       := 0;
                an_Nxk       := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xk_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xk_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_InfoAtuar_xk_Ant', TRUE);
    END sp_Sel_Dados_InfoAtuar_xk_Ant;
     --======================================================================================
   -- = Nome:      sp_Sel_Dados_InfoAtuar_xkpp_Ant
   -- = Descrição: Seleciona dados das informações atuariais (x+k).
   -- = Nível:     9.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_InfoAtuar_xkpp (an_axk12  OUT info_atuarial.vlr_ax12_infatr%TYPE,
                                          an_axkh12 OUT info_atuarial.vlr_axh12_infatr%TYPE,
                                          an_Dxk    OUT info_atuarial.vlr_dxaa_infatr%TYPE,
                                          an_Nxk    OUT info_atuarial.vlr_nxaa_infatr%TYPE) IS
        -- Declaração de variáveis locais
        ln_xkpp_Ant                    number;
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
   BEGIN
        -- Poderia ter utilizado a sp_Ver_Num_TabuaAtuar_Ant
        ln_xkpp_Ant                      := f_Cal_xkpp_Ant();
        ln_NumTabAtuar                 := f_Ver_Num_TabuaAtuar_Ant();
SELECT nvl(info_atuarial.vlr_ax12_infatr, 0),
       nvl(info_atuarial.vlr_axh12_infatr, 0),
       nvl(info_atuarial.vlr_dxaa_infatr, 0),
       nvl(info_atuarial.vlr_nxaa_infatr, 0)
  INTO an_axk12,
       an_axkh12,
       an_Dxk,
       an_Nxk
  FROM INFO_ATUARIAL
 WHERE info_atuarial.vlr_idade_infatr = ln_xkpp_Ant AND
       info_atuarial.num_sqncl_tabatr = ln_NumTabAtuar ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_axk12     := 0;
                an_axkh12    := 0;
                an_Dxk       := 0;
                an_Nxk       := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xk_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xkpp_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_InfoAtuar_xkpp_Ant', TRUE);
    END sp_Sel_Dados_InfoAtuar_xkpp;
           --======================================================================================
   -- = Nome:      sp_Sel_Dados_InfoAtuar_xkppts_Ant
   -- = Descrição: Seleciona dados das informações atuariais (x+k).
   -- = Nível:     9.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_InfoAtuar_xkppts (an_axk12  OUT info_atuarial.vlr_ax12_infatr%TYPE,
                                            an_axkh12 OUT info_atuarial.vlr_axh12_infatr%TYPE,
                                            an_Dxk    OUT info_atuarial.vlr_dxaa_infatr%TYPE,
                                            an_Nxk    OUT info_atuarial.vlr_nxaa_infatr%TYPE) IS
        -- Declaração de variáveis locais
        ln_xkppts_Ant                  number;
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
   BEGIN
        -- Poderia ter utilizado a sp_Ver_Num_TabuaAtuar_Ant
        ln_xkppts_Ant                  := f_Cal_xkppts_Ant();
        ln_NumTabAtuar                 := f_Ver_Num_TabuaAtuar_Ant();
SELECT nvl(info_atuarial.vlr_ax12_infatr, 0),
       nvl(info_atuarial.vlr_axh12_infatr, 0),
       nvl(info_atuarial.vlr_dxaa_infatr, 0),
       nvl(info_atuarial.vlr_nxaa_infatr, 0)
  INTO an_axk12,
       an_axkh12,
       an_Dxk,
       an_Nxk
  FROM INFO_ATUARIAL
 WHERE info_atuarial.vlr_idade_infatr = ln_xkppts_Ant AND
       info_atuarial.num_sqncl_tabatr = ln_NumTabAtuar ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_axk12     := 0;
                an_axkh12    := 0;
                an_Dxk       := 0;
                an_Nxk       := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xk_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xkppts_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_InfoAtuar_xkppts_Ant', TRUE);
    END sp_Sel_Dados_InfoAtuar_xkppts;
     --======================================================================================
   -- = Nome:      sp_Sel_Dados_InfoAtuar_xf_Ant
   -- = Descrição: Seleciona dados das informações atuariais (x).
   -- = Nível:     3.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_InfoAtuar_xf_Ant (an_ax12  OUT info_atuarial.vlr_ax12_infatr%TYPE,
                                            an_axh12 OUT info_atuarial.vlr_axh12_infatr%TYPE,
                                            an_Dx    OUT info_atuarial.vlr_dxaa_infatr%TYPE,
                                            an_Nx    OUT info_atuarial.vlr_nxaa_infatr%TYPE) IS
        -- Declaração de variáveis locais
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
        ln_Idade_Emprg_Ant             number;
        ln_xkpp_Ant                    number;
   BEGIN
        -- Poderia ter utilizado a sp_Ver_Num_TabuaAtuar_Ant
        ln_NumTabAtuar          := f_Ver_Num_TabuaAtuar_Ant();
        ln_Idade_Emprg_Ant      := f_Cal_Idade_Emprg_Ant();
        ln_xkpp_Ant             := f_VerMax_kpp_Ant();
        ln_Idade_Emprg_Ant      := ln_Idade_Emprg_Ant + round(ln_xkpp_Ant /12,0);
SELECT nvl(info_atuarial.vlr_ax12_infatr, 0),
       nvl(info_atuarial.vlr_axh12_infatr, 0),
       nvl(info_atuarial.vlr_dxaa_infatr, 0),
       nvl(info_atuarial.vlr_nxaa_infatr, 0)
  INTO an_ax12,
       an_axh12,
       an_Dx,
       an_Nx
  FROM INFO_ATUARIAL
 WHERE info_atuarial.vlr_idade_infatr = ln_Idade_Emprg_Ant AND
       info_atuarial.num_sqncl_tabatr = ln_NumTabAtuar ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_ax12     := 0;
                an_axh12    := 0;
                an_Dx       := 0;
                an_Nx       := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_x_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_x_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_InfoAtuar_x_Ant', TRUE);
    END sp_Sel_Dados_InfoAtuar_xf_Ant;
         --======================================================================================
   -- = Nome:      sp_Sel_Dados_InfoAtuar_xkf_Ant
   -- = Descrição: Seleciona dados das informações atuariais (x+k).
   -- = Nível:     9.
   --======================================================================================
   PROCEDURE sp_Sel_Dados_InfoAtuar_xkf_Ant (an_axk12  OUT info_atuarial.vlr_ax12_infatr%TYPE,
                                            an_axkh12 OUT info_atuarial.vlr_axh12_infatr%TYPE,
                                            an_Dxk    OUT info_atuarial.vlr_dxaa_infatr%TYPE,
                                            an_Nxk    OUT info_atuarial.vlr_nxaa_infatr%TYPE) IS
        -- Declaração de variáveis locais
        ln_xkf_Ant                     number;
        ln_NumTabAtuar                 tabua_atuarial.num_sqncl_tabatr%TYPE;
   BEGIN
        -- Poderia ter utilizado a sp_Ver_Num_TabuaAtuar_Ant
        ln_xkf_Ant               := f_Cal_xkf_Ant();
        ln_NumTabAtuar           := f_Ver_Num_TabuaAtuar_Ant();
SELECT nvl(info_atuarial.vlr_ax12_infatr, 0),
       nvl(info_atuarial.vlr_axh12_infatr, 0),
       nvl(info_atuarial.vlr_dxaa_infatr, 0),
       nvl(info_atuarial.vlr_nxaa_infatr, 0)
  INTO an_axk12,
       an_axkh12,
       an_Dxk,
       an_Nxk
  FROM INFO_ATUARIAL
 WHERE info_atuarial.vlr_idade_infatr = ln_xkf_Ant AND
       info_atuarial.num_sqncl_tabatr = ln_NumTabAtuar ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                an_axk12     := 0;
                an_axkh12    := 0;
                an_Dxk       := 0;
                an_Nxk       := 0;
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xk_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Sel_Dados_InfoAtuar_xkppts_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Sel_Dados_InfoAtuar_xkf_Ant', TRUE);
    END sp_Sel_Dados_InfoAtuar_xkf_Ant;
       --======================================================================================
   -- = Nome:      f_Cal_Coe_SB_Ant
   -- = Descrição: Calcula Coeficiente SB.
   -- = Nível:     9.
   --======================================================================================
   FUNCTION f_Cal_Coe_SB_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_SB_Ant                  number;
        ln_fund                        varchar2(1);
        nqtd_anoctb_asinss             number;
        ln_maior_k                     number;
--        gn_CodBenef_Ant                number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_Tem_ExperProf_Ant           number;
        ln_Tem_ExperProf_Inss          number;
        ln_Tem_ServTotal_Ant           number;
        ln_Ver_Max_kppts_Ant           number;
        ln_Ver_k_IdadeInss_Ant         number;
        ln_Ver_k_Tem_Serv_Ant          number;
        ln_Ver_K_Filiacao_Ant          number;
        ln_Tem_ExperProf_Wk            number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
   BEGIN
         ln_Ver_Max_kppts_Ant    := f_Vermax_Kppts_Ant();
         ln_Ver_K_Filiacao_Ant   := f_Ver_K_Filiacao_Ant();
         ln_Ver_k_IdadeInss_Ant  := f_Ver_k_IdadeInss_Ant();
         ln_Ver_k_Tem_Serv_Ant   := f_Ver_k_Tem_Serv_Ant();
         ln_fund                 := f_Def_Partic_Fund_Ant();
         ln_Tem_ExperProf_Inss   := f_Cal_Tem_ExperProf_Inss();
         ls_AtivFund_Emprg_Ant   := f_Def_AtivFund_Emprg_Ant();

        if    gn_CodBenef_Ant  =  4 and  gd_dib_ant < to_date('07-dec-1994') then
              ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
              ln_Tem_ExperProf_wk  := ln_Tem_ExperProf_wk + round(ln_Ver_Max_kppts_Ant/12,0);
        else
              if   gd_dib_ant < to_date('07-dec-1994') then
                   ln_Tem_ExperProf_wk   := f_Cal_Tem_ExperProf_Ant();
              else
                   IF gn_CodBenef_Ant  = 4 THEN
                      ln_Tem_ExperProf_wk   := f_Cal_Tem_ExperProf_K_Ant();
                   ELSE
                       IF   gn_CodBenef_Ant  = 2 THEN
                            ln_Tem_ExperProf_wk   := f_Cal_Tem_ExperProf_K_Ant();
                       end if;
                   END IF;
              end if;
        end if;
        ---
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);

       IF  gn_CodBenef_Ant = 3 THEN
            ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
            if  gd_dib_ant < to_date('07-dec-1994') then
                ln_Coe_SB_Ant   := 0.70 + (0.01 * ln_Tem_ExperProf_wk);
            else
                ln_Coe_SB_Ant   := 0.70 + (0.01 * (ln_Tem_ExperProf_wk + (ln_Ver_K_Filiacao_Ant /12 )));
            end if;
        ELSE
            IF  gn_CodBenef_Ant IN(2,4) THEN
                IF  ln_SexoEmprg = 'F' THEN
                    IF  ln_Tem_ExperProf_wk < 25 THEN
                        ln_Coe_SB_Ant := 0;
                    ELSE
                        ln_Coe_SB_Ant := 1;
                    END IF;
                ELSE
                       IF  ln_Tem_ExperProf_wk < 30 THEN
                           ln_Coe_SB_Ant       := 0;
                       ELSE
                           IF    ln_Tem_ExperProf_wk = 30 THEN ln_Coe_SB_Ant := 0.70;
                           ELSIF ln_Tem_ExperProf_wk = 31 THEN ln_Coe_SB_Ant := 0.76;
                           ELSIF ln_Tem_ExperProf_wk = 32 THEN ln_Coe_SB_Ant := 0.82;
                           ELSIF ln_Tem_ExperProf_wk = 33 THEN ln_Coe_SB_Ant := 0.88;
                           ELSIF ln_Tem_ExperProf_wk = 34 THEN ln_Coe_SB_Ant := 0.94;
                           ELSE  ln_Coe_SB_Ant := 1;
                           END IF;
                      END IF;
                END IF;
            ELSE
                ln_Coe_SB_Ant := 1;
            END IF;
        end if;

---
        SELECT  max(nvl(qtd_anoctb_asinss,0))
          INTO  nqtd_anoctb_asinss
          FROM  assistido_inss_fss
         WHERE  NUM_MATR_PARTF     = gn_NumMatricParticipante_Ant
           AND  cod_bnfins         = 931
           and  dat_apinss_asinss <= gd_dib_ant ;
---
         if  nqtd_anoctb_asinss <> 0   then     /* (aux doe)  */
             ln_Coe_SB_Ant := 0.80 + (0.01 * nqtd_anoctb_asinss);
         END IF ;
---
         if   gn_CodBenef_Ant = 5 then  /*(Aposentadoria Invalidez) */
              IF   gd_dib_Ant <= to_date('27-apr-1995')  THEN
                   ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
                   ln_Coe_SB_Ant   := 0.80 + (0.01 * ln_Tem_ExperProf_wk);
                   if  ln_Coe_SB_Ant > 1.00  then
                       ln_Coe_SB_Ant := 1.00;
                   end if;
              ELSE
                   ln_Coe_SB_Ant := 1.00;
             end if;
        else
             if gn_CodBenef_Ant = 6 then  /*(Invalidez Acidental) */
                ln_Coe_SB_Ant := 1.00;
             else
                if   gn_CodBenef_Ant = 19 then  /*(Pensao Natural) */
                     IF   gd_dib_Ant <= to_date('27-apr-1995')  THEN
                          ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
                          ln_Coe_SB_Ant   := 0.80 + (0.01 * ln_Tem_ExperProf_wk);
                          if  ln_Coe_SB_Ant > 1.00  then
                              ln_Coe_SB_Ant := 1.00;
                          end if;
                      ELSE
                          ln_Coe_SB_Ant := 1.00;
                      end if;
                else
                      if gn_CodBenef_Ant = 18 then  /*(Pensao Acidental) */
                         ln_Coe_SB_Ant := 1.00;
                      else
                         if gn_CodBenef_Ant = 21 then /*(Auxilio Doenca) */
                            IF   gd_dib_Ant <= to_date('27-apr-1995')  THEN
                                 ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
                                 ln_Coe_SB_Ant   := 0.80 + (0.01 * ln_Tem_ExperProf_wk);
                                 if  ln_Coe_SB_Ant  > 0.92  then
                                     ln_Coe_SB_Ant := 0.92;
                                 end if;
                           else
                                 ln_Coe_SB_Ant := 0.91;
                           end if;
                        else
                            if gn_CodBenef_Ant = 91 then /*(Auxilio Doenca acidente) */
                               IF  gd_dib_Ant <= to_date('27-apr-1995')  THEN
                                   ln_Coe_SB_Ant := 0.92;
                               else
                                   ln_Coe_SB_Ant := 0.91;
                               end if;
                            end if;
                         end if;
                     end if;
                 end if;
            end if;
        end if;
        -- Máximo = 1.
        IF  ln_Coe_SB_Ant > 1 or
            ln_Coe_SB_Ant = 0 THEN
            ln_Coe_SB_Ant := 1;
        END IF;

/*IF  gn_CodBenef_Ant IN(2,4) and
    ln_Ver_k_IdadeInss_Ant <= ln_Ver_k_Tem_Serv_Ant THEN
    If ln_Ver_k_IdadeInss_Ant >ln_Ver_K_Filiacao_Ant then
       ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
       IF ln_Tem_ExperProf_wk+round(ln_Ver_k_IdadeInss_Ant/12,0) <= 30  THEN
          ln_Coe_SB_Ant := 0.70 +
           0.01* (ln_Tem_ExperProf_wk+round(ln_Ver_k_IdadeInss_Ant/12,0));
      end if;
    end if;
else
    IF  gn_CodBenef_Ant         =  2  and
        ln_Tem_ExperProf_wk     < 30  and
        ln_Tem_ExperProf_Inss  >= 30  then
        ln_Coe_SB_Ant := 0.70;
    end if;
end if;
*/
IF  gn_CodBenef_Ant IN(2,4) and
    (ln_Ver_k_IdadeInss_Ant < ln_Ver_k_Tem_Serv_Ant or
     ln_Ver_k_IdadeInss_Ant <= ln_Ver_K_Filiacao_Ant) then
     ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
        if ln_Ver_k_IdadeInss_Ant >= ln_Ver_K_Filiacao_Ant then
           ln_Maior_k  := ln_Ver_k_IdadeInss_Ant;
        else
           ln_maior_k  := ln_Ver_K_Filiacao_Ant;
        end if;
        IF ln_Tem_ExperProf_wk + round(ln_maior_k/12,0) <= 30  THEN
           ln_Coe_SB_Ant := 0.70 +
           0.01* (ln_Tem_ExperProf_wk+round(ln_maior_k/12,0));
        end if;

else
    IF  gn_CodBenef_Ant         =  2  and
        ln_Tem_ExperProf_wk     < 30  and
        ln_Tem_ExperProf_Inss  >= 30  then
        ln_Coe_SB_Ant := 0.70;
    end if;
end if;
ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_wk< 25 AND gd_dib_ant < to_date('07-dec-1994')THEN
            ln_Coe_SB_Ant   := 1.00;
       END IF;
RETURN ln_Coe_SB_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_SB_Ant', TRUE);
   END f_Cal_Coe_SB_Ant;
       --======================================================================================
   -- = Nome:      f_Cal_Coe_SBx_Ant
   -- = Descrição: Calcula Coeficiente SBx.
   -- = Nível:     9.
   --======================================================================================
   FUNCTION f_Cal_Coe_SBx_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_SBx_Ant                 number;
--        gn_CodBenef_Ant                number;
        ln_Tem_ExperProf_Ant           number;
           ln_Tem_ExperProf_wk           number;
            ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_K_Ts                        number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Tem_ExperProf_Ant   := f_Cal_Tem_ExperProf_Ant();
        ---
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        IF  gn_CodBenef_Ant = 3 THEN
            ln_Coe_SBx_Ant   := 0.70 + (0.01 * ln_Tem_ExperProf_Ant);
        ELSE
            IF  gn_CodBenef_Ant = 2 then
                IF  ln_SexoEmprg = 'F' THEN
                    IF  ln_Tem_ExperProf_Ant < 25 THEN
                        ln_Coe_SBx_Ant  := 0;
                    ELSE
                         ln_Coe_SBx_Ant := 1;
                    END IF;
                ELSE
                    IF  ln_Tem_ExperProf_Ant < 30 THEN
                        ln_Coe_SBx_Ant       := 0;
                    ELSE
                        IF    ln_Tem_ExperProf_Ant = 30 THEN ln_Coe_SBx_Ant := 0.70;
                        ELSIF ln_Tem_ExperProf_Ant = 31 THEN ln_Coe_SBx_Ant := 0.76;
                        ELSIF ln_Tem_ExperProf_Ant = 32 THEN ln_Coe_SBx_Ant := 0.82;
                        ELSIF ln_Tem_ExperProf_Ant = 33 THEN ln_Coe_SBx_Ant := 0.88;
                        ELSIF ln_Tem_ExperProf_Ant = 34 THEN ln_Coe_SBx_Ant := 0.94;
                        ELSE  ln_Coe_SBx_Ant := 1;
                        END IF;
                    END IF;
                END IF;
            ELSE
                if gn_CodBenef_Ant = 4 then
        ---           ln_Tem_ExperProf_Ant   := f_Cal_Tem_ExperProf_K_Ant();
                   ln_Tem_ExperProf_Ant   := f_Cal_Tem_ExperProf_Ant();
                   ln_K_Ts                := f_Vermax_kppts_Ant();
                   ln_Tem_ExperProf_Ant   := ln_Tem_ExperProf_Ant + round(ln_K_Ts/12,0);

                    IF  ln_SexoEmprg = 'F' THEN
                        IF  ln_Tem_ExperProf_Ant < 25 THEN
                            ln_Coe_SBx_Ant       := 0;
                        ELSE
                            ln_Coe_SBx_Ant := 1;
                        END IF;
                    ELSE
                        IF  ln_Tem_ExperProf_Ant < 30 THEN
                            ln_Coe_SBx_Ant       := 0;
                        ELSE
                              IF  ln_Tem_ExperProf_Ant = 30 THEN ln_Coe_SBx_Ant := 0.80;
                                  ELSIF ln_Tem_ExperProf_Ant = 31 THEN ln_Coe_SBx_Ant := 0.83;
                                  ELSIF ln_Tem_ExperProf_Ant = 32 THEN ln_Coe_SBx_Ant := 0.86;
                                  ELSIF ln_Tem_ExperProf_Ant = 33 THEN ln_Coe_SBx_Ant := 0.89;
                                  ELSIF ln_Tem_ExperProf_Ant = 34 THEN ln_Coe_SBx_Ant := 0.92;
                                  ELSE  ln_Coe_SBx_Ant := 0.95;
                              END IF;
                        END IF;
                     end if;
                ELSE
                    ln_Coe_SBx_Ant := 1;
            END IF;
        END IF;
        end if;
        -- Máximo = 1.
        IF     ln_Coe_SBx_Ant  > 1  THEN
               ln_Coe_SBx_Ant  := 1;
        else
               if gn_CodBenef_Ant = 4  then
                  if ln_Coe_SBx_Ant < 0.80 then
                     ln_Coe_SBx_Ant  := 0.80;
                  end if;
               else
                  if  ln_Coe_SBx_Ant  < 0.70 then
                      ln_Coe_SBx_Ant  := 0.70;
                  end if;
               end if;
        END IF;
       ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
       ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
        IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_wk < 25 AND gd_dib_ant < to_date('07-dec-1994')THEN
            ln_Coe_SBx_Ant   := 1.00;
       END IF;
        RETURN ln_Coe_SBx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_SBx_Ant', TRUE);
   END f_Cal_Coe_SBx_Ant;

   --======================================================================================
   -- = Nome:      f_Cal_Coe_SBxk_Ant
   -- = Descrição: Calcula Coeficiente SB.
   -- = Nível:     9.
   --======================================================================================
   FUNCTION f_Cal_Coe_SBxk_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_SBxk_Ant                number;
--        gn_CodBenef_Ant                number;
        ln_Tem_ExperProf_Ant           number;
           ln_Tem_ExperProf_wk           number;
            ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Ver_Max_kpp_Ant             NUMBER;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Ver_Max_kpp_Ant             := f_Vermax_Kpp_Ant();
        ln_Tem_ExperProf_Ant           := f_Cal_Tem_ExperProf_Ant();
        ln_Tem_ExperProf_Ant           := ln_Tem_ExperProf_Ant
                                        + ROUND(ln_Ver_Max_kpp_Ant / 12,0);
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        IF  gn_CodBenef_Ant = 3 THEN
            ln_Coe_SBxk_Ant            := 0.70 + (0.01 * ln_Tem_ExperProf_Ant);
        ELSE
            IF  gn_CodBenef_Ant = 2 THEN
                IF  ln_SexoEmprg = 'F' THEN
                    IF  ln_Tem_ExperProf_Ant < 25 THEN
                        ln_Coe_SBxk_Ant       := 0;
                    ELSE
                        ln_Coe_SBxk_Ant       := 1;
                    END IF;
                ELSE
                    IF  ln_Tem_ExperProf_Ant < 30 THEN
                        ln_Coe_SBxk_Ant       := 0;
                    ELSE
                        IF    ln_Tem_ExperProf_Ant = 30 THEN ln_Coe_SBxk_Ant := 0.70;
                        ELSIF ln_Tem_ExperProf_Ant = 31 THEN ln_Coe_SBxk_Ant := 0.76;
                        ELSIF ln_Tem_ExperProf_Ant = 32 THEN ln_Coe_SBxk_Ant := 0.82;
                        ELSIF ln_Tem_ExperProf_Ant = 33 THEN ln_Coe_SBxk_Ant := 0.88;
                        ELSIF ln_Tem_ExperProf_Ant = 34 THEN ln_Coe_SBxk_Ant := 0.94;
                        ELSE  ln_Coe_SBxk_Ant := 1;
                        END IF;
                    END IF;
                END IF;
         ELSE
            IF  gn_CodBenef_Ant = 4 THEN
                IF  ln_SexoEmprg = 'F' THEN
                    IF  ln_Tem_ExperProf_Ant < 25 THEN
                        ln_Coe_SBxk_Ant       := 0;
                    ELSE
                        ln_Coe_SBxk_Ant       := 1;
                    END IF;
                ELSE
                    IF  ln_Tem_ExperProf_Ant < 30 THEN
                        ln_Coe_SBxk_Ant       := 0;
                    ELSE
                        IF    ln_Tem_ExperProf_Ant = 30 THEN ln_Coe_SBxk_Ant := 0.80;
                        ELSIF ln_Tem_ExperProf_Ant = 31 THEN ln_Coe_SBxk_Ant := 0.83;
                        ELSIF ln_Tem_ExperProf_Ant = 32 THEN ln_Coe_SBxk_Ant := 0.86;
                        ELSIF ln_Tem_ExperProf_Ant = 33 THEN ln_Coe_SBxk_Ant := 0.89;
                        ELSIF ln_Tem_ExperProf_Ant = 34 THEN ln_Coe_SBxk_Ant := 0.92;
                        ELSE  ln_Coe_SBxk_Ant := 0.95;
                        END IF;
                    END IF;
                END IF;
            ELSE
                ln_Coe_SBxk_Ant       := 1;
            END IF;
        END IF;
        END IF;
        -- Máximo = 1.
        IF  ln_Coe_SBxk_Ant > 1 THEN
            ln_Coe_SBxk_Ant := 1;
        else
            if  gn_CodBenef_Ant = 4 then
                if   ln_Coe_SBxk_Ant <= 0.80 then
                     ln_Coe_SBxk_Ant := 0.80;
                end if;
            else
                 if   ln_Coe_SBxk_Ant <= 0.70 then
                     ln_Coe_SBxk_Ant := 0.70;
                end if;
            end if;
        END IF;
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
        ln_Tem_ExperProf_wk  := f_Cal_Tem_ExperProf_Ant();
        IF  ls_AtivFund_Emprg_Ant = 'E' AND gn_CodBenef_Ant =  4
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_wk< 25 AND gd_dib_ant < to_date('07-dec-1994')THEN
            ln_Coe_SBxk_Ant   := 1.00;
       END IF;
        RETURN ln_Coe_SBxk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_SBxk_Ant', TRUE);
   END f_Cal_Coe_SBxk_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_ResConsA_Ant
   -- = Descrição: Calcula coeficiente Reserva Constituída.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_ResConsA_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_ResConsA_Ant             number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xk_Ant (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_ResConsA_Ant             := ((ln_Dxk / ln_Dx) * ln_axk12 );
        RETURN ln_Coe_ResConsA_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_ResConsA_Ant', TRUE);
   END f_Cal_Coe_ResConsA_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_ResConsAE_Ant
   -- = Descrição: Calcula coeficiente Reserva Constituída.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_ResConsAE_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_ResConsAE_Ant           number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xkppts (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_ResConsAE_Ant         := ((ln_Dxk / ln_Dx) * ln_axk12 );
        RETURN ln_Coe_ResConsAE_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_ResConsAE_Ant', TRUE);
   END f_Cal_Coe_ResConsAE_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_ResCons_Ant
   -- = Descrição: Calcula coeficiente Reserva Constituída.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_ResCons_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_ResCons_Ant             number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xk_Ant (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_ResCons_Ant             := ((ln_Dxk / ln_Dx) * (ln_axk12 + ln_axkh12));
        RETURN ln_Coe_ResCons_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_ResCons_Ant', TRUE);
   END f_Cal_Coe_ResCons_Ant;
     --======================================================================================
   -- = Nome:      f_Cal_Coe_aaa12_x_Ant
   -- = Descrição: Calcula coeficiente aaa12_x.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_aaa12_xkppts RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_aaa12_x_Ant            number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xkppts  (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_x_ant   (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_aaa12_x_Ant            := ((ln_Nx - ln_Nxk) / ln_Dx) - 13/24 * (1 - (ln_Dxk / ln_Dx));
        RETURN ln_Coe_aaa12_x_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_aaa12_xk_Ant', TRUE);
   END f_Cal_Coe_aaa12_xkppts;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_aaa12_x_Ant
   -- = Descrição: Calcula coeficiente aaa12_x.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_aaa12_xkf_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_aaa12_x_Ant            number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xkf_Ant (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_xf_ant  (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_aaa12_x_Ant            := ((ln_Nx - ln_Nxk) / ln_Dx) - 13/24 * (1 - (ln_Dxk / ln_Dx));
        RETURN ln_Coe_aaa12_x_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_aaa12_xk_Ant', TRUE);
   END f_Cal_Coe_aaa12_xkf_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_aaa12_xk_Ant
   -- = Descrição: Calcula coeficiente aaa12_xk.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_aaa12_xk_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_aaa12_xk_Ant            number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xk_Ant (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_aaa12_xk_Ant            := ((ln_Nx - ln_Nxk) / ln_Dx) - 13/24 * (1 - (ln_Dxk / ln_Dx));
        RETURN ln_Coe_aaa12_xk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_aaa12_xk_Ant', TRUE);
   END f_Cal_Coe_aaa12_xk_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Coe_aaa12_xke_Ant
   -- = Descrição: Calcula coeficiente aaa12_xk.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Coe_aaa12_xkpp_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Coe_aaa12_xke_Ant            number;
        ln_axk12                       info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                      info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                         info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                         info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_ax12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                          info_atuarial.vlr_nxaa_infatr%TYPE;
   BEGIN
        sp_Sel_Dados_InfoAtuar_xkpp (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_xkpp (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Coe_aaa12_xke_Ant            := ((ln_Nx - ln_Nxk) / ln_Dx) - 13/24 * (1 - (ln_Dxk / ln_Dx));
        RETURN ln_Coe_aaa12_xke_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Coe_aaa12_xke_Ant', TRUE);
   END f_Cal_Coe_aaa12_xkpp_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_SBx_Ant
   -- = Descrição: Calcula Fator do SBx.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Fator_SBx_Ant RETURN number IS
         -- Declaração de variáveis locais
        ln_Fator_SBx_Ant               number;
--        gd_DIB_Ant                     date;
        ld_DatIni                      afastamento.dat_inaft_afast%TYPE;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_QtdeVerbasFixas             number;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_Coe_SBx_Ant                  number;
        ln_CorrigeValorINSS            number;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
         ln_ValMinINSS                 limite_inss_fss.vlr_minimo_limins%type;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
        sp_Sel_Dados_Afast_Ant (ld_DatIni);
        sp_Sel_Dados_TabTempSRCINSS_An (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Coe_SBx_Ant                 := f_Cal_Coe_SBx_Ant();
        ln_CorrigeValorINSS            := PACK_SBF_MEMCALCULO_GERAL.f_CorrigeValorINSS(ld_DatIni, ld_DatIni, gd_DIB_Ant, ln_MediaVerbasFixas);
        IF  ld_DatIni <= TO_DATE ('01/01/1900','DD/MM/YYYY') THEN
            ln_Fator_SBx_Ant            := ln_MediaVerbasFixas * ln_Coe_SBx_Ant;
        ELSE
            ln_Fator_SBx_Ant            := ln_CorrigeValorINSS * ln_Coe_SBx_Ant;
        END IF;
        -- Máximo = Valor limite do INSS.
        IF  gc_lei8880                <> 'S' then
            IF  ln_Fator_SBx_Ant > ln_ValLimINSS * ln_Coe_SBx_Ant THEN
                ln_Fator_SBx_Ant := ln_ValLimINSS * ln_Coe_SBx_Ant;
            END IF;
        END IF;
        ---
        if ln_Fator_SBx_Ant < ln_ValMinINSS then
           ln_Fator_SBx_Ant  := ln_ValMinINSS;
        end if;
        RETURN ln_Fator_SBx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_SBx_Ant', TRUE);
   END f_Cal_Fator_SBx_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_SB_Ant
   -- = Descrição: Calcula Fator do SB.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Fator_SB_Ant RETURN number IS
         -- Declaração de variáveis locais
        ln_Fator_SB_Ant                number;
--        gd_DIB_Ant                     date;
        ld_DatIni                      afastamento.dat_inaft_afast%TYPE;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_QtdeVerbasFixas             number;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_Coe_SB_Ant                  number;
        ln_CorrigeValorINSS            number;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%type;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
   BEGIN
        ---
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
        ----
        sp_Sel_Dados_Afast_Ant (ld_DatIni);
        sp_Sel_Dados_TabTempSRCINSS_An (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Coe_SB_Ant                  := f_Cal_Coe_SB_Ant();
        ln_CorrigeValorINSS            := PACK_SBF_MEMCALCULO_GERAL.f_CorrigeValorINSS(ld_DatIni, ld_DatIni, gd_DIB_Ant, ln_MediaVerbasFixas);
        IF  ld_DatIni <= TO_DATE ('01/01/1900','DD/MM/YYYY') THEN
            ln_Fator_SB_Ant            := ln_MediaVerbasFixas * ln_Coe_SB_Ant;
        ELSE
            ln_Fator_SB_Ant            := ln_CorrigeValorINSS * ln_Coe_SB_Ant;
        END IF;
        -- Máximo = Valor limite do INSS.
        IF  gc_lei8880                <> 'S' then
            IF  ln_Fator_SB_Ant > ln_ValLimINSS * ln_Coe_SB_Ant THEN
                ln_Fator_SB_Ant := ln_ValLimINSS * ln_Coe_SB_Ant;
            END IF;
        END IF;

        ---
        if ln_Fator_SB_Ant < ln_ValMinINSS then
           ln_Fator_SB_Ant  := ln_ValMinINSS;
        end if;
        ---
        RETURN ln_Fator_SB_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_SB_Ant', TRUE);
   END f_Cal_Fator_SB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_SB_Ant xk para fins de pp
   -- = Descrição: Calcula Fator do SB.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Fator_SBxk_Ant RETURN number IS
         -- Declaração de variáveis locais
        ln_Fator_SBxk_Ant              number;
--        gd_DIB_Ant                     date;
        ld_DatIni                      afastamento.dat_inaft_afast%TYPE;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_QtdeVerbasFixas             number;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_Coe_SBxk_Ant                number;
        ln_CorrigeValorINSS            number;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
   BEGIN
--        gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
        sp_Sel_Dados_Afast_Ant (ld_DatIni);
        sp_Sel_Dados_TabTempSRCINSS_An (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Coe_SBxk_Ant                := f_Cal_Coe_SBxk_Ant();
        ln_CorrigeValorINSS            := PACK_SBF_MEMCALCULO_GERAL.f_CorrigeValorINSS(ld_DatIni, ld_DatIni, gd_DIB_Ant, ln_MediaVerbasFixas);
        IF  ld_DatIni <= TO_DATE ('01/01/1900','DD/MM/YYYY') THEN
            ln_Fator_SBxk_Ant          := ln_MediaVerbasFixas * ln_Coe_SBxk_Ant;
        ELSE
            ln_Fator_SBxk_Ant          := ln_CorrigeValorINSS * ln_Coe_SBxk_Ant;
        END IF;
        -- Máximo = Valor limite do INSS.
        IF  gc_lei8880                <> 'S' then
            IF  ln_Fator_SBxk_Ant > ln_ValLimINSS * ln_Coe_SBxk_Ant THEN
                ln_Fator_SBxk_Ant := ln_ValLimINSS * ln_Coe_SBxk_Ant;
            END IF;
        END IF;
        ---
        if ln_Fator_SBxk_Ant < ln_ValMinINSS then
           ln_Fator_SBxk_Ant := ln_ValMinINSS;
        end if;
        RETURN ln_Fator_SBxk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_SB_Ant', TRUE);
   END f_Cal_Fator_SBxk_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_SRB_Ant
   -- = Descrição: Calcula Fator do SRB.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Fator_SRB_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Fator_SRB_Ant               number;
        ln_Coe_SRB_Ant                 number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
   BEGIN
        ln_Coe_SRB_Ant                 := f_Cal_Coe_SRB_Ant();
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Fator_SRB_Ant               := ln_MediaVerbasFixas * ln_Coe_SRB_Ant;
        RETURN ln_Fator_SRB_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_SRB_Ant', TRUE);
   END f_Cal_Fator_SRB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_SRBxk_Ant
   -- = Descrição: Calcula Fator do SRBxk.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Fator_SRBxk_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Fator_SRBxk_Ant             number;
        ln_Coe_SRBxk_Ant               number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
   BEGIN
        ln_Coe_SRBxk_Ant               := f_Cal_Coe_SRBxk_Ant();
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Fator_SRBxk_Ant             := ln_MediaVerbasFixas * ln_Coe_SRBxk_Ant;
        RETURN ln_Fator_SRBxk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_SRBxk_Ant', TRUE);
   END f_Cal_Fator_SRBxk_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_SRBx_Ant
   -- = Descrição: Calcula Fator do SRBx.
   -- = Nível:     10.
   --======================================================================================
   FUNCTION f_Cal_Fator_SRBx_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Fator_SRBx_Ant              number;
        ln_Coe_SRBx_Ant                number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
   BEGIN
        ln_Coe_SRBx_Ant               := f_Cal_Coe_SRBx_Ant();
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Fator_SRBx_Ant             := ln_MediaVerbasFixas * ln_Coe_SRBx_Ant;
        RETURN ln_Fator_SRBx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_SRBx_Ant', TRUE);
   END f_Cal_Fator_SRBx_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefAposIda_Ant
   -- = Descrição: Calcula Valor Benefício por Idade.
   -- = Nível:     11.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposIda_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefAposIda_Ant        number;
        ln_Fator_SRB_Ant               number;
        ln_Per_TemServ_Ant             number;
        ln_Fator_SB_Ant                number;
        ln_Per_SemCtb_Ant              number;
   BEGIN
        ln_Fator_SRB_Ant               := f_Cal_Fator_SRB_Ant();
        ln_Per_TemServ_Ant             := f_Cal_Per_TemServ_Ant();
        ln_Fator_SB_Ant                := f_Cal_Fator_SB_Ant();
        ln_Per_SemCtb_Ant              := f_Cal_Per_SemCtb_Ant();

        IF  (((ln_Fator_SRB_Ant * ln_Per_TemServ_Ant) - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant) > ((0.15 * ln_Fator_SRB_Ant) * ln_Per_SemCtb_Ant) THEN
            ln_Val_BenefAposIda_Ant    := ((ln_Fator_SRB_Ant * ln_Per_TemServ_Ant) - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant;
        ELSE
            ln_Val_BenefAposIda_Ant    := (0.15 * ln_Fator_SRB_Ant) * ln_Per_SemCtb_Ant;
        END IF;
         RETURN ln_Val_BenefAposIda_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposIda_Ant', TRUE);
   END f_Cal_Val_BenefAposIda_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefAposIdaxkpp_Ant
   -- = Descrição: Calcula Valor Benefício por Idade.
   -- = Nível:     11.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposIdaxkpp RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefAposIdaxkpp        number;
        ln_Fator_SRBxkpp               number;
        ln_Per_TemServ_Ant             number;
        ln_Fator_SBxkpp                number;
        ln_Per_SemCtb_Ant              number;
   BEGIN
        ln_Fator_SRBxkpp               := f_Cal_Fator_SRBxk_Ant();
        ln_Per_TemServ_Ant             := f_Cal_Per_TemServ_Ant();
        ln_Fator_SBxkpp                := f_Cal_Fator_SBxk_Ant();
        ln_Per_SemCtb_Ant              := f_Cal_Per_SemCtb_Ant();

        IF  (((ln_Fator_SRBxkpp * ln_Per_TemServ_Ant) - ln_Fator_SBxkpp) * ln_Per_SemCtb_Ant) > ((0.15 * ln_Fator_SRBxkpp) * ln_Per_SemCtb_Ant) THEN
            ln_Val_BenefAposIdaxkpp    := ((ln_Fator_SRBxkpp * ln_Per_TemServ_Ant) - ln_Fator_SBxkpp) * ln_Per_SemCtb_Ant;
        ELSE
            ln_Val_BenefAposIdaxkpp    := (0.15 * ln_Fator_SRBxkpp) * ln_Per_SemCtb_Ant;
        END IF;
         RETURN ln_Val_BenefAposIdaxkpp;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposIda_Ant', TRUE);
   END f_Cal_Val_BenefAposIdaxkpp;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefAposTServ_Ant
   -- = Descrição: Calcula Valor Benefício por Tempo de Serviço.
   -- = Nível:     11.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposTServ_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefAposTServ_Ant      number;
        ln_Fator_SRB_Ant               number;
        ln_Fator_SB_Ant                number;
        ln_Per_SemCtb_Ant              number;
   BEGIN
        ln_Fator_SRB_Ant               := f_Cal_Fator_SRB_Ant();
        ln_Fator_SB_Ant                := f_Cal_Fator_SB_Ant();
        ln_Per_SemCtb_Ant              := f_Cal_Per_SemCtb_Ant();

        IF  ((ln_Fator_SRB_Ant - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant) > ((0.15 * ln_Fator_SRB_Ant) * ln_Per_SemCtb_Ant) THEN
            ln_Val_BenefAposTServ_Ant  := (ln_Fator_SRB_Ant - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant;
        ELSE
            ln_Val_BenefAposTServ_Ant  := (0.15 * ln_Fator_SRB_Ant) * ln_Per_SemCtb_Ant;
        END IF;
         RETURN ln_Val_BenefAposTServ_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposTServ_Ant', TRUE);
   END f_Cal_Val_BenefAposTServ_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefAposTServ_Ant
   -- = Descrição: Calcula Valor Benefício por Tempo de Serviço.
   -- = Nível:     11.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposTServx_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefAposTServx_Ant     number;
        ln_Fator_SRB_Ant               number;
        ln_Fator_SB_Ant                number;
        ln_Per_SemCtb_Ant              number;
   BEGIN
        ln_Fator_SRB_Ant               := f_Cal_Fator_SRBx_Ant();
        ln_Fator_SB_Ant                := f_Cal_Fator_SBx_Ant();
        ln_Per_SemCtb_Ant              := f_Cal_Per_SemCtb_Ant();

        IF  ((ln_Fator_SRB_Ant - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant) > ((0.15 * ln_Fator_SRB_Ant) * ln_Per_SemCtb_Ant) THEN
            ln_Val_BenefAposTServx_Ant  := (ln_Fator_SRB_Ant - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant;
        ELSE
            ln_Val_BenefAposTServx_Ant  := (0.15 * ln_Fator_SRB_Ant) * ln_Per_SemCtb_Ant;
        END IF;
        RETURN ln_Val_BenefAposTServx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposTServx_Ant', TRUE);
   END f_Cal_Val_BenefAposTServx_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefAposTServXk_Ant
   -- = Descrição: Calcula Valor Benefício por Tempo de Serviço.
   -- = Nível:     11.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposTServxk_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefAposTServxk_Ant    number;
        ln_Fator_SRBxk_Ant             number;
        ln_Fator_SBxk_Ant              number;
        ln_Per_SemCtb_Ant              number;
   BEGIN
        ln_Fator_SRBxk_Ant             := f_Cal_Fator_SRBxk_Ant();
        ln_Fator_SBxk_Ant              := f_Cal_Fator_SBxk_Ant();
        ln_Per_SemCtb_Ant              := f_Cal_Per_SemCtb_Ant();

        IF  ((ln_Fator_SRBxk_Ant - ln_Fator_SBxk_Ant) * ln_Per_SemCtb_Ant) > ((0.15 * ln_Fator_SRBxk_Ant) * ln_Per_SemCtb_Ant) THEN
            ln_Val_BenefAposTServxk_Ant  := (ln_Fator_SRBxk_Ant - ln_Fator_SBxk_Ant) * ln_Per_SemCtb_Ant;
        ELSE
            ln_Val_BenefAposTServxk_Ant  := (0.15 * ln_Fator_SRBxk_Ant) * ln_Per_SemCtb_Ant;
        END IF;
         RETURN ln_Val_BenefAposTServxk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposTServ_Ant', TRUE);
   END f_Cal_Val_BenefAposTServxk_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefMin_Ant
   -- = Descrição: Calcula Valor Benefício Minimo.
   -- = Nível:     11.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefMin_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Val_BenefMin_Ant            number;
        ln_Fator_SRB_Ant               number;
   BEGIN
        ln_Fator_SRB_Ant               := f_Cal_Fator_SRB_Ant();
        ln_Val_BenefMin_Ant            := 0.15 * ln_Fator_SRB_Ant;
        RETURN ln_Val_BenefMin_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefMin_Ant', TRUE);
   END f_Cal_Val_BenefMin_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_BenefApos_x_Ant
   -- = Descrição: Calcula Valor Benefício em x.
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposx_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefAposx_Ant          number;
--        gn_CodBenef_Ant                number;
        ln_Val_BenefAposIda_Ant        number;
        ln_Val_BenefAposTServ_Ant      number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Val_BenefAposIda_Ant        := f_Cal_Val_BenefAposIda_Ant();
        ln_Val_BenefAposTServ_Ant      := f_Cal_Val_BenefAposTServx_Ant();
        IF  gn_CodBenef_Ant     = 3 THEN
            ln_Val_BenefAposx_Ant    := ln_Val_BenefAposIda_Ant;
        ELSE
            ln_Val_BenefAposx_Ant    := ln_Val_BenefAposTServ_Ant;
        END IF;
        RETURN ln_Val_BenefAposx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposx_Ant', TRUE);
   END f_Cal_Val_BenefAposx_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefAposInv_Ant
   -- = Descrição: Calcula Valor Benefício por Invalidez.
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefAposInv_Ant RETURN number IS
             -- Declaração de variáveis locais
        ln_Val_BenefAposInv_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_Fator_SB_Ant                number;
        ln_Per_SemCtb_Ant              number;
        ln_Val_BenefMin_Ant            number;
   BEGIN
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Fator_SB_Ant                := f_Cal_Fator_SB_Ant();
        ln_Per_SemCtb_Ant              := f_Cal_Per_SemCtb_Ant();

        IF  ((ln_MediaVerbasFixas - ln_Fator_SB_Ant) *  ln_Per_SemCtb_Ant) > ((0.15 * ln_MediaVerbasFixas - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant) THEN
            ln_Val_BenefAposInv_Ant    := (ln_MediaVerbasFixas - ln_Fator_SB_Ant) *  ln_Per_SemCtb_Ant;
        ELSE
            ln_Val_BenefAposInv_Ant    := (0.15 * ln_MediaVerbasFixas - ln_Fator_SB_Ant) * ln_Per_SemCtb_Ant;
        END IF;
        -- Valor mínimo = ln_Val_BenefMin_Ant
        ln_Val_BenefMin_Ant            := f_Cal_Val_BenefMin_Ant();
        IF  ln_Val_BenefAposInv_Ant < ln_Val_BenefMin_Ant THEN ln_Val_BenefAposInv_Ant := ln_Val_BenefMin_Ant;
        END IF;
        RETURN ln_Val_BenefAposInv_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposInv_Ant', TRUE);
    END f_Cal_Val_BenefAposInv_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_BenefApos_xk_Ant
   -- = Descrição: Calcula Valor Benefício Integral(x+k).
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefApos_xk_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefApos_xk_Ant        number;
        gn_CodBenef_Ant                number;
        ln_Val_BenefAposIda_Ant        number;
        ln_Val_BenefAposTServ_Ant      number;
   BEGIN
        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Val_BenefAposIda_Ant        := f_Cal_Val_BenefAposIda_Ant();
        ln_Val_BenefAposTServ_Ant      := f_Cal_Val_BenefAposTServ_Ant();
        IF  gn_CodBenef_Ant     = 3 THEN
            ln_Val_BenefApos_xk_Ant    := ln_Val_BenefAposIda_Ant;
        ELSE
            ln_Val_BenefApos_xk_Ant    := ln_Val_BenefAposTServ_Ant;
        END IF;
        RETURN ln_Val_BenefApos_xk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefApos_xk_Ant', TRUE);
   END f_Cal_Val_BenefApos_xk_Ant;
         --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_E_Xkpp_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_E_xkpp_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_E_xkpp_Ant       number;
        ln_Cal_Coe_Srb_xk_Ant          number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Cal_Coe_Srb_xk_Ant := f_Cal_Coe_SRBxk_Ant ();
        ln_Base_Calculo_Ant   := ln_MediaVerbasFixas * ln_Cal_Coe_Srb_xk_Ant;

        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_E_xkpp_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_E_xkpp_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_E_xkpp_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_E_xkpp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_E_xkpp_Ant', TRUE);
   END f_Cal_Ctb_Partic_E_xkpp_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_BenefApos_xkpp_Ant
   -- = Descrição: Calcula Valor Benefício Integral(x+k).
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefApos_xkpp_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefApos_xkpp_Ant        number;
--        gn_CodBenef_Ant                number;
        ln_Val_BenefAposIdaxk_Ant        number;
        ln_Val_BenefAposTServxk_Ant      number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Val_BenefAposIdaxk_Ant      := f_Cal_Val_BenefAposIdaxkpp();
        ln_Val_BenefAposTServxk_Ant    := f_Cal_Val_BenefAposTServxk_Ant();
        IF  gn_CodBenef_Ant     = 3 THEN
            ln_Val_BenefApos_xkpp_Ant  := ln_Val_BenefAposIdaxk_Ant;
        ELSE
            ln_Val_BenefApos_xkpp_Ant  := ln_Val_BenefAposTServxk_Ant;
        END IF;
        RETURN ln_Val_BenefApos_xkpp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefApos_xkpp_Ant', TRUE);
   END f_Cal_Val_BenefApos_xkpp_Ant;
        --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsA_E_Xk_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída E considerando a A.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsA_E_Xk_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsA_E_Xk_Ant        number;
        ln_Ver_Max_kpp_Ant              number;
        ln_Val_BenefApos_xkpp_Ant       number;
        ln_Cal_Ctb_Partic_E_X_Ant       number;
        ln_Cal_Ctb_Partic_E_Xkpp_Ant    number;
        ln_Cal_Fator_Cont_Ant           number;
        ln_Cal_Coe_aaa12_XKe_Ant        number;
        ln_ax12                         info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                        info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                           info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                           info_atuarial.vlr_nxaa_infatr%TYPE;
        ---
        ln_axk12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                          info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_Kax12                        number;
        ln_Kaxh12                       number;
   BEGIN
       --- ln_Ver_Max_kpp_Ant           := f_VerMax_kpp_Ant();
/*        if ln_Ver_Max_kpp_Ant         = 0 then
           sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
           ln_Cal_Coe_aaa12_XKe_Ant    := f_Cal_Coe_Aaa12_Xk_Ant();
        else
           sp_Sel_Dados_InfoAtuar_xkpp (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
           ln_Cal_Coe_aaa12_XKe_Ant    := f_Cal_Coe_Aaa12_xkf_Ant();
        end if;  */
        gc_base                        := 2;
        sp_Sel_Dados_InfoAtuar_xkf_Ant    (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        sp_Sel_Dados_InfoAtuar_xf_Ant     (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Cal_Coe_aaa12_XKe_Ant    := f_Cal_Coe_Aaa12_xkf_Ant();
        ln_Kax12  := (ln_Dxk / ln_Dx) * ln_axk12;
        ln_Kaxh12 := (ln_Dxk / ln_Dx) * ln_axkh12;
        ln_Val_BenefApos_xkpp_Ant      := f_Cal_Val_BenefApos_xkpp_Ant();
        ln_Cal_Ctb_Partic_E_Xkpp_Ant   := f_Cal_Ctb_Partic_E_xkpp_Ant ();
        ln_Cal_Fator_Cont_Ant          := f_Cal_Fator_Cont_Ant ();
        ln_Val_ResConsA_E_Xk_Ant       := (ln_Val_BenefApos_xkpp_Ant * ln_Kax12)
                                        - (ln_Cal_Ctb_Partic_E_Xkpp_Ant * ln_Cal_Fator_Cont_Ant * ln_Cal_Coe_aaa12_XKe_Ant);
        RETURN ln_Val_ResConsA_E_Xk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsA_E_Xk_Ant', TRUE);
   END f_Cal_Val_ResConsA_E_Xk_Ant;
            --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaE_xk_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaA_E_Xk_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Ver_Max_kpp_Ant               number;
        ln_Val_ResNecaA_E_Xk_Ant         number;
        ln_Val_BenefApos_xkpp_Ant        number;
        ln_Val_SuplxE_liq_Ant            number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        ln_Ver_Max_kpp_Ant           := f_VerMax_kpp_Ant();
 /*       if ln_Ver_Max_kpp_Ant         = 0 then
           sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        else
           sp_Sel_Dados_InfoAtuar_xkpp    (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        end if; */
        sp_Sel_Dados_InfoAtuar_xf_Ant (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);

        ln_Val_BenefApos_xkpp_ant      := f_Cal_Val_BenefApos_xkpp_Ant();
        ln_Val_ResNecaA_E_Xk_Ant       := ln_Val_BenefApos_xkpp_Ant * ln_ax12;
        RETURN ln_Val_ResNecaA_E_Xk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaA_E_Xk_Ant', TRUE);
   END f_Cal_Val_ResNecaA_E_xk_Ant;
      --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_E_X_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_E_x_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_E_x_Ant          number;
        ln_Cal_Coe_Srb_x_Ant           number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Cal_Coe_Srb_x_Ant  := f_Cal_Coe_SRBX_Ant ();
        ln_Base_Calculo_Ant   := ln_MediaVerbasFixas * ln_Cal_Coe_Srb_x_Ant;
        /*if gc_base = 1 then */
               ln_Base_Calculo_Ant   := ln_MediaVerbasFixas * ln_Cal_Coe_Srb_x_Ant;
         /*  else
               ln_Base_Calculo_Ant := f_Cal_Val_BenefAposx_Ant();
        end if;          */

        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_E_x_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_E_x_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_E_x_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_E_x_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_E_x_Ant', TRUE);
   END f_Cal_Ctb_Partic_E_x_Ant;
      --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaE_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaA_E_X_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaA_E_X_Ant          number;
        ln_Val_BenefAposx_Ant            number;
        ln_Val_SuplxE_liq_Ant            number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        ln_Val_BenefAposx_Ant         := f_Cal_Val_BenefAposx_Ant();
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Val_ResNecaA_E_X_Ant       := ln_Val_BenefAposx_Ant * ln_ax12;
        RETURN ln_Val_ResNecaA_E_X_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaA_E_X_Ant', TRUE);
   END f_Cal_Val_ResNecaA_E_x_Ant;

     --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsA_E_X_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída E considerando a A.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsA_E_X_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Ver_Max_kpp_Ant              number;
        ln_Val_ResConsA_E_X_Ant         number;
        ln_Val_BenefApos_x_Ant          number;
        ln_Cal_Ctb_Partic_E_X_Ant       number;
        ln_Cal_Fator_Cont_Ant           number;
        ln_Cal_Coe_aaa12_X_Ant          number;
        ln_ax12                         info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                        info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                           info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                           info_atuarial.vlr_nxaa_infatr%TYPE;
        ---
        ln_axk12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                          info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_Kax12                        number;
        ln_Kaxh12                       number;
   BEGIN
        gc_base                        := 2;
        ln_Ver_Max_kpp_Ant             := f_VerMax_kpp_Ant();
        sp_Sel_Dados_InfoAtuar_x_Ant  (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        sp_Sel_Dados_InfoAtuar_xkppts (ln_axk12,  ln_axkh12,  ln_Dxk,  ln_Nxk);
        ln_Cal_Coe_aaa12_X_Ant      := f_Cal_Coe_Aaa12_Xkppts();
/*        if   ln_Ver_Max_kpp_Ant         = 0 then
             sp_Sel_Dados_InfoAtuar_xkpp   (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
             ln_Cal_Coe_aaa12_X_Ant      := f_Cal_Coe_Aaa12_Xk_Ant();
        else
             sp_Sel_Dados_InfoAtuar_xkppts  (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
             ln_Cal_Coe_aaa12_X_Ant         := f_Cal_Coe_Aaa12_Xkppts();
        end if;   */
        ln_Kax12  := (ln_Dxk / ln_Dx) * ln_axk12;
        ln_Kaxh12 := (ln_Dxk / ln_Dx) * ln_axkh12;
        ln_Val_BenefApos_x_Ant         := f_Cal_Val_BenefAposx_Ant();
        ln_Cal_Ctb_Partic_E_X_Ant      := f_Cal_Ctb_Partic_E_X_Ant ();
        ln_Cal_Fator_Cont_Ant          := f_Cal_Fator_Cont_Ant ();
        ln_Val_ResConsA_E_X_Ant        := (ln_Val_BenefApos_x_Ant * ln_Kax12)
                                        - (ln_Cal_Ctb_Partic_E_X_Ant * ln_Cal_Fator_Cont_Ant * ln_Cal_Coe_aaa12_X_Ant);
        RETURN ln_Val_ResConsA_E_X_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsA_E_X_Ant', TRUE);
   END f_Cal_Val_ResConsA_E_X_Ant;

  --======================================================================================
   -- = Nome:      f_Cal_Val_BenefApos_xk_E_Ant
   -- = Descrição: Calcula Valor Benefício Integral(x+kE).
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefApos_xk_E_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefApos_xk_E_Ant      number;
        ln_Val_Benef_Apos_xkpp_Ant     number;
        ln_Val_ResConsA_E_xk_Ant       number;
        ln_Val_ResNeceA_E_xk_Ant       number;
   BEGIN
        ln_Val_Benef_Apos_xkpp_Ant  :=  f_Cal_Val_BenefApos_xkpp_Ant();
        ln_Val_ResConsA_E_xk_Ant    :=  f_Cal_Val_ResConsA_E_xk_Ant();
        ln_Val_ResNeceA_E_xk_Ant    :=  f_Cal_Val_ResNecaA_E_xk_Ant();
---
        ln_Val_BenefApos_xk_E_Ant   := ln_Val_Benef_Apos_xkpp_Ant
                                     * (ln_Val_ResConsA_E_xk_Ant / ln_Val_ResNeceA_E_xk_Ant);

        RETURN ln_Val_BenefApos_xk_E_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefApos_xk_E_Ant', TRUE);
   END f_Cal_Val_BenefApos_xk_E_Ant;

   --======================================================================================
   -- = Nome:      f_Cal_Val_BenefApos_xE_Ant
   -- = Descrição: Calcula Valor Benefício em xE.
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefApos_xE_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefApos_xE_Ant        number;
--        gn_CodBenef_Ant                number;
        ln_Val_BenefAposX_Ant          number;
        ln_Val_ResConsA_E_x_Ant        number;
        ln_Val_ResNeceA_E_x_Ant        number;
   BEGIN
        ln_Val_BenefAposX_Ant        := f_Cal_Val_BenefAposx_Ant();
        ln_Val_ResConsA_E_x_Ant      := f_Cal_Val_ResConsA_E_X_Ant();
        ln_Val_ResNeceA_E_x_Ant      := f_Cal_Val_ResNecaA_E_X_Ant();
        ln_Val_BenefApos_xE_Ant      := ln_Val_BenefAposX_Ant
                                      * (ln_Val_ResConsA_E_x_Ant / ln_Val_ResNeceA_E_x_Ant);

        RETURN ln_Val_BenefApos_xE_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefAposxE_Ant', TRUE);
   END f_Cal_Val_BenefApos_xE_Ant;
       --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_EE_x_Ant
   -- = Descrição: Calcula Contribuição Participante em x E.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_EE_x_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_EE_x_Ant         number;
        ln_Cal_Coe_Srb_x_Ant           number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        ln_Base_Calculo_Ant   := f_Cal_Val_BenefApos_xE_Ant();
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_EE_x_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_EE_x_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_EE_x_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_EE_x_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_EE_xkpp_Ant', TRUE);
   END f_Cal_Ctb_Partic_EE_x_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_SuplXE_liq_Ant
   -- = Descrição: Calcula Contribuição Participante em k pp E.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Val_SuplXE_liq_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Val_Val_SuplXE_liq_Ant    number;
        ln_Val_Benef_Apos_X_E_Ant    number;
        ln_Val_Ctb_Partic_EE_X_Ant   number;
   begin
        ln_Val_Benef_Apos_X_E_Ant  := f_Cal_Val_BenefApos_xE_Ant();
        ln_Val_Ctb_Partic_EE_X_Ant := f_Cal_Ctb_Partic_EE_X_Ant();
        ln_Val_Val_SuplXE_liq_Ant  := ln_Val_Benef_Apos_X_E_Ant
                                    - ln_Val_Ctb_Partic_EE_X_Ant;
   RETURN ln_Val_Val_SuplXE_liq_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_SuplXE_liq_Ant', TRUE);
   END f_Cal_Val_SuplXE_liq_Ant;
    --============================
       --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_EE_xkpp_Ant
   -- = Descrição: Calcula Contribuição Participante em k pp E.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_EE_xkpp_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_EE_xkpp_Ant      number;
        ln_Cal_Coe_Srb_x_Ant           number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        ln_Base_Calculo_Ant   := f_Cal_Val_BenefApos_xk_E_Ant();
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_EE_xkpp_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_EE_xkpp_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_EE_xkpp_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_EE_xkpp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_EE_xkpp_Ant', TRUE);
   END f_Cal_Ctb_Partic_EE_xkpp_Ant;
       --======================================================================================
   -- = Nome:      f_Cal_Val_BenefApos_30_Ant
   -- = Descrição: Calcula Valor Benefício 30.
   -- = Nível:     12.
   --======================================================================================
   FUNCTION f_Cal_Val_BenefApos_30_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_BenefApos_30_Ant        number;
        ln_Per_SemCtb_Ant              number;
--        gn_CodBenef_Ant                number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        li_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        li_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        li_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_Fator_SRB_Ant               number;
        ln_Fator_SB_Ant                number;
        ln_Fator1_Ant                  number;
        ln_Fator2_Ant                  number;
--        gd_DIB_Ant                     date;
        ld_DatIni                      afastamento.dat_inaft_afast%TYPE;
        ln_CorrigeValorINSS            number;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        ln_Per_SemCtb_Ant := f_Cal_Per_Semctb_Ant;
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
---
        sp_Sel_Dados_Afast_Ant (ld_DatIni);
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas,
                                        ln_QtdeVerbasFixas,
                                        ln_MediaVerbasFixas);
        sp_Sel_Dados_TabTempSRCINSS_An (li_SomaVerbasFixas,
                                        li_QtdeVerbasFixas,
                                        li_MediaVerbasFixas);



        if    ln_SexoEmprg   =   'M'  then
              ln_Fator1_Ant := (ln_MediaVerbasFixas * 0.80 -
                                li_MediaVerbasFixas  * 0.70) * ln_Per_SemCtb_Ant;
              ln_Fator2_Ant :=  ln_MediaVerbasFixas * 0.12  * ln_Per_SemCtb_Ant;
              if  ln_fator1_Ant >= ln_fator2_Ant then
                  ln_Val_BenefApos_30_Ant := ln_fator1_Ant;
              else
                  ln_Val_BenefApos_30_Ant := ln_fator2_Ant;
              end if;
        else
              ln_fator1_Ant := (ln_MediaVerbasFixas -
                                li_MediaVerbasFixas ) * ln_Per_SemCtb_Ant;
              ln_fator2_Ant :=  0.15 * ln_MediaVerbasFixas *  ln_Per_SemCtb_Ant;
              if  ln_fator1_Ant >= ln_fator2_Ant then
                  ln_Val_BenefApos_30_Ant := ln_fator1_Ant;
              else
                  ln_Val_BenefApos_30_Ant := ln_fator2_Ant;
              end if;

        end if;

/*        sp_Sel_Dados_TabTempSRCINSS_An (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_CorrigeValorINSS            := PACK_SBF_MEMCALCULO_GERAL.f_CorrigeValorINSS(ld_DatIni, ld_DatIni, gd_DIB_Ant, ln_MediaVerbasFixas);
        IF  ld_DatIni <= TO_DATE ('01/01/1900','DD/MM/YYYY') THEN
            ln_Fator_SB_Ant            := ln_MediaVerbasFixas * 0.70;
        ELSE
            ln_Fator_SB_Ant            := ln_CorrigeValorINSS * 0.70;
        END IF;
        -- Máximo = Valor limite do INSS.
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS);
        IF  ln_Fator_SB_Ant > ln_ValLimINSS * 0.70 THEN ln_Fator_SB_Ant := ln_ValLimINSS * 0.70;
        END IF;

        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Fator_SRB_Ant               := ln_MediaVerbasFixas * 0.80;
        ln_Val_BenefApos_30_Ant := ln_Fator_SRB_Ant - ln_Fator_SB_Ant;
*/
        RETURN ln_Val_BenefApos_30_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_BenefApos_30_Ant', TRUE);
   END f_Cal_Val_BenefApos_30_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_94_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_94_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_Ant              number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
---
        if gc_base = 1 then
           ln_Base_Calculo_Ant := f_Cal_Val_BenefApos_xk_Ant();
        else
           ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
        end if;

 /*       sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_94_Ant', TRUE);
   END f_Cal_Ctb_Partic_94_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_Fu_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_Fu_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_Ant              number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ls_Partic_Fund_Ant  := f_Def_Partic_Fund_Ant();
        ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
 /*       sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_Fu_Ant', TRUE);
   END f_Cal_Ctb_Partic_Fu_Ant;
     --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_Ant              number;
        begin
            IF   gd_Dib_ant  < to_date('07-dec-1994') then
                 ln_Ctb_Partic_Ant := f_Cal_Ctb_Partic_94_Ant();
            else
                 ln_Ctb_Partic_Ant := f_Cal_Ctb_Partic_Fu_Ant();
            end if;
        RETURN ln_Ctb_Partic_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_Ant', TRUE);
   END f_Cal_Ctb_Partic_Ant;
     --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_Esp_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_Esp_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_Esp_Ant          number;
        ln_Cal_Fator_SRB_Ant           number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
 ---       sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Base_Calculo_Ant   := f_Cal_Fator_SRB_Ant;
 ---       ln_Base_Calculo_Ant   := ln_SomaVerbasFixas * ln_Cal_Fator_SRB_Ant;

 /*       sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_Esp_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_Esp_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_Esp_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_Esp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_Esp_Ant', TRUE);
   END f_Cal_Ctb_Partic_Esp_Ant;
     --====================================
     --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Particx_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Particx_Ant             number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ls_Partic_Fund_Ant := f_Def_Partic_Fund_Ant();
---        if  ls_Partic_Fund_Ant = 'S'  and
---            ln_SexoEmprg       = 'F'  then
---            ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
---        else
        if gc_base = 1 then
           ln_Base_Calculo_Ant := f_Cal_Val_BenefAposx_Ant();
        else
           ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
        end if;

 /*       sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Particx_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Particx_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Particx_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Particx_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Particx_Ant', TRUE);
   END f_Cal_Ctb_Particx_Ant;

        --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_E_Xk_Ant
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_E_xk_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_E_xk_Ant          number;
        ln_Cal_Coe_Srb_xk_Ant           number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_Cal_Coe_Srb_xk_Ant := f_Cal_Coe_SRBxk_Ant ();
        ln_Base_Calculo_Ant   := ln_MediaVerbasFixas * ln_Cal_Coe_Srb_xk_Ant;

        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_E_xk_Ant    := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_E_xk_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_E_xk_Ant := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_E_xk_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_E_xk_Ant', TRUE);
   END f_Cal_Ctb_Partic_E_xk_Ant;
     --======================================================================================
   -- = Nome:      f_Cal_Ctb_Partic_xkpp
   -- = Descrição: Calcula Contribuição Participante.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Partic_xkpp RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Partic_xkpp             number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
      BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                                ln_AgenciaEmprg,
                                ln_ContaCorrEmprg,
                                ln_SexoEmprg,
                                ln_DataAdmissEmprg,
                                ln_DataDesligEmprg,
                                ln_DataFalecEmprg,
                                ln_DataNascEmprg,
                                ln_EnderEmprg,
                                ln_BairroEmprg,
                                ln_MunicEmprg,
                                ln_EstadoEmprg,
                                ln_CEPEmprg,
                                ln_EstCivEmprg,
                                ln_CIEmprg,
                                ln_CPFEmprg,
                                ln_ValorSalario);
        -- Declaração de variáveis locais
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ls_Partic_Fund_Ant := f_Def_Partic_Fund_Ant();
        if  gc_base = 1 then
            ln_Base_Calculo_Ant := f_Cal_Val_BenefApos_xkpp_Ant();
        else
            ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
        end if;

 /*       sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
       ---
        IF  ln_Base_Calculo_Ant  <= ln_ValLimINSS/2 THEN
            ln_Ctb_Partic_xkpp   := 0.0145 * ln_Base_Calculo_Ant;
        ELSE
            IF   ln_Base_Calculo_Ant <= ln_ValLimINSS THEN
                 ln_Ctb_Partic_xkpp := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_Base_Calculo_Ant -  (ln_ValLimINSS / 2));
            ELSE
                 ln_Ctb_Partic_xkpp := 0.0145 * (ln_ValLimINSS / 2) + 0.0350 * (ln_ValLimINSS / 2) + 0.0750 * (ln_Base_Calculo_Ant - ln_ValLimINSS);
            END IF;
        END IF;
        RETURN ln_Ctb_Partic_xkpp;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Partic_xkpp', TRUE);
   END f_Cal_Ctb_Partic_xkpp;
       --======================================================================================
   -- = Nome:      f_Cal_Ctb_Patro_94_Ant
   -- = Descrição: Calcula Contribuição Patrocinadora.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Patro_94_Ant RETURN number IS
        -- Declaração de variáveis locais
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Ctb_Patro_Ant               number;
        ln_Fator_RT_Ant                number;
        ln_Ctb_Partic_Ant              number;
        ln_Fator_RI_Ant                number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        /*ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;*/
   BEGIN
      sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                              ln_AgenciaEmprg,
                              ln_ContaCorrEmprg,
                              ln_SexoEmprg,
                              ln_DataAdmissEmprg,
                              ln_DataDesligEmprg,
                              ln_DataFalecEmprg,
                              ln_DataNascEmprg,
                              ln_EnderEmprg,
                              ln_BairroEmprg,
                              ln_MunicEmprg,
                              ln_EstadoEmprg,
                              ln_CEPEmprg,
                              ln_EstCivEmprg,
                              ln_CIEmprg,
                              ln_CPFEmprg,
                              ln_ValorSalario);
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ls_Partic_Fund_Ant := f_Def_Partic_Fund_Ant();
---        if  ls_Partic_Fund_Ant = 'S' THEN
 ---         and ln_SexoEmprg       = 'F'  then
 ---           ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
---        else
             if gc_base = 1 then
                ln_Base_Calculo_Ant := f_Cal_Val_BenefApos_xk_Ant();
             else
                ln_Base_Calculo_Ant := ln_MediaVerbasFixas;
             end if;
 ---

        ln_Fator_RT_Ant                := f_Cal_Fator_RT_Ant;
        ln_Ctb_Partic_Ant              := f_Cal_Ctb_Partic_Ant();
        ln_Fator_RI_Ant                := f_Cal_Fator_RI_Ant();
       /*        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        ln_Ctb_Patro_Ant  := (ln_Fator_RT_Ant * ln_Ctb_Partic_Ant) - (ln_Fator_RI_Ant * ln_Base_Calculo_Ant);
        RETURN ln_Ctb_Patro_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Patro_94_Ant', TRUE);
   END f_Cal_Ctb_Patro_94_Ant;
       --======================================================================================
   -- = Nome:      f_Cal_Ctb_Patro_Fu_Ant
   -- = Descrição: Calcula Contribuição Patrocinadora.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Patro_Fu_Ant RETURN number IS
        -- Declaração de variáveis locais
        ls_Partic_Fund_Ant             varchar2(1);
        ln_Base_Calculo_Ant            number;
        ln_Ctb_Patro_Ant               number;
        ln_Fator_RT_Ant                number;
        ln_Ctb_Partic_Ant              number;
        ln_Fator_RI_Ant                number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ln_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ln_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ln_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ln_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ln_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ln_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ln_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ln_MunicEmprg                  empregado.cod_munici%TYPE;
        ln_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ln_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        /*ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas             tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;*/
   BEGIN
      sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg,
                              ln_AgenciaEmprg,
                              ln_ContaCorrEmprg,
                              ln_SexoEmprg,
                              ln_DataAdmissEmprg,
                              ln_DataDesligEmprg,
                              ln_DataFalecEmprg,
                              ln_DataNascEmprg,
                              ln_EnderEmprg,
                              ln_BairroEmprg,
                              ln_MunicEmprg,
                              ln_EstadoEmprg,
                              ln_CEPEmprg,
                              ln_EstCivEmprg,
                              ln_CIEmprg,
                              ln_CPFEmprg,
                              ln_ValorSalario);
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ls_Partic_Fund_Ant := f_Def_Partic_Fund_Ant();
 ---         and ln_SexoEmprg       = 'F'  then
        ln_Base_Calculo_Ant            := ln_MediaVerbasFixas;
        ln_Fator_RT_Ant                := f_Cal_Fator_RT_Ant;
        ln_Ctb_Partic_Ant              := f_Cal_Ctb_Partic_Ant();
        ln_Fator_RI_Ant                := f_Cal_Fator_RI_Ant();
       /*        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);*/
        ln_Ctb_Patro_Ant  := (ln_Fator_RT_Ant * ln_Ctb_Partic_Ant) - (ln_Fator_RI_Ant * ln_Base_Calculo_Ant);
        RETURN ln_Ctb_Patro_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Patro_Fu_Ant', TRUE);
   END f_Cal_Ctb_Patro_Fu_Ant;
      --======================================================================================
   -- = Nome:      f_Cal_Ctb_Patro_Ant
   -- = Descrição: Calcula Contribuição Patrocinadora.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Patro_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Patro_Fund_Ant             number;

   BEGIN
        IF   gd_Dib_ant  < to_date('07-dec-1994') then
             ln_Patro_Fund_Ant := f_Cal_Ctb_Patro_94_Ant();
        else
             ln_Patro_Fund_Ant := f_Cal_Ctb_Patro_Fu_Ant();
        end if;

    return ln_Patro_Fund_Ant;
        -- Tratamento de erro
    EXCEPTION
         WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Patro_Ant', TRUE);
   END f_Cal_Ctb_Patro_Ant;
     --======================================================================================
   -- = Nome:      f_Cal_Ctb_Tot_Ant
   -- = Descrição: Calcula Contribuição Total.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Cal_Ctb_Tot_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Ctb_Tot_Ant                 number;
        ln_Ctb_Partic_Ant              number;
        ln_Ctb_Patro_Ant               number;
   BEGIN
        ln_Ctb_Partic_Ant              := f_Cal_Ctb_Partic_Ant();
        ln_Ctb_Patro_Ant               := f_Cal_Ctb_Patro_Ant();
        ln_Ctb_Tot_Ant                 := ln_Ctb_Partic_Ant + ln_Ctb_Patro_Ant;
        RETURN ln_Ctb_Tot_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Ctb_Tot_Ant', TRUE);
   END f_Cal_Ctb_Tot_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_Suplxk_liq_Ant
   -- = Descrição: Calcula Valor suplemento liquido no momento x+k.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_Suplxk_liq_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_Suplxk_liq_Ant          number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_Ctb_Partic_Ant              number;
   BEGIN
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xk_Ant();
        ln_Ctb_Partic_Ant              := f_Cal_Ctb_Partic_Ant();
        ln_Val_Suplxk_liq_Ant          := ln_Val_BenefApos_xk_Ant  -  ln_Ctb_Partic_Ant;
        RETURN ln_Val_Suplxk_liq_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_Suplxk_liq_Ant', TRUE);
   END f_Cal_Val_Suplxk_liq_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_Suplxk_liq_Ant
   -- = Descrição: Calcula Valor suplemento liquido no momento x+k.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_Suplxkpp_liq RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_Suplxk_liq_xkpp         number;
        ln_Val_BenefApos_xkpp_Ant      number;
        ln_Ctb_Partic_xkpp             number;
   BEGIN
        ln_Val_BenefApos_xkpp_Ant      := f_Cal_Val_BenefApos_xkpp_Ant();
        ln_Ctb_Partic_xkpp             := f_Cal_Ctb_Partic_xkpp();
        ln_Val_Suplxk_liq_xkpp         := ln_Val_BenefApos_xkpp_Ant  -  ln_Ctb_Partic_xkpp;
        RETURN ln_Val_Suplxk_liq_xkpp;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_Suplxk_liq_Ant', TRUE);
   END f_Cal_Val_Suplxkpp_liq;
    --======================================================================================
   -- = Nome:      f_Cal_Val_Suplx_liq_Ant
   -- = Descrição: Calcula Valor do Suplemento liquido no momento x.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_Suplx_liq_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_Suplx_liq_Ant          number;
        ln_Val_BenefAposTServ_Ant     number;
        ln_Ctb_Partic_Ant             number;
   BEGIN
        ln_Val_BenefAposTServ_Ant     := f_Cal_Val_BenefAposTServx_Ant();
        ln_Ctb_Partic_Ant             := f_Cal_Ctb_Particx_Ant();
        ln_Val_Suplx_liq_Ant          := ln_Val_BenefAposTServ_Ant  -  ln_Ctb_Partic_Ant;
        RETURN ln_Val_Suplx_liq_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_Suplx_liq_Ant', TRUE);
   END f_Cal_Val_Suplx_liq_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_t0k_Ant
   -- = Descrição: Calcula Valor t0/t0+k
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_t0k_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_t0k_Ant                     number;
        ln_Cal_k_Ant                   number;
        ln_Ver_Tem_FiliacaoPl_Ant      number;
   BEGIN
        ln_Ver_Tem_FiliacaoPl_Ant      := f_Ver_Tem_FiliacaoPl_Ant();
        ln_Cal_k_Ant                   := f_Cal_k_Ant();
        ln_t0k_Ant          := ln_Ver_Tem_FiliacaoPl_Ant / (ln_Ver_Tem_FiliacaoPl_Ant  +  ln_Cal_k_Ant);
        RETURN ln_t0k_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_t0k_Ant', TRUE);
   END f_Cal_t0k_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_t0kpp_Ant
   -- = Descrição: Calcula Valor t0/t0+k
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_t0kpp_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_t0kpp_Ant                   number;
        ln_Cal_kpp_Ant                 number;
        ln_Ver_Tem_FiliacaoPl_Ant      number;
   BEGIN
        ln_Ver_Tem_FiliacaoPl_Ant      := f_Ver_Tem_FiliacaoPl_Ant();
        ln_Cal_kpp_Ant                 := f_Vermax_Kpp_Ant();
        ln_t0kpp_Ant                   := ln_Ver_Tem_FiliacaoPl_Ant / (ln_Ver_Tem_FiliacaoPl_Ant  +  ln_Cal_kpp_Ant);
        RETURN ln_t0kpp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_t0kpp_Ant', TRUE);
   END f_Cal_t0kpp_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_t0kppts_Ant
   -- = Descrição: Calcula Valor t0/t0+k
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_t0kppts_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_t0kppts_Ant                   number;
        ln_Cal_kppts_Ant                 number;
        ln_Ver_Tem_FiliacaoPl_Ant        number;
   BEGIN
        ln_Ver_Tem_FiliacaoPl_Ant      := f_Ver_Tem_FiliacaoPl_Ant();
        ln_Cal_kppts_Ant               := f_Vermax_Kppts_Ant();
        ln_t0kppts_Ant                 := ln_Ver_Tem_FiliacaoPl_Ant / (ln_Ver_Tem_FiliacaoPl_Ant  +  ln_Cal_kppts_Ant);
        RETURN ln_t0kppts_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_t0kppts_Ant', TRUE);
   END f_Cal_t0kppts_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResCons_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResCons_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResCons_Ant             number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_Coe_ResCons_Ant             number;
        ln_Ctb_Tot_Ant                 number;
        ln_Coe_aaa12_xk_Ant            number;
   BEGIN
        gc_base                        := 2;
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xk_Ant();
        ln_Coe_ResCons_Ant             := f_Cal_Coe_ResCons_Ant();
        ln_Ctb_Tot_Ant                 := f_Cal_Ctb_Tot_Ant();
        ln_Coe_aaa12_xk_Ant            := f_Cal_Coe_aaa12_xk_Ant;
        ln_Val_ResCons_Ant             := 13  * ( (ln_Val_BenefApos_xk_Ant * ln_Coe_ResCons_Ant) -  (ln_Ctb_Tot_Ant  * ln_Coe_aaa12_xk_Ant));
        RETURN ln_Val_ResCons_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResCons_Ant', TRUE);
   END f_Cal_Val_ResCons_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsA_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsA_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsA_Ant             number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_Coe_ResConsA_Ant            number;
        ln_Ctb_Esp_Ant                 number;
        ln_Cal_Fator_Cont_Ant          number;
        ln_Ctb_Partic_Ant              number;
        ln_Coe_aaa12_xk_Ant            number;
   BEGIN
        gc_base                        := 2;
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xk_Ant();
        ln_Coe_ResConsA_Ant            := f_Cal_Coe_ResConsA_Ant();
        ln_Ctb_Partic_Ant              := f_Cal_Ctb_Partic_Esp_Ant();
        ln_Cal_Fator_Cont_Ant          := f_Cal_Fator_Cont_Ant();
        ln_Ctb_Esp_Ant                 := ln_Ctb_Partic_Ant  *  ln_Cal_Fator_Cont_Ant;
        ln_Coe_aaa12_xk_Ant            := f_Cal_Coe_aaa12_xk_Ant;
        ln_Val_ResConsA_Ant            := ( (ln_Val_BenefApos_xk_Ant * ln_Coe_ResConsA_Ant) -  (ln_Ctb_Esp_Ant  * ln_Coe_aaa12_xk_Ant));
        RETURN ln_Val_ResConsA_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsA_Ant', TRUE);
   END f_Cal_Val_ResConsA_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsAE_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsAE_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsAE_Ant             number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_Coe_ResConsA_Ant            number;
        ln_Ctb_Esp_Ant                 number;
        ln_Cal_Fator_Cont_Ant          number;
        ln_Ctb_Partic_Ant              number;
        ln_Coe_aaa12_xk_Ant            number;
   BEGIN
        gc_base                        := 2;
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xk_Ant();
        ln_Coe_ResConsA_Ant            := f_Cal_Coe_ResConsAE_Ant();
        ln_Ctb_Partic_Ant              := f_Cal_Ctb_Partic_Esp_Ant();
        ln_Cal_Fator_Cont_Ant          := f_Cal_Fator_Cont_Ant();
        ln_Ctb_Esp_Ant                 := ln_Ctb_Partic_Ant  *  ln_Cal_Fator_Cont_Ant;
        ln_Coe_aaa12_xk_Ant            := f_Cal_Coe_aaa12_xkppts();
        ln_Val_ResConsAE_Ant            := ( (ln_Val_BenefApos_xk_Ant * ln_Coe_ResConsA_Ant) -  (ln_Ctb_Esp_Ant  * ln_Coe_aaa12_xk_Ant));
        RETURN ln_Val_ResConsAE_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsA_Ant', TRUE);
   END f_Cal_Val_ResConsAE_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsB_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída B.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsB_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsB_Ant             number;
        ln_Val_BenefApos_30_Ant        number;
        ln_Coe_ResCons_Ant             number;
        ln_Ctb_Tot_Ant                 number;
        ln_Coe_aaa12_xk_Ant            number;
   BEGIN
        gc_base                        := 2;
        ln_Val_BenefApos_30_Ant        := f_Cal_Val_BenefApos_30_Ant();
        ln_Coe_ResCons_Ant             := f_Cal_Coe_ResCons_Ant();
        ln_Ctb_Tot_Ant                 := f_Cal_Ctb_Tot_Ant();
        ln_Coe_aaa12_xk_Ant            := f_Cal_Coe_aaa12_xk_Ant;
        ln_Val_ResConsB_Ant            := 13  * ( (ln_Val_BenefApos_30_Ant * ln_Coe_ResCons_Ant) -  (ln_Ctb_Tot_Ant  * ln_Coe_aaa12_xk_Ant));
        RETURN ln_Val_ResConsB_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsB_Ant', TRUE);
   END f_Cal_Val_ResConsB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsC_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída C.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsC_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsC_Ant             number;
        ln_Val_BenefApos_xk_Ant         number;
        ln_Val_Suplxk_liq_Ant           number;
        ln_Cal_t0k_Ant                  number;
        ln_ax12                         info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                        info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                           info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                           info_atuarial.vlr_nxaa_infatr%TYPE;
        ---
        ln_axk12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                          info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_Kax12                        number;
        ln_Kaxh12                       number;
   BEGIN
        gc_base                        := 1;
        sp_Sel_Dados_InfoAtuar_x_Ant  (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        sp_Sel_Dados_InfoAtuar_xk_Ant (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        ln_Kax12  := (ln_Dxk / ln_Dx) * ln_axk12;
        ln_Kaxh12 := (ln_Dxk / ln_Dx) * ln_axkh12;
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xk_Ant();
        ln_Val_Suplxk_liq_Ant          := f_Cal_Val_Suplxkpp_liq();
        ln_Cal_t0k_Ant                 := f_Cal_t0k_Ant ();
        ln_Val_ResConsC_Ant            := 13  * (( (ln_Val_Suplxk_liq_Ant * ln_Kax12) + (ln_Val_BenefApos_xk_Ant  * ln_Kaxh12 ))* ln_Cal_t0k_Ant);
        RETURN ln_Val_ResConsC_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsC_Ant', TRUE);
   END f_Cal_Val_ResConsC_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsC_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída C.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsD_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsD_Ant             number;
        ln_Val_BenefApos_xk_Ant         number;
        ln_Val_Suplxk_liq_Ant           number;
        ln_Cal_t0k_Ant                  number;
        ln_ax12                         info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                        info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                           info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                           info_atuarial.vlr_nxaa_infatr%TYPE;
        ---
        ln_axk12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                          info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_Kax12                        number;
        ln_Kaxh12                       number;
   BEGIN
        gc_base                       := 1;
        sp_Sel_Dados_InfoAtuar_x_Ant    (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        sp_Sel_Dados_InfoAtuar_xkpp     (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        ln_Kax12  := (ln_Dxk / ln_Dx) * ln_axk12;
        ln_Kaxh12 := (ln_Dxk / ln_Dx) * ln_axkh12;
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xkpp_Ant();
        ln_Val_Suplxk_liq_Ant          := f_Cal_Val_Suplxkpp_liq();
        ln_Cal_t0k_Ant                 := f_Cal_t0kpp_Ant ();
        ln_Val_ResConsD_Ant            := 13  * (( (ln_Val_Suplxk_liq_Ant * ln_Kax12 ) +  (ln_Val_BenefApos_xk_Ant  * ln_Kaxh12))* ln_Cal_t0k_Ant);
        RETURN ln_Val_ResConsD_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsD_Ant', TRUE);
   END f_Cal_Val_ResConsD_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_Suplxk_E_Liq_Ant
   -- = Descrição: Calcula Valor Supl Liq em KE.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_Suplxk_E_Liq_Ant RETURN number IS

        ln_Val_Suplxk_E_Liq_Ant        number;
        ln_Val_BenefApos_xk_E_Ant      number;
        ln_Cal_Ctb_Partic_EE_xkpp_Ant  number;
   begin
        ln_Val_BenefApos_xk_E_Ant     := f_Cal_Val_Benefapos_Xk_e_Ant();
        ln_Cal_Ctb_Partic_EE_xkpp_Ant := f_Cal_Ctb_Partic_EE_xkpp_Ant();
        ln_Val_Suplxk_E_Liq_Ant       := ln_Val_BenefApos_xk_E_Ant - ln_Cal_Ctb_Partic_EE_xkpp_Ant;
        return ln_Val_Suplxk_E_Liq_Ant;
         EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_Suplxk_E_Liq_Ant', TRUE);
   END f_Cal_Val_Suplxk_E_Liq_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Val_ResConsE_Ant
   -- = Descrição: Calcula Valor da Reserva Constituída E.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResConsE_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResConsE_Ant             number;
        ln_Val_BenefApos_xk_E_Ant       number;
        ln_Val_Suplxk_E_liq_Ant         number;
        ln_Cal_t0kpp_Ant                number;
        ln_ax12                         info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                        info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                           info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                           info_atuarial.vlr_nxaa_infatr%TYPE;
        ---
        ln_axk12                        info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axkh12                       info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dxk                          info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nxk                          info_atuarial.vlr_nxaa_infatr%TYPE;
        ln_Kax12                        number;
        ln_Kaxh12                       number;
   BEGIN
        gc_base                       := 1;
        sp_Sel_Dados_InfoAtuar_x_Ant  (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        sp_Sel_Dados_InfoAtuar_xkpp   (ln_axk12, ln_axkh12, ln_Dxk, ln_Nxk);
        ln_Kax12  := (ln_Dxk / ln_Dx) * ln_axk12;
        ln_Kaxh12 := (ln_Dxk / ln_Dx) * ln_axkh12;
        ln_Val_BenefApos_xk_E_Ant      := f_Cal_Val_BenefApos_xk_E_Ant();
        ln_Val_Suplxk_E_liq_Ant        := f_Cal_Val_Suplxk_E_liq_Ant();
        ln_Cal_t0kpp_Ant               := f_Cal_t0kpp_Ant ();
        ln_Val_ResConsE_Ant            := 13  * (( (ln_Val_Suplxk_E_liq_Ant * ln_Kax12) + (ln_Val_BenefApos_xk_E_Ant  * ln_Kaxh12 ))* ln_Cal_t0kpp_Ant);
        RETURN ln_Val_ResConsE_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResConsE_Ant', TRUE);
   END f_Cal_Val_ResConsE_Ant;

   --======================================================================================
   -- = Nome:      f_Cal_Val_ResNec_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNec_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNec_Ant              number;
        ln_Val_BenefApos_xk_Ant        number;
        ln_Coe_ResNec_Ant              number;
   BEGIN
        ln_Val_BenefApos_xk_Ant       := f_Cal_Val_BenefApos_xk_Ant();
        ln_Coe_ResNec_Ant             := f_Cal_Coe_ResNec_Ant();
        ln_Val_ResNec_Ant             := 13  * ln_Val_BenefApos_xk_Ant * ln_Coe_ResNec_Ant ;
        RETURN ln_Val_ResNec_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNec_Ant', TRUE);
   END f_Cal_Val_ResNec_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaA_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaA_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaA_Ant              number;
        ln_Val_BenefApos_xk_Ant          number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        ln_Val_BenefApos_xk_Ant       := f_Cal_Val_BenefApos_xk_Ant();
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Val_ResNecaA_Ant             := ln_Val_BenefApos_xk_Ant * ln_ax12 ;
        RETURN ln_Val_ResNecaA_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaA_Ant', TRUE);
   END f_Cal_Val_ResNecaA_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaAE_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaAE_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaAE_Ant             number;
        ln_Val_BenefApos_xk_Ant          number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        ln_Val_BenefApos_xk_Ant       := f_Cal_Val_BenefApos_xk_Ant();
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Val_ResNecaAE_Ant          := ln_Val_BenefApos_xk_Ant * ln_ax12 ;
        RETURN ln_Val_ResNecaAE_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaAE_Ant', TRUE);
   END f_Cal_Val_ResNecaAE_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaB_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaB_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaB_Ant              number;
        ln_Val_BenefApos_30_Ant          number;
        ln_Coe_ResNec_Ant                number;
   BEGIN
        ln_Val_BenefApos_30_Ant       := f_Cal_Val_BenefApos_30_Ant();
        ln_Coe_ResNec_Ant             := f_Cal_Coe_ResNec_Ant();
        ln_Val_ResNecaB_Ant           := 13 * (ln_Val_BenefApos_30_Ant * ln_Coe_ResNec_Ant )  ;
        RETURN ln_Val_ResNecaB_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaB_Ant', TRUE);
   END f_Cal_Val_ResNecaB_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaC_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaC_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaC_Ant              number;
        ln_Val_BenefApos_xk_Ant          number;
        ln_Val_Suplxk_liq_Ant            number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        gc_base                       := 1;
        ln_Val_BenefApos_xk_Ant       := f_Cal_Val_BenefApos_xk_Ant();
        ln_Val_Suplxk_liq_Ant         := f_Cal_Val_Suplxkpp_liq();
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Val_ResNecaC_Ant             := 13 * ((ln_Val_Suplxk_liq_Ant * ln_ax12)+(ln_Val_BenefApos_xk_Ant * ln_axh12))  ;
        RETURN ln_Val_ResNecaC_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaC_Ant', TRUE);
   END f_Cal_Val_ResNecaC_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaD_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaD_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaD_Ant              number;
        ln_Val_BenefApos_x_Ant           number;
        ln_Val_Suplx_liq_Ant             number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        gc_base                       := 1;
        ln_Val_BenefApos_x_Ant        := f_Cal_Val_BenefAposTServx_Ant();
        ln_Val_Suplx_liq_Ant          := f_Cal_Val_Suplx_liq_Ant();
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Val_ResNecaD_Ant           := 13 * ((ln_Val_Suplx_liq_Ant * ln_ax12)+(ln_Val_BenefApos_x_Ant * ln_axh12))  ;
        RETURN ln_Val_ResNecaD_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaD_Ant', TRUE);
   END f_Cal_Val_ResNecaD_Ant;
      --======================================================================================
   -- = Nome:      f_Cal_Val_ResNecaE_Ant
   -- = Descrição: Calcula Valor da Reserva Necessária.
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_ResNecaE_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_ResNecaE_Ant              number;
        ln_Val_BenefApos_xE_Ant          number;
        ln_Val_SuplxE_liq_Ant            number;
        ln_ax12                          info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                         info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                            info_atuarial.vlr_Dx_infatr%TYPE;
        ln_Nx                            info_atuarial.vlr_Nx_infatr%TYPE;
   BEGIN
        gc_base                       := 1;
        ln_Val_BenefApos_xE_Ant       := f_Cal_Val_BenefApos_xE_Ant();
        ln_Val_SuplxE_liq_Ant         := f_Cal_Val_SuplxE_liq_Ant();
        sp_Sel_Dados_InfoAtuar_x_Ant (ln_ax12, ln_axh12, ln_Dx, ln_Nx);
        ln_Val_ResNecaE_Ant           := 13 * ((ln_Val_SuplxE_liq_Ant * ln_ax12)+(ln_Val_BenefApos_xE_Ant * ln_axh12))  ;
        RETURN ln_Val_ResNecaE_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_ResNecaE_Ant', TRUE);
   END f_Cal_Val_ResNecaE_Ant;

   --======================================================================================
   -- = Nome:      f_Cal_Fator_Prop94_Ant
   -- = Descrição: Calcula Fator de Proporcionalidade Para DIB'S anteriores a 07/12/94.
   -- = Nível:     14.
   --======================================================================================
   FUNCTION f_Cal_Fator_Prop94_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Fator_Prop94_Ant            number;
        ln_Cal_Per_SemCtb_Ant          number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
--        gn_CodBenef_Ant                number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_Serv_Bruto_Ant          number;
        ln_Tem_ExperProfNormTot_Ant    number;
        ln_QtdMesExperProf             number;
        ln_Tem_ExperProf_k_Ant         number;
        ln_Tem_Serv_Min_Ant            number;
        ln_k_Filiacao_Ant              number;
        ln_k_Idade_Ant                 number;
        ln_Val_ResNec_Ant              number;
        ln_Val_ResCons_Ant             number;
        ln_Val_ResNecaA_Ant            number;
        ln_Val_ResNecaAE_Ant           number;
        ln_Val_ResConsA_Ant            number;
        ln_Val_ResConsAE_Ant           number;
        ln_Val_ResNecaB_Ant            number;
        ln_Val_ResConsB_Ant            number;
        ln_Val_ResNecaC_Ant            number;
        ln_Val_ResConsC_Ant            number;
        ln_Val_ResNecaD_Ant            number;
        ln_Val_ResConsD_Ant            number;
        ln_Val_ResNecaE_Ant            number;
        ln_Val_ResConsE_Ant            number;
        ln_Idade_Minima_Ant            number;
        ln_Idade_Empregado_Ant         number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Cal_Per_SemCtb_Ant          := f_Cal_Per_SemCtb_Ant();
        ln_Tem_ExperProf_k_Ant         := f_Cal_Tem_ExperProf_Ant(); --f_Cal_Tem_ExperProf_k_Ant();
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        IF  ln_SexoEmprg                = 'M' THEN
            ln_Tem_Serv_Min_Ant        := 30;
            ln_Idade_Minima_Ant        := 65;
        ELSE
            ln_Tem_Serv_Min_Ant        := 25;
            ln_Idade_Minima_Ant        := 60;
        END IF;
        ln_Idade_Empregado_Ant         := f_Cal_Idade_Emprg_Ant();
        ls_Partic_Fund_Ant             := f_Def_Partic_Fund_Ant();
        ln_k_Filiacao_Ant              := f_Ver_k_Filiacao_Ant();
        ln_k_Idade_Ant                 := f_Ver_k_Idade_Ant();
        ln_Val_ResNec_Ant              := f_Cal_Val_ResNec_Ant();
        ln_Val_ResCons_Ant             := f_Cal_Val_ResCons_Ant();
        ln_Val_ResNecaA_Ant            := f_Cal_Val_ResNecaA_Ant();
        ln_Val_ResConsA_Ant            := f_Cal_Val_ResConsA_Ant();
        ln_Val_ResNecaAE_Ant           := f_Cal_Val_ResNecaAE_Ant();
        ln_Val_ResConsAE_Ant           := f_Cal_Val_ResConsAE_Ant();
        ln_Val_ResNecaB_Ant            := f_Cal_Val_ResNecaB_Ant();
        ln_Val_ResConsB_Ant            := f_Cal_Val_ResConsB_Ant();
        ln_Val_ResNecaC_Ant            := f_Cal_Val_ResNecaC_Ant();
        ln_Val_ResConsC_Ant            := f_Cal_Val_ResConsC_Ant();
        ln_Val_ResNecaD_Ant            := f_Cal_Val_ResNecaD_Ant();
        ln_Val_ResConsD_Ant            := f_Cal_Val_ResConsD_Ant();
        ln_Val_ResNecaE_Ant            := f_Cal_Val_ResNecaE_Ant();
        ln_Val_ResConsE_Ant            := f_Cal_Val_ResConsE_Ant();
        ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        ln_Tem_Serv_Bruto_Ant          := TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0);
---
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();

        IF  gn_CodBenef_Ant = 4 THEN
            IF   ls_Partic_Fund_Ant = 'N' THEN
                 ln_Fator_Prop94_Ant  := (ln_Val_ResConsAE_Ant / ln_Val_ResNecaAE_Ant)
                                       * (ln_Val_ResConsE_Ant / ln_Val_ResNecaE_Ant);
            ELSE

                 ln_Fator_Prop94_Ant := (ln_Val_ResConsA_Ant / ln_Val_ResNecaA_Ant);
            end if;

        ELSE
          if ln_Idade_Empregado_Ant >= ln_Idade_Minima_Ant then
             ln_Fator_Prop94_Ant          := ln_Val_ResConsD_Ant / ln_Val_ResNecaD_Ant ;
          else
          IF ln_Tem_ExperProf_k_Ant < ln_Tem_Serv_Min_Ant THEN
            IF ln_SexoEmprg               = 'F' THEN
              IF ls_Partic_Fund_Ant       = 'S' THEN
                 ln_Fator_Prop94_Ant          := ln_Val_ResConsB_Ant / ln_Val_ResNecaB_Ant ;
              ELSE
                 ln_Fator_Prop94_Ant          := ln_Val_ResConsC_Ant / ln_Val_ResNecaC_Ant ;
              END IF;
            ELSE
              ln_Fator_Prop94_Ant          := ln_Val_ResConsC_Ant / ln_Val_ResNecaC_Ant ;
            END IF;
          ELSE
            IF ln_SexoEmprg               = 'F' THEN
              IF  ln_k_Filiacao_Ant = 0 and ln_k_Idade_Ant = 0 THEN
               ln_Fator_Prop94_Ant          := ln_Val_ResConsB_Ant / ln_Val_ResNecaB_Ant ;
              ELSE
                IF ln_Tem_ExperProf_k_Ant >= 30  THEN
                   ln_Fator_Prop94_Ant          := ln_Val_ResConsD_Ant / ln_Val_ResNecaD_Ant ;
                ELSE
                   ln_Fator_Prop94_Ant          := ln_Val_ResConsC_Ant / ln_Val_ResNecaC_Ant ;
                END IF;
              END IF;
            ELSE
               ln_Fator_Prop94_Ant          := ln_Val_ResConsD_Ant / ln_Val_ResNecaD_Ant ;
            END IF;
          END IF;
        END IF;
        end if;
        IF   gn_CodBenef_Ant = 4 AND ls_AtivFund_Emprg_Ant = 'E'
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_Serv_Bruto_Ant< 25 THEN
            ln_Fator_Prop94_Ant := (ln_Val_ResConsc_Ant / ln_Val_ResNecac_Ant);
        END IF;
        RETURN ln_Fator_Prop94_Ant * ln_Cal_Per_SemCtb_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_Prop94_Ant', TRUE);
   END f_Cal_Fator_Prop94_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Fator_Prop_Ant
   -- = Descrição: Calcula Fator de Proporcionalidade.
   -- = Nível:     14.
   --======================================================================================
   FUNCTION  f_Cal_Fator_Prop_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Fator_Prop_Ant              number;
        ln_Cal_Per_SemCtb_Ant          number;
        ln_k_Ant                       number;
        ln_Val_ResNec_Ant              number;
        ln_Val_ResCons_Ant             number;
        ls_Partic_Fund_Ant             varchar2(1);
        ln_k_Idade_Ant                 number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ExperProf_k_Ant         number;
        ln_Tem_Serv_Min_Ant            number;
        ln_filiacao_anos_ant           number;
        ls_AtivFund_Emprg_Ant          varchar2(1);
        ln_DatVicPlano                 participante_fss.dat_vncfdc_partf%TYPE;
        ln_DatFimInscrPlano            adesao_plano_partic_fss.dat_fim_adplpr%TYPE;
        ln_DatIniInscrPlano            adesao_plano_partic_fss.dat_ini_adplpr%TYPE;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Cal_Per_SemCtb_Ant     := f_Cal_Per_SemCtb_Ant();
        ln_k_Ant                  := f_Cal_k_Ant();
        ln_Val_ResNec_Ant         := f_Cal_Val_ResNec_Ant();
        ln_Val_ResCons_Ant        := f_Cal_Val_ResCons_Ant();
        ls_Partic_Fund_Ant        := f_Def_Partic_Fund_Ant();
        ln_k_Idade_Ant            := f_Ver_k_Idade_Ant();
        ln_filiacao_anos_Ant      := f_Ver_filiacao_anos_Ant();
        ln_Tem_ExperProf_k_Ant    := f_Cal_Tem_ExperProf_Ant(); --f_Cal_Tem_ExperProf_k_Ant();
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        sp_Sel_Dados_AdesPln_Ant( ln_DatVicPlano ,ln_DatFimInscrPlano,ln_DatIniInscrPlano);
        IF  ln_SexoEmprg                = 'M' THEN
            ln_Tem_Serv_Min_Ant        := 30;
        ELSE
            ln_Tem_Serv_Min_Ant        := 25;
        END IF;
        IF gn_PlanoParticipante_Ant = 6 AND
            ls_Partic_Fund_Ant  = 'N' and
            (ln_DatIniInscrPlano>= to_date('15-nov-1974')and
             ln_DatIniInscrPlano<= to_date('31-jan-1983'))and
             ln_k_Idade_AnT<=0 and
             ln_Tem_ExperProf_k_Ant>ln_Tem_Serv_Min_Ant   and
             ln_filiacao_anos_Ant>=5 and ln_filiacao_anos_Ant<=15 THEN
             ln_Fator_Prop_Ant     := ln_filiacao_anos_Ant/15 ;
        ELSE
        IF  gn_CodBenef_Ant = 5 OR gn_CodBenef_Ant = 6 OR gn_CodBenef_Ant = 18 OR gn_CodBenef_Ant = 19 OR ln_k_Ant = 0 THEN
            ln_Fator_Prop_Ant     := 1 ;
        ELSE
            IF  ln_Val_ResNec_Ant = 0 THEN
                ln_Fator_Prop_Ant      := 0 ;
            ELSE
                IF gd_Dib_ant       < to_date('07-dec-1994') THEN
                   ln_Fator_Prop_Ant      := f_Cal_Fator_Prop94_Ant();
                 ELSE
                   ln_Fator_Prop_Ant      := ln_Val_ResCons_Ant / ln_Val_ResNec_Ant ;
             END IF;
            END IF;
        END IF;
        END IF;
        /*ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
         IF   gn_CodBenef_Ant = 4 AND ls_AtivFund_Emprg_Ant = 'E'
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_ExperProf_k_Ant< 30 THEN
            ln_Fator_Prop_Ant := 1;
        END IF;*/
      RETURN ln_Fator_Prop_Ant;
        /*RETURN ln_Fator_Prop_Ant *  ln_Cal_Per_SemCtb_Ant;*/
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_Prop_Ant', TRUE);
   END f_Cal_Fator_Prop_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Fator_Esp_Ant
   -- = Descrição: Calcula Fator de Proporcionalidade especial
   -- = Nível:     14.
   --======================================================================================
   FUNCTION f_Cal_Fator_Esp_Ant RETURN number IS
---
   ln_Val_ResNecaAE_Ant            number;
   ln_Val_ResConsAE_Ant            number;
   ls_Partic_Fund_Ant              CHAR(1);
   ln_Fator_Esp_Ant                number;
---
   begin
     ln_Val_ResNecaAE_Ant       := f_Cal_Val_ResNecaAE_Ant();
     ln_Val_ResConsAE_Ant       := f_Cal_Val_ResConsAE_Ant();
     ls_Partic_Fund_Ant         := f_Def_Partic_Fund_Ant();

     IF  gn_CodBenef_Ant = 4 THEN
         IF gd_Dib_ant   < to_date('07-dec-1994') THEN
            IF   ls_Partic_Fund_Ant = 'N' THEN
                 ln_Fator_Esp_Ant := ln_Val_ResConsAE_Ant / ln_Val_ResNecaAE_Ant;
            ELSE
                 ln_Fator_Esp_Ant := 1;
            end if;
         else
            ln_Fator_Esp_Ant := 1;
         end if;
     else
          ln_Fator_Esp_Ant := 1;
     end if;
     RETURN ln_Fator_Esp_Ant;
 -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_Esp_Ant', TRUE);
   END f_Cal_Fator_Esp_Ant;
    --======================================================================================
   -- = Nome:      f_Cal_Fator_Esp_Ant
   -- = Descrição: Calcula Fator de Proporcionalidade especial
   -- = Nível:     14.
   --======================================================================================
   FUNCTION f_Cal_Fator_Prop_Tl_Ant RETURN number IS
---
   ln_Val_ResNecaE_Ant            number;
   ln_Val_ResConsE_Ant            number;
   ln_Val_ResNecac_Ant            number;
   ln_Val_ResConsc_Ant            number;
   ls_Partic_Fund_Ant             CHAR(1);
   ln_Fator_Prop_Tl_Ant           number;
   ln_Tem_ExperProfNormTot_Ant    number;
   ln_Tem_Serv_Bruto_Ant          number;
   ln_QtdMesExperProf             number;
   ls_AtivFund_Emprg_Ant          CHAR(1);
---
   begin
     ln_Val_ResNecaE_Ant       := f_Cal_Val_ResNecaE_Ant();
     ln_Val_ResConsE_Ant       := f_Cal_Val_ResConsE_Ant();
     ln_Val_ResNecac_Ant       := f_Cal_Val_ResNecac_Ant();
     ln_Val_ResConsc_Ant       := f_Cal_Val_ResConsc_Ant();
     ls_Partic_Fund_Ant        := f_Def_Partic_Fund_Ant();
     ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        ln_Tem_Serv_Bruto_Ant          := TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0);
---
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();

     IF  gn_CodBenef_Ant = 4 THEN
         IF gd_Dib_ant   < to_date('07-dec-1994') THEN
            IF   ls_Partic_Fund_Ant = 'N' THEN
                 IF ln_Val_ResNecaE_Ant = 0 THEN
                    ln_Fator_Prop_Tl_Ant := 0;
                 ELSE
                    ln_Fator_Prop_Tl_Ant := ln_Val_ResConsE_Ant / ln_Val_ResNecaE_Ant;
                 END IF;
            ELSE
                 ln_Fator_Prop_Tl_Ant  := f_Cal_Fator_Prop94_Ant();
            end if;
         else
           ln_Fator_Prop_Tl_Ant  := f_Cal_Fator_Prop_Ant();
         end if;
     else
          ln_Fator_Prop_Tl_Ant := f_Cal_Fator_Prop_Ant();
     end if;
     IF   gn_CodBenef_Ant = 4 AND ls_AtivFund_Emprg_Ant = 'E'
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_Serv_Bruto_Ant< 25 AND gd_dib_ant < to_date('07-dec-1994') THEN
            ln_Fator_Prop_Tl_Ant := (ln_Val_ResConsc_Ant / ln_Val_ResNecac_Ant);
        END IF;
     RETURN ln_Fator_Prop_Tl_Ant;
 -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Fator_Prop_Tl_Ant', TRUE);
   END f_Cal_Fator_Prop_Tl_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_Pensao_Ant
   -- = Descrição: Calcula valor da pensão.
   -- = Nível:     15.
   --======================================================================================
   FUNCTION f_Cal_Val_Pensao_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_Pensao_Ant              number;
--        gn_CodBenef_Ant                number;
        ln_Val_BenefAposInv_Ant        number;
        ln_Fator_Prop_Ant              number;
        ln_Coe_Pensao_Ant              number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Val_BenefAposInv_Ant        := f_Cal_Val_BenefAposInv_Ant();
        ln_Fator_Prop_Ant              := f_Cal_Fator_Prop_Ant();
        ln_Coe_Pensao_Ant              := f_Cal_Coe_Pensao_Ant();
        IF  gn_CodBenef_Ant     = 18 or gn_CodBenef_Ant     = 19 THEN
            ln_Val_Pensao_Ant          := (ln_Val_BenefAposInv_Ant * ln_Fator_Prop_Ant) * ln_Coe_Pensao_Ant;
        ELSE
            ln_Val_Pensao_Ant          := 0;
        END IF;
        RETURN ln_Val_Pensao_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_Pensao_Ant', TRUE);
   END f_Cal_Val_Pensao_Ant;
      --======================================================================================
   -- = Nome:      f_Cal_Val_Saldo_Ant
   -- = Descrição: Calcula Valor do Saldo de Reversão de Poupança
   -- = Nível:     13.
   --======================================================================================
   FUNCTION f_Cal_Val_Saldo_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_Saldo_Ant                number;
        ln_Saldo_Ant                    number;
        ln_ax12                         info_atuarial.vlr_ax12_infatr%TYPE;
        ln_axh12                        info_atuarial.vlr_axh12_infatr%TYPE;
        ln_Dx                           info_atuarial.vlr_dxaa_infatr%TYPE;
        ln_Nx                           info_atuarial.vlr_nxaa_infatr%TYPE;
        ---

   BEGIN
        sp_Sel_Dados_InfoAtuar_x_Ant  (ln_ax12,  ln_axh12,  ln_Dx,  ln_Nx);
        sp_Sel_Saldo_Ant  (ln_Saldo_Ant);
        ln_Val_Saldo_Ant               := (ln_Saldo_Ant / (13*(ln_ax12 + ln_axh12 )));
        RETURN ln_Val_Saldo_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_Saldo_Ant', TRUE);
   END f_Cal_Val_Saldo_Ant;

   --======================================================================================
   -- = Nome:      f_Cal_Val_SuplIni_Ant
   -- = Descrição: Calcula Valor Suplemento Inicial.
   -- = Nível:     16.
   --======================================================================================
   FUNCTION f_Cal_Val_SuplIni_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_SuplIni_Ant             number;
--        gn_CodBenef_Ant                number;
        ln_Val_BenefAposTServ_Ant      number;
        ln_Val_Saldo_Ant               number;
        ln_Val_BenefAposIda_Ant        number;
        ln_Val_BenefAposInv_Ant        number;
        ln_Val_Pensao_Ant              number;
        ln_Fator_Prop_Ant              number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Val_BenefAposTServ_Ant      := f_Cal_Val_BenefAposTServ_Ant();
        ln_Val_BenefAposIda_Ant        := f_Cal_Val_BenefAposIda_Ant();
        ln_Val_BenefAposInv_Ant        := f_Cal_Val_BenefAposInv_Ant();
        ln_Val_Pensao_Ant              := f_Cal_Val_Pensao_Ant();
        ln_Fator_Prop_Ant              := f_Cal_Fator_Prop_Ant();
        IF    gn_CodBenef_Ant     IN (2, 4, 7) THEN ln_Val_SuplIni_Ant := ln_Val_BenefAposTServ_Ant * ln_Fator_Prop_Ant;
        ELSIF gn_CodBenef_Ant     = 3          THEN ln_Val_SuplIni_Ant := ln_Val_BenefAposIda_Ant   * ln_Fator_Prop_Ant;
        ELSIF gn_CodBenef_Ant     IN (5, 6)    THEN ln_Val_SuplIni_Ant := ln_Val_BenefAposInv_Ant;
        ELSIF gn_CodBenef_Ant     IN (18, 19)  THEN ln_Val_SuplIni_Ant := ln_Val_Pensao_Ant;
        ELSE  ln_Val_SuplIni_Ant  := 0;
        END IF;
        IF    ln_Val_SuplIni_Ant   < 0 THEN
              ln_Val_Saldo_Ant      := f_Cal_Val_Saldo_Ant();
              ln_Val_SuplIni_Ant := ln_Val_Saldo_Ant;
        END IF;
        RETURN ln_Val_SuplIni_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_SuplIni_Ant', TRUE);
   END f_Cal_Val_SuplIni_Ant;
   --======================================================================================
   -- = Nome:      f_Cal_Val_SuplIniTab_Ant
   -- = Descrição: Calcula Valor Supl.Inicial a ser gravado na tabela.
   -- = Nível:     17.
   --======================================================================================
   FUNCTION f_Cal_Val_SuplIniTab_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Val_SuplIniTab_Ant          number;
--        gn_CodBenef_Ant                number;
        ln_Val_SuplIni_Ant             number;
        ln_Val_BenefAposInv_Ant        number;
        ln_Fator_Prop_Ant              number;
   BEGIN
--        gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
        ln_Val_SuplIni_Ant             := f_Cal_Val_SuplIni_Ant();
        ln_Val_BenefAposInv_Ant        := f_Cal_Val_BenefAposInv_Ant();
        ln_Fator_Prop_Ant              := f_Cal_Fator_Prop_Ant();
        IF    gn_CodBenef_Ant     IN (2, 3, 4, 5, 6, 7)  THEN ln_Val_SuplIniTab_Ant := ln_Val_SuplIni_Ant;
        ELSIF gn_CodBenef_Ant     IN (18, 19)            THEN ln_Val_SuplIniTab_Ant := ln_Val_BenefAposInv_Ant * ln_Fator_Prop_Ant;
        ELSE  ln_Val_SuplIniTab_Ant := 0;
        END IF;
        RETURN ln_Val_SuplIniTab_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Cal_Val_SuplIniTab_Ant', TRUE);
   END f_Cal_Val_SuplIniTab_Ant;
   --======================================================================================
   --  Alterações sobre tempos, enviadas em .CLC
   --======================================================================================

   --======================================================================================
   -- = Nome:      sp_Cal_DatFim_Averb_Ant
   -- = Descrição: Calcula data Final da averbação.
   -- = Nível:     2.
   --======================================================================================
   PROCEDURE sp_Cal_DatFim_Averb_Ant (ad_DatfimAverb_Ant  OUT incidencia_empregado.dat_fimvig_incemp%TYPE) IS
        -- Declaração de variáveis locais
--        gn_CodEmpresa_Ant              number;
--        gn_NumMatricEmpregado_Ant      number;
        ld_DatIniAverb                 incidencia_empregado.dat_inivig_incemp%TYPE;
   BEGIN
--        gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
--        gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
        sp_Cal_MinDat_Averb_Ant(ld_DatIniAverb);
SELECT nvl(incidencia_empregado.dat_fimvig_incemp, TO_DATE('01/01/1900','DD/MM/YYYY'))
  INTO ad_DatfimAverb_Ant
  FROM incidencia_empregado
 WHERE incidencia_empregado.cod_emprs         = gn_CodEmpresa_Ant AND
       incidencia_empregado.num_rgtro_emprg   = gn_NumMatricEmpregado_Ant AND
       incidencia_empregado.cod_incdpc        = 11 AND
       incidencia_empregado.dat_inivig_incemp = ld_DatIniAverb ;
        -- Tratamento de erro
        EXCEPTION
            WHEN No_Data_Found THEN
                ad_DatfimAverb_Ant     := TO_DATE('01/01/1900','DD/MM/YYYY');
--                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_DatFim_Averb_Ant não retornou nenhum valor');
            WHEN too_many_rows THEN
                RAISE_APPLICATION_ERROR (-20020, 'sp_Cal_DatFim_Averb_Ant mais de uma linha');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar sp_Cal_DatFim_Averb_Ant', TRUE);
    END sp_Cal_DatFim_Averb_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEsp_Ant
   -- = Descrição: Define tempo de serviço Especial Anterior.
   -- = Nível:     2.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEsp_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEsp_Ant             number;
        ln_QtdMesExperProf             number;
   BEGIN
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        ln_Tem_ServEsp_Ant             := (ln_QtdMesExperProf * 30);
        -- Valor mínimo = 0
        IF  ln_Tem_ServEsp_Ant < 0 THEN ln_Tem_ServEsp_Ant := 0;
        END IF;
        RETURN ln_Tem_ServEsp_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEsp_Ant', TRUE);
   END f_Def_Tem_ServEsp_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspConvert_Ant
   -- = Descrição: Define tempo de serviço Especial Convertido.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspConvert_Ant RETURN number IS
          -- Declaração de variáveis locais
        ln_Tem_ServEspConvert_Ant      number;
        ln_BancoEmprg                  empregado.cod_banco%TYPE;
        ln_AgenciaEmprg                empregado.cod_agbco%TYPE;
        ls_ContaCorrEmprg              empregado.num_ctcor_emprg%TYPE;
        ln_SexoEmprg                   empregado.cod_sexo_emprg%TYPE;
        ld_DataAdmissEmprg             empregado.dat_admss_emprg%TYPE;
        ld_DataDesligEmprg             empregado.dat_deslg_emprg%TYPE;
        ld_DataFalecEmprg              empregado.dat_falec_emprg%TYPE;
        ld_DataNascEmprg               empregado.dat_nascm_emprg%TYPE;
        ls_EnderEmprg                  empregado.dcr_ender_emprg%TYPE;
        ls_BairroEmprg                 empregado.nom_bairro_emprg%TYPE;
        ls_MunicEmprg                  empregado.cod_munici%TYPE;
        ls_EstadoEmprg                 empregado.cod_estado%TYPE;
        ln_CEPEmprg                    empregado.cod_cep_emprg%TYPE;
        ln_EstCivEmprg                 empregado.cod_estcv_emprg%TYPE;
        ls_CIEmprg                     empregado.num_ci_emprg%TYPE;
        ln_CPFEmprg                    empregado.num_cpf_emprg%TYPE;
        ln_ValorSalario                empregado.vlr_salar_emprg%TYPE;
        ln_Tem_ServEsp_Ant             number;
   BEGIN
        sp_Sel_Dados_Emprg_Ant (ln_BancoEmprg, ln_AgenciaEmprg, ls_ContaCorrEmprg, ln_SexoEmprg, ld_DataAdmissEmprg, ld_DataDesligEmprg, ld_DataFalecEmprg, ld_DataNascEmprg, ls_EnderEmprg, ls_BairroEmprg, ls_MunicEmprg, ls_EstadoEmprg, ln_CEPEmprg, ln_EstCivEmprg, ls_CIEmprg, ln_CPFEmprg, ln_ValorSalario);
        ln_Tem_ServEsp_Ant             := f_Def_Tem_ServEsp_Ant();
        IF  ln_SexoEmprg = 'F' THEN
            ln_Tem_ServEspConvert_Ant  := (ln_Tem_ServEsp_Ant * 1.2);
        ELSE
            ln_Tem_ServEspConvert_Ant  := (ln_Tem_ServEsp_Ant * 1.4);
        END IF;
        -- Valor mínimo = 0
        IF  ln_Tem_ServEspConvert_Ant < 0 THEN ln_Tem_ServEspConvert_Ant := 0;
        END IF;
        RETURN ln_Tem_ServEspConvert_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspConvert_Ant', TRUE);
   END f_Def_Tem_ServEspConvert_Ant;
     --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspConvertF_Ant
   -- = Descrição: Define tempo de serviço Especial Convertido.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspConvertF_Ant RETURN number IS
          -- Declaração de variáveis locais
        ln_Tem_ServEspConvertF_Ant     number;
        ln_Tem_ServEsp_Ant             number;
        ln_Def_AtivFund_Ant           VARCHAR2(1);
   BEGIN
        ln_Tem_ServEsp_Ant             := f_Def_Tem_ServEsp_Ant();
        ln_Def_AtivFund_Ant            := f_Def_AtivFund_Emprg_Ant();
        IF  ln_Def_AtivFund_Ant  = 'N' THEN
            ln_Tem_ServEspConvertf_Ant  := (ln_Tem_ServEsp_Ant * 1.2);
        ELSE
            ln_Tem_ServEspConvertf_Ant  := ln_Tem_ServEsp_Ant ;
        END IF;
        -- Valor mínimo = 0
        IF  ln_Tem_ServEspConvertf_Ant < 0 THEN ln_Tem_ServEspConvertf_Ant := 0;
        END IF;
        RETURN ln_Tem_ServEspConvertf_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspConvertf_Ant', TRUE);
   END f_Def_Tem_ServEspConvertf_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspDib_Anos_Ant
   -- = Descrição: Define tempo de serviço Especial Dib em anos.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspDib_Anos_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEspDib_Anos_Ant     number;
        ln_Tem_ServEsp_Ant             number;
   BEGIN
        ln_Tem_ServEsp_Ant             := f_Def_Tem_ServEsp_Ant();
        ln_Tem_ServEspDib_Anos_Ant     := TRUNC((ln_Tem_ServEsp_Ant / 360), 0);
        RETURN ln_Tem_ServEspDib_Anos_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspDib_Anos_Ant', TRUE);
   END f_Def_Tem_ServEspDib_Anos_Ant;
   --======================================================================================
   -- = Nome:      f_Periodo_averbacao_Ant
   -- = Descrição: Periodo averbação.
   -- = Nível:     3.
   --======================================================================================
   FUNCTION f_Periodo_averbacao_Ant RETURN VARCHAR2 IS
           -- Declaração de variáveis locais
        ls_Periodo_averbacao_Ant       VARCHAR2(8);
        ld_DatIniAverb                 incidencia_empregado.dat_inivig_incemp%TYPE;
        ld_DatfimAverb_Ant             incidencia_empregado.dat_fimvig_incemp%TYPE;
   BEGIN
        sp_Cal_MinDat_Averb_Ant (ld_DatIniAverb);
        sp_Cal_DatFim_Averb_Ant (ld_DatfimAverb_Ant);
        ls_Periodo_averbacao_Ant       := PACK_SBF_MEMCALCULO_GERAL.f_PeriodoEntreDatas (ld_DatIniAverb, ld_DatfimAverb_Ant);
        RETURN ls_Periodo_averbacao_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Periodo_averbacao_Ant', TRUE);
   END f_Periodo_averbacao_Ant;

   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspConv_Anos_Ant
   -- = Descrição: Define tempo de serviço Especial Convertido anos.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspConv_Anos_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEspConv_Anos_Ant    number;
        ln_Tem_ServEspConvert_Ant      number;
   BEGIN
        ln_Tem_ServEspConvert_Ant      := f_Def_Tem_ServEspConvert_Ant();
        ln_Tem_ServEspConv_Anos_Ant    := TRUNC ((ln_Tem_ServEspConvert_Ant / 360), 0);
        -- Valor mínimo = 0
        IF  ln_Tem_ServEspConv_Anos_Ant < 0 THEN ln_Tem_ServEspConv_Anos_Ant := 0;
        END IF;
        RETURN ln_Tem_ServEspConv_Anos_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspConv_Anos_Ant', TRUE);
   END f_Def_Tem_ServEspConv_Anos_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspConv_Dias_Ant
   -- = Descrição: Define tempo de serviço Especial Convertidoem dias.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspConv_Dias_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEspConv_Dias_Ant    number;
        ln_Tem_ServEspConvert_Ant      number;
        ln_Tem_ServEspConv_Anos_Ant    number;
   BEGIN
        ln_Tem_ServEspConvert_Ant      := f_Def_Tem_ServEspConvert_Ant();
        ln_Tem_ServEspConv_Anos_Ant    := f_Def_Tem_ServEspConv_Anos_Ant();
        ln_Tem_ServEspConv_Dias_Ant    := ROUND (((((ln_Tem_ServEspConvert_Ant / 360) -
                                                 (ln_Tem_ServEspConv_Anos_Ant)) * 12) -
                                                 (TRUNC ((((ln_Tem_ServEspConvert_Ant / 360) -
                                                 (ln_Tem_ServEspConv_Anos_Ant)) * 12), 0))) * 30, 0);
        -- Valor mínimo = 0
        IF ln_Tem_ServEspConv_Dias_Ant < 0 THEN ln_Tem_ServEspConv_Dias_Ant := 0;
        END IF;
        RETURN ln_Tem_ServEspConv_Dias_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspConv_Dias_Ant', TRUE);
   END f_Def_Tem_ServEspConv_Dias_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspConv_Meses_An
   -- = Descrição: Define tempo de serviço especial converti em meses.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspConv_Meses_An RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEspConv_Meses_An    number;
        ln_Tem_ServEspConvert_Ant      number;
        ln_Tem_ServEspConv_Anos_Ant    number;
   BEGIN
        ln_Tem_ServEspConvert_Ant      := f_Def_Tem_ServEspConvert_Ant();
        ln_Tem_ServEspConv_Anos_Ant    := f_Def_Tem_ServEspConv_Anos_Ant();
        IF TRUNC ((((ln_Tem_ServEspConvert_Ant / 360) -
           (ln_Tem_ServEspConv_Anos_Ant)) * 12), 0) = 12 THEN
           ln_Tem_ServEspConv_Meses_An := 0;
        ELSE
           ln_Tem_ServEspConv_Meses_An := TRUNC ((((ln_Tem_ServEspConvert_Ant / 360) -
           (ln_Tem_ServEspConv_Anos_Ant)) * 12), 0);
        END IF;
        -- Valor mínimo = 0
        IF  ln_Tem_ServEspConv_Meses_An < 0 THEN ln_Tem_ServEspConv_Meses_An := 0;
        END IF;
        RETURN ln_Tem_ServEspConv_Meses_An;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspConv_Meses_An', TRUE);
   END f_Def_Tem_ServEspConv_Meses_An;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspDib_Dias_Ant
   -- = Descrição: Define tempo de serviço especial Dib em dias.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspDib_Dias_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEspDib_Dias_Ant     number;
        ln_Tem_ServEsp_Ant             number;
        ln_Tem_ServEspDib_Anos_Ant     number;
   BEGIN
        ln_Tem_ServEsp_Ant             := f_Def_Tem_ServEsp_Ant();
        ln_Tem_ServEspDib_Anos_Ant     := f_Def_Tem_ServEspDib_Anos_Ant();
        ln_Tem_ServEspDib_Dias_Ant     := ROUND (((((ln_Tem_ServEsp_Ant / 360) -
                                          (ln_Tem_ServEspDib_Anos_Ant)) * 12) -
                                          (TRUNC ((((ln_Tem_ServEsp_Ant / 360) -
                                          (ln_Tem_ServEspDib_Anos_Ant)) * 12), 0))) * 30, 0);
        RETURN ln_Tem_ServEspDib_Dias_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspDib_Dias_Ant', TRUE);
   END f_Def_Tem_ServEspDib_Dias_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServEspDib_Meses_Ant
   -- = Descrição: Define tempo de serviço especial Dib em meses.
   -- = Nível:     4.
   --======================================================================================
   FUNCTION f_Def_Tem_ServEspDib_Meses_Ant RETURN number IS
           -- Declaração de variáveis locais
        ln_Tem_ServEspDib_Meses_Ant    number;
        ln_Tem_ServEsp_Ant             number;
        ln_Tem_ServEspDib_Anos_Ant     number;
   BEGIN
        ln_Tem_ServEsp_Ant             := f_Def_Tem_ServEsp_Ant();
        ln_Tem_ServEspDib_Anos_Ant     := f_Def_Tem_ServEspDib_Anos_Ant();
        IF  TRUNC ((((ln_Tem_ServEsp_Ant / 360) -
            (ln_Tem_ServEspDib_Anos_Ant)) * 12), 0) = 12 THEN
            ln_Tem_ServEspDib_Meses_Ant := 0;
        ELSE
            ln_Tem_ServEspDib_Meses_Ant := TRUNC ((((ln_Tem_ServEsp_Ant / 360) -
                                             (ln_Tem_ServEspDib_Anos_Ant)) * 12), 0);
        END IF;
        RETURN ln_Tem_ServEspDib_Meses_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServEspDib_Meses_Ant', TRUE);
   END f_Def_Tem_ServEspDib_Meses_Ant;
    --======================================================================================
    -- = Nome:      f_Periodo_Averbacao_dias_Ant
    -- = Descrição: Periodo Averbação em dias
    -- = Nível:     4.
    --======================================================================================
    FUNCTION f_Periodo_Averbacao_dias_Ant RETURN NUMBER IS
        -- Declaração de variáveis locais
        ln_Periodo_Averbacao_dias_Ant  number;
        ls_Periodo_averbacao_Ant       varchar2(8);
    BEGIN
        ls_Periodo_averbacao_Ant       := f_Periodo_averbacao_Ant();
        ln_Periodo_Averbacao_dias_Ant  := to_number( substr( ls_Periodo_averbacao_Ant, 1, 4 )) * 360 +
                                          to_number( substr( ls_Periodo_averbacao_Ant, 5, 2 )) * 30  +
                                          to_number( substr( ls_Periodo_averbacao_Ant, 7, 2 ));
        RETURN ln_Periodo_Averbacao_dias_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Periodo_Averbacao_dias_Ant', TRUE);
    END f_Periodo_Averbacao_dias_Ant;

    --======================================================================================
    -- = Nome:      f_String_tempo_esp_dib_Ant
    -- = Descrição: String do tempo total de serviço
    -- = Nível:     4.
    --======================================================================================
    FUNCTION f_String_tempo_esp_dib_Ant RETURN varchar2 IS
        -- Declaração de variáveis locais
        ls_String_tempo_esp_dib_Ant    varchar2(25);
        ln_Tem_ServEspDib_Anos_Ant     number;
        ln_Tem_ServEspDib_Meses_Ant    number;
        ln_Tem_ServEspDib_Dias_Ant     number;
    BEGIN
        ln_Tem_ServEspDib_Anos_Ant     := f_Def_Tem_ServEspDib_Anos_Ant();
        ln_Tem_ServEspDib_Meses_Ant    := f_Def_Tem_ServEspDib_Meses_Ant();
        ln_Tem_ServEspDib_Dias_Ant     := f_Def_Tem_ServEspDib_Dias_Ant();
        ls_String_tempo_esp_dib_Ant    := to_char( ln_Tem_ServEspDib_Anos_Ant,'00')  || 'Anos '  ||
                                          to_char( ln_Tem_ServEspDib_Meses_Ant,'00') || 'Meses ' ||
                                          to_char( ln_Tem_ServEspDib_Dias_Ant,'00')  || 'Dias';
        RETURN ls_String_tempo_esp_dib_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_String_tempo_esp_dib_Ant', TRUE);
    END f_String_tempo_esp_dib_Ant;
   --======================================================================================
   -- = Nome:      f_Def_Tem_ServNor_Ant
   -- = Descrição: Define tempo de serviço Normal Anterior.
   -- = Nível:     5.
   --======================================================================================
   FUNCTION f_Def_Tem_ServNor_Ant RETURN number IS
            -- Declaração de variáveis locais
        ln_Tem_ServNor_Ant             number;
        ln_Tem_ExperProfNormTot_Ant    number;
        ln_Periodo_Averbacao_dias_Ant  number;
        ln_Periodo_Sem_Contrib_dia_Ant number;
   BEGIN
        ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        ln_Periodo_Averbacao_dias_Ant  := f_Periodo_Averbacao_dias_Ant();
        ln_Periodo_Sem_Contrib_dia_Ant := f_Periodo_Sem_Contrib_dia_Ant();
        ln_Tem_ServNor_Ant             := (ln_Tem_ExperProfNormTot_Ant * 30) -
--                                      ln_Periodo_Averbacao_dias_Ant - ln_Periodo_Sem_Contrib_dia_Ant;
                                                                           ln_Periodo_Sem_Contrib_dia_Ant;
        -- Valor mínimo = 0
        IF  ln_Tem_ServNor_Ant < 0 THEN ln_Tem_ServNor_Ant := 0;
        END IF;
        RETURN ln_Tem_ServNor_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServNor_Ant', TRUE);
   END f_Def_Tem_ServNor_Ant;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotal_Ant
    -- = Descrição: Define tempo de serviço Total Anterior.
    -- = Nível:     5.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotal_Ant RETURN NUMBER IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotal_Ant           number;
        ln_Tem_ServEspConvert_Ant      number;
        ln_Tem_ServNor_Ant             number;
    BEGIN
        ln_Tem_ServEspConvert_Ant      := f_Def_Tem_ServEspConvert_Ant();
        ln_Tem_ServNor_Ant             := f_Def_Tem_ServNor_Ant();
        ln_Tem_ServTotal_Ant           := ln_Tem_ServEspConvert_Ant + ln_Tem_ServNor_Ant;
        -- Valor mínimo = 0
        IF  ln_Tem_ServTotal_Ant < 0 THEN ln_Tem_ServTotal_Ant := 0;
        END IF;
        RETURN ln_Tem_ServTotal_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotal_Ant', TRUE);
    END f_Def_Tem_ServTotal_Ant;
       --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalF_Ant
    -- = Descrição: Define tempo de serviço Total Anterior.
    -- = Nível:     5.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalF_Ant RETURN NUMBER IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalF_Ant           number;
        ln_Tem_ServEspConvertF_Ant      number;
        ln_Tem_ServNor_Ant             number;
    BEGIN
        ln_Tem_ServEspConvertF_Ant     := f_Def_Tem_ServEspConvertF_Ant();
        ln_Tem_ServNor_Ant             := f_Def_Tem_ServNor_Ant();
        ln_Tem_ServTotalF_Ant          := ln_Tem_ServEspConvertF_Ant + ln_Tem_ServNor_Ant;
        -- Valor mínimo = 0
        IF  ln_Tem_ServTotalF_Ant < 0 THEN ln_Tem_ServTotalF_Ant := 0;
        END IF;
        RETURN ln_Tem_ServTotalF_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalF_Ant', TRUE);
    END f_Def_Tem_ServTotalF_Ant;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServNorDib_Anos_Ant
    -- = Descrição: Define tempo de serviço Especial Dib em anos
    -- = Nível:     6.
    --======================================================================================
    FUNCTION f_Def_Tem_ServNorDib_Anos_Ant RETURN NUMBER IS
        -- Declaração de variáveis locais
        ln_Tem_ServNorDib_Anos_Ant     number;
        ln_Tem_ServNor_Ant             number;
    BEGIN
        ln_Tem_ServNor_Ant             := f_Def_Tem_ServNor_Ant();
        ln_Tem_ServNorDib_Anos_Ant     := TRUNC ((ln_Tem_ServNor_Ant / 360), 0);
        IF  ln_Tem_ServNorDib_Anos_Ant < 0 THEN ln_Tem_ServNorDib_Anos_Ant := 0;
        END IF;
        RETURN ln_Tem_ServNorDib_Anos_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServNorDib_Anos_Ant', TRUE);
    END f_Def_Tem_ServNorDib_Anos_Ant;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalDib_Anos_Ant
    -- = Descrição: Define tempo de serviço total Dib em anos
    -- = Nível:     6.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalDib_Anos RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalDib_Anos       number;
        ln_Tem_ServTotal_Ant           number;
    BEGIN
        ln_Tem_ServTotal_Ant           := f_Def_Tem_ServTotal_Ant();
        ln_Tem_ServTotalDib_Anos       := TRUNC ((ln_Tem_ServTotal_Ant / 360), 0);
        IF ln_Tem_ServTotalDib_Anos < 0 THEN ln_Tem_ServTotalDib_Anos := 0;
        END IF;
        RETURN ln_Tem_ServTotalDib_Anos;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalDib_Anos', TRUE);
    END f_Def_Tem_ServTotalDib_Anos;
        --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalDib_AnosF_Ant
    -- = Descrição: Define tempo de serviço total Dib em anos
    -- = Nível:     6.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalDib_AnosF RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalDib_AnosF      number;
        ln_Tem_ServTotalF_Ant          number;
    BEGIN
        ln_Tem_ServTotalF_Ant          := f_Def_Tem_ServTotalF_Ant();
        ln_Tem_ServTotalDib_AnosF      := TRUNC ((ln_Tem_ServTotalF_Ant / 360), 0);
        IF ln_Tem_ServTotalDib_AnosF < 0 THEN ln_Tem_ServTotalDib_AnosF := 0;
        END IF;
        RETURN ln_Tem_ServTotalDib_AnosF;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalDib_AnosF', TRUE);
    END f_Def_Tem_ServTotalDib_AnosF;
    --======================================================================================
    -- = Nome:      f_String_tempo_esp_conv_Ant
    -- = Descrição: String do tempo especial convertido
    -- = Nível:     6.
    --======================================================================================
    FUNCTION f_String_tempo_esp_conv RETURN VARCHAR2 IS
        -- Declaração de variáveis locais
        ls_String_tempo_esp_conv       varchar2(25);
        ln_Tem_ServEspConv_Anos_Ant    number;
        ln_Tem_ServEspConv_Meses_An    number;
        ln_Tem_ServEspConv_Dias_Ant    number;
    BEGIN
        ln_Tem_ServEspConv_Anos_Ant    := f_Def_Tem_ServEspConv_Anos_Ant();
        ln_Tem_ServEspConv_Meses_An    := f_Def_Tem_ServEspConv_Meses_An();
        ln_Tem_ServEspConv_Dias_Ant    := f_Def_Tem_ServEspConv_Dias_Ant();
        ls_String_tempo_esp_conv       := to_char(ln_Tem_ServEspConv_Anos_Ant,'00') || 'Anos '  ||
                                          to_char(ln_Tem_ServEspConv_Meses_An,'00') || 'Meses ' ||
                                          to_char(ln_Tem_ServEspConv_Dias_Ant,'00') || 'Dias';
        RETURN ls_String_tempo_esp_conv;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_String_tempo_esp_conv', TRUE);
    END f_String_tempo_esp_conv;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServNorDib_Dias_Ant
    -- = Descrição: Define tempo de serviço Normal Dib em dias
    -- = Nível:     7.
    --======================================================================================
    FUNCTION f_Def_Tem_ServNorDib_Dias_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServNorDib_Dias_Ant     number;
        ln_Tem_ServNor_Ant             number;
        ln_Tem_ServNorDib_Anos_Ant     number;
    BEGIN
        ln_Tem_ServNor_Ant             := f_Def_Tem_ServNor_Ant();
        ln_Tem_ServNorDib_Anos_Ant     := f_Def_Tem_ServNorDib_Anos_Ant();
        ln_Tem_ServNorDib_Dias_Ant     := ROUND (((((ln_Tem_ServNor_Ant / 360) -
                                                    (ln_Tem_ServNorDib_Anos_Ant)) * 12) -
                                          (TRUNC ((((ln_Tem_ServNor_Ant / 360) -
                                                    (ln_Tem_ServNorDib_Anos_Ant)) * 12), 0))) * 30, 0);
        -- Não tem este mínimo em PlAntigo, mas tem na memória de cálculo.
        IF ln_Tem_ServNorDib_Dias_Ant < 0 THEN ln_Tem_ServNorDib_Dias_Ant := 0;
        END IF;
        RETURN ln_Tem_ServNorDib_Dias_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServNorDib_Dias_Ant', TRUE);
    END f_Def_Tem_ServNorDib_Dias_Ant;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServNorDib_Meses_Ant
    -- = Descrição: Define tempo de serviço normal Dib em meses
    -- = Nível:     7.
    --======================================================================================
    FUNCTION f_Def_Tem_ServNorDib_Meses_Ant RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServNorDib_Meses_Ant    number;
        ln_Tem_ServNor_Ant             number;
        ln_Tem_ServNorDib_Anos_Ant     number;
    BEGIN
        ln_Tem_ServNor_Ant             := f_Def_Tem_ServNor_Ant();
        ln_Tem_ServNorDib_Anos_Ant     := f_Def_Tem_ServNorDib_Anos_Ant();
        IF  TRUNC ((((ln_Tem_ServNor_Ant/360) - (ln_Tem_ServNorDib_Anos_Ant))*12), 0) = 12 THEN
            ln_Tem_ServNorDib_Meses_Ant := 0;
        ELSE
            ln_Tem_ServNorDib_Meses_Ant := TRUNC ((((ln_Tem_ServNor_Ant/360) - (ln_Tem_ServNorDib_Anos_Ant))*12), 0);
        END IF;
        -- Não tem este mínimo em PlAntigo, mas tem na memória de cálculo.
        IF ln_Tem_ServNorDib_Meses_Ant < 0 THEN ln_Tem_ServNorDib_Meses_Ant := 0;
        END IF;
        RETURN ln_Tem_ServNorDib_Meses_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServNorDib_Meses_Ant', TRUE);
    END f_Def_Tem_ServNorDib_Meses_Ant;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalDib_Dias_A
    -- = Descrição: Define tempo de serviço total Dib em dias
    -- = Nível:     7.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalDib_Dias_A RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalDib_Dias_Ant   number;
        ln_Tem_ServTotal_Ant           number;
        ln_Tem_ServTotalDib_Anos       number;
    BEGIN
        ln_Tem_ServTotal_Ant           := f_Def_Tem_ServTotal_Ant();
        ln_Tem_ServTotalDib_Anos       := f_Def_Tem_ServTotalDib_Anos();
        ln_Tem_ServTotalDib_Dias_Ant := ROUND (((((ln_Tem_ServTotal_Ant / 360) -
                                                  (ln_Tem_ServTotalDib_Anos)) * 12) -
                                              (TRUNC ((((ln_Tem_ServTotal_Ant / 360) -
                                                        (ln_Tem_ServTotalDib_Anos)) * 12), 0))) * 30, 0);
        -- Não tem este mínimo em PlAntigo, mas tem na memória de cálculo.
        IF ln_Tem_ServTotalDib_Dias_Ant < 0 THEN ln_Tem_ServTotalDib_Dias_Ant := 0;
        END IF;
        RETURN ln_Tem_ServTotalDib_Dias_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalDib_Dias_A', TRUE);
    END f_Def_Tem_ServTotalDib_Dias_A;
        --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalDib_Dias_AF
    -- = Descrição: Define tempo de serviço total Dib em dias
    -- = Nível:     7.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalDib_Dias_AF RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalDib_DiasF_Ant   number;
        ln_Tem_ServTotalF_Ant           number;
        ln_Tem_ServTotalDib_AnosF       number;
    BEGIN
        ln_Tem_ServTotalF_Ant           := f_Def_Tem_ServTotalF_Ant();
        ln_Tem_ServTotalDib_AnosF       := f_Def_Tem_ServTotalDib_AnosF();
        ln_Tem_ServTotalDib_DiasF_Ant := ROUND (((((ln_Tem_ServTotalF_Ant / 360) -
                                                  (ln_Tem_ServTotalDib_AnosF)) * 12) -
                                              (TRUNC ((((ln_Tem_ServTotalF_Ant / 360) -
                                                        (ln_Tem_ServTotalDib_AnosF)) * 12), 0))) * 30, 0);
        -- Não tem este mínimo em PlAntigo, mas tem na memória de cálculo.
        IF ln_Tem_ServTotalDib_DiasF_Ant < 0 THEN ln_Tem_ServTotalDib_DiasF_Ant := 0;
        END IF;
        RETURN ln_Tem_ServTotalDib_DiasF_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalDib_Dias_AF', TRUE);
    END f_Def_Tem_ServTotalDib_Dias_AF;
    --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalDib_Meses_A
    -- = Descrição: Define tempo de serviço total Dib em Meses
    -- = Nível:     7.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalDib_Meses_A RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalDib_Meses_A    number;
        ln_Tem_ServTotal_Ant           number;
        ln_Tem_ServTotalDib_Anos       number;
    BEGIN
        ln_Tem_ServTotal_Ant           := f_Def_Tem_ServTotal_Ant();
        ln_Tem_ServTotalDib_Anos       := f_Def_Tem_ServTotalDib_Anos();
        IF  TRUNC ((((ln_Tem_ServTotal_Ant / 360) - (ln_Tem_ServTotalDib_Anos)) * 12), 0) = 12 THEN
            ln_Tem_ServTotalDib_Meses_A := 0;
        ELSE
            ln_Tem_ServTotalDib_Meses_A := TRUNC ((((ln_Tem_ServTotal_Ant / 360) - (ln_Tem_ServTotalDib_Anos)) * 12), 0);
        END IF;
        -- Não tem este mínimo em PlAntigo, mas tem na memória de cálculo.
        IF ln_Tem_ServTotalDib_Meses_A < 0 THEN ln_Tem_ServTotalDib_Meses_A := 0;
        END IF;
        RETURN ln_Tem_ServTotalDib_Meses_A;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalDib_Meses_A', TRUE);
    END f_Def_Tem_ServTotalDib_Meses_A;
        --======================================================================================
    -- = Nome:      f_Def_Tem_ServTotalDib_Meses_AF
    -- = Descrição: Define tempo de serviço total Dib em Meses
    -- = Nível:     7.
    --======================================================================================
    FUNCTION f_Def_Tem_ServTotalDib_Mes_AF RETURN number IS
        -- Declaração de variáveis locais
        ln_Tem_ServTotalDib_Meses_AF    number;
        ln_Tem_ServTotalF_Ant           number;
        ln_Tem_ServTotalDib_AnosF       number;
    BEGIN
        ln_Tem_ServTotalF_Ant          := f_Def_Tem_ServTotalF_Ant();
        ln_Tem_ServTotalDib_AnosF      := f_Def_Tem_ServTotalDib_AnosF();
        IF  TRUNC ((((ln_Tem_ServTotalF_Ant / 360) - (ln_Tem_ServTotalDib_AnosF)) * 12), 0) = 12 THEN
            ln_Tem_ServTotalDib_Meses_AF := 0;
        ELSE
            ln_Tem_ServTotalDib_Meses_AF := TRUNC ((((ln_Tem_ServTotalF_Ant / 360) - (ln_Tem_ServTotalDib_AnosF)) * 12), 0);
        END IF;
        -- Não tem este mínimo em PlAntigo, mas tem na memória de cálculo.
        IF ln_Tem_ServTotalDib_Meses_AF < 0 THEN ln_Tem_ServTotalDib_Meses_AF := 0;
        END IF;
        RETURN ln_Tem_ServTotalDib_Meses_AF;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Def_Tem_ServTotalDib_Meses_AF', TRUE);
    END f_Def_Tem_ServTotalDib_Mes_AF;
    --======================================================================================
    -- = Nome:      f_String_tempo_nor_dib_Ant
    -- = Descrição: String do tempo normal de serviço
    -- = Nível:     8.
    --======================================================================================
    FUNCTION f_String_tempo_nor_dib_Ant RETURN varchar2 IS
        -- Declaração de variáveis locais
        ls_String_tempo_nor_dib_Ant    varchar2(25);
        ln_Tem_ServNorDib_Anos_Ant     number;
        ln_Tem_ServNorDib_Meses_Ant    number;
        ln_Tem_ServNorDib_Dias_Ant     number;
    BEGIN
        ln_Tem_ServNorDib_Anos_Ant     := f_Def_Tem_ServNorDib_Anos_Ant();
        ln_Tem_ServNorDib_Meses_Ant    := f_Def_Tem_ServNorDib_Meses_Ant();
        ln_Tem_ServNorDib_Dias_Ant     := f_Def_Tem_ServNorDib_Dias_Ant();
        ls_String_tempo_nor_dib_Ant    := to_char( ln_Tem_ServNorDib_Anos_Ant,'00')  || 'Anos '  ||
                                          to_char( ln_Tem_ServNorDib_Meses_Ant,'00') || 'Meses ' ||
                                          to_char( ln_Tem_ServNorDib_Dias_Ant,'00')  || 'Dias';
        RETURN ls_String_tempo_nor_dib_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_String_tempo_nor_dib_Ant', TRUE);
    END f_String_tempo_nor_dib_Ant;
    --======================================================================================
    -- = Nome:      f_String_tempo_total_dib_Ant
    -- = Descrição: String do tempo total de serviço
    -- = Nível:     8.
    --======================================================================================
    FUNCTION f_String_tempo_total_dib_Ant RETURN varchar2 IS
    -- Declaração de variáveis locais
        ln_String_tempo_total_dib_Ant  varchar2(25);
        ln_Tem_ServTotalDib_Anos       number;
        ln_Tem_ServTotalDib_Meses_A    number;
        ln_Tem_ServTotalDib_Dias_Ant   number;
    BEGIN
        ln_Tem_ServTotalDib_Anos       := f_Def_Tem_ServTotalDib_Anos();
        ln_Tem_ServTotalDib_Meses_A    := f_Def_Tem_ServTotalDib_Meses_A();
        ln_Tem_ServTotalDib_Dias_Ant   := f_Def_Tem_ServTotalDib_Dias_A();
        ln_String_tempo_total_dib_Ant  := to_char(ln_Tem_ServTotalDib_Anos,'00')     || 'Anos '  ||
                                          to_char(ln_Tem_ServTotalDib_Meses_A,'00')  || 'Meses ' ||
                                          to_char(ln_Tem_ServTotalDib_Dias_Ant,'00') || 'Dias';
        RETURN ln_String_tempo_total_dib_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_String_tempo_total_dib_Ant', TRUE);
    END f_String_tempo_total_dib_Ant;
        --======================================================================================
    -- = Nome:      f_String_tempo_total_dibF_Ant
    -- = Descrição: String do tempo total de serviço
    -- = Nível:     8.
    --======================================================================================
    FUNCTION f_String_tempo_total_dibF_Ant RETURN varchar2 IS
    -- Declaração de variáveis locais
        ln_String_tempo_total_dibF_Ant  varchar2(25);
        ln_Tem_ServTotalDib_AnosF       number;
        ln_Tem_ServTotalDib_Meses_AF    number;
        ln_Tem_ServTotalDib_DiasF_Ant   number;
    BEGIN
        ln_Tem_ServTotalDib_AnosF       := f_Def_Tem_ServTotalDib_AnosF();
        ln_Tem_ServTotalDib_Meses_AF    := f_Def_Tem_ServTotalDib_Mes_AF();
        ln_Tem_ServTotalDib_DiasF_Ant   := f_Def_Tem_ServTotalDib_Dias_AF();
        ln_String_tempo_total_dibF_Ant  := to_char(ln_Tem_ServTotalDib_AnosF,'00')     || 'Anos '  ||
                                          to_char(ln_Tem_ServTotalDib_Meses_AF,'00')  || 'Meses ' ||
                                          to_char(ln_Tem_ServTotalDib_DiasF_Ant,'00') || 'Dias';
        RETURN ln_String_tempo_total_dibF_Ant;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_String_tempo_total_dibF_Ant', TRUE);
    END f_String_tempo_total_dibF_Ant;

  PROCEDURE sp_cadastra_argumento IS
    gi_Session    number;
    x             number;
    SeqMemCalculo number ;
  BEGIN
     -- Procedure criada para atender ao chamado: PSD-23489
     -- Cadastra argumentos por sessao aberta
     -- 
     SELECT USERENV ('SESSIONID')
       INTO gi_Session
       FROM dual;

    select nvl(max(a.codsessao),0)
     into x
    from ATT.att_calculus_sessao a
    where a.codsessao = gi_Session;
   
    if x = 0 then
      -- att_calculus_sessao
      --
      insert into att.att_calculus_sessao
      values(gi_Session,'AMD',null,sysdate);
      --
      -- att_calculus_argumento_sp
      --
      -- NumMatricParticipante
      insert into att.att_calculus_argumento_sp  a
      values (gi_Session,1,'NumMatricParticipante','N',null,null,0.0000000,null,null);
      
      -- Lei_8880
      insert into att.att_calculus_argumento_sp  a
      values (gi_Session,2,'Lei_8880','L',null,null,0.0000000,null,null);
      --
    end if;
  END sp_cadastra_argumento;
  
       --======================================================================================
    -- = Nome:      f_ArgumentosCalculus
    -- = Descrição: Inicializa os argumentos do calculus.
    -- = Nível:     01.
    --======================================================================================
    FUNCTION f_ArgumentosCalculus (as_CallInterno                 IN char,
                                   an_NumMatricParticipante       IN number,
                                   an_PlanoParticipante           IN number,
                                   an_CodEmpresa                  IN number,
                                   an_NumMatricEmpregado          IN number,
                                   an_CodBenef                    IN number,
                                   ad_DIB                         IN date,
                                   ac_lei8880                     IN char) RETURN NUMBER IS
        -- Declaração de variáveis locais
    BEGIN
        IF  as_CallInterno = 'S' THEN
            sp_cadastra_argumento;
            
            -- Inicialização das variáveis públicas do pacote:
            gn_NumMatricParticipante_Ant   := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
            gn_PlanoParticipante_Ant       := PACK_CALCULUS.GetArgumentoNumerico ('PlanoParticipante');
            gn_CodEmpresa_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('CodEmpresa');
            gn_NumMatricEmpregado_Ant      := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricEmpregado');
            gn_CodBenef_Ant                := PACK_CALCULUS.GetArgumentoNumerico ('CodBenef');
            gd_DIB_Ant                     := PACK_CALCULUS.GetArgumentoData ('DIB');
            gc_lei8880                     := PACK_CALCULUS.GetArgumentoLiteral ('Lei_8880');
        ELSE
            -- Inicialização das variáveis públicas utilizando os valores do pacote chamador:
            gn_NumMatricParticipante_Ant   := an_NumMatricParticipante;
            gn_PlanoParticipante_Ant       := an_PlanoParticipante;
            gn_CodEmpresa_Ant              := an_CodEmpresa;
            gn_NumMatricEmpregado_Ant      := an_NumMatricEmpregado;
            gn_CodBenef_Ant                := an_CodBenef;
            gd_DIB_Ant                     := ad_DIB;
            gc_lei8880                     := ac_lei8880;
        END IF;
        RETURN 0;
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_ArgumentosCalculus', TRUE);
    END f_ArgumentosCalculus;
   --======================================================================================
   --                                                                                    --
   --                               Parte de gravação da tabela                          --
   --                                                                                    --
   --======================================================================================
   --======================================================================================
   -- = Nome:      sp_SBF_MemCalculo_PlAntigo
   -- = Descrição: Grava a tabela Simulacao_bd_rodape_fss, linha a linha.
   -- = Nível:     18.
   --======================================================================================
   PROCEDURE sp_SBF_MemCalculo_PlAntigo  IS
        -- Declaração de variáveis locais
        ln_CodRetorno                  number;
        ln_ArgumentosCalculus          number;
--        gn_NumMatricParticipante_Ant              number;
        ln_NumSqnclSmlbnf              number;
        ln_NumSqnclSmlrdp              number;
        ls_DcrInfcalcSmlrdp            varchar2(50);
        ls_DcrFrmcalcSmlrdp            varchar2(120);
        ln_VlrResformSmlrdp            number;
        ln_NumTabelaSmlrdp             number;
        ls_DcrColunaSmlrdp             varchar2(20);
        ls_DcrVlrcolSmlrdp             varchar2(20);
        -- Declaração de variáveis locais: sp_Sel_Dados_TabTempSRCINSS_An (linhas 2, 3)
        ln_SomaVerbasFixas             tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        ln_QtdeVerbasFixas             number;
        ln_MediaVerbasFixas            tmp_sal_contrib_fss.vlr_slrctr%TYPE;
        -- Declaração de variáveis locais: sp_Ver_Val_LimINSS_Ant (linha 4)
        ln_ValLimINSS                  limite_inss_fss.vlr_maximo_limins%TYPE;
        ln_ValMinINSS                  limite_inss_fss.vlr_minimo_limins%TYPE;
        -- Declaração de variáveis locais: f_Cal_Coe_SB_Ant (linha 5)
        ln_Coe_SB_Ant                  number;
        -- Declaração de variáveis locais: f_Cal_Coe_Pensao_INSS_Ant (linha 6)
        ln_Coe_Pensao_INSS_Ant         number;
        -- Declaração de variáveis locais: f_Cal_Fator_SB_Ant (linha 7, 15)
        ln_Fator_SB_Ant                number;
        -- Declaração de variáveis locais: f_Cal_ValINSS_Ant (linha 8)
        ln_ValINSS_Ant                 number;
        -- Declaração de variáveis locais: f_Cal_Val_PensaoINSS_Ant (linha 9)
        ln_Val_PensaoINSS_Ant          number;
        -- Declaração de variáveis locais: sp_Sel_Dados_TabTempSRCVFixa_A (linhas 12, 13)
        ln_SomaVerbasFixas12           tmp_sal_contrib_fss.vlr_somcor_slrctr%TYPE;
        ln_QtdeVerbasFixas12           tmp_sal_contrib_fss.qtd_ctbins_slrctr%TYPE;
        ln_MediaVerbasFixas12          tmp_sal_contrib_fss.vlr_sbb_slrctr%TYPE;
        -- Declaração de variáveis locais: f_Cal_Coe_SRB_Ant (linha 14)
        ln_Coe_SRB_Ant                 number;
        -- Declaração de variáveis locais: f_Cal_Val_BenefApos_xk_Ant (linha 16)
        ln_Val_BenefApos_xk_Ant        number;
        -- Declaração de variáveis locais: f_Cal_Val_BenefMin_Ant (linha 17)
        ln_Val_BenefMin_Ant            number;
        -- Declaração de variáveis locais: f_Cal_Fator_Prop_Ant (linha 18)
        ln_Fator_Prop_Ant              number;
        -- Declaração de variáveis locais: f_Cal_Coe_Pensao_Ant (linha 19, 21)
        ln_Coe_Pensao_Ant              number;
        ln_Val_SuplIniTab_Ant          number;
        -- Declaração de variáveis locais: f_Cal_Val_SuplIni_Ant (linha 21)
        ln_Val_SuplIni_Ant             number;
        -- Declaração de variáveis locais: f_String_tempo_nor_dib_Ant (linha 23)
        ls_String_tempo_nor_dib_Ant    varchar2(25);
        -- Declaração de variáveis locais: f_String_tempo_esp_dib_Ant (linha 24)
        ls_String_tempo_esp_dib_Ant    varchar2(25);
        -- Declaração de variáveis locais: f_String_tempo_esp_conv (linha 25)
        ls_String_tempo_esp_conv       varchar2(25);
        -- Declaração de variáveis locais: f_String_tempo_total_dib_Ant (linha 26)
        ln_String_tempo_total_dib_Ant  varchar2(25);
         ln_String_tempo_total_dibF_Ant  varchar2(25);
         ln_Tem_ExperProfNormTot_Ant    number;
   ln_Tem_Serv_Bruto_Ant          number;
   ln_QtdMesExperProf             number;
   ls_AtivFund_Emprg_Ant          CHAR(1);
---

         NUM_LINHA_ERRO NUMBER :=0;
   BEGIN
        -- Inicialização das variáveis públicas:
        ln_ArgumentosCalculus          := f_ArgumentosCalculus('S', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
        ln_CodRetorno                  := 0;
--        gn_NumMatricParticipante_Ant              := PACK_CALCULUS.GetArgumentoNumerico ('NumMatricParticipante');
        ln_NumSqnclSmlbnf              := PACK_CALCULUS.GetArgumentoNumerico ('SeqMemCalculo');

      DELETE FROM simulacao_bd_rodape_fss
             WHERE num_matr_partf   = gn_NumMatricParticipante_Ant
                AND num_sqncl_smlbnf = ln_NumSqnclSmlbnf;
       COMMIT;
        NUM_LINHA_ERRO := 1;
        -- Gravação da linha 1
        ln_NumSqnclSmlrdp              := 1;
        ls_DcrInfcalcSmlrdp            := 'I - RENDA OFICIAL';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        ATT.PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        NUM_LINHA_ERRO := 2;
        -- Gravação da linha 2
        sp_Sel_Dados_TabTempSRCINSS_An (ln_SomaVerbasFixas, ln_QtdeVerbasFixas, ln_MediaVerbasFixas);
        ln_NumSqnclSmlrdp              := 2;
        ls_DcrInfcalcSmlrdp            := '01 - Soma Salários Contrib. Corrigidos';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_SomaVerbasFixas,2);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        NUM_LINHA_ERRO := 3;
        -- Gravação da linha 3
        ln_NumSqnclSmlrdp              := 3;
        ls_DcrInfcalcSmlrdp            := '02 - Salário de Benefício';
        ls_DcrFrmcalcSmlrdp            := '(1/36)';
        ln_VlrResformSmlrdp            := TRUNC(ln_MediaVerbasFixas,2);
        ln_NumTabelaSmlrdp             := 1;
        ls_DcrColunaSmlrdp             := 'vlr_sb_bfpart';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_MediaVerbasFixas,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 4
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
           if ln_MediaVerbasFixas >= ln_ValLimINSS then
              ln_MediaVerbasFixas  := ln_ValLimINSS;
           end if;
                ln_NumSqnclSmlrdp      := 4;
        ls_DcrInfcalcSmlrdp            := '03 - Limite Salário Benefício';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := ln_ValLimINSS;
        ln_NumTabelaSmlrdp             := 3;
        ls_DcrColunaSmlrdp             := 'vlr_sb_bfpart';
        ls_DcrVlrcolSmlrdp             :=  TRUNC(ln_MediaVerbasFixas,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 5
        ln_Coe_SB_Ant                  := f_Cal_Coe_SB_Ant();
        ln_NumSqnclSmlrdp              := 5;
        ls_DcrInfcalcSmlrdp            := '04 - Percentual de Cálculo (PCSB)';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Coe_SB_Ant,2);
        ln_NumTabelaSmlrdp             := 3;
        ls_DcrColunaSmlrdp             := 'vripctcalculoinss';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_Coe_SB_Ant,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 6
        ln_Coe_Pensao_INSS_Ant         := f_Cal_Coe_Pensao_INSS_Ant();
        ln_NumSqnclSmlrdp              := 6;
        ls_DcrInfcalcSmlrdp            := '05 - Coeficiente de Pensão';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Coe_Pensao_INSS_Ant,2);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 7
        ln_Fator_SB_Ant                := f_Cal_Fator_SB_Ant();
        sp_Ver_Val_LimINSS_Ant (ln_ValLimINSS, ln_ValMinINSS);
        if    ln_Fator_SB_Ant  < ln_ValMinINSS then
              ln_Fator_SB_Ant  := ln_ValMinINSS;
        end if;
        ln_NumSqnclSmlrdp              := 7;
        ls_DcrInfcalcSmlrdp            := '06 - Renda Mensal Inicial';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Fator_SB_Ant,2);
        ln_NumTabelaSmlrdp             := 3;
        ls_DcrColunaSmlrdp             := 'vrivalrmiteorico';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_Fator_SB_Ant,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 8
        ln_ValINSS_Ant                 := f_Cal_ValINSS_Ant();
        ln_NumSqnclSmlrdp              := 8;
        ls_DcrInfcalcSmlrdp            := '07 - Renda Real Atualizada';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_ValINSS_Ant,2);
        ln_NumTabelaSmlrdp             := 1;
        ls_DcrColunaSmlrdp             := 'vlr_ininss_bfpart';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_Fator_SB_Ant,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 9
         IF   gn_CodBenef_Ant IN(18,19) THEN
        ln_Fator_SB_Ant                := f_Cal_Fator_SB_Ant();
        ln_Coe_Pensao_INSS_Ant         := f_Cal_Coe_Pensao_INSS_Ant();
        ln_Val_PensaoINSS_Ant          := ln_Fator_SB_Ant * ln_Coe_Pensao_INSS_Ant;
        ELSE
        ln_Val_PensaoINSS_Ant          := f_Cal_Val_PensaoINSS_Ant();
        END IF;
        ln_NumSqnclSmlrdp              := 9;
        ls_DcrInfcalcSmlrdp            := '08 - Valor da Pensão';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Val_PensaoINSS_Ant,2);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 10
        ln_NumSqnclSmlrdp              := 10;
        ls_DcrInfcalcSmlrdp            := NULL;
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 11
        ln_NumSqnclSmlrdp              := 11;
        ls_DcrInfcalcSmlrdp            := 'II - SUPLEMENTAÇÃO';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 12
        sp_Sel_Dados_TabTempSRCVFixa_A (ln_SomaVerbasFixas12, ln_QtdeVerbasFixas12, ln_MediaVerbasFixas12);
        ln_NumSqnclSmlrdp              := 12;
        ls_DcrInfcalcSmlrdp            := '01 - Soma Sal. Reais Contr. Corrigidos';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_SomaVerbasFixas12,2);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 13
        ln_NumSqnclSmlrdp              := 13;
        ls_DcrInfcalcSmlrdp            := '02 - Salário Real de Benefício';
        ls_DcrFrmcalcSmlrdp            := '(1/12)';
        ln_VlrResformSmlrdp            := TRUNC(ln_MediaVerbasFixas12,2);
        ln_NumTabelaSmlrdp             := 1;
        ls_DcrColunaSmlrdp             := 'vlr_sbb_bfpart';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_MediaVerbasFixas12,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 14
        ln_Coe_SRB_Ant                 := f_Cal_Coe_SRB_Ant();
        ln_NumSqnclSmlrdp              := 14;
        ls_DcrInfcalcSmlrdp            := '03 - Percentual de Cálculo (PCSRB)';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Coe_SRB_Ant,2);
        ln_NumTabelaSmlrdp             := 3;
        ls_DcrColunaSmlrdp             := 'vripctcalculosrb';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_Coe_SRB_Ant,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 15
        ln_NumSqnclSmlrdp              := 15;
        ls_DcrInfcalcSmlrdp            := '04 - Renda Mensal Inicial Prev. Oficial Teórico';
        IF GC_LEI8880                <> 'S' then
        ls_DcrFrmcalcSmlrdp            := NULL;
        else
        ls_DcrFrmcalcSmlrdp            := '(Não Limitado)';
        end if;
        ln_VlrResformSmlrdp            := TRUNC(ln_Fator_SB_Ant,2);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 16
        ln_Val_BenefApos_xk_Ant        := f_Cal_Val_BenefApos_xk_Ant();
        ln_NumSqnclSmlrdp              := 16;
        ls_DcrInfcalcSmlrdp            := '05 - Valor da Suplementação Normal';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Val_BenefApos_xk_Ant,2);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 17
        ln_Val_BenefMin_Ant            := f_Cal_Val_BenefMin_Ant();
        ln_NumSqnclSmlrdp              := 17;
        ls_DcrInfcalcSmlrdp            := '06 - Benefício Mínimo';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Val_BenefMin_Ant,2);
        ln_NumTabelaSmlrdp             := 3;
        ls_DcrColunaSmlrdp             := 'adb_valorbenefminimo';
        ls_DcrVlrcolSmlrdp             := TRUNC(ln_Val_BenefMin_Ant,2);
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
         -- Gravação da linha 18
        ln_Fator_Prop_Ant              := f_Cal_Fator_Esp_Ant();
        ln_NumSqnclSmlrdp              := 18;
        ls_DcrInfcalcSmlrdp            := '07 - Fator Redutor Apos. Especial';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := Round(ln_Fator_Prop_Ant,5);

        --- fator pp total --------
        ln_Fator_Prop_Ant              := f_Cal_Fator_Prop_Ant();
        ln_NumTabelaSmlrdp             := 3;
        ls_DcrColunaSmlrdp             := 'vripctfatorpp';
        ls_DcrVlrcolSmlrdp             := Round(ln_Fator_Prop_Ant,5);
        ln_Tem_ExperProfNormTot_Ant    := f_Cal_Tem_ExperProfNormTot_Ant();
        sp_Cal_Tem_ExperProfEsp_Ant (ln_QtdMesExperProf);
        ln_Tem_Serv_Bruto_Ant          := TRUNC((ln_Tem_ExperProfNormTot_Ant + ln_QtdMesExperProf)/12,0);
        ls_AtivFund_Emprg_Ant          := f_Def_AtivFund_Emprg_Ant();
         IF   gn_CodBenef_Ant = 4 AND ls_AtivFund_Emprg_Ant = 'E'
             AND gn_PlanoParticipante_Ant = 4 AND
            ln_Tem_Serv_Bruto_Ant< 25 THEN
            ls_DcrVlrcolSmlrdp             := '1,00';
            ln_VlrResformSmlrdp            := 1;
        END IF;

        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 18
        ln_Fator_Prop_Ant              := f_Cal_Fator_Prop_Tl_Ant();
        ln_NumSqnclSmlrdp              := 19;
        ls_DcrInfcalcSmlrdp            := '08 - Fator Redutor (PP)';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := Round(ln_Fator_Prop_Ant,5);
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 19
        ln_Coe_Pensao_Ant              := f_Cal_Coe_Pensao_Ant();
        ln_Val_SuplIniTab_Ant          := f_Cal_Val_SuplIniTab_Ant();
        ln_NumSqnclSmlrdp              := 20;
        ls_DcrInfcalcSmlrdp            := '09 - Coeficiente de Pensão';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Coe_Pensao_Ant,2);
        ln_NumTabelaSmlrdp             := 1;
        ls_DcrColunaSmlrdp             := 'vlr_inisupl_bfpart';
        ls_DcrVlrcolSmlrdp             := REPLACE(TO_CHAR(TRUNC(ln_Val_SuplIniTab_Ant,2)),'.',',');
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 20
--        ln_NumSqnclSmlrdp              := 21;
---        ls_DcrInfcalcSmlrdp            := NULL;
--        ls_DcrFrmcalcSmlrdp            := NULL;
---        ln_VlrResformSmlrdp            := NULL;
---        ln_NumTabelaSmlrdp             := NULL;
---        ls_DcrColunaSmlrdp             := NULL;
--        ls_DcrVlrcolSmlrdp             := NULL;
---        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 21
        ln_Val_SuplIni_Ant             := f_Cal_Val_SuplIni_Ant();
        ln_NumSqnclSmlrdp              := 22;
        ls_DcrInfcalcSmlrdp            := '10 - Suplemento Inicial';
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := TRUNC(ln_Val_SuplIni_Ant,2);
        ln_NumTabelaSmlrdp             := 1;
        ls_DcrColunaSmlrdp             := 'vlr_inisupl_bfpart';
        ls_DcrVlrcolSmlrdp             := REPLACE(TO_CHAR(TRUNC(ln_Val_SuplIniTab_Ant,2)),'.',',');
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 22
        ln_NumSqnclSmlrdp              := 23;
        ls_DcrInfcalcSmlrdp            := NULL;
        ls_DcrFrmcalcSmlrdp            := NULL;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 23
        ls_String_tempo_nor_dib_Ant    := f_String_tempo_nor_dib_Ant();
        ln_NumSqnclSmlrdp              := 24;
        ls_DcrInfcalcSmlrdp            := 'Tempo de Serviço Normal na DIB';
        ls_DcrFrmcalcSmlrdp            := ls_String_tempo_nor_dib_Ant;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 24
        ls_String_tempo_esp_dib_Ant    := f_String_tempo_esp_dib_Ant();
        ln_NumSqnclSmlrdp              := 25;
        ls_DcrInfcalcSmlrdp            := 'Tempo de Serviço Especial';
        ls_DcrFrmcalcSmlrdp            := ls_String_tempo_esp_dib_Ant;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 25
        ls_String_tempo_esp_conv       := f_String_tempo_esp_conv();
        ln_NumSqnclSmlrdp              := 26;
        ls_DcrInfcalcSmlrdp            := 'Tempo de Serviço Especial Convertido';
        ls_DcrFrmcalcSmlrdp            := ls_String_tempo_esp_conv;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Gravação da linha 26
        ln_String_tempo_total_dibF_Ant  := f_String_tempo_total_dibF_Ant();
        ln_NumSqnclSmlrdp              := 27;
        ls_DcrInfcalcSmlrdp            := 'Tempo de Serviço Fundação Total na DIB';
        ls_DcrFrmcalcSmlrdp            := ln_String_tempo_total_dibF_Ant;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
             -- Gravação da linha 28
        ln_String_tempo_total_dib_Ant  := f_String_tempo_total_dib_Ant();
        ln_NumSqnclSmlrdp              := 28;
        ls_DcrInfcalcSmlrdp            := 'Tempo de Serviço INSS Total na DIB';
        ls_DcrFrmcalcSmlrdp            := ln_String_tempo_total_dib_Ant;
        ln_VlrResformSmlrdp            := NULL;
        ln_NumTabelaSmlrdp             := NULL;
        ls_DcrColunaSmlrdp             := NULL;
        ls_DcrVlrcolSmlrdp             := NULL;
        PACK_SBF_MEMCALCULO_GERAL.sp_Grava_Simul_bd_rodape_fss (gn_NumMatricParticipante_Ant, ln_NumSqnclSmlbnf, ln_NumSqnclSmlrdp, ls_DcrInfcalcSmlrdp, ls_DcrFrmcalcSmlrdp, ln_VlrResformSmlrdp, ln_NumTabelaSmlrdp, ls_DcrColunaSmlrdp, ls_DcrVlrcolSmlrdp);
        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
--                RAISE_APPLICATION_ERROR (-20020, 'Erro na linha 1 de sp_SBF_MemCal_PlAntigo na linha de comando:' ||NUM_LINHA_ERRO||'  '||ln_NumSqnclSmlbnf||'  '||ln_NumSqnclSmlrdp||'  '||gn_NumMatricParticipante_Ant, TRUE);    END sp_SBF_MemCalculo_PlAntigo;
                RAISE_APPLICATION_ERROR (-20020, sqlcode || ' - ' || sqlerrm, TRUE);    
END sp_SBF_MemCalculo_PlAntigo;

   --======================================================================================
   -- = Nome:      f_Executa_SBF_MemCal_PlAntigo
   -- = Descrição: Executa a procedure principal. Foi necessário devido a incompatibilidade
   -- =            do driver client Oracle 9 com PowerBuilder 8.
   -- = Nível:     19.
   --======================================================================================
   FUNCTION f_Executa_SBF_MemCal_PlAntigo RETURN number IS
        -- Declaração de variáveis locais
        ln_SBF_MemCal_PlAntigo        number := 0;

   BEGIN

        sp_SBF_MemCalculo_PlAntigo;

        RETURN ln_SBF_MemCal_PlAntigo;

        -- Tratamento de erro
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20020, 'Erro ao executar f_Executa_SBF_MemCal_PlAntigo', TRUE);
   END f_Executa_SBF_MemCal_PlAntigo;


END PACK_SBF_MEMCALCULO_PLANTIGO;
