
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_ARBEITSPLATZ_BI" 
  before insert on isi_arbeitsplatz
  for each row
declare

begin
  if :new.arbeitsplatz_id is null
  then
    select seq_isi_arbeitsplaz_id.nextval
      into :new.arbeitsplatz_id
      from dual;
  end if;

  -- BW Erst mal alle einzustellenden Parameter in Tabelle isi_arbeits_platz_cfg kopieren
  insert into isi_arbeitsplatz_cfg
    select null,
           :new.arbeitsplatz_id,
           modul_name,
           modul_funktion,
           modul_parameter,
           ''
      from isi_arbeitsplatz_param;
end tr_isi_arbeitsplatz_bi;


/
ALTER TRIGGER "TR_ISI_ARBEITSPLATZ_BI" ENABLE;


-- sqlcl_snapshot {"hash":"67acccab466570d8330d0e712191a178ed03b580","type":"TRIGGER","name":"TR_ISI_ARBEITSPLATZ_BI","schemaName":"DIRKSPZM32","sxml":""}