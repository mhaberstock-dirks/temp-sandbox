create or replace editionable trigger dirkspzm32.tr_isi_purch_pos_biud before
    insert or update or delete on dirkspzm32.isi_purch_pos
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(255);
    v_artikel      isi_artikel.artikel%type;
    v_kopf_id      number;
    v_found        boolean;
    v_header       isi_purch_kopf%rowtype;
    v_kunden_nr    isi_adressen.adr_nr%type;
    v_liefer_datum date;
    v_kunden       isi_adressen%rowtype;
    cursor c_isi_purch_kopf is
    select
        *
    from
        isi_purch_kopf s
    where
        s.id = v_kopf_id;

    cursor c_kunden is
    select
        *
    from
        isi_adressen t
    where
        t.adress_id = v_header.kunde_id;

begin
    if inserting then
        if :new.id is null then
            select
                seq_isi_purch_pos.nextval
            into :new.id
            from
                dual;

        end if;

        if :new.erz_datum is null then
            :new.erz_datum := sysdate;
        end if;

        v_kopf_id := :new.kopf_id;
        open c_isi_purch_kopf;
        fetch c_isi_purch_kopf into v_header;
        v_found := c_isi_purch_kopf%found;
        close c_isi_purch_kopf;
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                   to_char(:new.artikel_id));

        end if;

        v_liefer_datum := v_header.liefer_datum;
        if v_liefer_datum is null then
            v_liefer_datum := trunc(sysdate);
        end if;
        if not isi_p_base.get_isi_artikel_nr_by_id(:new.sid,
                                                   :new.artikel_id,
                                                   v_artikel) then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                   to_char(:new.artikel_id));

        end if;

        if v_header.vorg_typ = 'BE'
        or v_header.vorg_typ = 'AN' then
            insert into s_rcv_auftr values ( :new.firma_nr,       -- FIRMA_NR
                                             :new.id,             -- AUF_ID
                                             :new.kopf_id,        -- VORGANG_ID
                                             'BE',                -- VORGANG,
                                             :new.kopf_id,        -- AUFTRAG
                                             :new.pos,            -- POS_NR
                                             0,                   -- UPOS_NR
                                             v_artikel,          -- ARTIKEL,
                                             'L',                 -- ADR_ART,
                                             :new.lieferant_nr,   -- ADR_NR,
                                             0,                   -- ADR_LIEFER,
                                             null,                -- LEITZAHL,
                                             null,                -- Charge
                                             null,                -- SERIENNR,
                                             'FIFO',              -- Strategie
                                             sysdate,             -- MHD
                                             :new.kopf_id,        -- LI_NR,
                                             :new.pos,            -- li_pos_nr,
                                             null,                -- arbeitsplatz_id
                                             null,                -- KOM_INFO,
                                             :new.menge,          -- SOLL_MENGE,
                                             0,                   -- IST_MENGE,
                                             'N',                 -- STATUS,
                                             'SPED',              -- WA_ZIEL
                                             sysdate,             -- GEN_DATUM,
                                             null,                -- LVS_INFO,
                                             3,                   -- PRIORITAET),
                                             null,                -- BEST_NR_KUNDE,
                                             null,                -- FA_AG
                                             null,                -- ZIEL
                                             null,                -- ANBRUCH
                                             null,                -- LIEFER_DATUM
                                             'WAWI',              -- BESTELLER
                                             null,       -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                             null,       -- Tour
                                             null        --  UEBER_UNTER_LIEFERN  N VARCHAR2(4) Y
                                              );

        end if;

        if v_header.vorg_typ = 'AUFTR' then
            open c_kunden;
            fetch c_kunden into v_kunden;
            v_found := c_kunden%found;
            close c_kunden;
            if not v_found then
                v_err_nr := 20;
                v_err_text := lc.ec_p1(lc.o_tp1_txt_adresse_nf,
                                       to_char(v_header.kunde_id));

            end if;

            insert into s_rcv_kunden_auftr_pos values ( :new.sid,                    -- SID
                                                        :new.firma_nr,               -- FIRMA_NR
                                                        :new.id,                     -- KUNDEN_AUFTR_POS_ID
                                                        'N',                         -- STATUS
                                                        :new.kopf_id,                -- AUFTRAG
                                                        :new.pos,                    -- POS_NR
                                                        0,                           -- UPOS_NR
                                                        'K',                         -- ADR_ART,
                                                        v_kunden.adr_nr,             -- ADR_NR,
                                                        v_kunden.adr_liefer,         -- ADR_LIEFER,
                                                        null,                        -- LOGIN_ID,
                                                        null,                        -- arbeitsplatz_id
                                                        v_artikel,                  -- ARTIKEL,
                                                        null,                        -- FA_NR,
                                                        null,                        -- FA_AG
                                                        null,                        -- FA_UPOS
                                                        null,                        -- Charge
                                                        null,                        -- SERIENNR,
                                                        'FIFO',                      -- Strategie
                                                        null,                        -- Keine Vorgabe MHD
                                                        null,                        -- KOM_INFO,
                                                        :new.menge,                  -- SOLL_MENGE,
                                                        null,                        -- MENGENEINHEIT,
                                                        'SPED',                      -- WAE_ZIEL,
                                                        'WAWI',                      -- BESTELLER ,
                                                        null,                        -- FREIGABE,
                                                        v_header.erz_datum,          -- FREIGABE_DATUM,
                                                        sysdate,                     -- FREIGEGEBEN_DATUM,
                                                        sysdate,                     -- ORDER_DATUM
                                                        v_liefer_datum,              -- LIEFER_DATUM
                                                        v_header.liefer_datum,       -- FERTIG_DATUM
                                                        3,                           -- PRIORITÄT
                                                        c.r_c_anbruch_ausnahme(),    -- ANBRUCH
                                                        0,                           -- MIN_MHD_TAGE
                                                        0,                           -- MKIN_REIFEZEIT,
                                                        v_header.kunden_auftrags_nr, -- BEST_NR_KUNDE
                                                        null,                        -- ZEICHNUNGG_INDEX
                                                        v_header.lieferschein_nr,    -- LI_NR
                                                        :new.pos,                   -- LI_POS_NR
                                                        null,       -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,       -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,      -- LAM_SEL10 N  VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                        null,      -- PROD_PARAM
                                                        null );     -- ZIEL
        end if;

    end if;

    if deleting then
        update s_rcv_auftr a
        set
            a.status = 'L'
        where
            a.auf_id = :old.id;

        update s_rcv_kunden_auftr_pos kap
        set
            kap.status = 'D'
        where
            kap.kunden_auftr_pos_id = :old.id;

    end if;

    if updating then
        if
            :new.wek_ok = 'T'
            and ( ( :old.wek_ok is null )
            or ( :old.wek_ok = 'F' ) )
        then
      -- Wenn die Wareneingangskontrolle erfolgt ist,
      -- muss auch das aktuelle Datum gesetzt werden
            :new.wek_datum := sysdate;
        end if;

        v_kopf_id := :new.kopf_id;
        open c_isi_purch_kopf;
        fetch c_isi_purch_kopf into v_header;
    -- warum zuweisen, wenn anschliessend nicht abfragen: v_found := c_isi_purch_kopf%FOUND;
        close c_isi_purch_kopf;
        v_found := isi_p_base.get_adress_nr_by_id(v_header.sid, v_header.kunde_id, v_kunden_nr);
        if not v_found then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_txt_adresse_nf,
                                   to_char(v_header.kunde_id));

        end if;

        v_liefer_datum := v_header.liefer_datum;
        if v_liefer_datum is null then
            v_liefer_datum := trunc(sysdate);
        end if;
        if v_header.vorg_typ = 'BE'
        or v_header.vorg_typ = 'AN' then
            update s_rcv_auftr a
            set
                a.pos_nr = :new.pos,
                a.soll_mg = :new.menge,
                a.liefer_datum = v_liefer_datum
            where
                a.auf_id = :new.id;

        end if;

        if
            v_header.vorg_typ = 'AUFTR'
            and v_header.status = 'N'
        then
            update s_rcv_kunden_auftr_pos a
            set
                a.pos_nr = :new.pos,
                a.soll_menge = :new.menge,
                a.liefer_datum = v_liefer_datum
            where
                a.kunden_auftr_pos_id = :new.id;

        end if;

    end if;

exception
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
end;
/

alter trigger dirkspzm32.tr_isi_purch_pos_biud enable;


-- sqlcl_snapshot {"hash":"13adea132ac87b633fddeea0f838809c428f78e1","type":"TRIGGER","name":"TR_ISI_PURCH_POS_BIUD","schemaName":"DIRKSPZM32","sxml":""}