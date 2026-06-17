create or replace 
function DIRKSPZM32.get_charge_id(p_sid in isi_sid.sid%type,
                                         p_firma             in isi_firma.firma_nr%type,
                                         p_lieferanten_id    in lvs_charge.lieferanten_id%type,
                                         p_charge            in lvs_charge.charge_bez%type,
                                         p_artikel_id        in isi_artikel.artikel_id%type)
                                         return number is
  Result number;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);


  v_charge lvs_charge%rowtype;
  v_art    isi_artikel%rowtype;

  v_charge_bez lvs_charge.charge_bez%type;

  v_found  boolean;

  v_min_l  number;
  v_max_l  number;

  CURSOR c_charge IS
  SELECT *
    FROM lvs_charge ch
    WHERE ch.sid = p_sid
      AND nvl(ch.lieferanten_id, '0') = nvl(p_lieferanten_id, '0')
      and ch.charge_bez = v_charge_bez
      and nvl(ch.artikel_id, -1) = nvl(p_artikel_id, -1);

  CURSOR c_charge_ohne_art IS
  SELECT *
    FROM lvs_charge ch
    WHERE ch.sid = p_sid
      AND nvl(ch.lieferanten_id, '0') = nvl(p_lieferanten_id, '0')
      and ch.charge_bez = v_charge_bez;

  CURSOR c_art IS
  SELECT *
    FROM isi_artikel art
    WHERE art.sid = p_sid
      AND nvl(art.artikel_id, -1) = nvl(v_charge.artikel_id, -1);

begin
  -- Erst prüfen ob für diese Chargenbezeichnung bereits eine Charge existiert
  -- falls nicht, dann wird diese angelegt
  v_charge_bez := get_charge_bez_check(p_sid, p_firma, p_charge);
  OPEN c_charge;
  FETCH c_charge into v_charge;
  v_found := c_charge%FOUND;
  CLOSE c_charge;

  if not v_found then -- Neue Charge
    OPEN c_charge_ohne_art;
    FETCH c_charge_ohne_art into v_charge;
    v_found := c_charge_ohne_art%FOUND;
    CLOSE c_charge_ohne_art;

    if v_found then -- Charge für anderen Artikel
    -- Wenn die Cahrge nicht nur Artikelrein sein darf, dann Fehler
      if isi_allg.get_firma_cfg_param(p_sid,
                                      p_firma,
                                      'LVS',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      NULL,                   -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'LVS_CHARGE_ART_REIN',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'LVS',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                  -- in_typ                   in isi_firma_cfg.typ%type,
                                      c.C_FALSE,              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') = c.C_TRUE   -- in_default_param_typ
      then
        if v_charge.artikel_id != p_artikel_id then
          OPEN c_art;
          FETCH c_art into v_art;
          CLOSE c_art;
          v_err_nr := 20;
          v_err_text := LC.ec_p2(LC.O_TP2_CHARGE_IST_ZUGEORDNED, v_charge_bez, nvl(' ' || v_art.artikel, ' ID = ' || v_charge.artikel_id));
          -- v_err_text := 'Fehler: Charge ' || v_charge_bez || ' ist' || nvl(' Artikel ' || v_art.artikel, ' ID = ' || v_charge.artikel_id) || ' zugeordnet!';
          raise v_error;
        end if;
      else
        select seq_charge.nextval into v_charge.charge_id from dual;
        insert into lvs_charge
               values (p_sid,
                       v_charge.charge_id,
                       p_artikel_id,
                       nvl(p_lieferanten_id, '0'),
                       v_charge_bez,
                       sysdate,
                       0,
                       0);
      end if;
    else
      select seq_charge.nextval into v_charge.charge_id from dual;
      insert into lvs_charge
             values (p_sid,
                     v_charge.charge_id,
                     p_artikel_id,
                     nvl(p_lieferanten_id, '0'),
                     v_charge_bez,
                     sysdate,
                     0,
                     0);
    end if;
  end if;
  result := v_charge.charge_id;
  return(Result);
exception
  -- Im Fehlerfall ist der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end get_charge_id;
/



-- sqlcl_snapshot {"hash":"38392d9db10419e8ac979d144e40f2b83d920068","type":"FUNCTION","name":"GET_CHARGE_ID","schemaName":"DIRKSPZM32","sxml":""}