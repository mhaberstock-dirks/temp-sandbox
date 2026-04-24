create or replace function dirkspzm32.get_charge_next_id (
    in_sid            in isi_sid.sid%type,
    in_lieferanten_id in lvs_charge.lieferanten_id%type,
    in_charge         in lvs_charge.charge_bez%type,
    in_artikel_id     in isi_artikel.artikel_id%type,
    in_charge_id      in lvs_charge.charge_id%type
) return number is

    result      number;
    v_charge    lvs_charge%rowtype;
    v_n_charge  lvs_charge.charge_bez%type;      -- Neue Charge
    v_charge_id lvs_charge.charge_id%type;
    v_run       number;
    v_pos       number;
    v_found     boolean;
    cursor c_charge is
    select
        *
    from
        lvs_charge ch
    where
            ch.sid = in_sid
        and ch.charge_id = v_charge_id;

    cursor c_charge_bez is
    select
        *
    from
        lvs_charge ch
    where
            ch.sid = in_sid
        and ch.charge_bez = v_n_charge;

begin
    v_charge_id := in_charge_id;
    v_run := 0;
    result := in_charge_id;
    v_charge_id := in_charge_id;
  -- Erst prüfen ob für diese Chargenbezeichnung bereits eine Charge existiert
  -- falls nicht, dann wird diese angelegt
    open c_charge;
    fetch c_charge into v_charge;
    v_found := c_charge%found;
    close c_charge;
    loop
        v_run := v_run + 1;
        exit when v_run > 3;  -- Maximal 3 Versuche;
        begin
            if not v_found then
                v_n_charge := rtrim(
                    to_char(in_charge),
                    ' '
                )
                              || '-1';
                insert into lvs_charge values ( in_sid,
                                                v_charge_id,
                                                in_artikel_id,
                                                nvl(in_lieferanten_id, '0'),
                                                v_n_charge,
                                                sysdate,
                                                0,
                                                0 );

                v_n_charge := rtrim(
                    to_char(in_charge),
                    ' '
                )
                              || '-2';
            else
                v_pos := length(in_charge) + 2;
                v_n_charge := substr(v_charge.charge_bez, v_pos);
                v_n_charge := in_charge
                              || '-'
                              || to_char(to_number(nvl(v_n_charge, 0)) + 1);

            end if;

            select
                seq_charge.nextval
            into v_charge_id
            from
                dual;

            insert into lvs_charge values ( in_sid,
                                            v_charge_id,
                                            in_artikel_id,
                                            nvl(in_lieferanten_id, '0'),
                                            v_n_charge,
                                            sysdate,
                                            0,
                                            0 );

            result := v_charge_id;
            exit;
        exception
            when others then
                open c_charge_bez;
                fetch c_charge_bez into v_charge;
                v_found := c_charge_bez%found;
                close c_charge_bez;
                if v_found then
                    v_charge_id := v_charge.charge_id;
                else
                    v_run := 3; -- Damit Ende
                end if;

        end;

    end loop;

    return ( result );
end get_charge_next_id;
/


-- sqlcl_snapshot {"hash":"d833c72e5b8ae3ef844bfc766296c041cf3d44b1","type":"FUNCTION","name":"GET_CHARGE_NEXT_ID","schemaName":"DIRKSPZM32","sxml":""}