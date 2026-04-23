create or replace editionable trigger dirkspzm32.tr_pzm_personal_aiu after
    insert or update on dirkspzm32.pzm_personal
    for each row
declare
  -- local variables here
    v_found                  boolean;
    v_pers_nr                pzm_personal.pers_nr%type;
    v_uk_konto               pzm_konten%rowtype;
    v_konten_bh_id           pzm_konten_bh.konten_bh_id%type;
    v_schichtmodell          pzm_schicht_modelle%rowtype;
    v_schichtmodell_abt      pzm_schicht_modelle%rowtype;
    v_d_arb_std_pro_tag      pzm_schicht_modelle.d_arb_std_pro_tag%type;

  --v_jahresurlaub_diff number;
    v_urlaub_anspr_aa_id     pzm_personal.pers_urlaub_anspr_aa_id%type;
    v_jahresurlaub_diff      number;
    v_pers_urlaub_anspr_wert number(5, 2);
    v_date                   date;
    cursor c_pzm_konten_uk is
    select
        t.*
    from
        pzm_konten            t,
        pzm_abwesenheitsarten aa,
        pzm_lohnarten         lz
    where
            t.sid = '01'
        and t.firma_nr = 1
        and t.pers_nr = v_pers_nr
        and t.name_kurz = lz.lz_konto_name_kurz
        and lz.lz_id = aa.lz_id
        and aa.aa_id = v_urlaub_anspr_aa_id;

    cursor c_schichtmodell is
    select
        t.*
    from
        pzm_schicht_modelle t
    where
        t.sm_name = :new.pers_sm_name;

    cursor c_schichtmodell_abt is
    select
        t.*
    from
        pzm_abteilungen     a,
        pzm_schicht_modelle t
    where
            a.abt_id = :new.pers_abt_id
        and t.sm_name = a.abt_standard_sm_name;

begin
    v_pers_nr := :new.pers_nr;
    if inserting then
    -- Alle Kontotypen für neuen Mitarbeiter anlegen
        insert into pzm_konten
            select
                '01',
                1,
                v_pers_nr,
                seq_pzm_konto_nr.nextval,
                k.name,
                k.name_kurz,
                k.typ,
                k.buch_einheit,
                0, -- saldo
                null, -- letzte_buchung
                null, -- letzter_abschluss_am
                null, -- abschluss_saldo
                k.info,
                k.def_max_saldo,
                k.def_min_saldo,
                k.aktiv,
                0
            from
                pzm_konten_cfg k
            where
                    k.aktiv = 'T'
                and k.name_kurz not in (
                    select
                        la.lz_konto_name_kurz
                    from
                        pzm_lohnarten         la, pzm_abwesenheitsarten a
                    where
                            la.lz_konto_name_kurz = k.name_kurz
                        and a.lz_id = la.lz_id
                        and a.kennz_urlaub = 'T'
                        and a.aa_id != :new.pers_urlaub_anspr_aa_id
                );

        v_urlaub_anspr_aa_id := :new.pers_urlaub_anspr_aa_id;
        open c_pzm_konten_uk;
        fetch c_pzm_konten_uk into v_uk_konto;
        v_found := c_pzm_konten_uk%found;
        close c_pzm_konten_uk;
        begin
            if
                :new.pers_urlaub_anspr_wert is not null
                and v_found
            then
                v_date := :new.pers_eintrittsdatum;
                v_jahresurlaub_diff := to_number ( to_char(:new.pers_eintrittsdatum,
                                                           'MM') );
                if to_number ( to_char(:new.pers_eintrittsdatum,
                                       'DD') ) > 15 then
                    v_jahresurlaub_diff := v_jahresurlaub_diff + 1;
                elsif
                    to_number ( to_char(:new.pers_eintrittsdatum,
                                        'DD') ) <= 15
                    and to_number ( to_char(:new.pers_eintrittsdatum,
                                            'DD') ) > 1
                then
                    v_jahresurlaub_diff := v_jahresurlaub_diff + 0.5;
                end if;
        -- (30 / 12 * (12 - 7.5 + 1)  
                v_jahresurlaub_diff := round(:new.pers_urlaub_anspr_wert / 12 *(12 - v_jahresurlaub_diff) + 1,
                                             0);

                if upper(v_uk_konto.buch_einheit) = 'HH24' then
                    open c_schichtmodell;
                    fetch c_schichtmodell into v_schichtmodell;
                    v_found := c_schichtmodell%found;
                    close c_schichtmodell;
                    if
                        v_found
                        and nvl(
                            pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell.sm_name),
                            0
                        ) > 0
                    then
                        v_d_arb_std_pro_tag := pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell.sm_name);
                    else
                        open c_schichtmodell_abt;
                        fetch c_schichtmodell_abt into v_schichtmodell_abt;
                        v_found := c_schichtmodell_abt%found;
                        close c_schichtmodell_abt;
                        v_d_arb_std_pro_tag := pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell_abt.sm_name);
                    end if;

                    if not v_found then
                        v_d_arb_std_pro_tag := 8;
                    end if;
                    v_pers_urlaub_anspr_wert := v_jahresurlaub_diff * v_d_arb_std_pro_tag;
                else
                    v_pers_urlaub_anspr_wert := v_jahresurlaub_diff;
                end if;

                pzm_kontoverwaltung.zugang_buchen('01',
                                                  1,
                                                  v_uk_konto.konto_nr,
                                                  v_pers_nr,
                                                  :new.pers_kst_id,
                                                  v_pers_urlaub_anspr_wert,
                                                  'Anspruch Jahresurlaub (Personalstamm)',
                                                  'G',
                                                  :new.pers_abt_id,
                                                  v_konten_bh_id);

                update pzm_konten_bh t
                set
                    t.zk_start = :new.pers_eintrittsdatum,   --ToDo: BWe an HJG
                    t.zk_aa_id = null
                where
                        t.sid = '01'
                    and t.firma_nr = 1
                    and t.konten_bh_id = v_konten_bh_id;

            end if;
        exception
            when others then
                pzm_p_log.log_exception(
                    p_category => 'Personal',
                    p_module   => 'trigger tr_pzm_personal_aiu',
                    p_context  => 'Anspruch Jahresurlaub buchen',
                    p_pers_nr  => v_pers_nr
                );
        end;

    end if;

end;
/

alter trigger dirkspzm32.tr_pzm_personal_aiu enable;


-- sqlcl_snapshot {"hash":"be317b4bc1fb7e57b67d96b9a481a3e7b1e7378a","type":"TRIGGER","name":"TR_PZM_PERSONAL_AIU","schemaName":"DIRKSPZM32","sxml":""}