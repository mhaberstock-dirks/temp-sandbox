create or replace function dirkspzm32.get_charge_bez_check (
    p_sid    in isi_sid.sid%type,
    p_firma  in isi_firma.firma_nr%type,
    p_charge in lvs_charge.charge_bez%type
) return varchar2 is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr         number;
    v_err_text       varchar2(255);
    v_parameter_wert varchar2(40);
    v_charge_bez     lvs_charge.charge_bez%type;
    v_min_l          number;
    v_max_l          number;
    auto_fil_char    varchar2(100);
begin
  -- Erst prüfen ob für diese Chargenbezeichnung bereits eine Charge existiert
  -- falls nicht, dann wird diese angelegt
    v_charge_bez := p_charge;
    v_min_l := isi_allg.c_get_firma_cfg_param(p_sid, p_firma, 'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
     null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
     'CHARGE_MIN_LENGTH',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                               '1',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'INTEGER');            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    if nvl(
        length(v_charge_bez),
        0
    ) < v_min_l then
        auto_fil_char := isi_allg.c_get_firma_cfg_param(p_sid, p_firma, 'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'CHARGE_AUT_FIL_CHAR', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                        'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                         'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                         null,                  -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                         'STRING');             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
        if auto_fil_char is not null then
            if v_charge_bez is not null then
                v_charge_bez := lpad(v_charge_bez, v_min_l, auto_fil_char);
            else
                v_charge_bez := auto_fil_char;
            end if;

        else
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_charge_zu_kurz,
                                   nvl(
                                                to_char(v_min_l),
                                                'NULL'
                                            ));
      -- 'Fehler: Charge ist zu kurz! MIN Länge = <' || nvl(to_char(v_min_l), 'NULL') || '> zugeordnet!';
            raise v_error;
        end if;

    end if;

    if isi_allg.c_get_firma_cfg_param(p_sid, p_firma, 'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,

     null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,

     'CHARGE_UPPER_CASE',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                       'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                       c.c_false,             -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                       'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                       then
        v_charge_bez := upper(v_charge_bez);
    end if;

    v_max_l := isi_allg.c_get_firma_cfg_param(p_sid, p_firma, 'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,

     null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,

     'CHARGE_MAX_LENGTH',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                               '0',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'INTEGER');            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    if
        length(v_charge_bez) > v_max_l
        and v_max_l != 0
    then
        v_err_nr := 10;
        v_err_text := lc.ec_p1(lc.o_tp1_charge_zu_lang,
                               nvl(
                                        to_char(v_max_l),
                                        'NULL'
                                    ));
    --v_err_text := 'Fehler: Charge ist zu lang! MAX Länge = <' || nvl(to_char(v_max_l), 'NULL') || '> zugeordnet!';
        raise v_error;
    end if;

    return ( v_charge_bez );
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
end get_charge_bez_check;
/


-- sqlcl_snapshot {"hash":"35a4b0f1bf31ce2cd7493e1d00c70dbb3b7eec66","type":"FUNCTION","name":"GET_CHARGE_BEZ_CHECK","schemaName":"DIRKSPZM32","sxml":""}