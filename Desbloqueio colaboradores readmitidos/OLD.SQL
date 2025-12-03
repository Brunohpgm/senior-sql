WITH LATEST_MATRICULA AS
 (SELECT A.CPF_PESSOA
    FROM LG.TB_CONTRATO_TRABALHO@INTEGRACOES A
   INNER JOIN LG.TB_SITUACAO@INTEGRACOES S
      ON S.ID_SITUACAO = A.ID_SITUACAO_COLABORADOR
   WHERE A.MATRICULA = (SELECT MAX(B.MATRICULA)
                          FROM LG.TB_CONTRATO_TRABALHO@INTEGRACOES B
                         WHERE B.CPF_PESSOA = A.CPF_PESSOA)
     AND S.TIPO != '5')
SELECT P.NU_MATRICULA                    AS "RegistrationNumber",
       P.NM_PESSOA                       AS "Name",
       P.CD_SITUACAO_PESSOA              AS "PersonSituation",
       P.CD_ESTRUTURA_ORGANIZACIONAL     AS "OrganizationalStructure",
       P.CD_ESTRUTURA_ORG_EMPRESA        AS "OrganizationalStructureCompany",
       P.NU_CPF                          AS "Cpf",
       P.NU_PIS                          AS "Pis",
       NVL(C.CELULAR, C.TELEFONE)        AS "CellPhone",
       NVL(C.DDDCELULAR, C.DDDTELEFONE)  AS "CellPhoneDDD",
       P.NU_PIS                          AS "CredentialNumberForRepUse",
       0                                 AS "MasterType"
  FROM DEFAULT_ACESSO.PESSOA P
 INNER JOIN LATEST_MATRICULA LM
    ON LM.CPF_PESSOA = P.NU_CPF
 INNER JOIN LG.TB_COLABORADOR@INTEGRACOES C
 ON C.CPF = P.NU_CPF
 WHERE P.CD_SITUACAO_PESSOA = 30
