
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_TOR_CFG_BUID" 
  before insert or update or delete on DIRKSPZM32.isi_tor_cfg
  for each row
declare
  -- local variables here
begin
  if inserting then
    if :new.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = :new.tor_id_lesegeraet,
             cs.com_geraet_typ = 'TOR'
       where cs.sid = :new.sid
         and cs.firma_nr = :new.firma_nr
         and cs.com_name = :new.com_name;
    end if;
  elsif updating then
    if :old.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = NULL,
             cs.com_geraet_typ = NULL
       where cs.sid = :old.sid
         and cs.firma_nr = :old.firma_nr
         and cs.com_name = :old.com_name;
    end if;
    if :new.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = :new.tor_id_lesegeraet,
             cs.com_geraet_typ = 'TOR'
       where cs.sid = :new.sid
         and cs.firma_nr = :new.firma_nr
         and cs.com_name = :new.com_name;
    end if;
  else
    if :old.com_name is not null then
      update isi_com_server cs
         set cs.com_geraet_name = NULL,
             cs.com_geraet_typ = NULL
       where cs.sid = :old.sid
         and cs.firma_nr = :old.firma_nr
         and cs.com_name = :old.com_name;
    end if;
  end if;
end TR_ISI_TOR_CFG_BUID;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_TOR_CFG_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"4c9778014da7d33c2745edb47fa1a8ec999fdbdb","type":"TRIGGER","name":"TR_ISI_TOR_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}