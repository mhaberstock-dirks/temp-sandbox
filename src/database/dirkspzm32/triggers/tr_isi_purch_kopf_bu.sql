create or replace editionable trigger dirkspzm32.tr_isi_purch_kopf_bu before
    update on dirkspzm32.isi_purch_kopf
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_id       isi_purch_kopf.id%type;
    v_kunden   isi_adressen%rowtype;
    v_found    boolean;
    cursor c_kunden is
    select
        *
    from
        isi_adressen t
    where
        t.adress_id = :new.kunde_id;

begin
    if updating then
     --if :new.vorg_typ ='BE' or v_header.vorg_typ ='AN' then
        -- nichts zu tun
     --end if;
        if :new.vorg_typ = 'AUFTR' then
            open c_kunden;
            fetch c_kunden into v_kunden;
            v_found := c_kunden%found;
            close c_kunden;
            if v_found = false then
                v_err_nr := 20;
                v_err_text := lc.ec_p1(lc.o_tp1_txt_adresse_nf,
                                       to_char(:new.kunde_id));

            end if;

            if :old.status != 'E' then
                :new.aend_datum := sysdate;
            end if;

            if :new.status = 'F' then
                return;
            end if;
            if ( :new.liefer_datum <> :old.liefer_datum )
            or ( :new.lieferschein_nr <> :old.lieferschein_nr )
            or ( :new.kunde_id <> :old.kunde_id ) then
                update s_rcv_kunden_auftr_pos a
                set
                    a.liefer_datum = :new.liefer_datum,
                    a.fertig_datum = :new.liefer_datum,
                    a.adr_nr = v_kunden.adr_nr,
                    a.adr_liefer = v_kunden.adr_liefer,
                    a.li_nr = :new.lieferschein_nr
                where
                    a.auftrag = :new.id;

            end if;

        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_purch_kopf_bu enable;


-- sqlcl_snapshot {"hash":"465365ec5e31905b72c437aa03b9405014369672","type":"TRIGGER","name":"TR_ISI_PURCH_KOPF_BU","schemaName":"DIRKSPZM32","sxml":""}