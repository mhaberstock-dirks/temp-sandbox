create or replace editionable trigger dirkspzm32.tr_s_qs_babtec_auf_bu before
    update on dirkspzm32.bde_fa_auftrag
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
    v_res      isi_resource%rowtype;
    v_art      isi_artikel%rowtype;
    cursor c_res is
    select
        *
    from
        isi_resource t
    where
        t.res_id = :new.res_id;

    cursor c_art is
    select
        *
    from
        isi_artikel t
    where
        t.artikel_id = :new.ag_artikel_id;

begin
    if
        :new.freig_status = 'AP'
        and nvl(:old.freig_status,
                'NULL') != 'AP'
    then
        v_res := null;
        v_art := null;
        open c_res;
        fetch c_res into v_res;
        close c_res;
        open c_art;
        fetch c_art into v_art;
        close c_art;
        begin
            insert into s_qs_babtec_auf t values ( lpad(
                to_char(:new.leitzahl),
                7,
                '0'
            )
                                                   || '/'
                                                   || lpad(
                to_char(:new.fa_ag),
                3,
                '0'
            )
                                                   || '-'
                                                   || nvl(v_res.res_ext_name, 'Fehlt')
                                                   || '-'
                                                   || to_char(
                trunc(sysdate),
                'yyyy-mm-dd'
            ), -- AUFTRAGNR   VARCHAR2(30) not null,
                                                   nvl(v_art.artikel, 'Fehlt'),                     -- ARTIKEL     VARCHAR2(30),
                                                   lpad(
                                                       nvl(:new.kunden_nr,
                                                           '0'),
                                                       7,
                                                       '0'
                                                   )
                                                   || '-'
                                                   || lpad(
                                                       decode(
                                                           to_char(nvl(:new.kunden_nr_adr_liefer,
                                                                       '1')),
                                                           '1',
                                                           '0',
                                                           to_char(:new.kunden_nr_adr_liefer)
                                                       ),
                                                       6,
                                                       '0'
                                                   ),
                                                                 -- KUNDENNR    VARCHAR2(30),
                                                   :new.ag_soll_mg,                                 -- LIEFERMENGE NUMBER,
                                                   :new.best_nr_kunde,                              -- BESTELLNR   VARCHAR2(30),
                                                   :new.ab_text2,                                   -- BENUTZER1   VARCHAR2(60), Hier die Charge
                                                   v_res.res_ext_name );                             -- BENUTZER2   VARCHAR2(60)
        exception
            when others then
                null;
        end;

    end if;
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then
        raise_application_error(-20000 - v_err_nr, v_err_text);
        raise;
    when others then
        if v_err_nr is not null then
            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            raise;
        end if;
end tr_s_qs_babtec_auf_bu;
/

alter trigger dirkspzm32.tr_s_qs_babtec_auf_bu enable;


-- sqlcl_snapshot {"hash":"61338bcb995c5fe2639e53c3a407233c48f1bb92","type":"TRIGGER","name":"TR_S_QS_BABTEC_AUF_BU","schemaName":"DIRKSPZM32","sxml":""}