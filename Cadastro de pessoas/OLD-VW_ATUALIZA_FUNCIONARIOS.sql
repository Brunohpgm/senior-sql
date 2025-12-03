-- DEVELOPS.VW_ATUALIZA_FUNCIONARIOS source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "DEVELOPS"."VW_ATUALIZA_FUNCIONARIOS" ("Id", "RegistrationNumber", "Name", "PersonSituation", "OrganizationalStructureCompany", "OrganizationalStructure", "AccessProfile", "Pis", "Cpf", "CellPhone", "CellPhoneDDD", "CellPhoneDDI", "MultipleSituationGrantType", "MultiplePersonSituationRules", "HourToCollectAtValidCredEnd", "CredentialNumberForRepUse", "CredentialNumberForFaceUse", "MasterType", "VEHICLELICENSEPLATE") AS 
  SELECT X."Id",
       X."RegistrationNumber",
       X."Name",
       X."PersonSituation",
       X."OrganizationalStructureCompany",
       X."OrganizationalStructure",
       X."AccessProfile",
       X."Pis",
       X."Cpf",
       X."CellPhone",
       X."CellPhoneDDD",
       X."CellPhoneDDI",
       X."MultipleSituationGrantType",
       X."MultiplePersonSituationRules",
       X."HourToCollectAtValidCredEnd",
       X."CredentialNumberForRepUse",
       X."CredentialNumberForFaceUse",
       X."MasterType",
       X.VEHICLELICENSEPLATE
  FROM (SELECT P.CD_PESSOA AS "Id",
               CT.ID_PESSOA AS "RegistrationNumber",
               CT.NOME_PESSOA AS "Name",
               DECODE(S.TIPO, 5, 30, 10) AS "PersonSituation",
               FC_GET_UO_ESTABELECIMENTO(CT.ID_ESTABELECIMENTO) AS "OrganizationalStructureCompany",
               FC_GET_UO_CENTRODECUSTO(CT.ID_ESTABELECIMENTO, CT.ID_CENTRO_CUSTO) AS "OrganizationalStructure",
               1 AS "AccessProfile",
               C.CODIGO_PISPASEP AS "Pis",
               C.CPF AS "Cpf",
               C.TELEFONE AS "CellPhone",
               C.DDDCELULAR AS "CellPhoneDDD",
               NULL AS "CellPhoneDDI",
               NULL AS "MultipleSituationGrantType",
               NULL AS "MultiplePersonSituationRules",
               NULL AS "HourToCollectAtValidCredEnd",
               C.CODIGO_PISPASEP AS "CredentialNumberForRepUse",
               NULL AS "CredentialNumberForFaceUse",
               0 AS "MasterType",
               NULL AS VEHICLELICENSEPLATE
          FROM LG.TB_CONTRATO_TRABALHO@INTEGRACOES CT,
               LG.TB_COLABORADOR@INTEGRACOES       C,
               LG.TB_SITUACAO@INTEGRACOES          S,
               DEFAULT_ACESSO.PESSOA               P
         WHERE CT.ID_PESSOA = C.ID_PESSOA
           AND CT.ID_SITUACAO_COLABORADOR = S.ID_SITUACAO
           AND P.NU_CPF = C.CPF
              /*---[Desconsidera Empresa PJ]---*/
           AND CT.ID_EMPRESA NOT IN (100)
              /*---[Desconsidera Autonomos]---*/
           AND CT.ID_CATEGORIA NOT IN ('701')
              /*---[Desconsidera Desligados]---*/
           AND S.TIPO != '5'
              /*---[Desconsidera Unidade Org. de Sucessores (Duplo Vinculo)]---*/
           AND CT.ID_UNIDADE_ORGANIZACIONAL NOT IN (882, 885)

        UNION ALL

        /*Colaboradores Demitidos que ainda permanecem ativos*/
        SELECT P.CD_PESSOA AS "Id",
               CT.ID_PESSOA AS "RegistrationNumber",
               CT.NOME_PESSOA AS "Name",
               DECODE(S.TIPO, 5, 30, 10) AS "PersonSituation",
               FC_GET_UO_ESTABELECIMENTO(CT.ID_ESTABELECIMENTO) AS "OrganizationalStructure",
               FC_GET_UO_CENTRODECUSTO(CT.ID_ESTABELECIMENTO, CT.ID_CENTRO_CUSTO) AS "OrganizationalStructureCompany",
               1 AS "AccessProfile",
               C.CODIGO_PISPASEP AS "Pis",
               C.CPF AS "Cpf",
               C.TELEFONE AS "CellPhone",
               C.DDDCELULAR AS "CellPhoneDDD",
               NULL AS "CellPhoneDDI",
               NULL AS "MultipleSituationGrantType",
               NULL AS "MultiplePersonSituationRules",
               NULL AS "HourToCollectAtValidCredEnd",
               C.CODIGO_PISPASEP AS "CredentialNumberForRepUse",
               NULL AS "CredentialNumberForFaceUse",
               0 AS "MasterType",
               NULL AS VEHICLELICENSEPLATE
          FROM LG.TB_CONTRATO_TRABALHO@INTEGRACOES CT,
               LG.TB_COLABORADOR@INTEGRACOES       C,
               LG.TB_SITUACAO@INTEGRACOES          S,
               DEFAULT_ACESSO.PESSOA               P
         WHERE CT.ID_PESSOA = C.ID_PESSOA
           AND CT.ID_SITUACAO_COLABORADOR = S.ID_SITUACAO
           AND P.NU_CPF = C.CPF
              /*---[Desconsidera Empresa PJ]---*/
           AND CT.ID_EMPRESA NOT IN (100)
              /*---[Desconsidera Autonomos]---*/
           AND CT.ID_CATEGORIA NOT IN ('701')
              ---[Filtra somente colaboradores desligados]---
           AND S.TIPO = '5'
              ---[Verifica se a situacao esta divergente]---
           AND DECODE(S.TIPO, 5, 30, 10) != P.CD_SITUACAO_PESSOA
              ---[Desconsidera registros de transferencia da migracao do Protheus]---
           AND CT.ID_SITUACAO_COLABORADOR NOT IN (64)
              /*---[Desconsidera Unidade Org. de Sucessores (Duplo Vinculo)]---*/
           AND CT.ID_UNIDADE_ORGANIZACIONAL NOT IN (882, 885)
              ---[Busca o ultimo contrato]---
           AND CT.DT_SITUACAO_ATUAL IN
               (SELECT MAX(CT1.DT_SITUACAO_ATUAL)
                  FROM LG.TB_CONTRATO_TRABALHO@INTEGRACOES CT1
                 WHERE CT1.ID_SITUACAO_COLABORADOR NOT IN (64)
                   AND CT1.ID_PESSOA = CT.ID_PESSOA)
           AND NOT EXISTS (SELECT 1
                  FROM LG.TB_CONTRATO_TRABALHO@INTEGRACOES A,
                       LG.TB_SITUACAO@INTEGRACOES          B
                 WHERE A.ID_SITUACAO_COLABORADOR = B.ID_SITUACAO
                   AND B.TIPO != '5'
                   AND A.CPF_PESSOA = CT.CPF_PESSOA)) X
 GROUP BY X."Id",
          X."RegistrationNumber",
          X."Name",
          X."PersonSituation",
          X."OrganizationalStructureCompany",
          X."OrganizationalStructure",
          X."AccessProfile",
          X."Pis",
          X."Cpf",
          X."CellPhone",
          X."CellPhoneDDD",
          X."CellPhoneDDI",
          X."MultipleSituationGrantType",
          X."MultiplePersonSituationRules",
          X."HourToCollectAtValidCredEnd",
          X."CredentialNumberForRepUse",
          X."CredentialNumberForFaceUse",
          X."MasterType",
          X.VEHICLELICENSEPLATE
;