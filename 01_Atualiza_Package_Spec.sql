CREATE OR REPLACE PACKAGE ATT.PACK_SBF_MEMCALCULO_PLANTIGO AS
--======================================================================================
-- = Nome:      PACK_SBF_MEMCALCULO_PLANTIGO
-- = Descri��o: Pacote de SPs e Fun��es referentes � MEM�RIA DE C�LCULO  PLANTIGO do SBF
--======================================================================================
-- Procedures e fun��es p�blicas
   PROCEDURE sp_SBF_MemCalculo_PlAntigo ;

   FUNCTION f_Executa_SBF_MemCal_PlAntigo RETURN NUMBER;

   
-- Vari�veis p�blicas:
    gn_NumMatricParticipante_Ant       number;
    gn_PlanoParticipante_Ant           number;
    gd_DIB_Ant                         date;
    gn_CodEmpresa_Ant                  number;
    gn_NumMatricEmpregado_Ant          number;
    gn_CodBenef_Ant                    number;
    gc_lei8880                         char;
    gc_base                            number(1);
    
 
    
END PACK_SBF_MEMCALCULO_PLANTIGO;
