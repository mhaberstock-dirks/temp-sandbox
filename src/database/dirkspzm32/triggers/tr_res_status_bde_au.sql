create or replace editionable trigger dirkspzm32.tr_res_status_bde_au after
    update on dirkspzm32.isi_res_status
    for each row
declare
  -- local variables here
    v_r_zeit               number;
    v_s_zeit               number;
    v_res_status_cfg       isi_res_status_cfg%rowtype;
    v_res_zust_akt         isi_resource_zust_akt%rowtype;
    v_found_res_status_cfg boolean;
    v_found_res_zust_akt   boolean;
    cursor c_res_status_cfg is
    select
        t.*
    from
        isi_res_status_cfg t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.res_st_id = :new.res_st_id
        and t.res_typ = :new.res_typ;

    cursor c_res_zust_akt is
    select
        t.*
    from
        isi_resource_zust_akt t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.res_id = :new.res_id;

begin
  /* Störzeiten in der BDE Tabelle aktualisieren  */
    if
        :old.st_ende is null
        and :new.st_ende is not null
    then
    /* Wenn ein Status beendet wird */
        if :new.res_st_id != 0 then
      -- nur wenn wirklich eine Störung (Stillstand) vorliegt
            v_r_zeit := 0;
            v_s_zeit := 0;
            open c_res_zust_akt;
            fetch c_res_zust_akt into v_res_zust_akt;
            v_found_res_zust_akt := c_res_zust_akt%found;
            close c_res_zust_akt;
            open c_res_status_cfg;
            fetch c_res_status_cfg into v_res_status_cfg;
            v_found_res_status_cfg := c_res_status_cfg%found;
            close c_res_status_cfg;
            if
                v_found_res_status_cfg
                and v_found_res_zust_akt
            then
                if v_res_status_cfg.st_gruppe = 'R'      -- Ruesten
                 then
                    v_r_zeit := round((:new.st_ende - :new.st_start) * 24 * 60);
                else
                    v_s_zeit := round((:new.st_ende - :new.st_start) * 24 * 60);
                end if;

                update bde_fa_auftrag fa
                set
                    fa.stoer_zeit_ist = fa.stoer_zeit_ist + v_s_zeit,
                    fa.ruest_zeit_ist = fa.ruest_zeit_ist + v_r_zeit
                where
                        fa.sid = :new.sid
                    and fa.firma_nr = :new.firma_nr
                    and fa.leitzahl = v_res_zust_akt.leitzahl
                    and fa.fa_ag = v_res_zust_akt.fa_ag
                    and fa.fa_upos = v_res_zust_akt.fa_upos;

            end if;

        end if;

    end if;
end tr_res_status_bde_au;
/

alter trigger dirkspzm32.tr_res_status_bde_au enable;


-- sqlcl_snapshot {"hash":"417ba0e64b2a50760791396c1047c0e7a757816f","type":"TRIGGER","name":"TR_RES_STATUS_BDE_AU","schemaName":"DIRKSPZM32","sxml":""}