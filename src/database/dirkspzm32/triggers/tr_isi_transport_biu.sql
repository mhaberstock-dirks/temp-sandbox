
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_BIU" 
  before insert or update on DIRKSPZM32.isi_TRANSPORT
  for each row
declare
  -- local variables here
  v_old_status isi_transport.status%type;
  v_old_tourNr isi_transport.transport_gruppe%type;
  v_old_res_id isi_transport.res_id%type;
  v_old_lte_id isi_transport.lte_id%type;
  v_transaction_id varchar2(30);
begin
  if inserting and :new.transp_id is null
  then
    select seq_transport_id.nextval into :new.transp_id from dual;
  end if;

  if :new.transp_typ = 'E'
  then
    if inserting
    then
      if :new.res_id is not NULL
      then
        update lvs_fahrzeuge f
           set f.akt_trans_lte = f.akt_trans_lte + 1,
               f.anz_test_lte = decode(f.fahrzeug_ok, '?', f.anz_test_lte - 1, f.anz_test_lte)
         where f.res_id = :new.res_id;
      end if;
    else -- updateing
      if nvl(:new.res_id, -1) != nvl(:old.res_id, -1)
      then
        update lvs_fahrzeuge f
           set f.akt_trans_lte = f.akt_trans_lte + 1,
               f.anz_test_lte = decode(f.fahrzeug_ok, '?', f.anz_test_lte - 1, f.anz_test_lte)
         where f.res_id = :new.res_id;
        update lvs_fahrzeuge f
           set f.akt_trans_lte = f.akt_trans_lte - 1
         where f.res_id = :old.res_id;
      end if;
    end if;
  end if;

  v_old_status := '-'; -- unbekannt
  v_old_tourNr := null; -- unbekannt
  v_old_res_id := null; -- unbekannt
  v_old_lte_id := null; -- unbekannt
  if updating
  then
    v_old_status := :old.status;
    v_old_tourNr := :old.Transport_Gruppe;
    v_old_res_id := :old.res_id;
    v_old_lte_id := :old.lte_id;
  end if;
  v_transaction_id := dbms_transaction.local_transaction_id;

  -- AG 25.07.2016 Umlagerungen nur hier zählen je LTE
  if :new.transp_typ = 'U' -- Umlagern
  and :new.status = 'T'
  and v_old_status != 'T'
  then
    UPDATE lvs_lte
        SET anz_uml            = anz_uml + 1
        WHERE lte_id = :new.lte_id;
  else
    -- Hier eine Ein oder Auslagerung, dann Umlagerungen wieder 0
    if :new.transp_typ != 'U' -- Umlagern
    and :new.status = 'T'
    and v_old_status != 'T'
    then
      UPDATE lvs_lte
          SET anz_uml            = 0
          WHERE lte_id = :new.lte_id;
    end if;
  end if;

  if (:new.status != v_old_status) or
     (v_old_tourNr <> :new.Transport_Gruppe) or
     (nvl(v_old_res_id, 0) != nvl(:new.res_id, 0)) or
     (v_old_lte_id <> :new.Lte_id)

  then
    -- nur bei Statusänderung loggen
    insert into isi_transport_log
    values (
      :new.sid,
      :new.firma_nr,
      seq_transp_log_id.nextval,
      :new.transp_id,
      :new.status,
      null, -- user_id ist hier falsch, da das der Erzeuger ist
      systimestamp,
      'STAT', -- log_typ
      null, -- arbeitsplatz_id
      null, -- check_typ
      null, -- scan_data
      null,  --check_q_eti_typ
      null, -- check_passed
      v_transaction_id,
      :new.Transport_Gruppe,
      :new.res_id,
      :new.parent_transp_id,
      :new.Lte_id

    );
  end if;
end TR_ISI_TRANSPORT_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"18874a614203db005bbf4b205e8c1325f57a50f1","type":"TRIGGER","name":"TR_ISI_TRANSPORT_BIU","schemaName":"DIRKSPZM32","sxml":""}