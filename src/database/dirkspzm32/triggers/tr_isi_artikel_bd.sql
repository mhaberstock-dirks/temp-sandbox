create or replace editionable trigger dirkspzm32.tr_isi_artikel_bd before
    delete on dirkspzm32.isi_artikel
    for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);

  -- local variables here

    v_c_result number;
    v_found    boolean;
    cursor c_lam is
    select
        lam_id
    from
        lvs_v_lam
    where
        artikel_id = :old.artikel_id;

    cursor c_fa_auftrag is
    select
        auf.leitzahl
    from
        bde_fa_auftrag auf
    where
        auf.ag_artikel_id = :old.artikel_id;

    cursor c_linie_daten is
    select
        plw.linie_nr
    from
        lvs_prod_linie_waren plw
    where
        plw.artikel_id = :old.artikel_id;

begin
    open c_lam;
    fetch c_lam into v_c_result;
    v_found := c_lam%found;
    close c_lam;
    if v_found then
        v_err_nr := 10;
        v_err_text := 'Fehler: Artikel kann nicht gelöscht werden, da dieser Bestandsführung hat.';
        raise v_error;
    end if;

    open c_fa_auftrag;
    fetch c_fa_auftrag into v_c_result;
    v_found := c_fa_auftrag%found;
    close c_fa_auftrag;
    if v_found then
        v_err_nr := 20;
        v_err_text := 'Fehler: Artikel kann nicht gelöscht werden, da dieser in der Produktionplanung für Fertigungsauftrag '
                      || v_c_result
                      || ' ist.';
        raise v_error;
    end if;

    open c_linie_daten;
    fetch c_linie_daten into v_c_result;
    v_found := c_linie_daten%found;
    close c_linie_daten;
    if v_found then
        v_err_nr := 30;
        v_err_text := 'Fehler: Artikel kann nicht gelöscht werden, da dieser in der Warenauszeichnung auf Linie '
                      || v_c_result
                      || ' Eingetragen ist.';
        raise v_error;
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

alter trigger dirkspzm32.tr_isi_artikel_bd enable;


-- sqlcl_snapshot {"hash":"b33c316739c176cb816fd9fe76bf470949d6afb9","type":"TRIGGER","name":"TR_ISI_ARTIKEL_BD","schemaName":"DIRKSPZM32","sxml":""}