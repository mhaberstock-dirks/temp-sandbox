create or replace package body dirkspzm32.isi_utils is

    function max_number (
        in_a in number,
        in_b in number
    ) return number is
        v_max_number number;
    begin
        v_max_number := in_a;
        if in_b > in_a then
            v_max_number := in_b;
        end if;
        return ( v_max_number );
    end;

    function md5_encrypt (
        in_clear_value in varchar2
    ) return varchar2 is
        v_result varchar2(4000);
    begin
        v_result := utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => in_clear_value
        ))));

        return ( v_result );
    end;

    function time_delta (
        in_from_date       in date,
        in_to_date         in date,
        in_format          in varchar2,
        in_use_feiertage   in varchar2,
        in_use_weekend     in varchar2,
        in_day_start_limit in number,
        in_day_end_limit   in number
    ) return number is

        v_result         number;
        v_diff_from_date date;
        v_dayofweek      number;
    --v_do_increment boolean;
        v_temp           varchar2(10);
    --v_std_delta number;
        v_is_weekend     boolean;
        v_is_feiertag    boolean;
        v_n_arb_std_tag  number;
    begin
        v_result := in_to_date - in_from_date;
        v_n_arb_std_tag := nvl(in_day_start_limit * 24, 0) + ( 24 - nvl((in_day_end_limit * 24), 0) );

        v_diff_from_date := in_from_date;
        if v_result > 5 then
            v_diff_from_date := ( trunc(in_to_date) - 5 );
            v_result := in_to_date - v_diff_from_date;
            if lower(in_format) = 'hh24' then
                v_result := v_result * 24; -- In Stunden
            end if;
            return ( trunc(v_result) );
        end if;

        while trunc(v_diff_from_date) <= trunc(in_to_date) loop
            v_is_weekend := false;
            v_is_feiertag := false;
            if in_use_weekend = 'T' then
                v_dayofweek := iso_weekday(v_diff_from_date); -- 1= Mo; 2= Di; D = Day of Week
                v_is_weekend := v_dayofweek in ( 6, 7 );
            end if;

            if in_use_feiertage = 'T' then
                v_is_feiertag := ( ist_feiertag(null, null, null, null, v_diff_from_date,
                                                v_temp) = 1 );
            end if;

            if
                trunc(in_from_date) = trunc(in_to_date)
                and ( v_is_weekend
                or v_is_feiertag )
            then
                v_result := 0;
                return ( v_result );
            end if;

      -- erster tag
            if trunc(v_diff_from_date) = trunc(in_from_date) then
                if v_is_weekend then
                    v_result := v_result - ( ( trunc(v_diff_from_date) + 1 ) - v_diff_from_date );
                    v_diff_from_date := v_diff_from_date + 1; -- Am Samstag und Sonntag 1 Tag weiterzählen
                    goto continue;
                end if;

                if v_is_feiertag then
                    v_result := v_result - ( ( trunc(v_diff_from_date) + 1 ) - v_diff_from_date );
                    v_diff_from_date := v_diff_from_date + 1; -- Am Feiertag 1 Tag weiterzählen
                    goto continue;
                end if;

                if lower(in_format) = 'hh24' then
          -- jetzt nur noch die karenzstunden abziehen
                    if
                        in_day_start_limit is not null
                        and v_diff_from_date < ( trunc(v_diff_from_date) + in_day_start_limit )
                    then
                        v_result := v_result - ( ( trunc(v_diff_from_date) + in_day_start_limit ) - v_diff_from_date );
                    end if;

                    if
                        in_day_end_limit is not null
                        and in_to_date >= ( trunc(v_diff_from_date) + 1 )
                    then
                        if v_diff_from_date <= ( trunc(v_diff_from_date) + in_day_end_limit ) then
                            v_result := v_result - ( ( trunc(v_diff_from_date) + 1 ) - ( trunc(v_diff_from_date) + in_day_end_limit )
                            );

                        else
                            v_result := v_result - ( ( trunc(v_diff_from_date) + 1 ) - v_diff_from_date );
                        end if;

                    end if;

                end if;

            end if;

            if trunc(v_diff_from_date) = trunc(in_to_date) then
        -- letzter tag
                if v_is_weekend then
                    v_result := v_result - ( in_to_date - trunc(in_to_date) ); -- Alle Stunden dieses Tages abziehen
                    v_diff_from_date := v_diff_from_date + 1; -- Am Samstag und Sonntag 1 Tag weiterzählen
                    goto continue;
                end if;

                if v_is_feiertag then
                    v_result := v_result - ( in_to_date - trunc(in_to_date) ); -- Alle Stunden dieses Tages abziehen
                    v_diff_from_date := v_diff_from_date + 1; -- Am Feiertag 1 Tag weiterzählen
                    goto continue;
                end if;

                if lower(in_format) = 'hh24' then
          -- jetzt nur noch die karenzstunden abziehen
                    if
                        in_day_start_limit is not null
                        and in_from_date < trunc(v_diff_from_date)
                    then
                        if in_to_date < ( trunc(in_to_date) + in_day_start_limit ) then
                            v_result := v_result - ( in_to_date - trunc(in_to_date) );
                        else
                            v_result := v_result - ( ( trunc(in_to_date) + in_day_start_limit ) - trunc(in_to_date) );
                        end if;
                    end if;

                    if
                        in_day_end_limit is not null
                        and in_to_date > ( trunc(in_to_date) + in_day_end_limit )
                    then
                        v_result := v_result - ( in_to_date - ( trunc(in_to_date) + in_day_end_limit ) );
                    end if;

                end if;

            end if;

            if
                trunc(v_diff_from_date) > trunc(in_from_date)
                and trunc(v_diff_from_date) < trunc(in_to_date)
            then
        -- alle Tage zwischen dem ersten und letzten
                if v_is_weekend then
                    v_result := v_result - 1;
                    v_diff_from_date := v_diff_from_date + 1; -- Am Sonntag 1 Tage weiterzählen
                    goto continue;
                end if;

                if v_is_feiertag then
                    v_result := v_result - 1;
                    v_diff_from_date := v_diff_from_date + 1; -- Am Feiertag 1 Tage weiterzählen
                    goto continue;
                end if;

                if lower(in_format) = 'hh24' then
                    v_result := v_result - ( v_n_arb_std_tag / 24 );
                end if;

            end if;

            v_diff_from_date := v_diff_from_date + 1; -- Tageweise zählen
            << continue >> null;
        end loop;

        if lower(in_format) = 'hh24' then
            v_result := v_result * 24; -- In Stunden
        end if;
        return ( trunc(v_result) );
    end;

    function byte_unit_to_byte (
        in_value     in number,
        in_unit_name in varchar2
    ) return number is
        v_result number;
    begin
        v_result := in_value;
        if upper(in_unit_name) = 'KB' then
            v_result := in_value * 1024;
        elsif upper(in_unit_name) = 'MB' then
            v_result := in_value * 1024 * 1024;
        elsif upper(in_unit_name) = 'GB' then
            v_result := in_value * 1024 * 1024 * 1024;
        elsif upper(in_unit_name) = 'TB' then
            v_result := in_value * 1024 * 1024 * 1024 * 1024;
        end if;

        return ( v_result );
    end;

  -- Führt einen Oracle "substr" bis zu einem CR/LF aus
    function substr_to_eol (
        in_str in varchar2,
        in_pos in number
    ) return varchar2 is
        v_result  varchar2(4000);
        v_eol_pos number;
    begin
        v_result := substr(in_str, in_pos);
        v_eol_pos := instr(in_str,
                           chr(13),
                           in_pos,
                           1);
        if v_eol_pos >= 1 then
            v_result := substr(in_str, in_pos, v_eol_pos - in_pos);
        else
            v_eol_pos := instr(in_str,
                               chr(10),
                               in_pos,
                               1);
            if v_eol_pos >= 1 then
                v_result := substr(in_str, in_pos, v_eol_pos - in_pos);
            end if;

        end if;

        return ( v_result );
    end;

    function get_csv_items_count (
        in_csv_string in varchar2
    ) return number is
        v_result    number;
        v_colon_pos number;
    begin
        v_result := 0;
        v_colon_pos := 0;
        if in_csv_string is null then
            return ( v_result );
        end if;
        loop
            v_result := v_result + 1; -- es gibt mindestens 1 Eintrag, aich wenn kein ; vorhanden ist
            v_colon_pos := instr(in_csv_string, ';', v_colon_pos + 1);
            exit when v_colon_pos = 0;
        end loop;

        return ( v_result );
    end;

    function get_csv_value (
        in_csv_string in varchar2,
        in_csv_item   in varchar2
    ) return varchar2 is
        v_item_index number;
        v_item       varchar2(1024);
        v_equals_pos number;
        v_result     varchar2(1024);
    begin
        v_result := null;
        v_item_index := index_of_csv_item(in_csv_string, in_csv_item);
        if v_item_index = -1 then
            return ( v_result );
        end if;
        if get_csv_item(in_csv_string, v_item_index, v_item) then
            v_equals_pos := instr(v_item, '=', 1);
            v_result := substr(v_item, v_equals_pos + 1);
            return ( v_result );
        end if;

        return ( v_result );
    end;

    function get_csv_item (
        in_csv_string      in varchar2,
        in_item_ix         in number,
        out_item_substring out varchar2
    ) return boolean is
        v_colon_pos  number;
        v_colon2_pos number;
    begin
        out_item_substring := null;
        if in_csv_string is null
           or in_item_ix is null
        or in_item_ix < 0
        or ( in_item_ix > get_csv_items_count(in_csv_string) ) then
            return ( false );
        end if;

        if in_item_ix = 0 then
            v_colon_pos := instr(in_csv_string, ';', 1);
            if v_colon_pos >= 1 then
                out_item_substring := substr(in_csv_string, 1, v_colon_pos - 1);
                return ( true );
            else
                out_item_substring := in_csv_string;
                return ( true );
            end if;

        end if;

        v_colon_pos := instr(in_csv_string, ';', 1, in_item_ix);
        if v_colon_pos >= 1 then
            v_colon2_pos := instr(in_csv_string, ';', v_colon_pos + 1, 1);
            if v_colon2_pos >= 1 then
                out_item_substring := substr(in_csv_string, v_colon_pos + 1, v_colon2_pos - v_colon_pos - 1);
            else
                out_item_substring := substr(in_csv_string, v_colon_pos + 1);
            end if;

            return ( true );
        end if;

        return ( false );
    end;

    function index_of_csv_item (
        in_csv_string in varchar2,
        in_csv_item   in varchar2
    ) return number is
        i       number;
        v_count number;
        v_item  varchar2(1024);
    begin
        i := 0;
        v_count := get_csv_items_count(in_csv_string);
        loop
            exit when i >= v_count;
            if get_csv_item(in_csv_string, i, v_item) then
                if v_item like in_csv_item || '=%'
                   or in_csv_item like v_item || '=%' then
                    return ( i );
                end if;

            end if;

            i := i + 1;
        end loop;

        return ( -1 );
    end;

    function is_param_list_comlete (
        in_csv_params_values in varchar2,
        in_csv_params_cfg    in varchar2,
        in_check_values      in varchar2
    ) return varchar2 is

        v_params_count     number;
        v_params_cfg_count number;
        i                  number;
        v_pv_item          varchar2(1024);
        v_param_cfg_item   varchar2(1024);
        v_ok               boolean;
        v_ix               number;
    begin
        v_params_count := get_csv_items_count(in_csv_params_values);
        v_params_cfg_count := get_csv_items_count(in_csv_params_cfg);
        if v_params_count < v_params_cfg_count then
      -- zu wenig
            return c.c_false;
        end if;
        v_ok := true;
        i := 0;
        loop
            exit when i >= v_params_count
            or not v_ok;
            if get_csv_item(in_csv_params_cfg, i, v_param_cfg_item)
         --and
             then
                if v_param_cfg_item is not null then
                    v_ix := index_of_csv_item(in_csv_params_values, v_param_cfg_item);
                    if v_ix >= 0 then
                        if
                            get_csv_item(in_csv_params_values, v_ix, v_pv_item)
                            and (
                                v_pv_item = v_param_cfg_item || '='
                                and in_check_values = 'T'
                            ) -- Param ohne Wert
                        then
                            v_ok := false;
                        end if;

                    else
                        v_ok := false;
                    end if;

                end if;

            end if;

            i := i + 1;
        end loop;

        if v_ok then
            return c.c_true;
        else
            return c.c_false;
        end if;
    end;

    procedure spez_barcode_gen (
        in_artikel        in isi_artikel.artikel%type,
        in_charge         in lvs_charge.charge_bez%type,
        in_menge          in lvs_lam.menge%type,
        in_p_datum        in lvs_lam.prod_datum%type,
        in_ean            in varchar2,
        in_typ            in varchar2,
        in_hersteller_tag in varchar2,
        in_parameter_wert in isi_firma_cfg.parameter_wert%type,
        out_barcode       out varchar2
    ) is

        v_start_pos     number;
        v_start_artikel number;
        v_start_charge  number;
        v_start_typ     number;
        v_start_h_tag   number;
        v_start_menge   number;
        v_menge_str     varchar2(20);
        v_menge         number;
        v_menge_komma   boolean;
        v_menge_len     number;
        v_artikel_len   number;
        v_artikel_str   isi_artikel.artikel%type;
        v_charge_len    number;
        v_charge_str    lvs_charge.charge_bez%type;
        v_typ_len       number;
        v_typ_str       varchar2(20);
        v_h_tag_len     number;
        v_h_tag_str     varchar2(20);
    begin
        out_barcode := '';
        v_start_pos := 1;
        v_start_artikel := 0;
        v_start_charge := 0;
        v_start_typ := 0;
        v_start_h_tag := 0;
        v_start_menge := 0;
        v_menge_len := 0;
        v_artikel_len := 0;
        v_charge_len := 0;
        v_typ_len := 0;
        v_h_tag_len := 0;
        v_menge_komma := false;
        v_menge_len := null;
        v_menge := in_menge;
        while ( v_start_pos - 1 < length(in_parameter_wert) ) loop
            if substr(
                upper(in_parameter_wert),
                v_start_pos,
                1
            ) = 'M' then
                v_menge_len := nvl(v_menge_len, 0) + 1;
                if substr(in_parameter_wert, v_start_pos, 1) = 'm' then
                    v_menge_komma := true;
                end if;

            end if;

            if v_menge_komma then
                v_menge := v_menge * 10;
            end if;
            v_start_pos := v_start_pos + 1;
        end loop;

        v_start_pos := 1;
        while ( v_start_pos - 1 < length(in_parameter_wert) ) loop
            if substr(
                upper(in_parameter_wert),
                v_start_pos,
                1
            ) = 'A' then
                v_artikel_len := v_artikel_len + 1;
            end if;

            v_start_pos := v_start_pos + 1;
        end loop;

        v_start_pos := 1;
        while ( v_start_pos - 1 < length(in_parameter_wert) ) loop
            if substr(
                upper(in_parameter_wert),
                v_start_pos,
                1
            ) = 'C' then
                v_charge_len := v_charge_len + 1;
            end if;

            v_start_pos := v_start_pos + 1;
        end loop;

        v_start_pos := 1;
        while ( v_start_pos - 1 < length(in_parameter_wert) ) loop
            if substr(
                upper(in_parameter_wert),
                v_start_pos,
                1
            ) = 'T' then
                v_typ_len := v_typ_len + 1;
            end if;

            v_start_pos := v_start_pos + 1;
        end loop;

        v_start_pos := 1;
        while ( v_start_pos - 1 < length(in_parameter_wert) ) loop
            if substr(
                upper(in_parameter_wert),
                v_start_pos,
                1
            ) = 'H' then
                v_h_tag_len := v_h_tag_len + 1;
            end if;

            v_start_pos := v_start_pos + 1;
        end loop;

        v_menge := round(v_menge, 0);
        if v_menge_len > 0 then
            v_menge_str := lpad(v_menge, v_menge_len, '0');
        end if;

        if v_artikel_len > 0 then
            v_artikel_str := lpad(in_artikel, v_artikel_len, '0');
        end if;

        if v_charge_len > 0 then
            v_charge_str := lpad(in_charge, v_charge_len, '0');
        end if;

        if v_typ_len > 0 then
            v_typ_str := lpad(in_typ, v_typ_len, '0');
        end if;

        if v_h_tag_len > 0 then
            v_h_tag_str := lpad(in_hersteller_tag, v_h_tag_len, '0');
        end if;

        v_start_pos := 1;
        out_barcode := ''; -- Am Anfang leer
    -- !!! Achtung Änderungen hier auch in Modul BDE_SCANNER.spez_barcode_gen ändern redundante Routine
    -- !!!                              in Modul LVS_P_LTE_LHM.spez_barcode_gen
    -- !!!                              in Modul ISI_UTILS.spez_barcode_gen

        while ( v_start_pos - 1 < length(in_parameter_wert) ) loop
            if substr(in_parameter_wert, v_start_pos, 1) = 'A' then
                v_start_artikel := v_start_artikel + 1;
                out_barcode := out_barcode
                               || substr(v_artikel_str, v_start_artikel, 1);
            elsif substr(in_parameter_wert, v_start_pos, 1) = 'C' then
                v_start_charge := v_start_charge + 1;
                out_barcode := out_barcode
                               || substr(v_charge_str, v_start_charge, 1);
            elsif substr(in_parameter_wert, v_start_pos, 1) = 'T' then
                v_start_typ := v_start_typ + 1;
                out_barcode := out_barcode
                               || substr(v_typ_str, v_start_typ, 1);
            elsif substr(in_parameter_wert, v_start_pos, 1) = 'H' then
                v_start_h_tag := v_start_h_tag + 1;
                out_barcode := out_barcode
                               || substr(v_h_tag_str, v_start_h_tag, 1);
            elsif substr(in_parameter_wert, v_start_pos, 6) = 'PDMMYY' then
                out_barcode := out_barcode || to_char(in_p_datum, 'DDMMYY');
                v_start_pos := v_start_pos + 5;
            elsif substr(in_parameter_wert, v_start_pos, 4) = 'PYYY' then
                out_barcode := out_barcode || to_char(in_p_datum, 'YYYY');
                v_start_pos := v_start_pos + 3;
            elsif substr(in_parameter_wert, v_start_pos, 2) = 'PY' then
                out_barcode := out_barcode || to_char(in_p_datum, 'YY');
                v_start_pos := v_start_pos + 1;
            elsif substr(in_parameter_wert, v_start_pos, 2) = 'KW' then
                out_barcode := out_barcode || to_char(in_p_datum, 'WW');
                v_start_pos := v_start_pos + 1;
            elsif substr(in_parameter_wert, v_start_pos, 1) = 'D' then
                out_barcode := out_barcode || to_char(in_p_datum, 'D');
            elsif substr(in_parameter_wert, v_start_pos, 5) = 'EAN06' then
                out_barcode := out_barcode
                               || substr(in_ean, v_start_pos, 6);
                v_start_pos := v_start_pos + 5;
-- Bugfix Laenge falsch 17.12.2010
            elsif substr(in_parameter_wert, v_start_pos, 5) = 'EAN13' then
                out_barcode := out_barcode
                               || substr(in_ean, v_start_pos, 13);
                v_start_pos := v_start_pos + 12;
            elsif substr(in_parameter_wert, v_start_pos, 5) = 'EAN14' then
                out_barcode := out_barcode
                               || substr(in_ean, v_start_pos, 14);
                v_start_pos := v_start_pos + 13;
            elsif substr(
                upper(in_parameter_wert),
                v_start_pos,
                1
            ) = 'M' then
                v_start_menge := v_start_menge + 1;
                out_barcode := out_barcode
                               || substr(v_menge_str, v_start_menge, 1);
            else
                out_barcode := out_barcode
                               || substr(in_parameter_wert, v_start_pos, 1);
            end if;

            v_start_pos := v_start_pos + 1;
        end loop;

    end spez_barcode_gen;

    procedure spez_barcode_lfdn (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_barcode     in varchar2,
        in_barcode_ref in varchar2,
        out_lfdn       out number
    ) is

        v_firma     isi_firma%rowtype;
        v_start_pos number;
        v_ende_pos  number;
        v_laenge_nr number;
        v_id        number;
        v_id_len    number;
        v_len       number;
        v_id_str    lvs_lte.lte_id%type;
        v_format    lvs_lte.lte_id%type;
    begin
        if not isi_p_base.get_isi_firma(in_sid, in_firma_nr, v_firma) then
            out_lfdn := null;
            return;
        end if;

        if in_barcode_ref = c.basis_lhm then
            if v_firma.lhm_barcode_type != c.lte_barcode_spez then
                out_lfdn := null;
                return;
            else
                v_id_len := v_firma.lhm_barcode_laenge;
                v_format := v_firma.lhm_barcode_kopf;
            end if;

        end if;

        if in_barcode_ref = c.basis_lte then
            if v_firma.lte_barcode_type != c.lte_barcode_spez then
                out_lfdn := null;
                return;
            else
                v_id_len := v_firma.lte_barcode_laenge;
                v_format := v_firma.lte_barcode_kopf;
            end if;
        end if;

        v_len := 0;
        v_start_pos := nvl(
            instr(v_format, '_', 1, 1),
            1
        );

        v_ende_pos := v_start_pos;
        while (
            ( nvl(
                instr(v_format, '_', v_ende_pos, 1),
                0
            ) != 0 )
            and ( v_ende_pos <= v_id_len )
        ) loop
            v_ende_pos := v_ende_pos + 1;
            v_len := v_len + 1;
        end loop;

        v_id_str := substr(
            nvl(in_barcode, ''),
            v_start_pos,
            v_ende_pos
        );
        begin
            out_lfdn := to_number ( v_id_str );
        exception
            when others then
                out_lfdn := null;
        end;

    end;

    function secondsbetweend (
        in_from_date in date,
        in_to_date   in date
    ) return number is
        v_secs number;
    begin
        v_secs := in_to_date - in_from_date; -- Differenz in Tagen
        v_secs := v_secs * 24 * 60 * 60;     -- Umrechnung in Sekunden
        return v_secs;
    end;

  --------------------------------------------------------------------------------
  -- FUNCTION human_to_steuerzeichen
  --------------------------------------------------------------------------------
    function human_to_steuerzeichen (
        in_str in varchar2
    ) return varchar2 is
        str_out     varchar2(256) := null;
        v_start_pos number;
        v_out_pos   number;
    begin
        v_start_pos := 1;
        v_out_pos := 1;
        while ( v_start_pos < length(in_str) ) loop
            if substr(in_str, v_start_pos, 5) = '<NUL>' then
                str_out := str_out || chr(0);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<SOH>' then
                str_out := str_out || chr(1);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<STX>' then
                str_out := str_out || chr(2);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<ETX>' then
                str_out := str_out || chr(3);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<EOT>' then
                str_out := str_out || chr(4);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<ENQ>' then
                str_out := str_out || chr(5);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<ACK>' then
                str_out := str_out || chr(6);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<BEL>' then
                str_out := str_out || chr(7);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 4) = '<BS>' then
                str_out := str_out || chr(8);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<HT>' then
                str_out := str_out || chr(9);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<LF>' then
                str_out := str_out || chr(10);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<VT>' then
                str_out := str_out || chr(11);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<FF>' then
                str_out := str_out || chr(12);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<CR>' then
                str_out := str_out || chr(13);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<SO>' then
                str_out := str_out || chr(14);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<SI>' then
                str_out := str_out || chr(15);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 5) = '<DLE>' then
                str_out := str_out || chr(16);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<DC1>' then
                str_out := str_out || chr(17);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<DC2>' then
                str_out := str_out || chr(18);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<DC3>' then
                str_out := str_out || chr(19);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<DC4>' then
                str_out := str_out || chr(20);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<NAK>' then
                str_out := str_out || chr(21);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<SYN>' then
                str_out := str_out || chr(22);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<ETB>' then
                str_out := str_out || chr(23);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<CAN>' then
                str_out := str_out || chr(24);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 4) = '<EM>' then
                str_out := str_out || chr(25);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 5) = '<SUB>' then
                str_out := str_out || chr(26);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 5) = '<ESC>' then
                str_out := str_out || chr(27);
                v_start_pos := v_start_pos + 5;
            elsif substr(in_str, v_start_pos, 4) = '<FS>' then
                str_out := str_out || chr(28);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<GS>' then
                str_out := str_out || chr(29);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<RS>' then
                str_out := str_out || chr(30);
                v_start_pos := v_start_pos + 4;
            elsif substr(in_str, v_start_pos, 4) = '<US>' then
                str_out := str_out || chr(31);
                v_start_pos := v_start_pos + 4;
            else
                str_out := str_out
                           || substr(in_str, v_start_pos, 1);
                v_start_pos := v_start_pos + 1;
            end if;

            v_out_pos := v_out_pos + 1;
        end loop;

        return ( str_out );
    end;


  --------------------------------------------------------------------------------
  -- FUNCTION Format_EAN
  --
  -- 4027453230095 -> 40 27453 23009 5
  -- 04027453230095 -> 040 27453 23009 5
  --------------------------------------------------------------------------------
    function format_ean (
        in_str in varchar2
    ) return varchar2 is
        str_out varchar2(256) := null;
    begin
        str_out := ' '
                   || substr(in_str,
                             length(in_str),
                             1);
        str_out := ' '
                   || substr(in_str,
                             length(in_str) - 5,
                             5)
                   || str_out;

        str_out := ' '
                   || substr(in_str,
                             length(in_str) - 10,
                             5)
                   || str_out;

        str_out := substr(in_str,
                          1,
                          length(in_str) - 11)
                   || str_out;

        return ( str_out );
    end;

  --------------------------------------------------------------------------------
  -- FUNCTION Format_NVE
  --
  -- 340274530000050083 -> 3 40 27453 000005008 3
  --------------------------------------------------------------------------------
    function format_nve (
        in_str in varchar2
    ) return varchar2 is
        str_out varchar2(256) := null;
    begin
        str_out := ' '
                   || substr(in_str,
                             length(in_str),
                             1);
        str_out := ' '
                   || substr(in_str,
                             length(in_str) - 9,
                             9)
                   || str_out;

        str_out := ' '
                   || substr(in_str,
                             length(in_str) - 14,
                             5)
                   || str_out;

        str_out := ' '
                   || substr(in_str,
                             length(in_str) - 16,
                             2)
                   || str_out;

        str_out := substr(in_str,
                          1,
                          length(in_str) - 17)
                   || str_out;

        return ( str_out );
    end;
  
  --------------------------------------------------------------------------------
  -- FUNCTION Modulo43_CheckDigit
  -- out CheckDigit
  -- 159AZ -> H 
  -- description modulo 43 see https://www.activebarcode.de/codes/checkdigit/modulo43.html
  --------------------------------------------------------------------------------
    function modulo43_checkdigit (
        in_text in varchar2
    ) return varchar2 as

        modulo43charset varchar2(100) := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%';
        mychar          varchar2(1);
        i               number;
        charpos         number;
        modulodigit     number;
    begin
        modulodigit := 0;
        for i in 0..length(in_text) - 1 loop
            mychar := ( substr(in_text, i + 1, 1) );
            charpos := instr(modulo43charset, mychar, 1) - 1;
            if charpos < 0 then
                raise_application_error(-20001, 'Input Text not Modulo43 Conform');
            end if;
            modulodigit := modulodigit + charpos;
        end loop;

        modulodigit := mod(modulodigit, 43);
        return ( substr(modulo43charset, modulodigit + 1, 1) );
    end modulo43_checkdigit;

  --------------------------------------------------------------------------------
  -- Iso_WeekDay 
  -- in date
  -- out number weekday 1=Mo; 2=Di; 3=Mi; ..... 
  --------------------------------------------------------------------------------

    function iso_weekday (
        in_date in date
    ) return number as
    begin
        return ( trunc(in_date) - trunc(in_date, 'IW') + 1 );
    end iso_weekday;

end isi_utils;
/


-- sqlcl_snapshot {"hash":"dae3cfd1d8e1ef20d4606a1d3b10d0d454333154","type":"PACKAGE_BODY","name":"ISI_UTILS","schemaName":"DIRKSPZM32","sxml":""}