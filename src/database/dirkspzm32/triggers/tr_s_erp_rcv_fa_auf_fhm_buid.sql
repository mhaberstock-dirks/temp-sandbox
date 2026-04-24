create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_fa_auf_fhm_buid before
    insert or update or delete on dirkspzm32.s_erp_rcv_fa_auf_fhm
    for each row
declare
    v_error exception;
    v_err_nr          number;
    v_err_text        varchar2(2550);
    v_fa_fhm          s_rcv_fa_auf_fhm%rowtype;
    v_fa_res_list     bde_fa_auftrag_res_liste%rowtype;
    v_fa_res_fhm      isi_res_fhm%rowtype;
    v_fa_res_fhm_list isi_res_fhm_list%rowtype;
    v_found           boolean;
    cursor c_fa_res_list is
    select
        *
    from
        bde_fa_auftrag_res_liste rl
    where
            rl.sid = '01'
        and rl.firma_nr = :new.firma_nr
        and rl.leitzahl = :new.leitzahl
        and rl.fa_ag = :new.fa_ag;

    cursor c_fa_res_fhm is
    select
        *
    from
        isi_res_fhm rf
    where
            rf.firma_nr = :new.firma_nr
        and rf.fhm = :new.prod_fhm;

    cursor c_fa_res_fhm_list is
    select
        *
    from
        isi_res_fhm_list rf
    where
            rf.res_id = v_fa_res_list.res_id
        and rf.fhm = :new.prod_fhm;

    cursor c_fa_fhm is
    select
        *
    from
        s_rcv_fa_auf_fhm t
    where
            t.sid = '01'
        and t.firma_nr = :new.firma_nr
        and t.leitzahl = :new.leitzahl
        and t.fa_ag = :new.fa_ag
        and t.fa_upos = :new.fa_upos
        and t.prod_fhm = :new.prod_fhm;

begin
    if inserting
    or updating then
        open c_fa_fhm;
        fetch c_fa_fhm into v_fa_fhm;
        v_found := c_fa_fhm%found;
        close c_fa_fhm;
        v_fa_fhm.fhm_grp := :new.fhm_grp;
        if
            nvl(:new.fhm_grp,
                0) = 0
            and not v_found
        then
            select
                nvl(
                    max(t.fhm_grp),
                    0
                ) + 1
            into v_fa_fhm.fhm_grp
            from
                bde_fa_auftrag_fhm t
            where
                    t.sid = '01'
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag
                and t.fa_upos = :new.fa_upos;

        end if;

        if not v_found then
            begin
                insert into s_rcv_fa_auf_fhm values ( '01',
                                                      :new.firma_nr,
                                                      :new.auf_id,
                                                      :new.auftrag,
                                                      :new.leitzahl,
                                                      :new.fa_ag,
                                                      :new.fa_upos,
                                                      :new.prod_fhm,
                                                      v_fa_fhm.fhm_grp,
                                                      1                      --Aktuell nicht in der Schnittstellentabelle, dann immer 1
                                                       );

            exception
                when dup_val_on_index then
                    null;
            end;
        else
            update s_rcv_fa_auf_fhm t
            set
                t.auf_id = :new.auf_id,
                t.auftrag = :new.auftrag,
                t.fhm_grp = nvl(
                    nvl(:new.fhm_grp,
                        t.fhm_grp),
                    v_fa_fhm.fhm_grp
                )
            where
                    t.sid = '01'
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag
                and t.fa_upos = :new.fa_upos
                and t.prod_fhm = :new.prod_fhm;

        end if;

        if :new.ruest_zeit > 0 then
            open c_fa_res_fhm;
            fetch c_fa_res_fhm into v_fa_res_fhm;
            v_found := c_fa_res_fhm%found;
            close c_fa_res_fhm;
            if not v_found then
                insert into isi_res_fhm values ( '01',
                                                 :new.firma_nr,
                                                 :new.prod_fhm,
                                                 'DYN_GEN_' || :new.prod_fhm,
                                                 null,
                                                 null,
                                                 null,
                                                 2,
                                                 100000,
                                                 100,
                                                 0,
                                                 0,
                                                 null,
                                                 nvl(:new.ruest_zeit,
                                                     0),
                                                 0,
                                                 'T',
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 null );

            end if;

            open c_fa_res_list;
            fetch c_fa_res_list into v_fa_res_list;
            loop
                exit when c_fa_res_list%notfound;
                open c_fa_res_fhm_list;
                fetch c_fa_res_fhm_list into v_fa_res_fhm_list;
                v_found := c_fa_res_fhm_list%found;
                close c_fa_res_fhm_list;
                if not v_found then
                    insert into isi_res_fhm_list values ( :new.prod_fhm,
                                                          v_fa_res_list.res_id,
                                                          to_date('01.01.2000', 'dd.mm.yyyy'),
                                                          to_date('01.01.2999 00:00:00', 'dd.mm.yyyy hh24:mi:ss'),
                                                          0,
                                                          100 );

                end if;

                fetch c_fa_res_list into v_fa_res_list;
            end loop;

            close c_fa_res_list;
        end if;

    end if;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt
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
end tr_s_erp_rcv_fa_auf_fhm_buid;
/

alter trigger dirkspzm32.tr_s_erp_rcv_fa_auf_fhm_buid enable;


-- sqlcl_snapshot {"hash":"f6ed0bc1533fde0b64c8a813a745e6f7497c2c4e","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}