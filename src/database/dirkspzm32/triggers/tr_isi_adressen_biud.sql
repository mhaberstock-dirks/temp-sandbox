create or replace editionable trigger dirkspzm32.tr_isi_adressen_biud before
    insert or update or delete on dirkspzm32.isi_adressen
    for each row
declare
  -- local variables here
    v_error exception;                 --
    v_err_nr         number;
    v_err_text       varchar2(255);
    v_adress_id      isi_adressen.adress_id%type;
    v_lvs_prod_linie lvs_prod_linie%rowtype;
    v_owner_id       lvs_lam.owner_address_id%type;
    cursor c_lvs_prod_linie is
    select
        *
    from
        lvs_prod_linie t
    where
        t.adress_id = v_adress_id
    for update of linie_aktiv;

    cursor c_lam is
    select
        l.owner_address_id
    from
        lvs_lam l
    where
        l.owner_address_id = :old.adress_id;

begin
    if inserting then
        if :new.adress_id is null then
            select
                seq_adressen_id.nextval
            into :new.adress_id
            from
                dual;

        end if;

        if
            :new.adr_art = 'L'
            and :new.ext_etiketten_druck = 'T'
        then
      -- bei fregeschlatetem Etikettendruck für externe Lieferanten
      -- Linie für den jew. Lieferanten freischalten
            lvs_prod.lieferant_linie_erzeugen(:new.sid,
                                              :new.firma_nr,
                                              :new.adr_art
                                              || to_char(:new.adr_nr),
                                              :new.adress_id);

        end if;

    elsif updating then
        if :new.adr_art = 'L' then
      -- Liniendaten für Lieferanten pflegen
      -- (derzeit gibt es nur 1 Linie für einen Lieferanten)
            v_adress_id := :new.adress_id;
            open c_lvs_prod_linie;
            fetch c_lvs_prod_linie into v_lvs_prod_linie;
            if c_lvs_prod_linie%notfound then
                if :new.ext_etiketten_druck = 'T' then
                    lvs_prod.lieferant_linie_erzeugen(:new.sid,
                                                      :new.firma_nr,
                                                      :new.adr_art
                                                      || to_char(:new.adr_nr),
                                                      :new.adress_id);

                end if;
            else
                if :new.ext_etiketten_druck = 'F' then
          -- Linie sperren
                    update lvs_prod_linie
                    set
                        linie_aktiv = 0
                    where
                        current of c_lvs_prod_linie;

                elsif
                    :new.ext_etiketten_druck = 'T'
                    and v_lvs_prod_linie.linie_aktiv = 0
                then
          -- Linie freischalten
                    update lvs_prod_linie
                    set
                        linie_aktiv = 1
                    where
                        current of c_lvs_prod_linie;

                end if;
            end if;

            close c_lvs_prod_linie;
        end if;
    elsif deleting then
        open c_lam;
        fetch c_lam into v_owner_id;
        if c_lam%found then
            close c_lam;
            v_err_nr := 10;
            v_err_text := 'Fehler: Adresse kann nicht gelöscht werden, da diese in der Bestandsführung ist.';
            raise v_error;
        end if;

        close c_lam;
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
end tr_isi_adressen_biud;
/

alter trigger dirkspzm32.tr_isi_adressen_biud enable;


-- sqlcl_snapshot {"hash":"632a2b9de4aade107845b6c9b1217af0b250fa31","type":"TRIGGER","name":"TR_ISI_ADRESSEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}