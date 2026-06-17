
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_PACK_VORSCHR_GEW_BUI" 
  before insert or update on DIRKSPZM32.S_RCV_PACK_VORSCHR_GEW
  for each row
declare

  v_found                 boolean;
  v_pack_vorschr_gew      isi_pack_vorschr_gew%rowtype;
  CURSOR c_pack_vorschr_gew is
    select *
      from isi_pack_vorschr_gew t
    where t.sid = :new.sid
      and t.firma_nr = :new.firma_nr
      and t.artikel_id = (select a.artikel_id from isi_artikel a where a.sid = :new.sid and a.artikel = :new.artikel)
      and t.kunden_nr = :new.kunden_nr;
begin

  OPEN c_pack_vorschr_gew;
  FETCH c_pack_vorschr_gew into v_pack_vorschr_gew;
  v_found := c_pack_vorschr_gew%FOUND;
  CLOSE c_pack_vorschr_gew;

  if not v_found
  then
    insert into isi_pack_vorschr_gew
    values
      (:new.sid,
       :new.firma_nr,
       (select a.artikel_id from isi_artikel a where a.sid = :new.sid and a.artikel = :new.artikel),
       :new.kunden_nr,
       :new.gew_nr,
       (select a.artikel_id from isi_artikel a where a.sid = :new.sid and a.artikel = :new.lhm_artikel),
       :new.lhm_gew_nom,
       :new.lhm_gew_max,
       :new.lhm_gew_min,
       :new.lhm_gew_abw_pal,
       :new.created_date,
       :new.created_login_id,
       :new.last_change_date,
       :new.last_change_login_id);
  else
    update isi_pack_vorschr_gew
       set gew_nr = :new.gew_nr,
           lhm_art_id = (select a.artikel_id from isi_artikel a where a.sid = :new.sid and a.artikel = :new.lhm_artikel),
           lhm_gew_nom = :new.lhm_gew_nom,
           lhm_gew_max = :new.lhm_gew_max,
           lhm_gew_min = :new.lhm_gew_min,
           lhm_gew_abw_pal = :new.lhm_gew_abw_pal,
           created_date = :new.created_date,
           created_login_id = :new.created_login_id,
           last_change_date = :new.last_change_date,
           last_change_login_id = :new.last_change_login_id
     where sid = :new.sid
       and firma_nr = :new.firma_nr
       and artikel_id = (select a.artikel_id from isi_artikel a where a.sid = :new.sid and a.artikel = :new.artikel)
       and kunden_nr = :new.kunden_nr;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_PACK_VORSCHR_GEW_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"e13314219c82b7caf8714ae2f98d74ee917aacfa","type":"TRIGGER","name":"TR_S_RCV_PACK_VORSCHR_GEW_BUI","schemaName":"DIRKSPZM32","sxml":""}