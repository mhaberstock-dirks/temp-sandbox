create or replace 
package z_euscher_druck is

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
  function vda_etikett(in_sid         in isi_sid.sid%type,
                       in_firma_nr    in isi_firma.firma_nr%type,
                       in_id          in lvs_lte.lte_id%type,
                       in_waren_typ   in lvs_lte.waren_typ%type)
                        return varchar2;

end;
/



-- sqlcl_snapshot {"hash":"dbe4134b735f0ab4d4f8dbf8df806b4fa2c61649","type":"PACKAGE_SPEC","name":"Z_EUSCHER_DRUCK","schemaName":"DIRKSPZM32","sxml":""}