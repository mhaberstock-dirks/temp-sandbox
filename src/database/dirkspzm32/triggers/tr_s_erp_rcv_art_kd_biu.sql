
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_ART_KD_BIU" 
  before insert or update or delete on DIRKSPZM32.S_ERP_RCV_ART_KD
  for each row
declare
  -- local variables here
begin
  -- sid

  if updating or inserting then
    if inserting
    then
      if :new.created_date is NULL
      then
        :new.created_date := sysdate;
      end if;
      if :new.created_login_id is NULL
      then
        :new.created_login_id := -1;
      end if;
    end if;
    if updating
    then
      if :new.last_change_date = :old.last_change_date
      or :new.last_change_date is NULL
      then
        :new.last_change_date := sysdate;
      end if;
    end if;

    begin
      insert into s_rcv_art_kd art (
                  art.firma_nr,
                  art.artikel,
                  art.kunden_nr)
           values (
                  :new.firma_nr,
                  :new.artikel,
                  :new.kunden_nr);
    exception
      when dup_val_on_index then NULL;
    end;
    update s_rcv_art_kd a
         set
                  a.kd_art_nr = :new.kd_art_nr,
                  a.kd_art_text1 = :new.kd_art_text1,
                  a.kd_art_text2 = :new.kd_art_text2,
                  a.lhm_name = :new.lhm_name,
                  a.lhm_menge = :new.lhm_menge,
                  a.lhm_gewicht_kg = :new.lhm_gewicht_kg,
                  a.lhm_ean = :new.lhm_ean,
                  a.lte_name = :new.lte_name,
                  a.lte_menge = :new.lte_menge,
                  a.lte_gewicht_kg = :new.lte_gewicht_kg,
                  a.lte_breite_max = :new.lte_breite_max,
                  a.lte_tiefe_max = :new.lte_tiefe_max,
                  a.lte_hoehe_max = :new.lte_hoehe_max,
                  a.lte_lhm_menge = :new.lte_lhm_menge,
                  a.lte_lhm_pro_lage = :new.lte_lhm_pro_lage,
                  a.lte_lhm_lagen = :new.lte_lhm_lagen,
                  a.lte_hoehe_lage = :new.lte_hoehe_lage,
                  a.lte_ean = :new.lte_ean,
                  a.ean = :new.ean,
                  a.aktiv = :new.aktiv,
                  a.pack_vorschr = :new.pack_vorschr

     where a.firma_nr = :new.firma_nr
       and a.artikel= :new.artikel
       and a.kunden_nr = :new.kunden_nr;
  elsif deleting then
    update s_rcv_art_kd a
         set      a.aktiv = 'f'
     where a.firma_nr = :old.firma_nr
       and a.artikel= :old.artikel
       and a.kunden_nr = :new.kunden_nr;
  end if;

end tr_s_ERP_rcv_art_kd_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_ART_KD_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"21834b63a9f94752af0fd00e04d2265ec7c1d00d","type":"TRIGGER","name":"TR_S_ERP_RCV_ART_KD_BIU","schemaName":"DIRKSPZM32","sxml":""}