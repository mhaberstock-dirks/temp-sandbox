
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ARBEITSPLATZ_BI" 
  before insert on DIRKSPZM32.isi_arbeitsplatz
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ARBEITSPLATZ_BI" ENABLE;


-- sqlcl_snapshot {"hash":"8822aa51eb6db535c40c608d7bd238674257bffb","type":"TRIGGER","name":"TR_ISI_ARBEITSPLATZ_BI","schemaName":"DIRKSPZM32","sxml":""}