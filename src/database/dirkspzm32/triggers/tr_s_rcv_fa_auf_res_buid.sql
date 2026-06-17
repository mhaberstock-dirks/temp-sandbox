
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_FA_AUF_RES_BUID" 
  before insert or update or delete on DIRKSPZM32.S_RCV_FA_AUF_RES
  for each row
declare

  v_found                 boolean;
begin
  if inserting
  then
    if :new.Minuten is null then
      :new.Minuten := 0; --BugFix BWE
    end if;
    insert into bde_fa_auftrag_res_liste
    values
      (:new.sid,          -- v_sid,
       :new.firma_nr,     -- v_firma_nr,
       :new.auftrag,      -- v_abnr,
       :new.leitzahl,     -- v_leitzahl,
       :new.fa_ag,        -- v_fa_ag,
       :new.fa_upos,      -- v_fa_upos,
       :new.res_id,       -- v_res_id,
       :new.minuten,      -- v_res_delta);
       :new.minuten_ruesten);

  elsif updating
  then
    update bde_fa_auftrag_res_liste t
       set t.minuten = :new.minuten,
           t.minuten_ruesten = :new.minuten_ruesten,
           t.abnr = :new.auftrag
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos
       and t.res_id = :new.res_id;

  else -- delete
    delete bde_fa_auftrag_res_liste t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.leitzahl = :old.leitzahl
       and t.fa_ag = :old.fa_ag
       and t.fa_upos = :old.fa_upos
       and t.res_id = :old.res_id;
  end if;

end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_FA_AUF_RES_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"059d14f7a6ee7a2e393de892642945e3db98e29f","type":"TRIGGER","name":"TR_S_RCV_FA_AUF_RES_BUID","schemaName":"DIRKSPZM32","sxml":""}