create or replace package body dirkspzm32.lvs_prod is

  -------------------------------------------------------------------------
    function str_mb_format (
        in_str_a      in varchar2,
        in_trenner    in char,
        in_formatchar in char,
        in_laenge     in number
    ) return varchar2 is
    -------------------------------------------------------------------------
    -- 1;2;4;3;  --> 001;002;004;
        v_elem      varchar2(255);
        v_return    varchar2(255);
        v_start_pos number;
        v_ende_pos  number;
    begin
        v_return := '';
        v_start_pos := 1;
        v_ende_pos := 1;
        while ( v_ende_pos > 0 ) loop
            v_ende_pos := instr(in_str_a, in_trenner, v_start_pos, 1);
            if ( v_ende_pos > 0 ) then
                v_elem := substr(in_str_a, v_start_pos, v_ende_pos - v_start_pos + 1);
                while ( length(v_elem) < in_laenge ) loop
                    v_elem := in_formatchar || v_elem;
                end loop;

                v_return := v_return || v_elem;
            end if;

            v_start_pos := v_ende_pos + 1;
        end loop;

        return ( v_return );
    end str_mb_format;

  -------------------------------------------------------------------------
    function str_mb_ix (
        in_str_a    in varchar2,
        in_laenge   in number,
        in_position in number
    ) return varchar2 is
    -------------------------------------------------------------------------
    -- 01;03;02; laenge = 3 Position = 2 --> Return(03;)
        v_start_pos number;
    begin
        v_start_pos := ( in_position - 1 ) * in_laenge + 1;
        return ( substr(in_str_a, v_start_pos, in_laenge) );
    end;
  -------------------------------------------------------------------------
    function str_mb_count (
        in_str_a  in varchar2,
        in_laenge in number
    ) return number is
    -------------------------------------------------------------------------
    -- 01;03;02; laenge = 3 --> Return(3) Anzahl an Elementen
        v_str_laenge number;
    begin
        v_str_laenge := length(in_str_a);
        return ( v_str_laenge / in_laenge );
    end;

  -------------------------------------------------------------------------
    function str_mb_get_param (
        in_str_a      in varchar2,
        in_start_char in char
    ) return varchar2 is
    -------------------------------------------------------------------------
    -- in_str_a = PL_123 [02;01;] return 02;01;
        v_start_pos number;
        v_ende_pos  number;
        v_result    varchar2(255);
    begin
        v_start_pos := instr(in_str_a, in_start_char, 1, 1);
        if ( v_start_pos < 0 ) then
            v_start_pos := 0;
        end if;
        v_ende_pos := instr(in_str_a, in_start_char, 1, 1);
        if ( v_ende_pos < 0 ) then
            v_ende_pos := 0;
        end if;
        v_result := substr(in_str_a, v_start_pos + 1, v_ende_pos - v_start_pos);
        return ( v_result );
    end str_mb_get_param;

  -------------------------------------------------------------------------
    function str_mb_log_und (
        in_str_a  in varchar2,
        in_str_b  in varchar2,
        in_laenge in number
    ) return varchar2 is
    -------------------------------------------------------------------------
    -- in_str_a = 02;01; in_str_b= 03;01; return  = 01;

        v_count_a number;
        v_elem_a  varchar2(255);
        v_count   number;
        v_result  varchar2(255);
        v_found_b varchar2(255);
    begin
        v_result := '';
        v_count_a := str_mb_count(in_str_a, in_laenge);
        for v_count in 1..v_count_a loop
            v_elem_a := str_mb_ix(in_str_a, in_laenge, v_count);
            v_found_b := instr(in_str_b, v_elem_a, 1, 1);
            if ( v_found_b > 0 ) then
                v_result := v_result || v_elem_a;
            end if;
        end loop;

        return ( v_result );
    end str_mb_log_und;

    procedure lieferant_linie_erzeugen (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_linie_name in lvs_prod_linie.linie_name%type,
        in_adress_id  in isi_adressen.adress_id%type
    ) is
    begin
        insert into lvs_prod_linie values ( in_sid,
                                            in_firma_nr,
                                            null,                        -- LINIE_NR; wird aus sequence gesetzt
                                            in_linie_name,               -- LINIE_NAME
                                            1,                           -- LINIE_AKTIV; Aktiv = 1
                                            null,                        -- LINIE_PRODUKTIONSDATUM
                                            null,                        -- LINIE_LAGERORT
                                            'Euro',                      -- LTE_NAME; erstmal keine Palettenvorgabe
                                            null,                        -- LTE_VOL_HOEHE
                                            null,                        -- LTE_VOL_BREITE
                                            null,                        -- LTE_VOL_TIEFE
                                            null,                        -- RES_ID
                                            null,                        -- RES_STRING
                                            in_adress_id,                -- ADRESS_ID
                                            'SD',                        -- der lieferant möchte ja Etiketten drucken ...
                                            null,                        -- Noch kein packschema
                                            null,                    -- Auto Depal ist unbekannt
                                            null,                    -- wickelprogramm ist unbekannt,
                                            null,                    -- wickelprogramm_einl ist unbekannt
                                            null );

    end;

end lvs_prod;
/


-- sqlcl_snapshot {"hash":"e0cee800091903d8d4835e35b6c9d1f90bd3a909","type":"PACKAGE_BODY","name":"LVS_PROD","schemaName":"DIRKSPZM32","sxml":""}