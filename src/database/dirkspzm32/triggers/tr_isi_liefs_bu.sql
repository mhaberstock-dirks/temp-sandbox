create or replace editionable trigger dirkspzm32.tr_isi_liefs_bu before
    update on dirkspzm32.isi_liefs
    for each row
declare
  -- local variables here
    v_lam_id lvs_lam.lam_id%type;
    v_menge  lvs_lam.menge%type;
    v_found  boolean;
    v_lte    lvs_lte%rowtype;
    cursor c_lte is
    select
        *
    from
        lvs_lte lte
    where
            lte.sid = :new.sid
        and lte.lte_id = :new.lte_id
        and ( lte.lte_status = c.lte_af_stat
              or lte.lte_status = c.lte_ag_stat );

    cursor c_lam_lte is
    select
        sum(lam.menge)
    from
        lvs_lam lam
    where
            lam.sid = :new.sid
        and lam.lte_id = :new.lte_id
    group by
        lam.lte_id;

begin
    open c_lam_lte; -- Ersten Eintrag lesen
    fetch c_lam_lte into v_menge;
    v_found := c_lam_lte%found; -- Eintrag mit Menge vorhanden, das ist ein Fehler (Abbruch)
    close c_lam_lte;
    if
        v_found
        and v_menge > 0
        and :new.login_id_verantwortung is not null
    then
        open c_lte; -- Eintrag lesen (Nur Status AF (Auslagern Fertig)
        fetch c_lte into v_lte;
        v_found := c_lte%found; -- Eintrag mit Menge vorhanden, das ist ein Fehler (Abbruch)
        close c_lte;
        if
            v_found
            and v_lte.lte_status = c.lte_af_stat
        then
      -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
            v_lam_id := lvs_ausl.lvs_lam_abgang(:new.sid,
                                                :new.firma_nr,
                                                :new.artikel_id,
                                                :new.lte_id,
                                                null,
                                                :new.auftrag,
                                                null,
                                                sysdate,
                                                :new.login_id_verantwortung,
                                                null,
                                                null,
                                                null,
                                                null,
                                                null,
                                                null,
                                                c.lam_bh_bus_abg,
                                                :new.vorgang_id,
                                                :new.li_nr,
                                                :new.li_pos_nr);

            update lvs_lte lte
            set
                lte.lgr_platz = null,
                lte.lgr_platz_gruppe = null,
                lte.lgr_ort = null,
                lte.ziel_lgr_ort = null,
                lte.ziel_lgr_platz = null,
                lte.ziel_lgr_ort_n_freif = null,
                lte.ziel_lgr_platz_n_freif = null
            where
                    lte.sid = :new.sid
                and lte.lte_id = :new.lte_id;

        end if;

    end if;

end tr_isi_liefs_bu;
/

alter trigger dirkspzm32.tr_isi_liefs_bu enable;


-- sqlcl_snapshot {"hash":"4bc5f2f0b6b969fe28787ce7dc7d6e6526d947f6","type":"TRIGGER","name":"TR_ISI_LIEFS_BU","schemaName":"DIRKSPZM32","sxml":""}