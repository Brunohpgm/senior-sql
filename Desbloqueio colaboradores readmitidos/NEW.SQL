SELECT P.NU_MATRICULA AS "RegistrationNumber",
       P.NM_PESSOA AS "Name",
       10 AS "PersonSituation",
       P.CD_ESTRUTURA_ORGANIZACIONAL AS "OrganizationalStructure",
       P.CD_ESTRUTURA_ORG_EMPRESA AS "OrganizationalStructureCompany",
       P.NU_CPF AS "Cpf",
       P.NU_PIS AS "Pis",
       P.NU_PIS AS "CredentialNumberForRepUse",
       0 AS "MasterType"
  FROM DEFAULT_ACESSO.PESSOA@MADIS P
 INNER JOIN SENIOR.TB_COLABORADOR C
    ON P.NU_CPF = C.CPF
   AND P.CD_SITUACAO_PESSOA = 30
   AND C.SITUACAO_AFASTAMENTO <> 7