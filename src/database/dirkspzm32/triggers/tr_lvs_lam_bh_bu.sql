create or replace editionable trigger dirkspzm32.tr_lvs_lam_bh_bu before
    update on dirkspzm32.lvs_lam_bh
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

  -- local variables here
    v_diff_kg  number;             -- Differenz Gewicht der Buchung
    v_diff_mg  number;             -- Differenz Menge der Buchung
    v_old      lvs_lam_bh%rowtype;
    v_ziel_ort lvs_lgr_ort%rowtype;        -- Lagerort Ziel
    v_art      isi_artikel%rowtype;   -- Artikeldaten
    v_lgr      lvs_lgr%rowtype;            -- Lagerplatz des Materials
    v_lam_akt  lvs_lam%rowtype;            -- Lagerbestand der aktuellen Buchung
    v_lte      lvs_lte%rowtype;            -- Palettendaten

    cursor c_lam_akt is                    -- Cursor für den Lagerbestand der aktuellen Buchung
    select
        *
    from
        lvs_lam lam_akt
    where
            lam_akt.sid = :new.sid
        and lam_akt.firma_nr = :new.firma_nr
        and lam_akt.lam_id = :new.lam_id;

  -- -AG- Bug-Fix 2015.05.07
    cursor c_lgr is                        -- Lesen des Lagerplatz
    select
        *
    from
        lvs_lgr lgr
    where
        lgr.lgr_platz = v_lam_akt.lgr_platz;

    cursor c_art is                        -- Lesen des Artikels
    select
        *
    from
        isi_artikel art
    where
            art.sid = :new.sid
        and art.artikel_id = :new.artikel_id;

    cursor c_lgr_ort is                             -- Lesen des Lagerplatz
    select
        *
    from
        lvs_lgr_ort ort
    where
            ort.lgr_ort = v_lgr.lgr_ort
        and ort.firma_nr = v_lgr.firma_nr
        and ort.sid = v_lgr.sid;

begin
    v_old.sid := :old.sid;
    v_old.firma_nr := :old.firma_nr;
    v_old.vorg_id := :old.vorg_id;
    v_old.vorg_typ := :old.vorg_typ;
    v_old.lam_bh_id := :old.lam_bh_id;
    v_old.lam_id := :old.lam_id;
    v_old.artikel_id := :old.artikel_id;
    v_old.bus := :new.bus;
    v_old.buch_datum := :old.buch_datum;
    v_old.ls_login_id := :old.ls_login_id;
    v_old.lgr_platz := :old.lgr_platz;
    v_old.lte_id := :old.lte_id;
    v_old.lhm_id := :old.lhm_id;
    v_old.charge_id := :old.charge_id;
    v_old.serie_id := :old.serie_id;
    v_old.abnr := :old.abnr;
    v_old.menge := :old.menge;
    v_old.lam_bh_kg := :old.lam_bh_kg;
    v_old.lam_bh_kg_einheit := :old.lam_bh_kg_einheit;
    v_old.res_id := :new.res_id;
    v_old.leitzahl := :new.leitzahl;
    v_old.fa_ag := :new.fa_ag;
    v_old.fa_upos := :new.fa_upos;
    v_old.abnr_extern := :new.abnr_extern;
    open c_lam_akt;                    -- Lagerbestandsdaten für aktuelle Buchung holen
    fetch c_lam_akt into v_lam_akt;    --
    close c_lam_akt;                   -- Aktueller Lagerbestand im Zugriff

    open c_art;                    --
    fetch c_art into v_art;        -- Hole dei Artikeldaten
    close c_art;                   --

    open c_lgr;                    --
    fetch c_lgr into v_lgr;        -- Lesen den Eintrag des Lagerplatz
    close c_lgr;                   --

    if not lvs_p_base.get_lte(v_lam_akt.lte_id, v_lte) then
        v_lte := null;
    end if;

    if
        :new.bus != c.lam_bh_bus_inv                    -- Keine Inventurbuchung
        and :new.bus != c.lam_bh_bus_zug_konsi              -- KONSI hat keinen Einfluss auf INVENTUR
        and :new.bus != c.lam_bh_bus_abg_konsi              -- KONSI hat keinen Einfluss auf INVENTUR
                                  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                  -- Achtung: BUS 24 ist eine Bestandsveränderung
                                  -- im KONSI und auch im eingenen Lagerbestand.
                                  -- Daher muss Inventur beachtet werden
                                  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    then
        if v_art.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Artikel '
                          || v_art.artikel
                          || ' '
                          || v_art.bezeichnung1
                          || ' ist in Inventur.';

            v_err_nr := 10;
            raise v_error;
        end if;

        if v_lgr.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Lagerplatz '
                          || v_lgr.lgr_platz
                          || ' ist in Inventur.';
            v_err_nr := 15;
            raise v_error;
        end if;

        open c_lgr_ort;
        fetch c_lgr_ort into v_ziel_ort;
        close c_lgr_ort;
        if v_ziel_ort.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Lagerort '
                          || v_ziel_ort.lgr_ort
                          || ' '
                          || v_ziel_ort.lgr_ort_text
                          || ' ist in Inventur.';

            v_err_nr := 20;
            raise v_error;
        end if;

        if v_lam_akt.akt_inventur_id is not null then
            v_err_text := 'Fehler: Buchung nicht möglich. '
                          || 'Lagerbestand für LHM '
                          || v_lam_akt.lhm_id
                          || ' ist in Inventur.';
            v_err_nr := 25;
            raise v_error;
        end if;

    end if;

    if :old.menge > 0 then
        if :old.menge != :new.menge then
            :new.lam_bh_kg := :old.lam_bh_kg / :old.menge * :new.menge;

        else
            :new.lam_bh_kg_einheit := :new.lam_bh_kg / :new.menge;
        end if;
    else
        :new.lam_bh_kg := :old.lam_bh_kg_einheit * :new.menge;
    end if;

    if :new.bus != 1 then                  -- Inventur
    -- -AG- Neue Funktion - Wenn Rohware gesperrt wird, dann dies auch zum Host buchen
        if
            :old.bus != 5                             -- Sperren
            and :new.bus = 5
            and nvl(:new.menge,
                    0) > 0
        then
            s_schnittstelle.write_host_bew(null,
                                           v_lam_akt,
                                           :new.lam_bh_id,
                                           :new.bus,
                                           :new.vorg_typ,
                                           null,
                                           'UE',
                                           v_lgr,
                                           null,
                                           :new.ls_login_id,
                                           nvl(:new.menge,
                                               0));
        end if;

        :new.menge := nvl(:new.menge,
                          0);
        if ( lvs_ausl.lvs_lam_bh_update_mg(v_old,
                                           :new.menge) != 1 ) then
            return;
        end if;
  ---------------------------------------------------------------------------------------------------------------------------------
    -- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang-- Zugang
        if :new.bus = 2                       -- Zugang
        or :new.bus = 12                      -- Zugang KommDirekt
        or :new.bus = 22                      -- Zugang Konsi
         then
            if
                :old.lgr_platz is null
                and :new.lgr_platz is not null
                and :new.bus = 2
            then
                lvs_p_base.set_artikel_letztes_einl_datum(v_lam_akt.sid,
                                                          v_lam_akt.firma_nr,
                                                          v_lam_akt.artikel_id,
                                                          v_lam_akt.leitzahl,
                                                          v_lam_akt.fa_ag,
                                                          :new.buch_datum);
            end if;

            v_diff_kg := nvl(:new.lam_bh_kg,
                             0) - nvl(:old.lam_bh_kg,
                                      0);               -- Gewicht rechnen
            v_diff_mg := nvl(:new.menge,
                             0) - nvl(:old.menge,
                                      0);
  ---------------------------------------------------------------------------------------------------------------------------------
    -- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang-- Abgang
        elsif :new.bus = 3                    -- Abgang
        or :new.bus = 13                   -- Abgang KommDirekt
        or :new.bus = 23                   -- Abgang KONSI
        or :new.bus = 7                    -- Quarantäne
         then
            v_diff_kg := nvl(:old.lam_bh_kg,
                             0) - nvl(:new.lam_bh_kg,
                                      0);               -- Gewicht rechnen
            v_diff_mg := nvl(:old.menge,
                             0) - nvl(:new.menge,
                                      0);

        else
            v_diff_kg := nvl(:old.lam_bh_kg,
                             0) - nvl(:new.lam_bh_kg,
                                      0);               -- Gewicht rechnen
        end if;

    else
        v_diff_kg := nvl(:new.lam_bh_kg,
                         0) - nvl(:old.lam_bh_kg,
                                  0);               -- Gewicht rechnen
        v_diff_mg := nvl(:new.menge,
                         0) - nvl(:old.menge,
                                  0);

        s_schnittstelle.write_host_bew(null,
                                       v_lam_akt,
                                       :new.lam_bh_id,
                                       :new.bus,
                                       :new.vorg_typ,
                                       null,
                                       'UE',
                                       v_lgr,
                                       null,
                                       :new.ls_login_id,
                                       v_diff_mg);

    end if;
  -- Update dokumentieren
    if :new.bus != c.lam_bh_bus_wke_konsi then
        :new.last_change_date := sysdate;
        :new.last_change_login_id := :new.ls_login_id;
        :new.change_menge := nvl(:new.menge,
                                 0) + v_diff_mg;
    end if;

    if (
        ( :new.bus = 24                   -- Entnahme KONSI
        or :new.bus = 22 )                  -- Zugang KONSI
        and abs(nvl(:old.menge,
                    0)) != v_lam_akt.menge -- Entnahme wird in + und - gebucht (+)= Entnahme KONSI (-)= Zurück ins KONSI mit Menge
    )
    or (
        :new.bus = 23                    -- Abgang KONSI
        and ( :new.menge != 0               -- Nur komplett erlauben
        or v_lam_akt.menge != 0 )
    ) then
        v_err_text := 'Fehler: KONSI-Buchung nicht möglich. '
                      || 'Lagerbestand für LHM '
                      || v_lam_akt.lhm_id
                      || ' ist breits verändert. Storno nicht mehr möglich.';
        v_err_nr := 26;
        raise v_error;
    end if;

    v_lam_akt.menge := nvl(v_lam_akt.menge, 0) + nvl(v_diff_mg, 0);

    v_lam_akt.lam_kg := nvl(v_lam_akt.lam_kg, 0) + nvl(v_diff_kg, 0);

    if
        v_lam_akt.menge = 0
        and :new.menge = 0
        and ( :new.bus = 2
        or :new.bus = 22                       -- Zugang KONSI
        or :new.bus = 12 )                      -- Zugang KommDirekt
    then
        v_lam_akt.lgr_platz := null;
        v_lte.lte_akt_lhm := v_lte.lte_akt_lhm - 1;
    end if;

    if
        v_lam_akt.menge > 0
        and v_lam_akt.lgr_platz is null
    then
        v_lam_akt.lgr_platz := :new.lgr_platz;
    end if;

    update lvs_lam
    set
        menge = v_lam_akt.menge,
        lam_kg = v_lam_akt.lam_kg,
        lgr_platz = v_lam_akt.lgr_platz
    where
            sid = :new.sid
        and firma_nr = :new.firma_nr
        and lam_id = :new.lam_id;

    update lvs_lhm
    set
        lhm_akt_kg = nvl(lhm_akt_kg, 0) + nvl(v_diff_kg, 0),
        lgr_platz = v_lam_akt.lgr_platz
    where
        lhm_id = :new.lhm_id;

    update lvs_lte
    set
        lte_akt_kg = nvl(lte_akt_kg, 0) + nvl(v_diff_kg, 0)
    where
        lte_id = :new.lte_id;

  -- -AG- Bug-Fix 2015.05.07
    update lvs_lgr
    set
        lgr_akt_kg = nvl(lgr_akt_kg, 0) + nvl(v_diff_kg, 0)
    where
        lgr_platz = v_lgr.lgr_platz;

  -- Nur wenn bei einem Zugang der einzige LAM abgezogen wird
  -- und es sich um einen echten Lagerplatz hanndelt
    if
        v_lam_akt.lgr_platz is null
        and v_lte.lte_akt_lhm = 0
        and v_lgr.lgr_verwendung = c.lgr_typ_lager
    then
    -- In dieser Sequenz ist der Lagerpltz in der LTE leer und das führt zu einem Fehler in der Unterfunktion
        update lvs_lte
        set
            lgr_platz = v_lte.lgr_platz
        where
            lte_id = :new.lte_id;

        lvs_p_lte.lvs_korr_te_ausbuchen(v_lte.sid,          -- in_te_sid         in lvs_lte.sid%TYPE,
                                        v_lte.firma_nr,     -- in_te_firma_nr    in lvs_lte.firma_nr%TYPE,
                                        v_lte.lte_id,       -- in_lte_id         in LVS_LTE.LTE_ID%TYPE,
                                        v_lte.lte_status,   -- in_lte_status     in lvs_lte.lte_status%TYPE,
                                        v_lte.sid,          -- in_lgr_sid        in lvs_lgr.sid%TYPE,
                                        v_lte.firma_nr,     -- in_lgr_firma_nr   in lvs_lgr.firma_nr%TYPE,
                                        v_lte.lgr_ort,      -- in_lgr_ort        in lvs_lgr.lgr_ort%TYPE,
                                        v_lte.lgr_platz,    -- in_lgr_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                        :new.ls_login_id);  -- in_ls_login_id    in isi_user.login_id%TYPE)
    end if;

exception
   -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || cr_lf()
                      || dbms_utility.format_error_backtrace;
        raise_application_error(-20000 - v_err_nr, v_err_text, true);
    when others then
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || cr_lf()
                          || dbms_utility.format_error_backtrace;
            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || cr_lf()
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;
end;
/

alter trigger dirkspzm32.tr_lvs_lam_bh_bu enable;


-- sqlcl_snapshot {"hash":"ac81794337712428889949f3a34ee15a20de01d3","type":"TRIGGER","name":"TR_LVS_LAM_BH_BU","schemaName":"DIRKSPZM32","sxml":""}