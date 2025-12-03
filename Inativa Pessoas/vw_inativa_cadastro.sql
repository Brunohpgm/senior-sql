SELECT P.CD_PESSOA AS "Id",
       'CT.ID_PESSOA' AS "RegistrationNumber", -- campo não existente na senior
       C.NOME AS "Name",
       30 AS "PersonSituation", --30 = rescisão
       DEVELOPS.FC_GET_UO_ESTABELECIMENTO@MADIS(C.FILIAL) AS "OrganizationalStructureCompany",
       DEVELOPS.FC_GET_UO_CENTRODECUSTO@MADIS(C.FILIAL, C.COD_CENTRO_CUSTO) AS "OrganizationalStructure",
       1 AS "AccessProfile",
       C.PISPASEP AS "Pis",
       C.CPF AS "Cpf",
       C.TELEFONE AS "CellPhone",
       C.DDD AS "CellPhoneDDD",
       NULL AS "CellPhoneDDI",
       NULL AS "MultipleSituationGrantType",
       NULL AS "MultiplePersonSituationRules",
       NULL AS "HourToCollectAtValidCredEnd",
       C.PISPASEP AS "CredentialNumberForRepUse",
       NULL AS "CredentialNumberForFaceUse",
       0 AS "MasterType",
       NULL AS VEHICLELICENSEPLATE
  FROM SENIOR.TB_COLABORADOR C
 INNER JOIN DEFAULT_ACESSO.PESSOA@MADIS P
    ON C.CPF = P.NU_CPF
   AND C.TIPO <> 2 --autonomos/pj de acordo com consultor
   AND C.SITUACAO_AFASTAMENTO = 7 -- RESCISÃO
   AND C.DATA_AFASTAMENTO = TRUNC(SYSDATE - 1) --testar se precisa de controle ou não

