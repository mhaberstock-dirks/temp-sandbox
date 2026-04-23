create or replace editionable trigger dirkspzm32.tr_pzm_konten_bh_bd before
    delete on dirkspzm32.pzm_konten_bh
    for each row
declare
  -- Lokale Variablen
    v_sid        isi_sid.sid%type;
    v_firma_nr   isi_firma.firma_nr%type;
    v_pers_nr    pzm_personal.pers_nr%type;
    v_konto_nr   pzm_konten.konto_nr%type;
    v_pzm_konten pzm_konten%rowtype;
    cursor c_pzm_konten is
    select
        t.*
    from
        pzm_konten t
    where
            t.sid = v_sid
        and t.firma_nr = v_firma_nr
        and t.pers_nr = v_pers_nr
        and t.konto_nr = v_konto_nr;

    v_found      boolean;
begin
  -- Buchungsschlüssel sind
  -- 1  Zugang
  -- 2  Abgang
  -- 3 Zugang storniert
  -- 4 Abgang storniert

    v_sid := :old.sid;
    v_firma_nr := :old.firma_nr;
    v_pers_nr := :old.pers_nr;
    v_konto_nr := :old.konto_nr;
    open c_pzm_konten;
    fetch c_pzm_konten into v_pzm_konten;
    v_found := c_pzm_konten%found;
    close c_pzm_konten;

  -- Plausibiltät prüfen
    if not v_found then
        return;    -- Wenn kein Konto mehr da, dann gelöscht und keine Bestands-Korrektur
        raise_application_error(-20000, 'Kein Konto für diese Buchung verfügbar.');
    end if;
    if v_pzm_konten.buch_einheit != :old.einheit then
        raise_application_error(-20000, 'Die Buchungseinheit etnspricht nicht der Buchungseinheit in den Kontoeinstellungen.');
    end if;

    if :old.bus = 2
    or :old.bus = 3        -- normaler Abgang / Zugang storniert
     then
        v_pzm_konten.saldo := v_pzm_konten.saldo + :old.wert;
    elsif :old.bus = 1
    or :old.bus = 4           -- normaler Zugang / Abgang storniert
     then
        v_pzm_konten.saldo := v_pzm_konten.saldo - :old.wert;
    end if;

    update pzm_konten t
    set
        t.saldo = v_pzm_konten.saldo,
        t.letzte_buchung = v_pzm_konten.letzte_buchung
    where
            t.sid = v_sid
        and t.firma_nr = v_firma_nr
        and t.pers_nr = v_pers_nr
        and t.konto_nr = v_konto_nr;

end tr_pzm_konten_bh_bd;
/

alter trigger dirkspzm32.tr_pzm_konten_bh_bd enable;


-- sqlcl_snapshot {"hash":"99e69a824290736e27b4e58736f22fea32409e13","type":"TRIGGER","name":"TR_PZM_KONTEN_BH_BD","schemaName":"DIRKSPZM32","sxml":""}