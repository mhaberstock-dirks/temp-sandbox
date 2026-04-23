create or replace editionable trigger dirkspzm32.tr_pzm_konten_bh_bi before
    insert on dirkspzm32.pzm_konten_bh
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

    v_sid := :new.sid;
    v_firma_nr := :new.firma_nr;
    v_pers_nr := :new.pers_nr;
    v_konto_nr := :new.konto_nr;
    open c_pzm_konten;
    fetch c_pzm_konten into v_pzm_konten;
    v_found := c_pzm_konten%found;
    close c_pzm_konten;
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        :new.created_login_id := nvl(
            current_isi_user_login_id(), -1
        );
        :new.created_user := current_isi_user();
    end if;

  -- Plausibiltät prüfen
    if not v_found then
        raise_application_error(-20000, 'Kein Konto für diese Buchung verfügbar.');
    end if;
    if v_pzm_konten.buch_einheit != :new.einheit then
        raise_application_error(-20000, 'Die Buchungseinheit etnspricht nicht der Buchungseinheit in den Kontoeinstellungen.');
    end if;

    if :new.bus = 1
    or :new.bus = 2 then
        if :new.typ is null then
            :new.typ := 'B'; -- normale Buchung
        end if;
    elsif :new.bus = 3
    or :new.bus = 4 then
        if :new.typ is null then
            :new.typ := 'S'; -- Stornobuchung
        end if;

        if :new.storno_konten_bh_id is null then
            raise_application_error(-20001, 'Es ist keine Buchungsnummer für Stornierung angegeben worden.');
        end if;

    end if;

    if :new.buch_datum is null then
        :new.buch_datum := sysdate;
    end if;

    :new.wert := round(:new.wert,
                       3);
    v_pzm_konten.letzte_buchung := :new.buch_datum;
    :new.wert := nvl(:new.wert,
                     0);
    if :new.bus = 1
    or :new.bus = 4           -- normaler Zugang / Abgang storniert
     then
        v_pzm_konten.saldo := v_pzm_konten.saldo + :new.wert;
    elsif :new.bus = 2
    or :new.bus = 3        -- normaler Abgang / Zugang storniert
     then
        v_pzm_konten.saldo := v_pzm_konten.saldo - :new.wert;
    end if;

    select
        seq_konten_bh_id.nextval
    into :new.konten_bh_id
    from
        dual;

    update pzm_konten t
    set
        t.saldo = v_pzm_konten.saldo,
        t.letzte_buchung = v_pzm_konten.letzte_buchung
    where
            t.sid = v_sid
        and t.firma_nr = v_firma_nr
        and t.pers_nr = v_pers_nr
        and t.konto_nr = v_konto_nr;

end tr_pzm_konten_bh_bi;
/

alter trigger dirkspzm32.tr_pzm_konten_bh_bi enable;


-- sqlcl_snapshot {"hash":"d37468b290bc097738c4e40bfa7e266d9e01996f","type":"TRIGGER","name":"TR_PZM_KONTEN_BH_BI","schemaName":"DIRKSPZM32","sxml":""}