create or replace editionable trigger dirkspzm32.tr_ze_loa_ausw_biud before
    insert or update or delete on dirkspzm32.pzm_ze_loa_ausw
    for each row
declare
    c_kto_bus_zugang constant number := 1;
    c_kto_bus_abgang constant number := 2;

  -- local variables here
    v_persnr         number;
    v_stddiff        number;
    v_k_bh_id        pzm_konten_bh.konten_bh_id%type;
    v_sid            isi_sid.sid%type;
    v_firma_nr       isi_firma.firma_nr%type;
    v_konto          pzm_konten%rowtype;
    v_konten_bh_id   pzm_konten_bh.konten_bh_id%type;
    v_loa            pzm_lohnarten.lz_lohnart%type;
    v_lohnarten      pzm_lohnarten%rowtype;
    cursor c_lohzulagen_kto is
    select
        t.*
    from
        pzm_lohnarten t
    where
            t.lz_lohnart = v_loa
        and t.lz_konto_bus is not null;

    v_found          boolean;
    v_wert           number;
begin
    v_sid := '01';
    v_firma_nr := 1;
    if inserting then
        if :new.zeaw_korr_datum is not null then
      -- Korrekturzeitpunkt auf die Zeit vom Datenbankserver setzen
            :new.zeaw_korr_datum := sysdate;
        end if;

        if :new.passiv_loa = 'T' then
            return; -- keine Kontobuchungen bei PASSIV LOA
        end if;
        v_loa := :new.zeaw_lz_lohnart;
        open c_lohzulagen_kto;
        fetch c_lohzulagen_kto into v_lohnarten;
        v_found := c_lohzulagen_kto%found;
        close c_lohzulagen_kto;
        if v_found then
            v_persnr := :new.zeaw_pers_nr;

      -- Es ist eine Buchungfähige LOA
            if pzm_kontoverwaltung.is_konto_vorhanden(v_sid, v_firma_nr, v_persnr, v_lohnarten.lz_konto_name_kurz, 'ZK',
                                                      v_konto) then
                v_wert := :new.zeaw_lz_loa_std;
                if v_konto.buch_einheit = 'DD' then
                    v_wert := 1; -- nur 1 Tag, da die LOA immer für einen Tag gespeichert wird
                end if;
                if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
                    pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                         v_firma_nr,
                                                         v_konto.konto_nr,
                                                         v_persnr,
                                                         get_pers_kst_id(v_persnr),
                                                         v_wert,
                                                         'Abbuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                         :new.zeaw_datum,
                                                         :new.aa_id,
                                                         get_pers_abt_id(v_persnr),
                                                         v_konten_bh_id);
                elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
                    pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                         v_firma_nr,
                                                         v_konto.konto_nr,
                                                         v_persnr,
                                                         get_pers_kst_id(v_persnr),
                                                         v_wert,
                                                         'Zubuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                         :new.zeaw_datum,
                                                         :new.aa_id,
                                                         get_pers_abt_id(v_persnr),
                                                         v_konten_bh_id);
                end if;

            end if;

        end if;

    elsif updating then
        v_persnr := :new.zeaw_pers_nr;
        :new.zeaw_aa_id_alt := :old.aa_id;         -- Backup

        if :old.zeaw_korr_datum is null then
            if :new.zeaw_korr_datum is not null then
        -- Korrekturzeitpunkt auf die Zeit vom Datenbankserver setzen
                :new.zeaw_korr_datum := sysdate;
            end if;
        else
            if :new.zeaw_korr_datum is null
               or :new.zeaw_korr_datum = :old.zeaw_korr_datum then
        -- Mit der Änderung des Wertes muss auch das Korrekturdatum sich verändern
        -- Werte zurücksetzen, da keine Veränderung erlaubt ist
                :new.zeaw_lz_loa_std := :old.zeaw_lz_loa_std;
            else
        -- Es wurde eine manuelle Korrektur durchgeführt
        -- Korrekturzeitpunkt auf die Zeit vom Datenbankserver setzen
                :new.zeaw_korr_datum := sysdate;
            end if;
        end if;

        if :new.passiv_loa = 'T' then
            return; -- keine Kontobuchungen bei PASSIV LOA
        end if;
        if :new.zeaw_lz_lohnart <> :old.zeaw_lz_lohnart then
      -- Stunden wurden in eine andere LOA verschoben
            v_loa := :old.zeaw_lz_lohnart;
            open c_lohzulagen_kto;
            fetch c_lohzulagen_kto into v_lohnarten;
            v_found := c_lohzulagen_kto%found;
            close c_lohzulagen_kto;
            if v_found then
        -- Es ist eine Buchungfähige LOA (old)
                if pzm_kontoverwaltung.is_konto_vorhanden(v_sid,
                                                          v_firma_nr,
                                                          :old.zeaw_pers_nr,
                                                          v_lohnarten.lz_konto_name_kurz,
                                                          'ZK',
                                                          v_konto) then
                    v_wert := :old.zeaw_lz_loa_std;
                    if v_konto.buch_einheit = 'DD' then
                        v_wert := 1; -- nur 1 Tag, da die LOA immer für einen Tag gespeichert wird
                    end if;
          -- vorherige LOA stunden wieder auf das Konto gegenbuchen
                    if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
            --LOA stunden wieder auf das Konto buchen
                        pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                             v_firma_nr,
                                                             v_konto.konto_nr,
                                                             v_persnr,
                                                             get_pers_kst_id(v_persnr),
                                                             v_wert,
                                                             'STORNIERT: Abbuchung nach LOA ' || :old.zeaw_lz_lohnart,
                                                             :old.zeaw_datum,
                                                             :old.aa_id,
                                                             get_pers_abt_id(v_persnr),
                                                             v_konten_bh_id);
                    elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
            --LOA stunden wieder vom Konto abbuchen
                        pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                             v_firma_nr,
                                                             v_konto.konto_nr,
                                                             v_persnr,
                                                             get_pers_kst_id(v_persnr),
                                                             v_wert,
                                                             'STORNIERT: Zubuchung nach LOA ' || :old.zeaw_lz_lohnart,
                                                             :old.zeaw_datum,
                                                             :old.aa_id,
                                                             get_pers_abt_id(v_persnr),
                                                             v_konten_bh_id);
                    end if;

                end if;
            end if;

            v_loa := :new.zeaw_lz_lohnart;
            open c_lohzulagen_kto;
            fetch c_lohzulagen_kto into v_lohnarten;
            v_found := c_lohzulagen_kto%found;
            close c_lohzulagen_kto;
            if v_found then
        -- Es ist eine Buchungfähige LOA (new)
                if pzm_kontoverwaltung.is_konto_vorhanden(v_sid,
                                                          v_firma_nr,
                                                          :new.zeaw_pers_nr,
                                                          v_lohnarten.lz_konto_name_kurz,
                                                          'ZK',
                                                          v_konto) then
                    v_wert := :new.zeaw_lz_loa_std;
                    if v_konto.buch_einheit = 'DD' then
                        v_wert := 1; -- nur 1 Tag, da die LOA immer für einen Tag gespeichert wird
                    end if;
                    if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
                        pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                             v_firma_nr,
                                                             v_konto.konto_nr,
                                                             v_persnr,
                                                             get_pers_kst_id(v_persnr),
                                                             v_wert,
                                                             'Abbuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                             :new.zeaw_datum,
                                                             :new.aa_id,
                                                             get_pers_abt_id(v_persnr),
                                                             v_konten_bh_id);
                    elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
                        pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                             v_firma_nr,
                                                             v_konto.konto_nr,
                                                             v_persnr,
                                                             get_pers_kst_id(v_persnr),
                                                             v_wert,
                                                             'Zubuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                             :new.zeaw_datum,
                                                             :new.aa_id,
                                                             get_pers_abt_id(v_persnr),
                                                             v_konten_bh_id);
                    end if;

                end if;
            end if;

        else
      -- :new.zeaw_lz_lohnart = :old.zeaw_lz_lohnart (LOA wurde nicht verändert höchstens die stunden wurden korrigiert)
            v_loa := :new.zeaw_lz_lohnart;
            open c_lohzulagen_kto;
            fetch c_lohzulagen_kto into v_lohnarten;
            v_found := c_lohzulagen_kto%found;
            close c_lohzulagen_kto;
            if v_found then
        -- Es ist eine Buchungfähige LOA
                if pzm_kontoverwaltung.is_konto_vorhanden(v_sid, v_firma_nr, v_persnr, v_lohnarten.lz_konto_name_kurz, 'ZK',
                                                          v_konto) then
                    v_stddiff := :new.zeaw_lz_loa_std - :old.zeaw_lz_loa_std;
                    if v_konto.buch_einheit = 'HH24' then
                        if v_stddiff > 0 then
              -- nach oben korrigieren
                            if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
                                pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                                     v_firma_nr,
                                                                     v_konto.konto_nr,
                                                                     v_persnr,
                                                                     get_pers_kst_id(v_persnr),
                                                                     v_stddiff,
                                                                     'KORRIGIERT: Abbuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                                     :new.zeaw_datum,
                                                                     :new.aa_id,
                                                                     get_pers_abt_id(v_persnr),
                                                                     v_konten_bh_id);

                            elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
                                pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                                     v_firma_nr,
                                                                     v_konto.konto_nr,
                                                                     v_persnr,
                                                                     get_pers_kst_id(v_persnr),
                                                                     v_stddiff,
                                                                     'KORRIGIERT: Zubuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                                     :new.zeaw_datum,
                                                                     :new.aa_id,
                                                                     get_pers_abt_id(v_persnr),
                                                                     v_konten_bh_id);
                            end if;

                        elsif v_stddiff < 0 then
              -- nach unten korrigieren
                            if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
                                pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                                     v_firma_nr,
                                                                     v_konto.konto_nr,
                                                                     v_persnr,
                                                                     get_pers_kst_id(v_persnr),
                                                                     abs(v_stddiff),
                                                                     'KORRIGIERT: Abbuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                                     :new.zeaw_datum,
                                                                     :new.aa_id,
                                                                     get_pers_abt_id(v_persnr),
                                                                     v_konten_bh_id);

                            elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
                                pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                                     v_firma_nr,
                                                                     v_konto.konto_nr,
                                                                     v_persnr,
                                                                     get_pers_kst_id(v_persnr),
                                                                     abs(v_stddiff),
                                                                     'KORRIGIERT: Zubuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                                     :new.zeaw_datum,
                                                                     :new.aa_id,
                                                                     get_pers_abt_id(v_persnr),
                                                                     v_konten_bh_id);
                            end if;
                        end if;

                    elsif
                        v_konto.buch_einheit = 'DD'
                        and :new.zeaw_lz_loa_std = 0
                    then
                        if v_konto.buch_einheit = 'DD' then
                            v_wert := 1; -- nur 1 Tag, da die LOA immer für einen Tag gespeichert wird
                        end if;

            -- nur 1 Tag nach unten korrigieren
                        if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
                            pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                                 v_firma_nr,
                                                                 v_konto.konto_nr,
                                                                 v_persnr,
                                                                 get_pers_kst_id(v_persnr),
                                                                 v_wert,
                                                                 'KORRIGIERT: Abbuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                                 :new.zeaw_datum,
                                                                 :new.aa_id,
                                                                 get_pers_abt_id(v_persnr),
                                                                 v_konten_bh_id);

                        elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
                            pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                                 v_firma_nr,
                                                                 v_konto.konto_nr,
                                                                 v_persnr,
                                                                 get_pers_kst_id(v_persnr),
                                                                 v_wert,
                                                                 'KORRIGIERT: Zubuchung nach LOA ' || :new.zeaw_lz_lohnart,
                                                                 :new.zeaw_datum,
                                                                 :new.aa_id,
                                                                 get_pers_abt_id(v_persnr),
                                                                 v_konten_bh_id);
                        end if;

                    end if;

                end if;
            end if;

        end if;

    elsif deleting then
        if :old.aa_id is not null then
            raise_application_error(-20000, 'Diese LOA ist an eine Abwesenheit gebunden, und kann nicht direkt gelöscht werden.');
        end if;

        if :old.passiv_loa = 'T' then
            return; -- keine Kontobuchungen bei PASSIV LOA
        end if;
        v_loa := :old.zeaw_lz_lohnart;
        open c_lohzulagen_kto;
        fetch c_lohzulagen_kto into v_lohnarten;
        v_found := c_lohzulagen_kto%found;
        close c_lohzulagen_kto;
        if v_found then
            v_persnr := :old.zeaw_pers_nr;

      -- Es ist eine Buchungfähige LOA
            if pzm_kontoverwaltung.is_konto_vorhanden(v_sid, v_firma_nr, v_persnr, v_lohnarten.lz_konto_name_kurz, 'ZK',
                                                      v_konto) then
                v_wert := :old.zeaw_lz_loa_std;
                if v_konto.buch_einheit = 'DD' then
                    v_wert := 1; -- nur 1 Tag, da die LOA immer für einen Tag gespeichert wird
                end if;

        -- jeweils immer wieder das gegenteil buchen
                if v_lohnarten.lz_konto_bus = c_kto_bus_abgang then
                    select
                        max(x.konten_bh_id)
                    into v_k_bh_id
                    from
                        pzm_konten_bh x
                    where
                            x.konto_nr = v_konto.konto_nr
                        and x.zk_start = :old.zeaw_datum
                        and x.bus = c_kto_bus_abgang
                        and x.wert = v_wert
                        and x.typ = 'B'
                        and x.info = 'Abbuchung nach LOA ' || :old.zeaw_lz_lohnart;

                    if v_k_bh_id is not null then
                        delete pzm_konten_bh x
                        where
                            x.konten_bh_id = v_k_bh_id;  -- Jetzt den passenden Zatz löschen
                    else
            --LOA stunden wieder auf das Konto buchen
                        pzm_kontoverwaltung.zk_zugang_buchen(v_sid,
                                                             v_firma_nr,
                                                             v_konto.konto_nr,
                                                             v_persnr,
                                                             get_pers_kst_id(v_persnr),
                                                             v_wert,
                                                             'STORNIERT: Abbuchung nach LOA ' || :old.zeaw_lz_lohnart,
                                                             :old.zeaw_datum,
                                                             :old.aa_id,
                                                             get_pers_abt_id(v_persnr),
                                                             v_konten_bh_id);
                    end if;

                elsif v_lohnarten.lz_konto_bus = c_kto_bus_zugang then
                    select
                        max(x.konten_bh_id)
                    into v_k_bh_id
                    from
                        pzm_konten_bh x
                    where
                            x.konto_nr = v_konto.konto_nr
                        and x.zk_start = :old.zeaw_datum
                        and x.bus = c_kto_bus_zugang
                        and x.wert = v_wert
                        and x.typ = 'B'
                        and x.info = 'Zubuchung nach LOA ' || :old.zeaw_lz_lohnart;

                    if v_k_bh_id is not null then
                        delete pzm_konten_bh x             -- Jetzt den passenden Zatz löschen
                        where
                            x.konten_bh_id = v_k_bh_id;

                    else
            --LOA stunden wieder vom Konto abbuchen
                        pzm_kontoverwaltung.zk_abgang_buchen(v_sid,
                                                             v_firma_nr,
                                                             v_konto.konto_nr,
                                                             v_persnr,
                                                             get_pers_kst_id(v_persnr),
                                                             v_wert,
                                                             'STORNIERT: Zubuchung nach LOA ' || :old.zeaw_lz_lohnart,
                                                             :old.zeaw_datum,
                                                             :old.aa_id,
                                                             get_pers_abt_id(v_persnr),
                                                             v_konten_bh_id);
                    end if;

                end if;

            end if;

        end if;

    end if;

end;
/

alter trigger dirkspzm32.tr_ze_loa_ausw_biud enable;


-- sqlcl_snapshot {"hash":"dcf1efb5354c7a0492307b4d4a201552891469b6","type":"TRIGGER","name":"TR_ZE_LOA_AUSW_BIUD","schemaName":"DIRKSPZM32","sxml":""}