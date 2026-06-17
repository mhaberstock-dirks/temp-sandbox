
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_ARTIKEL_STATUS_BIUD" 
  before insert or update or delete on DIRKSPZM32.lvs_artikel_status
  for each row
declare
  -- Lokale Variablen
  v_art_letzte_inv_upd boolean;
begin
  v_art_letzte_inv_upd := false;
  if inserting
  then
    select seq_artikel_status_id.nextval into :new.artikel_status_id from dual;

    v_art_letzte_inv_upd := (:new.letzte_inventur_id is not null);
  end if;

  begin
    if inserting or updating
    then
      if :new.leitzahl is null and :new.fa_ag is null
      then
        -- Status eines "reinen" Artikels (ohne Leitzahl, FA_AG, etc.)
        update isi_artikel a
           set a.akt_inventur_id = :new.akt_inventur_id
         where a.sid = :new.sid
           and a.artikel_id = :new.artikel_id
           and nvl(a.akt_inventur_id, 0) != nvl(:new.akt_inventur_id, 0);
      end if;

      v_art_letzte_inv_upd := (:new.letzte_inventur_id is not null
                               and :new.letzte_inventur_id <> nvl(:old.letzte_inventur_id, - 1));
    end if;
  exception
    when others then NULL; -- Wenn ein Update auf den Artikel fehlschlaegt, dann ignorieren und alles andere Buchen
  end;

  begin
    if v_art_letzte_inv_upd
    then
      -- neuesten Inventurstatus am Artikel übernehmen, egal, ob dieser Datensatz eine Leitzahl, FA_AG, etc. hat
      update isi_artikel a
         set a.letzte_inventur_id = :new.letzte_inventur_id,
             a.inventur_datum = :new.letzte_inventur_datum,
             a.inventur_user_id = :new.letzte_inventur_login_id
       where a.sid = :new.sid
         and a.artikel_id = :new.artikel_id
         and nvl(a.letzte_inventur_id, 0) != :new.letzte_inventur_id;
    end if;
  exception
    when others then NULL; -- Wenn ein Update auf den Artikel fehlschlaegt, dann ignorieren und alles andere Buchen
  end;
end tr_lvs_artikel_status_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_ARTIKEL_STATUS_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"3a2896f45e9b18a780f712844f540a36292d8624","type":"TRIGGER","name":"TR_LVS_ARTIKEL_STATUS_BIUD","schemaName":"DIRKSPZM32","sxml":""}