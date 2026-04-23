create or replace editionable trigger dirkspzm32.tr_isi_resource_bi before
    insert on dirkspzm32.isi_resource
    for each row
declare
  -- local variables here
    v_res_zust_akt isi_resource_zust_akt%rowtype;
    cursor c_res_zust_akt is
    select
        t.*
    from
        isi_resource_zust_akt t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.res_id = :new.res_id;

    v_res_variante isi_resource_var%rowtype;
    cursor c_res_variante is
    select
        t.*
    from
        isi_resource_var t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.res_id = :new.res_id
        and t.variante = :new.variante;

begin
    if inserting then
        if :new.sid is null then
            select
                sid
            into :new.sid
            from
                isi_sid s
            where
                s.sid_my_sid = 1;

        end if;

        if :new.variante is null then
            :new.variante := 1;
        end if;

        if :new.res_id is null then
            select
                seq_res_id.nextval
            into :new.res_id
            from
                dual;

        end if;

        open c_res_zust_akt;
        fetch c_res_zust_akt into v_res_zust_akt;
        if c_res_zust_akt%notfound then
            insert into isi_resource_zust_akt values ( :new.sid,
                                                       :new.res_id,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       0,
                                                       sysdate,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       :new.firma_nr,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       null,
                                                       'F',
                                                       null,
                                                       null,
                                                       null );

        end if;

        close c_res_zust_akt;
        open c_res_variante;
        fetch c_res_variante into v_res_variante;
        if c_res_variante%notfound then
      -- variante nur hinzufügen, wenn sie nicht vorhanden ist
            insert into isi_resource_var values ( :new.sid,
                                                  :new.res_id,
                                                  :new.variante, -- variante
                                                  'aktive', -- status
                                                  sysdate, -- datum_von
                                                  to_date('31.12.9999', 'dd.mm.yyyy'), -- datum_bis
                                                  :new.firma_nr,
                                                  null, -- lgr_platz number
                                                  0, -- zyk_prod_res
                                                  0, -- zyk_prod_ges
                                                  0, -- std_prod_res
                                                  0, -- std_prod_ges
                                                  null, --zyklus_typ
                                                  sysdate, -- im_bestand_seit
                                                  null, -- letzte_wartg_am
                                                  null, -- letzte_wartg_zykl_ges
                                                  null, -- artkel_id
                                                  'F', -- res_container (kein Container)
                                                  null, -- menge_in_container (unbenutzt)
                                                  null ); -- inspektion_info
        end if;

        close c_res_variante;
    end if; -- inserting
end tr_bde_resource_bi;
/

alter trigger dirkspzm32.tr_isi_resource_bi enable;


-- sqlcl_snapshot {"hash":"10f13d6c76c870fc15e86b678e5adad5b5243294","type":"TRIGGER","name":"TR_ISI_RESOURCE_BI","schemaName":"DIRKSPZM32","sxml":""}