
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_FA_AUF_FHM_BUID" 
  before insert or delete on DIRKSPZM32.S_RCV_FA_AUF_FHM
  for each row
declare

  v_found                 boolean;
begin
  if inserting
  then
    insert into bde_fa_auftrag_fhm
    values
      (:new.sid,          -- v_sid,
       :new.firma_nr,     -- v_firma_nr,
       :new.auf_id,       -- v_abnr,
       :new.leitzahl,     -- v_leitzahl,
       :new.fa_ag,        -- v_fa_ag,
       :new.fa_upos,      -- v_fa_upos,
       :new.prod_fhm,     -- v_prod_fhm
       :new.fhm_grp,     -- v_fhm_grp
       :new.anz_benoetigt);    -- Anzahl der benötigten FHMs
  else -- delete
    delete bde_fa_auftrag_fhm t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.leitzahl = :old.leitzahl
       and t.fa_ag = :old.fa_ag
       and t.fa_upos = :old.fa_upos
       and t.prod_fhm = :old.prod_fhm;
    delete isi_res_fhm t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.fhm = :old.prod_fhm
       and t.dyn_gen = c.C_TRUE
       and not exists (select x.prod_fhm from bde_fa_auftrag_fhm x where x.sid = :old.sid and x.firma_nr = :old.firma_nr and x.prod_fhm = :old.prod_fhm);
  end if;

end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_FA_AUF_FHM_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"a0fb7b6b66b496aed8d26668fc64f42543adb85a","type":"TRIGGER","name":"TR_S_RCV_FA_AUF_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}