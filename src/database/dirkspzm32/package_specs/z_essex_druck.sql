create or replace package dirkspzm32.z_essex_druck is

  -- Author  : HJGOEDEKE
  -- Created : 24.06.2004 16:37:26
  -- Purpose : Funktionen für Euscher (Etikettendruck)

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
    function vda_etikett (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_id        in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"0c522efec5ddffb95781004a13fc96e1cc4f6944","type":"PACKAGE_SPEC","name":"Z_ESSEX_DRUCK","schemaName":"DIRKSPZM32","sxml":""}