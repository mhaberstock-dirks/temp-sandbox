create or replace package body dirkspzm32.z_euscher_druck is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  23.04.2004 14:53:34
  __________________________________________________
  Description
  Project Euscher Print Routinen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        Author    Comment
  -----------  ---------   ------   ---------------
  22.11.2013   3.5.7.2     (-WK-)   Erweiterung Konsilager
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);
  -- Function and procedure implementations
    function vda_etikett (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_id        in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2 is

        v_print_daten                  varchar2(4096);
        v_found                        boolean;
        v_pos                          isi_order_pos%rowtype;
        v_kopf                         isi_order_kopf%rowtype;
        v_adr                          isi_adressen%rowtype;
        v_art                          isi_artikel%rowtype;
        v_art_kd                       isi_artikel_kunde%rowtype;
        v_charge                       lvs_charge%rowtype;
        v_lte_c                        lvs_lte_cfg%rowtype;
        v_lhm_c                        lvs_lhm_cfg%rowtype;
        v_lte_sid                      lvs_lte.sid%type;
        v_lte_firma_nr                 lvs_lte.firma_nr%type;
        v_lte_lte_id                   lvs_lte.lte_id%type;
        v_lte_lte_name                 lvs_lte.lte_name%type;
        v_lte_ziel_lgr_platz           lvs_lte.ziel_lgr_platz%type;
        v_lte_lte_akt_lhm              lvs_lte.lte_akt_lhm%type;
        v_lte_order_vorgang_id         lvs_lte.order_vorgang_id%type;
        v_lhm_lhm_name                 lvs_lhm.lhm_name%type;
        v_lam_charge_id                lvs_lam.charge_id%type;
        v_lam_kunden_nr                lvs_lam.kunden_nr%type;
        v_lam_memge                    lvs_lam.menge%type;
        v_lam_memge_basis              lvs_lam.menge_basis%type;
        v_lam_leitzahl                 lvs_lam.leitzahl%type;
        v_lam_prod_datum               lvs_lam.prod_datum%type;
        v_order_pos_auf_id             isi_order_pos.auf_id%type;
        v_lte_id_b                     varchar2(100);
        v_lte_lte_voll                 lvs_lte.lte_voll%type;
        v_lam_zeichnung                lvs_lam.zeichnung%type;
        v_lam_zeichnung_index          lvs_lam.zeichnung_index%type;
        v_lam_best_nr                  lvs_lam.best_nr%type;
        v_fa_auftrag                   bde_fa_auftrag%rowtype;
        v_netto                        number;
        v_brutto                       number;
        v_adr_nr                       isi_adressen.adr_nr%type;
        v_adr_liefer                   isi_adressen.adr_liefer%type;
        v_adr_id                       isi_adressen.adress_id%type;
        v_lam_order_pos_auf_id         isi_order_pos.auf_id%type;
        v_lam_artikel_id               isi_artikel.artikel_id%type;
        v_lam_art_fanr                 lvs_lam.leitzahl%type;
        v_lam_art_faag                 lvs_lam.fa_ag%type;
        v_lieferanten_nr               isi_adressen.adr_nr%type;
        v_best_nr_kunde                isi_order_pos.best_nr_kunde%type;
        v_li_nr_lief                   lvs_lam.li_nr_lief%type;
        v_naechste_maschine            isi_resource.res_ext_name%type;
        v_vdadatenfeldfuerlieferanten  varchar2(255);
        v_vdagewichtbrutto             varchar2(255);
        v_vdagewichtnetto              varchar2(255);
        v_vdalieferscheinnrbestnr      varchar2(255);
        v_vdalieferscheinnr            varchar2(255);
        v_vdalieferscheinnrlief        varchar2(255);
        v_vdawarenempfaengerkurz       varchar2(255);
        v_vdawarenempfaengerlang1      varchar2(255);
        v_vdawarenempfaengerlang2      varchar2(255);
        v_vdawarenempfaengerlang3      varchar2(255);
        v_vdaabladestelle              varchar2(255);
        v_vdaanzahlpackstuecke         varchar2(255);
        v_vdafuellmenge                varchar2(255);
        v_vdafuellmengemengeneinheit   varchar2(255);
        v_vdabezeichnunglieferungl     varchar2(255);
        v_vdasachnrlieferant           varchar2(255);
        v_vdasachnrlieferantiskdpackm  varchar2(255);
        v_vdasachnrlieferantzusangaben varchar2(255);
        v_vdasachnrlieferantprodnr     varchar2(255);
        v_vdasachnrlieferantabmessung  varchar2(255);
        v_vdasachnrkunde               varchar2(255);
        v_vdadatum                     varchar2(255);
        v_vdaaenderungkonstruktion     varchar2(255);
        v_vdaaenderungkonstruktiono    varchar2(255);
        v_vdaaenderungkonstruktionz    varchar2(255);
        v_vdapackstucknr               varchar2(255);
        v_vdachangennr                 varchar2(255);
        v_vdasachnrkundebarcode        varchar2(255);
        v_vdafuellmengebarcode         varchar2(255);
        v_vdapackstucknrbarcode        varchar2(255);
        v_vdasachnrlieferantbarcode    varchar2(255);
        v_vdachangennrbarcode          varchar2(255);
        v_vdasachnrlieferantprodnrbarc varchar2(255);
        v_vdanrkundebarcode            varchar2(255);
        v_vdalieferanschriftkurz       varchar2(255);
        v_vdalieferantennr             varchar2(255);
        v_vdalieferantennrbarcode      varchar2(255);
        v_vdalieferantenanschrift1     varchar2(255);
        v_vdalieferantenanschrift2     varchar2(255);
        v_vdalieferantenanschrift3     varchar2(255);
        v_vdalieferantenanschrift4     varchar2(255);
        v_vdabestellnummerkunde        varchar2(255);
        v_vdabezeichnungkunde          varchar2(50);
        v_grapholhmid                  varchar2(50);
        v_chargeid                     varchar2(50);
        v_infohinweis                  varchar2(50);
        cursor c_lte is
        select
            lte.sid,
            lte.firma_nr,
            lte.lte_id,
            lte.lte_name,
            nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
            lte.lte_akt_lhm,
            lte.order_vorgang_id,
            lte.lte_voll,
            (
                select
                    decode(
                        min(lhm.lhm_name),
                        max(lhm.lhm_name),
                        min(lhm.lhm_name),
                        null
                    )
                from
                    lvs_lhm lhm
                where
                        lte.sid = lhm.sid (+)
                    and lte.lte_id = lhm.lte_id (+)
            )                                      lhm_name,
            min(lam.charge_id)                     charge_id,   -- -AG- Erste Charge der Palette andrucken
            decode(
                min(lam.kunden_nr),
                max(lam.kunden_nr),
                min(lam.kunden_nr),
                null
            )                                      kunden_nr,
            decode(
                min(lam.best_nr),
                max(lam.best_nr),
                min(lam.best_nr),
                null
            )                                      best_nr,
            min(lte.lte_akt_kg),
            sum(lam.lam_kg)                        netto,
            min(lam.order_pos_auf_id)              order_pos_auf_id,
            sum(lam.menge),
            decode(
                min(lam.mengeneinheit_basis),
                max(lam.mengeneinheit_basis),
                min(lam.mengeneinheit_basis),
                null
            )                                      menge_basis,
            decode(
                min(lam.leitzahl),
                max(lam.leitzahl),
                min(lam.leitzahl),
                null
            )                                      leitzahl,
            decode(
                trunc(min(lam.prod_datum)),
                trunc(max(lam.prod_datum)),
                trunc(min(lam.prod_datum)),
                null
            )                                      prod_datum,
            decode(
                min(lam.zeichnung),
                max(lam.zeichnung),
                min(lam.zeichnung),
                null
            )                                      zeichnung,
            decode(
                min(lam.zeichnung_index),
                max(lam.zeichnung_index),
                min(lam.zeichnung_index),
                null
            )                                      zeichnung_index,
            decode(
                min(lam.artikel_id),
                max(lam.artikel_id),
                min(lam.artikel_id),
                null
            )                                      artikel_id,
            decode(
                min(lam.leitzahl),
                max(lam.leitzahl),
                min(lam.leitzahl),
                null
            )                                      leitzahl,
            decode(
                min(lam.fa_ag),
                max(lam.fa_ag),
                min(lam.fa_ag),
                null
            )                                      fa_ag,
            decode(
                min(lam.lieferant_nr),
                max(lam.lieferant_nr),
                min(lam.lieferant_nr),
                null
            )                                      lieferanten_nr,
            decode(
                min(lam.li_nr_lief),
                max(lam.li_nr_lief),
                min(lam.li_nr_lief),
                null
            )                                      li_nr_lief,
            decode(
                min(lam.charge_id),
                max(lam.charge_id),
                min(lam.charge_id),
                null
            )                                      charge_id,
            decode(
                min(nvl(lam.owner_address_id, 0)),
                0,
                null,
                'Konsi-Ware!'
            )                                      info_hinweis
        from
            lvs_lte lte,
            lvs_lam lam
        where
                lte.sid = lam.sid (+)
            and lte.lte_id = in_id
            and lte.lte_id = lam.lte_id (+)
        group by
            lte.sid,
            lte.firma_nr,
            lte.order_vorgang_id,
            lte.lte_voll,
            lte.lte_id,
            lte.lte_name,
            lte.ziel_lgr_platz,
            lte.lte_akt_lhm,
            lte.lgr_platz;

        cursor c_lhm is
        select
            lam.sid,
            lam.firma_nr,
            lhm.lhm_id,
            lhm.lhm_name,
            nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
            '1',
            lte.order_vorgang_id,
            'V',
            decode(
                min(lhm.lhm_name),
                max(lhm.lhm_name),
                min(lhm.lhm_name),
                null
            )                                      lhm_name,
            min(lam.charge_id)                     charge_id,    -- -AG- Erste Charge der Palette andrucken
            decode(
                min(lam.kunden_nr),
                max(lam.kunden_nr),
                min(lam.kunden_nr),
                null
            )                                      kunden_nr,
            decode(
                min(lam.best_nr),
                max(lam.best_nr),
                min(lam.best_nr),
                null
            )                                      best_nr,
            min(lhm.lhm_akt_kg)                    brutto,
            sum(lam.lam_kg)                        netto,
            min(lam.order_pos_auf_id)              order_pos_auf_id,
            sum(lam.menge),
            decode(
                min(lam.menge_basis),
                max(lam.menge_basis),
                min(lam.menge_basis),
                null
            )                                      menge_basis,
            decode(
                min(lam.leitzahl),
                max(lam.leitzahl),
                min(lam.leitzahl),
                null
            )                                      leitzahl,
            decode(
                trunc(min(lam.prod_datum)),
                trunc(max(lam.prod_datum)),
                trunc(min(lam.prod_datum)),
                null
            )                                      prod_datum,
            decode(
                min(lam.zeichnung),
                max(lam.zeichnung),
                min(lam.zeichnung),
                null
            )                                      zeichnung,
            decode(
                min(lam.zeichnung_index),
                max(lam.zeichnung_index),
                min(lam.zeichnung_index),
                null
            )                                      zeichnung_index,
            decode(
                min(lam.artikel_id),
                max(lam.artikel_id),
                min(lam.artikel_id),
                null
            )                                      artikel_id,
            decode(
                min(lam.leitzahl),
                max(lam.leitzahl),
                min(lam.leitzahl),
                null
            )                                      leitzahl,
            decode(
                min(lam.fa_ag),
                max(lam.fa_ag),
                min(lam.fa_ag),
                null
            )                                      fa_ag,
            decode(
                min(lam.lieferant_nr),
                max(lam.lieferant_nr),
                min(lam.lieferant_nr),
                null
            )                                      lieferanten_nr,
            decode(
                min(lam.li_nr_lief),
                max(lam.li_nr_lief),
                min(lam.li_nr_lief),
                null
            )                                      li_nr_lief,
            decode(
                min(lam.charge_id),
                max(lam.charge_id),
                min(lam.charge_id),
                null
            )                                      charge_id
        from
            lvs_lhm lhm,
            lvs_lte lte,
            lvs_lam lam
        where
                lhm.lhm_id = in_id
            and lhm.lte_id = lte.lte_id
            and lhm.lhm_id = lam.lhm_id
        group by
            lam.sid,
            lam.firma_nr,
            lte.order_vorgang_id,
            lhm.lhm_id,
            lhm.lhm_name,
            lte.ziel_lgr_platz,
            lte.lgr_platz;

        cursor c_art is
        select
            *
        from
            isi_artikel art
        where
                art.sid = v_lte_sid
            and art.artikel_id = v_lam_artikel_id;

        cursor c_art_kd is
        select
            *
        from
            isi_artikel_kunde art
        where
                art.sid = v_lte_sid
            and art.artikel_id = v_lam_artikel_id
            and art.kunden_nr = v_adr_nr;

        cursor c_pos is
        select
            *
        from
            isi_order_pos pos
        where
                pos.sid = v_lte_sid
            and pos.firma_nr = v_lte_firma_nr
            and pos.auf_id = v_lam_order_pos_auf_id;

        cursor c_pos_lte_all is
        select
            decode(
                min(pos.best_nr_kunde),
                max(pos.best_nr_kunde),
                min(pos.best_nr_kunde),
                null
            )
        from
            isi_order_pos pos,
            lvs_lam       lam
        where
                pos.sid = v_lte_sid
            and pos.firma_nr = v_lte_firma_nr
            and pos.auf_id = lam.order_pos_auf_id
            and lam.sid = v_lte_sid
            and lam.firma_nr = v_lte_firma_nr
            and lam.lte_id = v_lte_lte_id;

        cursor c_pos_lhm_all is
        select
            decode(
                min(pos.best_nr_kunde),
                max(pos.best_nr_kunde),
                min(pos.best_nr_kunde),
                null
            )
        from
            isi_order_pos pos,
            lvs_lam       lam
        where
                pos.sid = v_lte_sid
            and pos.firma_nr = v_lte_firma_nr
            and pos.auf_id = lam.order_pos_auf_id
            and lam.sid = v_lte_sid
            and lam.firma_nr = v_lte_firma_nr
            and lam.lhm_id = v_lte_lte_id;

        cursor c_kopf is
        select
            *
        from
            isi_order_kopf kopf
        where
                kopf.sid = v_lte_sid
            and kopf.firma_nr = v_lte_firma_nr
            and kopf.vorgang_typ = 'WAE'
            and kopf.vorgang_id = v_lte_order_vorgang_id
            and kopf.li_nr = v_pos.li_nr;

        cursor c_resource is
        select
            r.res_ext_name
        from
            isi_resource r
        where
                r.sid = v_fa_auftrag.sid
            and r.res_id = v_fa_auftrag.res_id;

        cursor c_fa_next_ag is
        select
            fa.*
        from
            bde_fa_auftrag fa
        where
                fa.sid = v_lte_sid
            and fa.firma_nr = v_lte_firma_nr
            and fa.leitzahl = v_lam_art_fanr
            and fa.fa_ag > v_lam_art_faag
        order by
            fa_ag;

        cursor c_fa_auf_lte is
        select
            decode(
                min(fa.best_nr_kunde),
                max(fa.best_nr_kunde),
                min(fa.best_nr_kunde),
                null
            )
        from
            bde_fa_auftrag fa,
            lvs_lam        lam
        where
                fa.sid = v_lte_sid
            and fa.firma_nr = v_lte_firma_nr
            and ( lam.lte_id = v_lte_lte_id
                  or lam.lhm_id = v_lte_lte_id )
            and fa.leitzahl = lam.leitzahl
            and decode(fa.kenz_letzt_ag, 1, fa.fa_ag, 0) = nvl(lam.fa_ag, 0);

        cursor c_fa_auf_lhm is
        select
            decode(
                min(fa.best_nr_kunde),
                max(fa.best_nr_kunde),
                min(fa.best_nr_kunde),
                null
            )
        from
            bde_fa_auftrag fa,
            lvs_lam        lam
        where
                fa.sid = v_lte_sid
            and fa.firma_nr = v_lte_firma_nr
            and lam.lhm_id = v_lte_lte_id
            and fa.leitzahl = lam.leitzahl
            and decode(fa.kenz_letzt_ag, 1, fa.fa_ag, 0) = nvl(lam.fa_ag, 0);

        cursor c_kunde is
        select
            *
        from
            isi_adressen adr
        where
                adr.sid = v_lte_sid
            and adr.firma_nr = v_lte_firma_nr
            and adr.adr_art = 'K'
            and adr.adr_nr = v_adr_nr
            and adr.adr_liefer = 0;

        cursor c_lieferant is
        select
            *
        from
            isi_adressen adr
        where
                adr.sid = v_lte_sid
            and adr.firma_nr = v_lte_firma_nr
            and adr.adr_art = 'L'
            and adr.adr_nr = v_lieferanten_nr
            and adr.adr_liefer = 0;

        cursor c_adr is
        select
            *
        from
            isi_adressen adr
        where
                adr.sid = v_lte_sid
            and adr.adress_id = v_adr_id;

        cursor c_charge is
        select
            *
        from
            lvs_charge c
        where
                c.sid = v_lte_sid
            and c.charge_id = v_lam_charge_id;

        cursor c_lhm_c is
        select
            *
        from
            lvs_lhm_cfg lhm_c
        where
                lhm_c.sid = v_lte_sid
            and lhm_c.firma_nr = v_lte_firma_nr
            and lhm_c.lhm_name = v_lte_lte_name;

        cursor c_lte_c is
        select
            *
        from
            lvs_lte_cfg lte_c
        where
                lte_c.sid = v_lte_sid
            and lte_c.firma_nr = v_lte_firma_nr
            and lte_c.lte_name = v_lte_lte_name;

    begin
        v_vdadatenfeldfuerlieferanten := null;
        v_vdagewichtnetto := null;
        v_vdagewichtbrutto := null;
        v_vdalieferscheinnrbestnr := null;
        v_vdalieferscheinnr := null;
        v_vdalieferscheinnrlief := null;
        v_vdawarenempfaengerkurz := null;
        v_vdawarenempfaengerlang1 := null;
        v_vdawarenempfaengerlang2 := null;
        v_vdawarenempfaengerlang3 := null;
        v_vdaabladestelle := null;
        v_vdaanzahlpackstuecke := null;
        v_vdafuellmenge := null;
        v_vdafuellmengemengeneinheit := null;
        v_vdabezeichnunglieferungl := null;
        v_vdasachnrlieferant := null;
        v_vdasachnrlieferantiskdpackm := null;
        v_vdasachnrlieferantzusangaben := null;
        v_vdasachnrlieferantprodnr := null;
        v_vdasachnrlieferantabmessung := null;
        v_vdasachnrkunde := null;
        v_vdadatum := null;
        v_vdaaenderungkonstruktion := null;
        v_vdaaenderungkonstruktiono := null;
        v_vdaaenderungkonstruktionz := null;
        v_vdapackstucknr := null;
        v_vdachangennr := null;
        v_vdalieferantennr := null;
        v_vdasachnrkundebarcode := null;
        v_vdafuellmengebarcode := null;
        v_vdapackstucknrbarcode := null;
        v_vdasachnrlieferantbarcode := null;
        v_vdachangennrbarcode := null;
        v_vdasachnrlieferantprodnrbarc := null;
        v_vdanrkundebarcode := null;
        v_vdalieferantennrbarcode := null;
        v_vdalieferantenanschrift1 := null;
        v_vdalieferantenanschrift2 := null;
        v_vdalieferantenanschrift3 := null;
        v_vdalieferantenanschrift4 := null;
        v_vdabezeichnungkunde := null;
        v_grapholhmid := null;
        v_chargeid := null;
        v_infohinweis := null;
        v_lam_art_fanr := null;
        v_lam_art_faag := null;
        if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = c.basis_lte then
            open c_lte;
            fetch c_lte into
                v_lte_sid,
                v_lte_firma_nr,
                v_lte_lte_id,
                v_lte_lte_name,
                v_lte_ziel_lgr_platz,
                v_lte_lte_akt_lhm,
                v_lte_order_vorgang_id,
                v_lte_lte_voll,
                v_lhm_lhm_name,
                v_lam_charge_id,
                v_lam_kunden_nr,
                v_lam_best_nr,
                v_brutto,
                v_netto,
                v_order_pos_auf_id,
                v_lam_memge,
                v_lam_memge_basis,
                v_lam_leitzahl,
                v_lam_prod_datum,
                v_lam_zeichnung,
                v_lam_zeichnung_index,
                v_lam_artikel_id,
                v_lam_art_fanr,
                v_lam_art_faag,
                v_lieferanten_nr,
                v_li_nr_lief,
                v_chargeid,
                v_infohinweis;

            v_found := c_lte%found;
            close c_lte;
            open c_lte_c;
            fetch c_lte_c into v_lte_c;
            if c_lte_c%found then
                v_vdadatenfeldfuerlieferanten := v_lte_c.lte_text;
            end if;
            close c_lte_c;
            open c_fa_auf_lte;
            fetch c_fa_auf_lte into v_vdabestellnummerkunde;
            if c_fa_auf_lte%notfound then
                v_vdabestellnummerkunde := null;
            end if;
            close c_fa_auf_lte;
            open c_pos_lte_all;
            fetch c_pos_lte_all into v_best_nr_kunde;
            if c_pos_lte_all%found then
                v_vdabestellnummerkunde := v_best_nr_kunde;
            end if;
            close c_pos_lte_all;
        elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = c.basis_lhm then
            open c_lhm;
            fetch c_lhm into
                v_lte_sid,
                v_lte_firma_nr,
                v_lte_lte_id,
                v_lte_lte_name,
                v_lte_ziel_lgr_platz,
                v_lte_lte_akt_lhm,
                v_lte_order_vorgang_id,
                v_lte_lte_voll,
                v_lhm_lhm_name,
                v_lam_charge_id,
                v_lam_kunden_nr,
                v_lam_best_nr,
                v_brutto,
                v_netto,
                v_order_pos_auf_id,
                v_lam_memge,
                v_lam_memge_basis,
                v_lam_leitzahl,
                v_lam_prod_datum,
                v_lam_zeichnung,
                v_lam_zeichnung_index,
                v_lam_artikel_id,
                v_lam_art_fanr,
                v_lam_art_faag,
                v_lieferanten_nr,
                v_li_nr_lief,
                v_chargeid;

            v_found := c_lhm%found;
            close c_lhm;
            open c_lhm_c;
            fetch c_lhm_c into v_lhm_c;
            if c_lhm_c%found then
                v_vdadatenfeldfuerlieferanten := v_lhm_c.lhm_text;
            end if;
            close c_lhm_c;
            open c_fa_auf_lhm;
            fetch c_fa_auf_lhm into v_vdabestellnummerkunde;
            if c_fa_auf_lhm%notfound then
                v_vdabestellnummerkunde := null;
            end if;
            close c_fa_auf_lhm;
            open c_pos_lhm_all;
            fetch c_pos_lhm_all into v_best_nr_kunde;
            if c_pos_lhm_all%found then
                v_vdabestellnummerkunde := v_best_nr_kunde;
            end if;
            close c_pos_lhm_all;
        end if;

        v_naechste_maschine := null;
        if v_lam_art_fanr is not null then
            open c_fa_next_ag;
            fetch c_fa_next_ag into v_fa_auftrag;
            if c_fa_next_ag%found then
                open c_resource;
                fetch c_resource into v_naechste_maschine;
                close c_resource;
            end if;

            close c_fa_next_ag;
        end if;

        open c_art;
        fetch c_art into v_art;
        if c_art%notfound then
            v_art := null;
        end if;
        close c_art;
        if v_found then
            v_vdagewichtnetto := v_netto;
            v_vdagewichtbrutto := v_brutto;
            v_vdalieferscheinnrbestnr := v_lam_best_nr;
            v_vdaabladestelle := v_lte_ziel_lgr_platz;
            v_vdasachnrlieferantprodnr := v_lam_leitzahl;
            v_vdasachnrlieferantiskdpackm := v_lte_lte_name;
            v_vdasachnrlieferantzusangaben := v_lhm_lhm_name;
            v_vdaanzahlpackstuecke := v_lte_lte_akt_lhm;
            v_vdasachnrlieferant := v_art.artikel;

      -- -CMe 20190211- Es soll nur noch die Artikelnummer angezeigt werden. Ticket:W20310-215
      --v_Vdasachnrlieferant           := v_art.artikel_p1; -- Bei Euscher QS-Prüftext
      -- Falls der Parameter P1 nicht gefüllt, dann nur die Artikelnummer eintragen
      --if v_Vdasachnrlieferant is NULL
      --then
      --  v_Vdasachnrlieferant           := v_art.artikel;
      --else
      --  v_Vdasachnrlieferant           := v_Vdasachnrlieferant || ' ' || v_art.artikel;
      --end if;

            if v_lam_art_faag is not null then
                v_vdasachnrlieferant := v_vdasachnrlieferant
                                        || '-'
                                        || nvl(
                    to_char(v_lam_art_fanr),
                    'X'
                )
                                        || '/'
                                        || to_char(v_lam_art_faag);

                if v_naechste_maschine is not null then
                    v_vdasachnrlieferant := v_vdasachnrlieferant
                                            || ' --> '
                                            || v_naechste_maschine;
                end if;

            end if;

            v_vdafuellmenge := v_lam_memge;
            v_vdabezeichnunglieferungl := v_art.bezeichnung1;
            v_vdasachnrlieferantabmessung := v_art.bezeichnung2;
            v_vdaaenderungkonstruktiono := v_art.bezeichnung3;
            if v_lam_prod_datum is not null then
                v_vdadatum := 'P' || to_char(v_lam_prod_datum, 'YYMMDD');
            end if;

            v_vdaaenderungkonstruktionz := v_lam_zeichnung;
            v_vdaaenderungkonstruktion := v_lam_zeichnung_index;
            if v_lam_leitzahl is not null then
                v_vdasachnrlieferantprodnrbarc := '20S' || v_lam_leitzahl;
            end if;
            if v_art.artikel is not null then
                v_vdasachnrlieferantbarcode := '30S' || v_art.artikel;
                if v_lam_art_faag is not null then
                    v_vdasachnrlieferantbarcode := v_vdasachnrlieferantbarcode
                                                   || '-'
                                                   || nvl(
                        to_char(v_lam_art_fanr),
                        'X'
                    )
                                                   || '/'
                                                   || to_char(v_lam_art_faag);

                end if;

            end if;

            v_vdafuellmengebarcode := 'Q' || v_lam_memge;
            open c_charge;
            fetch c_charge into v_charge;
            v_found := c_charge%found;
            close c_charge;
            if v_found then
                v_vdachangennr := v_charge.charge_bez;
                v_vdachangennrbarcode := 'H' || v_charge.charge_bez;
            end if;

            v_vdalieferantennr := v_lieferanten_nr;
            v_vdalieferscheinnrlief := v_li_nr_lief;
            v_vdalieferantennrbarcode := 'V' || v_lieferanten_nr;
            open c_pos;
            fetch c_pos into v_pos;
            v_found := c_pos%found;
            if not v_found then
                v_adr_nr := v_lam_kunden_nr;
                open c_kunde;
                fetch c_kunde into v_adr;
                v_found := c_kunde%found;
                close c_kunde;
                if v_found then
                    v_vdawarenempfaengerkurz := v_adr.name_1;
                    v_vdawarenempfaengerlang1 := v_adr.name_1;
                    v_vdawarenempfaengerlang2 := v_adr.name_2;
                    v_vdawarenempfaengerlang3 := v_adr.plz
                                                 || ' '
                                                 || v_adr.ort;
                end if;

            else
                open c_kopf;
                fetch c_kopf into v_kopf;
                if v_found then
                    v_adr_id := v_kopf.adress_id;
                    v_vdalieferscheinnr := to_char(v_kopf.vorgang_id);
                    if v_kopf.wae_ziel is not null then
                        v_vdaabladestelle := v_kopf.wae_ziel;
                    end if;
                    open c_adr;
                    fetch c_adr into v_adr;
                    v_found := c_adr%found;
                    if v_found then
                        v_vdawarenempfaengerkurz := v_adr.name_1;
                        v_vdawarenempfaengerlang1 := v_adr.name_1;
                        v_vdawarenempfaengerlang2 := v_adr.name_2;
                        v_vdawarenempfaengerlang3 := v_adr.plz
                                                     || ' '
                                                     || v_adr.ort;
                        v_vdaabladestelle := nvl(v_kopf.wae_ziel, v_vdaabladestelle);
                        v_adr_nr := v_adr.adr_nr;
                    end if;

                    close c_adr;
                    v_adr_id := v_kopf.order_adress_id;
                    open c_adr;
                    fetch c_adr into v_adr;
                    v_found := c_adr%found;
                    close c_adr;
                    if v_found then
                        v_vdalieferanschriftkurz := v_adr.name_1;
                    end if;
                else
                    v_adr_nr := v_lam_kunden_nr;
                    open c_kunde;
                    fetch c_kunde into v_adr;
                    v_found := c_kunde%found;
                    close c_kunde;
                    if v_found then
                        v_vdawarenempfaengerkurz := v_adr.name_1
                                                    || ' '
                                                    || v_adr.name_2
                                                    || ' '
                                                    || v_adr.plz
                                                    || ' '
                                                    || v_adr.ort;

                        v_vdawarenempfaengerlang1 := v_adr.name_1;
                        v_vdawarenempfaengerlang2 := v_adr.name_2;
                        v_vdawarenempfaengerlang3 := v_adr.plz
                                                     || ' '
                                                     || v_adr.ort;
                    end if;

                end if;

                close c_kopf;
            end if;

            close c_pos;
            open c_lieferant;
            fetch c_lieferant into v_adr;
            v_found := c_lieferant%found;
            close c_lieferant;
            if v_found then
                v_vdalieferantenanschrift1 := v_adr.name_1;
                v_vdalieferantenanschrift2 := v_adr.name_2;
                v_vdalieferantenanschrift3 := v_adr.name_3;
                v_vdalieferantenanschrift4 := v_adr.name_1
                                              || ', '
                                              || v_adr.name_2
                                              || ', '
                                              || v_adr.plz
                                              || ', '
                                              || v_adr.ort;

            end if;

            if v_art.artikel is not null then
                open c_art_kd;
                fetch c_art_kd into v_art_kd;
                v_found := c_art_kd%found;
                close c_art_kd;
                if
                    v_found
                    and v_art_kd.kd_art_nr is not null
                    and v_lam_art_faag is null
                then
                    v_vdasachnrkundebarcode := 'P' || v_art_kd.kd_art_nr;
                    v_vdasachnrkunde := v_art_kd.kd_art_nr;
                    v_vdabezeichnungkunde := v_art_kd.kd_art_text1;
                end if;

            end if;

        end if;

        v_print_daten := '';
        if in_waren_typ = 'MP' then
            v_vdapackstucknrbarcode := 'G';
        elsif v_lte_lte_voll = c.lte_voll_v then
            v_vdapackstucknrbarcode := 'S';
        else
            v_vdapackstucknrbarcode := 'M';
        end if;

        v_vdapackstucknr := in_id;
        v_vdapackstucknrbarcode := v_vdapackstucknrbarcode || in_id;
        v_grapholhmid := 'E'
                         || lpad(
            substr(
                to_char(v_vdapackstucknr),
                10
            ),
            10,
            '0'
        );

        v_print_daten := 'VdaSachNrLieferantDatenfeldFuerLieferanten='
                         || v_vdadatenfeldfuerlieferanten
                         || cr_lf()
                         || 'VdaGewichtBrutto='
                         || v_vdagewichtbrutto
                         || cr_lf()
                         || 'VdaGewichtNetto='
                         || v_vdagewichtnetto
                         || cr_lf()
                         || 'VdaLieferscheinNrBestellnummer='
                         || v_vdalieferscheinnrbestnr
                         || cr_lf()
                         || 'VdaLieferscheinNr='
                         || v_vdalieferscheinnr
                         || cr_lf()
                         || 'VdaLieferscheinNrLief='
                         || v_vdalieferscheinnrlief
                         || cr_lf()
                         || 'VdaWarenempfaengerKurz='
                         || v_vdawarenempfaengerkurz
                         || cr_lf()
                         || 'VdaWarenempfaengerLang1='
                         || v_vdawarenempfaengerlang1
                         || cr_lf()
                         || 'VdaWarenempfaengerLang2='
                         || v_vdawarenempfaengerlang2
                         || cr_lf()
                         || 'VdaWarenempfaengerLang3='
                         || v_vdawarenempfaengerlang3
                         || cr_lf()
                         || 'VdaAbladestelle='
                         || v_vdaabladestelle
                         || cr_lf()
                         || 'VdaAnzahlPackstuecke='
                         || v_vdaanzahlpackstuecke
                         || cr_lf()
                         || 'VdaFuellmenge='
                         || v_vdafuellmenge
                         || cr_lf()
                         || 'VdaFuellmengeMengeneinheit='
                         || v_vdafuellmengemengeneinheit
                         || cr_lf()
                         || 'VdaBezeichnungLieferungLeistung='
                         || v_vdabezeichnunglieferungl
                         || cr_lf()
                         || 'VdaSachNrLieferant='
                         || v_vdasachnrlieferant
                         || cr_lf()
                         || 'VdaSachNrLieferantISKDPackmittel='
                         || v_vdasachnrlieferantiskdpackm
                         || cr_lf()
                         || 'VdaSachNrLieferantZusAngaben='
                         || v_vdasachnrlieferantzusangaben
                         || cr_lf()
                         || 'VdaSachNrLieferantProduktionsNr='
                         || v_vdasachnrlieferantprodnr
                         || cr_lf()
                         || 'VdaSachNrLieferantAbmessung='
                         || v_vdasachnrlieferantabmessung
                         || cr_lf()
                         || 'VdaSachNrKunde='
                         || v_vdasachnrkunde
                         || cr_lf()
                         || 'VdaDatum='
                         || v_vdadatum
                         || cr_lf()
                         || 'VdaAenderungKonstruktion='
                         || v_vdaaenderungkonstruktion
                         || cr_lf()
                         || 'VdaAenderungKonstruktionOberflaeche='
                         || v_vdaaenderungkonstruktiono
                         || cr_lf()
                         || 'VdaAenderungKonstruktionZeichnung='
                         || v_vdaaenderungkonstruktionz
                         || cr_lf()
                         || 'VdaPackstuckNr='
                         || v_vdapackstucknr
                         || cr_lf()
                         || 'VdaChangenNr='
                         || v_vdachangennr
                         || cr_lf()
                         || 'VdaLieferantenNr='
                         || v_vdalieferantennr
                         || cr_lf()
                         || 'VdaLieferantenanschriftLang='
                         || v_vdalieferantenanschrift4
                         || cr_lf()
                         || 'VdaSachNrKundeBarcode='
                         || v_vdasachnrkundebarcode
                         || cr_lf()
                         || 'VdaFuellmengeBarcode='
                         || v_vdafuellmengebarcode
                         || cr_lf()
                         || 'VdaPackstuckNrBarcode='
                         || v_vdapackstucknrbarcode
                         || cr_lf()
                         || 'VdaSachNrLieferantBarcode='
                         || v_vdasachnrlieferantbarcode
                         || cr_lf()
                         || 'VdaChangenNrBarcode='
                         || v_vdachangennrbarcode
                         || cr_lf()
                         || 'VdaSachNrLieferantProduktionsNrBarcode='
                         || v_vdasachnrlieferantprodnrbarc
                         || cr_lf()
                         || 'VdaNrKundeBarcode='
                         || v_vdanrkundebarcode
                         || cr_lf()
                         || 'VdaLieferantenNrBarcode='
                         || v_vdalieferantennrbarcode
                         || cr_lf()
                         || 'VdaBezeichnungKunde='
                         || v_vdabezeichnungkunde
                         || cr_lf()
                         || 'GraphoLhmId='
                         || v_grapholhmid
                         || cr_lf()
                         || 'GraphoArtBez='
                         || substr(v_vdabezeichnunglieferungl, 1, 10)
                         || cr_lf()
                         || 'GraphoChargeId='
                         || 'E'
                         || v_chargeid
                         || cr_lf()
                         || 'InfoHinweis='
                         || v_infohinweis;

        return ( v_print_daten );
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
    end vda_etikett;

end;
/


-- sqlcl_snapshot {"hash":"c8eb79ba44d41e327a792c8f16ce355f03914b22","type":"PACKAGE_BODY","name":"Z_EUSCHER_DRUCK","schemaName":"DIRKSPZM32","sxml":""}