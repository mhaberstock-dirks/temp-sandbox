create or replace editionable trigger dirkspzm32.tr_lvs_fahrzeug_au after
    update on dirkspzm32.lvs_fahrzeuge
    for each row
declare begin
    if
        :new.fahrzeug_ok = 'M'
        and :old.fahrzeug_ok != 'M'
    then
        insert into lvs_fahrz_defekt_dispo_st values ( :new.sid,
                                                       :new.firma_nr,
                                                       :new.res_id,
                                                       sysdate,
                                                       'N' );

    elsif :new.fahrzeug_ok != 'M' then
        update lvs_fahrz_defekt_dispo_st t
        set
            t.status = 'X'            -- Abgebrochen
        where
                t.sid = :new.sid
            and t.firma_nr = :new.firma_nr
            and t.res_id = :new.res_id
            and t.status != 'F';

    end if;
end tr_lvs_fahrzeug_au;
/

alter trigger dirkspzm32.tr_lvs_fahrzeug_au enable;


-- sqlcl_snapshot {"hash":"0f9353b29c6607a16cc0492b3ecf73f552af0097","type":"TRIGGER","name":"TR_LVS_FAHRZEUG_AU","schemaName":"DIRKSPZM32","sxml":""}