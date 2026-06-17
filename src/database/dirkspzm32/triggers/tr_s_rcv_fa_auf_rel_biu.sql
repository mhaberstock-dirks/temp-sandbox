
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_FA_AUF_REL_BIU" 
  before insert or update or delete on DIRKSPZM32.S_RCV_FA_AUF_REL
  for each row
declare
  v_fa_rel                s_rcv_fa_auf_rel%rowtype;
  v_found                 boolean;
  CURSOR c_fa_rel is
    select *
      from bde_fa_auftrag_rel t
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.leitzahl = :new.leitzahl
       and t.fa_ag = :new.fa_ag
       and t.fa_upos = :new.fa_upos
       and t.nfa_ag = :new.nfa_ag
       and t.nfa_upos = :new.nfa_upos;
begin
  if updating or inserting then
    OPEN c_fa_rel;
    FETCH c_fa_rel into v_fa_rel;
    v_found := c_fa_rel%found;
    CLOSE c_fa_rel;

    if v_found
    then
      update bde_fa_auftrag_rel t
         set t.ueberlappungstyp = :new.ueberlappungstyp,
             t.wert = :new.wert,
             t.minpuffer = :new.minpuffer,
             t.maxpufferbeachten = :new.maxpufferbeachten,
             t.maxpuffer = :new.maxpuffer
       where t.sid = :new.sid
         and t.firma_nr = :new.firma_nr
         and t.leitzahl = :new.leitzahl
         and t.fa_ag = :new.fa_ag
         and t.fa_upos = :new.fa_upos
         and t.nfa_ag = :new.nfa_ag
         and t.nfa_upos = :new.nfa_upos;
    else
      insert into bde_fa_auftrag_rel
      values
        (:new.sid,
         :new.firma_nr,
         :new.leitzahl,
         :new.fa_ag,
         :new.fa_upos,
         :new.nfa_ag,
         :new.nfa_upos,
         :new.ueberlappungstyp,
         :new.wert,
         :new.minpuffer,
         :new.maxpufferbeachten,
         :new.maxpuffer);
    end if;

  elsif deleting then
    delete bde_fa_auftrag_rel t
     where t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.leitzahl = :old.leitzahl
       and t.fa_ag = :old.fa_ag
       and t.fa_upos = :old.fa_upos
       and t.nfa_ag = :old.nfa_ag
       and t.nfa_upos = :old.nfa_upos;
  end if;
end TR_S_RCV_FA_AUF_REL;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_FA_AUF_REL_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"d0acc49f7a1b26c026e1b066dc8b7757b40b8c80","type":"TRIGGER","name":"TR_S_RCV_FA_AUF_REL_BIU","schemaName":"DIRKSPZM32","sxml":""}