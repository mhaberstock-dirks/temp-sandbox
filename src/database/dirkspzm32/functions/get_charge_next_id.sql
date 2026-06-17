create or replace 
function DIRKSPZM32.get_charge_next_id(in_sid in isi_sid.sid%type,
                                              in_lieferanten_id    in lvs_charge.lieferanten_id%type,
                                              in_charge            in lvs_charge.charge_bez%type,
                                              in_artikel_id        in isi_artikel.artikel_id%type,
                                              in_charge_id         in lvs_charge.charge_id%type)
                                              return number is
  Result number;

  v_charge     lvs_charge%rowtype;
  v_n_charge   lvs_charge.charge_bez%type;      -- Neue Charge
  v_charge_id  lvs_charge.charge_id%type;
  v_run        number;

  v_pos        number;
  v_found      boolean;

  CURSOR c_charge IS
    SELECT *
      FROM lvs_charge ch
      WHERE ch.sid = in_sid AND
            ch.charge_id = v_charge_id;

  CURSOR c_charge_bez IS
    SELECT *
      FROM lvs_charge ch
     WHERE ch.sid = in_sid
       AND ch.charge_bez = v_n_charge;

begin
  v_charge_id := in_charge_id;
  v_run := 0;
  result := in_charge_id;
  v_charge_id := in_charge_id;
  -- Erst prüfen ob für diese Chargenbezeichnung bereits eine Charge existiert
  -- falls nicht, dann wird diese angelegt
  OPEN c_charge;
  FETCH c_charge into v_charge;
  v_found := c_charge%FOUND;
  CLOSE c_charge;

  LOOP
    v_run := v_run + 1;
    exit when v_run > 3;  -- Maximal 3 Versuche;
    begin

      if not v_found then
         v_n_charge := rtrim(to_char(in_charge), ' ') ||  '-1';
         insert into lvs_charge
                values (in_sid,
                        v_charge_id,
                        in_artikel_id,
                        nvl(in_lieferanten_id, '0'),
                        v_n_charge,
                        sysdate,
                        0,
                        0);
         v_n_charge := rtrim(to_char(in_charge), ' ') ||  '-2';
      else
        v_pos := length(in_charge) + 2;
        v_n_charge := substr(v_charge.charge_bez, v_pos);
        v_n_charge := in_charge || '-' || to_char(to_number(nvl(v_n_charge, 0)) + 1);
      end if;

      select seq_charge.nextval into v_charge_id from dual;
      insert into lvs_charge
          values (in_sid,
                  v_charge_id,
                  in_artikel_id,
                  nvl(in_lieferanten_id, '0'),
                  v_n_charge,
                  sysdate,
                  0,
                  0);
      result := v_charge_id;
      exit;
    exception
      when others then
        OPEN c_charge_bez;
        FETCH c_charge_bez into v_charge;
        v_found := c_charge_bez%FOUND;
        CLOSE c_charge_bez;
        if v_found then
          v_charge_id := v_charge.charge_id;
        else
          v_run := 3; -- Damit Ende
        end if;
    end;
  end LOOP;
  return(Result);
end get_charge_next_id;
/



-- sqlcl_snapshot {"hash":"f0190a636fc1b276036647b7724d51b4b16f4c2f","type":"FUNCTION","name":"GET_CHARGE_NEXT_ID","schemaName":"DIRKSPZM32","sxml":""}