create or replace function dirkspzm32.bde_pd_lte_id_buch (
    in_sid          in isi_sid.sid%type,
    in_res_id       in isi_resource.res_id%type,
    in_scanner_name in varchar2,
    in_barcode      in varchar2,
    out_msg         out varchar2
) return number is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_res_zus  isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
    v_result   number;
    v_found    boolean;

	-- Holen des aktuellen Zustands dieser Maschine
    cursor c_bde_res_zus is
    select
        *
    from
        isi_resource_zust_akt zust_akt
    where
            zust_akt.sid = in_sid
        and zust_akt.res_id = in_res_id;

begin
    v_err_nr := null;
    open c_bde_res_zus;
    fetch c_bde_res_zus into v_res_zus;
    v_found := c_bde_res_zus%found;
    close c_bde_res_zus;
	-- Wenn nicht gefunden dann setze Fehlertext !!
    if not v_found then
        v_err_nr := 10;
        v_err_text := 'Zustand der Maschine ID: '
                      || in_res_id
                      || ' nicht vorhanden';
        raise v_error;
    end if;

    update isi_resource_zust_akt
    set
        lte_id = in_barcode                            -- Ergebnis im aktuellen Maschinenzustand SPEICHERN
    where
            sid = in_sid
        and res_id = in_res_id;

    update lvs_lte t
    set
        t.lte_id = in_barcode
    where
        t.lte_id = v_res_zus.lte_id;

    v_result := bde_scanner.bde_c_scanner_buch_spez(in_scanner_name, v_res_zus.lte_id, v_res_zus.lte_id, out_msg);

    update lvs_lte t
    set
        t.lte_status = 'BF'
    where
        t.lte_id = in_barcode;

    commit;
    return ( v_result );
exception

  -- Im Fehlerfall ist der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
end bde_pd_lte_id_buch;
/


-- sqlcl_snapshot {"hash":"bc99a609c34dcd226f8c09ee7e399904f2e1f734","type":"FUNCTION","name":"BDE_PD_LTE_ID_BUCH","schemaName":"DIRKSPZM32","sxml":""}