create or replace 
package body DIRKSPZM32.LVS_PROD is


  -------------------------------------------------------------------------
  Function STR_MB_FORMAT(in_str_a      in varchar2,
                         in_trenner    in char,
                         in_formatchar in char,
                         in_laenge     in number)
                         return varchar2 is
    -------------------------------------------------------------------------
    -- 1;2;4;3;  --> 001;002;004;
    v_elem      varchar2(255);
    v_return    varchar2(255);
    v_start_pos number;
    v_ende_pos  number;
  BEGIN
    v_return    := '';
    v_start_pos := 1;
    v_ende_pos  := 1;
    while (v_ende_pos > 0) loop
      v_ende_pos := INSTR(in_str_a, in_trenner, v_start_pos, 1);
      if (v_ende_pos > 0) then
        v_elem := substr(in_Str_a,
                         v_start_pos,
                         v_ende_pos - v_start_pos + 1);
        while (length(v_elem) < in_laenge) loop
          v_elem := in_formatchar || v_elem;
        end loop;
        v_return := v_return || v_elem;
      end if;
      v_start_pos := v_Ende_pos + 1;
    end loop;
    return(v_return);
  END STR_MB_FORMAT;

  -------------------------------------------------------------------------
  Function STR_MB_IX(in_str_a    in varchar2,
                     in_laenge   in number,
                     in_position in number)
                     return varchar2 is
    -------------------------------------------------------------------------
    -- 01;03;02; laenge = 3 Position = 2 --> Return(03;)
    v_start_pos number;
  BEGIN
    v_start_pos := (in_position - 1) * in_laenge + 1;
    return(substr(in_str_a, v_start_pos, in_laenge));
  END;
  -------------------------------------------------------------------------
  Function STR_MB_COUNT(in_str_a in varchar2,
                        in_laenge in number)
                        return number is
    -------------------------------------------------------------------------
    -- 01;03;02; laenge = 3 --> Return(3) Anzahl an Elementen
    v_str_laenge number;
  BEGIN
    v_str_laenge := length(in_str_a);
    return(v_str_laenge / in_laenge);
  END;

  -------------------------------------------------------------------------
  Function STR_MB_GET_PARAM(in_str_a in varchar2,
                            in_start_char in char)
                            return varchar2 is
    -------------------------------------------------------------------------
    -- in_str_a = PL_123 [02;01;] return 02;01;
    v_start_pos number;
    v_ende_pos  number;
    v_result    varchar2(255);
  BEGIN
    v_start_pos := INSTR(in_str_a, in_start_char, 1, 1);
    if (v_start_pos < 0) then
      v_start_pos := 0;
    end if;
    v_ende_pos := INSTR(in_str_a, in_start_char, 1, 1);
    if (v_ende_pos < 0) then
      v_ende_pos := 0;
    end if;
    v_result := substr(in_str_a, v_start_pos + 1, v_ende_pos - v_start_pos);
    return(v_result);
  END STR_MB_GET_PARAM;

  -------------------------------------------------------------------------
  Function STR_MB_LOG_UND(in_str_a  in varchar2,
                          in_str_b  in varchar2,
                          in_laenge in number) return varchar2 is
    -------------------------------------------------------------------------
    -- in_str_a = 02;01; in_str_b= 03;01; return  = 01;

    v_count_a number;
    v_elem_a  varchar2(255);
    v_count   number;
    v_result  varchar2(255);
    v_found_b varchar2(255);
  BEGIN
    v_result  := '';
    v_count_a := STR_MB_COUNT(in_str_a, in_laenge);
    for v_count in 1 .. v_count_a LOOP
      v_elem_a  := STR_MB_IX(in_str_a, in_laenge, v_count);
      v_found_b := INSTR(in_str_b, v_elem_a, 1, 1);
      if (v_found_b > 0) Then
        v_result := v_result || v_elem_a;
      END IF;
    END loop;
    return(v_result);
  END STR_MB_LOG_UND;

  procedure LIEFERANT_LINIE_ERZEUGEN(in_sid in isi_sid.sid%TYPE,
                                     in_firma_nr in isi_firma.firma_nr%TYPE,
                                     in_linie_name in lvs_prod_linie.linie_name%TYPE,
                                     in_adress_id in isi_adressen.adress_id%TYPE) is
  begin
    INSERT INTO lvs_prod_linie
       VALUES ( in_sid,
                in_firma_nr,
                NULL,                        -- LINIE_NR; wird aus sequence gesetzt
                in_linie_name,               -- LINIE_NAME
                1,                           -- LINIE_AKTIV; Aktiv = 1
                NULL,                        -- LINIE_PRODUKTIONSDATUM
                NULL,                        -- LINIE_LAGERORT
                'Euro',                      -- LTE_NAME; erstmal keine Palettenvorgabe
                NULL,                        -- LTE_VOL_HOEHE
                NULL,                        -- LTE_VOL_BREITE
                NULL,                        -- LTE_VOL_TIEFE
                NULL,                        -- RES_ID
                NULL,                        -- RES_STRING
                in_adress_id,                -- ADRESS_ID
                'SD',                        -- der lieferant möchte ja Etiketten drucken ...
                Null,                        -- Noch kein packschema
                null,                    -- Auto Depal ist unbekannt
                null,                    -- wickelprogramm ist unbekannt,
                null,                    -- wickelprogramm_einl ist unbekannt
                null);                   
  end;

end LVS_PROD;
/



-- sqlcl_snapshot {"hash":"b065a8acde43a838b13722a726a924fe5fce7cc3","type":"PACKAGE_BODY","name":"LVS_PROD","schemaName":"DIRKSPZM32","sxml":""}