SELECT P.CD_PESSOA AS "Id",
       'CT.ID_PESSOA' AS "RegistrationNumber", -- campo não existente na senior
       C.NOME AS "Name",
       10 AS "PersonSituation", --10 = contrato normal, pois essa integração só trabalha com essa situação de colaborador.
       DEVELOPS.FC_GET_UO_ESTABELECIMENTO@MADIS(C.FILIAL) AS "OrganizationalStructureCompany",
       DEVELOPS.FC_GET_UO_CENTRODECUSTO@MADIS(C.FILIAL, C.COD_CENTRO_CUSTO) AS "OrganizationalStructure",
       1 AS "AccessProfile",
       'C.CODIGO_PISPASEP' AS "Pis", -- campo faltante senior, necessita desenvolvimento
       C.CPF AS "Cpf",
       C.TELEFONE AS "CellPhone",
       C.DDD AS "CellPhoneDDD",
       NULL AS "CellPhoneDDI",
       NULL AS "MultipleSituationGrantType",
       NULL AS "MultiplePersonSituationRules",
       NULL AS "HourToCollectAtValidCredEnd",
       'C.CODIGO_PISPASEP' AS "CredentialNumberForRepUse", -- campo faltante senior, necessita desenvolvimento
       NULL AS "CredentialNumberForFaceUse",
       0 AS "MasterType",
       NULL AS VEHICLELICENSEPLATE
  FROM SENIOR.TB_COLABORADOR C
 INNER JOIN DEFAULT_ACESSO.PESSOA@MADIS P
    ON C.CPF = P.NU_CPF
   AND C.FILIAL <> 100 --PJ
      --  AND CT.ID_CATEGORIA NOT IN ('701') --autonomos, qual sera na senior?
   AND C.SITUACAO_AFASTAMENTO = 1 --atividade normal 
-- AND CT.ID_UNIDADE_ORGANIZACIONAL NOT IN (882, 885) unidade org.sucessores, validar como ficara na senior
and c.cpf = 46748072808

 --realmente precisa da parte 2 da view?     /*Colaboradores Demitidos que ainda permanecem ativos*/
