create or replace editionable trigger dirkspzm32.tr_isi_transport_bi before
    insert on dirkspzm32.isi_transport
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr             number;
    v_err_text           varchar2(255);

  -- Sonstige Var
    v_inv_lgr            lvs_lgr.akt_inventur_id%type;
    v_prio_lgr           lvs_lgr.aktivierung_prio%type;
    v_inv_ort            lvs_lgr_ort.akt_inventur_id%type;
    v_std_transport_zeit number;
    cursor c_lgr_ziel is
    select
        lz.akt_inventur_id,
        oz.akt_inventur_id,
        lz.aktivierung_prio
    from
        lvs_lgr     lz,
        lvs_lgr_ort oz
    where
            lz.lgr_platz = :new.lgr_platz_ziel
        and oz.lgr_ort = lz.lgr_ort;

    cursor c_lgr_quelle is
    select
        lq.akt_inventur_id,
        oq.akt_inventur_id,
        lq.aktivierung_prio
    from
        lvs_lgr     lq,
        lvs_lgr_ort oq
    where
            lq.lgr_platz = :new.lgr_platz_quelle
        and oq.lgr_ort = lq.lgr_ort;

begin
    open c_lgr_quelle;
    fetch c_lgr_quelle into
        v_inv_lgr,
        v_inv_ort,
        v_prio_lgr;
    close c_lgr_quelle;

  -- AG 20180620 Wenn die aktivierungs-Prio am Lagerplatz > als die im Auftrag, dann Prio hochsetzen
    if v_prio_lgr > nvl(:new.prio,
                        0) then
        :new.prio := v_prio_lgr;
    end if;

    if :new.soll_fertig_bis is null then
    -- Falls keine Zeit eingegeben, dann soll der Auftrag sofort beginnen und damit in x Min fertig sein
    -- Somit aendert sich nicht in der Reihenfolge und die Transportaufträge sind abwaerts kompatibel
        v_std_transport_zeit := to_number ( isi_allg.get_firma_cfg_param(:new.sid,                                      -- in_sid                   in isi_firma_cfg.sid%type,
                                                                         :new.firma_nr,                                 -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                                                         'CFG',                                         -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                                         null,                                          -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                                         'STD_WARTE_ZEIT_MIN',                          -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                         'TRANSPORT',                                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                         'CFG',                                         -- in_typ                   in isi_firma_cfg.typ%type,
                                                                         '30',                                          -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                         'INTEGER') );                                   -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
        :new.soll_fertig_bis := sysdate + v_std_transport_zeit / 1440;
    end if;

    if v_inv_lgr is not null then
        v_err_text := 'Fehler: Auf dem Quellenlagerplatz: '
                      || :new.lgr_platz_quelle
                      || ' wird eine Inventur durchgeführt.';
        v_err_nr := 10;
        raise v_error;
    elsif v_inv_ort is not null then
        v_err_text := 'Fehler: Auf dem Quellenlagerort vom Lagerplatz: '
                      || :new.lgr_platz_quelle
                      || ' wird eine Inventur durchgeführt.';
        v_err_nr := 10;
        raise v_error;
    end if;

    open c_lgr_ziel;
    fetch c_lgr_ziel into
        v_inv_lgr,
        v_inv_ort,
        v_prio_lgr;
    close c_lgr_ziel;
    if v_prio_lgr > nvl(:new.prio,
                        0) then
        :new.prio := v_prio_lgr;
    end if;

    if v_inv_lgr is not null then
        v_err_text := 'Fehler: Auf dem Ziellagerplatz: '
                      || :new.lgr_platz_ziel
                      || ' wird eine Inventur durchgeführt.';
        v_err_nr := 10;
        raise v_error;
    elsif v_inv_ort is not null then
        v_err_text := 'Fehler: Auf dem Ziellagerort vom Lagerplatz: '
                      || :new.lgr_platz_ziel
                      || ' wird eine Inventur durchgeführt.';
        v_err_nr := 10;
        raise v_error;
    end if;

    if :new.transp_id is null then
        select
            seq_transport_id.nextval
        into :new.transp_id
        from
            dual;

    end if;

exception
     -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;
end tr_isi_transport_bi;
/

alter trigger dirkspzm32.tr_isi_transport_bi enable;


-- sqlcl_snapshot {"hash":"0e027ada867bdca43b93b02acc2d9d82366ad223","type":"TRIGGER","name":"TR_ISI_TRANSPORT_BI","schemaName":"DIRKSPZM32","sxml":""}