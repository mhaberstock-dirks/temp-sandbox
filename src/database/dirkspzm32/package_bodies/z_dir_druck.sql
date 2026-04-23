create or replace package body dirkspzm32.z_dir_druck is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  /* VDA Felder falls VDA
    VdaAbladestelleWarenempfaenger
    VdaLieferscheinNr
    VdaLieferscheinNrLief
    VdaLieferanschriftkurz
    VdaGewichtNetto
    VdaGewichtBrutto
    VdaAnzahlPackstuecke
    VdaSachNrKunde
    VdaFuellmenge
    VdaFuellmengeMengeneinheit
    VdaBezeichnungLieferungLeistung
    VdaSachNrLieferant
    VdaSachNrLieferantDicke
    VdaSachNrLieferantbreite
    VdaSachNrLieferantLaenge
    VdaSachNrLieferantDatenfeldFuerLieferanten
    VdaSachNrLieferantISKDPackmittel
    VdaSachNrLieferantZusAngaben
    VdaSachNrLieferantProduktionsNr
    VdaSachNrLieferantGefaehrlicheGueter
    VdaLieferantenNr
    VdaDatum
    VdaDatumProduktiondatum
    VdaDatumVersanddatum
    VdaDatumVerfalldatum
    VdaAenderungKonstruktion
    VdaAenderungKonstruktionOberflaeche
    VdaAenderungKonstruktionZeichnung
    VdaPackstuckNr
    VdaChangenNr
    VdaLieferantenanschriftLang
    VdaVordruckBezeichnung
    VdaAenderungKonstruktionstand
    VdaSachNrKundeBarcode
    VdaFuellmengeBarcode
    VdaPackstuckNrBarcode
    VdaSachNrLieferantBarcode
    VdaChangenNrBarcode
    VdaVersionEtikett
    VdaNrKunde
    VdaSachNrLieferantAbmessung
    VdaSachNrLieferantProduktionsNrBarcode
    VdaNrKundeBarcode
    VdaLieferantenNrBarcode
    VdaBestellNummerKunde
  */

  -- Private variable declarations

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);

  -- Function and procedure implementations
  -------------------------------------------------------------------------------------------------------
  -- VDA-Etikett druck
  -------------------------------------------------------------------------------------------------------
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
        v_vdapackstuecknr              varchar2(255);
        v_vdachangennr                 varchar2(255);
        v_vdasachnrkundebarcode        varchar2(255);
        v_vdafuellmengebarcode         varchar2(255);
        v_vdapackstuecknrbarcode       varchar2(255);
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
        v_vdapackstuecknr := null;
        v_vdachangennr := null;
        v_vdalieferantennr := null;
        v_vdasachnrkundebarcode := null;
        v_vdafuellmengebarcode := null;
        v_vdapackstuecknrbarcode := null;
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
            v_vdasachnrlieferant := v_art.artikel_p1; -- Bei Euscher QS-Prüftext
      -- Falls der Parameter P1 nicht gefüllt, dann nur die Artikelnummer eintragen
            if v_vdasachnrlieferant is null then
                v_vdasachnrlieferant := v_art.artikel;
            else
                v_vdasachnrlieferant := v_vdasachnrlieferant
                                        || ' '
                                        || v_art.artikel;
            end if;

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
            v_vdapackstuecknrbarcode := 'G';
        elsif v_lte_lte_voll = c.lte_voll_v then
            v_vdapackstuecknrbarcode := 'S';
        else
            v_vdapackstuecknrbarcode := 'M';
        end if;

        v_vdapackstuecknr := in_id;
        v_vdapackstuecknrbarcode := v_vdapackstuecknrbarcode || in_id;
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
                         || 'VdaPackstueckNr='
                         || v_vdapackstuecknr
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
                         || 'VdaPackstueckNrBarcode='
                         || v_vdapackstuecknrbarcode
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

  -------------------------------------------------------------------------------------------------------
  -- CCG-Etikett druck
  -------------------------------------------------------------------------------------------------------
    function ccg_etikett (
        in_lte_id    in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2 is

        v_menge_basis         varchar2(3);
        v_menge               number;
        v_ccg_nve             varchar2(100);  --1
        v_ccg_arttext         varchar2(100);  --2
        v_ccg_ean_lhm_string  varchar2(100);  --3
        v_ccg_ean_lke_string  varchar2(100);  --4
        v_ccg_mhd_string      varchar2(100);  --5
        v_ccg_lhm_menge       number;         --6
        v_ccg_lke_menge       number;         --7
        v_ccg_arttext_kurz    varchar2(100);  --8
        v_ccg_lage_lagen      varchar2(100);  --9
        v_ccg_charge          varchar2(100);  --10
        v_ccg_gewicht_kg      varchar2(100);  --11
        v_ccg_artikel_nr      varchar2(100);  --14
        v_ccg_mhd_monat       varchar2(100);  --15
        v_ccg_menge_in_lhm    number;         --16
        v_ccg_lhm_pro_lage    number;         --17
        v_ccg_menge_pro_lage  number;         --18
        v_ccg_lagen           number;         --19
        v_ccg_pid             varchar2(100);  --20
        v_ccg_anz_becher      number;         --21
        v_ccg_anz_karton      number;         --22
        v_artikel_nr          varchar2(100);  --23
        v_ccg_lhm_l_lage      number;         --24
        v_ccg_kom_lagen       number;         --25

        v_ccg_barcodea_string varchar2(100);  --BC1_TEXT
        v_ccg_barcodeb_string varchar2(100);  --BC2_TEXT
        v_ccg_barcodec_string varchar2(100);  --BC3_TEXT
        v_ccg_barcoded_string varchar2(100);  --BC4_TEXT
        v_ccg_barcodee_string varchar2(100);  --BC5_TEXT
        v_ccg_barcodef_string varchar2(100);  --BC5_TEXT
        v_ccg_barcodea        varchar2(100);  --BC1
        v_ccg_barcodeb        varchar2(100);  --BC2
        v_ccg_barcodec        varchar2(100);  --BC2
        v_ccg_barcoded        varchar2(100);  --BC4
        v_ccg_barcodee        varchar2(100);  --BC5
        v_ccg_barcodef        varchar2(100);  --BC5

        v_print_daten         varchar2(2048);
        v_found               boolean;
        v_adresse             isi_adressen%rowtype;
        cursor c_firma is
        select
            a.*
        from
            isi_firma    t,
            isi_adressen a
        where
                t.sid = v_adresse.sid
            and t.firma_nr = v_adresse.firma_nr
            and a.sid = t.sid
            and a.adress_id = t.adress_id;

        cursor c_et_daten is
        select
            lte.sid,
            lte.firma_nr,
            lvs_p_lte_lhm.format_nve(nvl(lte.nve_nr, lte.lte_id)) as tf_1,
            nvl(art.bezeichnung3, art.bezeichnung1)               as tf_2,
            '0'
            || lvs_p_lte_lhm.format_ean(art.lhm_ean)              as tf_3,
            lvs_p_lte_lhm.format_ean(art.ean)                     as tf_4,
            to_char(lam.lam_mhd_ausgabe, 'DD.MM.YY')              as tf_5,
            to_char(lam.lam_mhd_ausgabe, 'MM.YYYY')               as tf_15,
            lam.menge                                             as tf_6,
            lam.menge_basis,
            art.lhm_menge                                         as tf_16,
            art.lte_lhm_pro_lage                                  as tf_17,
            art.lte_lhm_pro_lage * art.lhm_menge                  as tf_18,
            art.lte_lhm_lagen                                     as tf_19,
            art.lte_menge                                         as tf_21,
            art.lte_lhm_menge                                     as tf_22,
            nvl(art.artikel_kurz, art.artikel)                    as tf_8,
            art.artikel                                           as tf_14,
            '('
            || art.lte_lhm_pro_lage
            || 'x'
            || art.lte_lhm_lagen
            || ')'                                                as tf_9,
            cha.charge_bez                                        as tf_10,
            round(lte.lte_akt_kg, 2)                              as tf_11,
            lte.lte_id                                            as tf_20,
            '(93)'
            || lte.lte_id
            || '(37)'
            || lpad(lam.menge, 6, '0')
            || '(15)'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as "BC1_Text",
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(10)'
            || cha.charge_bez                                     as "BC2_Text",
            '(00)'
            || nvl(lte.nve_nr, lte.lte_id)                        as "BC3_Text",
            '(37)'
            || lpad(lam.menge, 6, '0')
            || '(15)'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as "BC4_Text",
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(37)'
            || lpad(lam.menge, 6, '0')                            as "BC5_Text",
            '(10)'
            || cha.charge_bez
            || '(15)'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as "BC6_Text",
            '93'
            || lte.lte_id
            || chr(29)
            || '37'
            || lpad(lam.menge, 6, '0')
            || chr(29)
            || '15'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as bc1,
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '10'
            || cha.charge_bez                                     as bc2,
            '00'
            || nvl(lte.nve_nr, lte.lte_id)                        as bc3,
            '37'
            || lpad(lam.menge, 6, '0')
            || chr(29)
            || '15'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as bc4,
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '37'
            || lpad(lam.menge, 6, '0')                            as bc5,
            '10'
            || cha.charge_bez
            || chr(29)
            || '15'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as bc6
        from
            lvs_lte     lte,
            lvs_lam     lam,
            isi_artikel art,
            lvs_charge  cha
        where
                lte.lte_id = in_lte_id
            and lam.lte_id = in_lte_id
            and lam.artikel_id = art.artikel_id (+)
            and lam.sid = art.sid (+)
            and cha.sid (+) = lam.sid
            and nvl(
                cha.charge_id(+),
                -1
            ) = nvl(lam.charge_id, -1);

    begin
        open c_et_daten;
        fetch c_et_daten into
            v_adresse.sid,
            v_adresse.firma_nr,
            v_ccg_nve,
            v_ccg_arttext,
            v_ccg_ean_lhm_string,
            v_ccg_ean_lke_string,
            v_ccg_mhd_string,
            v_ccg_mhd_monat,
            v_menge,
            v_menge_basis,
            v_ccg_menge_in_lhm,
            v_ccg_lhm_pro_lage,
            v_ccg_menge_pro_lage,
            v_ccg_lagen,
            v_ccg_anz_becher,
            v_ccg_anz_karton,
            v_ccg_arttext_kurz,
            v_artikel_nr,
            v_ccg_lage_lagen,
            v_ccg_charge,
            v_ccg_gewicht_kg,
            v_ccg_pid,
            v_ccg_barcodea_string,
            v_ccg_barcodeb_string,
            v_ccg_barcodec_string,
            v_ccg_barcoded_string,
            v_ccg_barcodee_string,
            v_ccg_barcodef_string,
            v_ccg_barcodea,
            v_ccg_barcodeb,
            v_ccg_barcodec,
            v_ccg_barcoded,
            v_ccg_barcodee,
            v_ccg_barcodef;

        v_found := c_et_daten%found;
        close c_et_daten;
        open c_firma;
        fetch c_firma into v_adresse;
        close c_firma;
        v_ccg_artikel_nr := format_artikel(v_adresse.sid, v_adresse.firma_nr, v_artikel_nr);
        if not v_found then
            v_err_nr := 10;
            v_err_text := 'Fehler beim lesen der Etikettendaten der Transporteinheit ' || in_lte_id;
            raise v_error;
        end if;

        if v_ccg_menge_in_lhm = 0 then
            v_ccg_menge_in_lhm := 1;
        end if;
        if v_menge_basis = 'LHM' then
            v_ccg_lhm_menge := v_menge;
            v_ccg_lke_menge := v_menge * v_ccg_menge_in_lhm;
            v_ccg_anz_karton := v_ccg_lhm_menge;
        elsif v_menge_basis = 'LKE' then
            v_ccg_lhm_menge := round((v_menge / v_ccg_menge_in_lhm) + 0.5, 0);
            v_ccg_lke_menge := v_menge;
        else
            v_ccg_lhm_menge := round(v_ccg_menge_pro_lage * v_ccg_lagen / v_ccg_menge_in_lhm + 0.5, 0);
            v_ccg_lke_menge := v_ccg_menge_pro_lage * v_ccg_lagen;
            v_ccg_anz_karton := v_ccg_lhm_menge;
        end if;

        begin
            v_ccg_lhm_l_lage := mod(v_ccg_anz_karton, v_ccg_lhm_pro_lage);
        exception
            when others then
                v_ccg_lhm_l_lage := 0;
        end;

        begin
            v_ccg_kom_lagen := round(((v_ccg_anz_karton - v_ccg_lhm_pro_lage / 2) / v_ccg_lhm_pro_lage), 0);
        exception
            when others then
                v_ccg_kom_lagen := 0;
        end;

        if in_waren_typ != 'MP' then
            v_print_daten := 'CCG_FIRMANAME='
                             || nvl(v_adresse.name_1, 'Name')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMASTRASSE='
                             || nvl(v_adresse.strasse, 'Str.')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMAPLZORT='
                             || nvl(v_adresse.plz, 'PLZ')
                             || ' '
                             || nvl(v_adresse.ort, 'Ort')
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR1='
                             || 'INTERPORTO S. PALOMBA S.R.L.'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR2='
                             || 'Interrporto Palomba'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR3='
                             || 'VIA ADREANTINA, KM 22.000'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR4='
                             || '00040 S. PALOMBA-POMEZIA RM'
                             || chr(13)
                             || chr(10)
                             || 'CCG_AUSLIEFERUNGSDATUM='
                             || '01.10.2003'
                             || chr(13)
                             || chr(10)
                             || 'CCG_NVE='
                             || v_ccg_nve
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTTEXT='
                             || v_ccg_arttext
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_KARTON='
                             || v_ccg_ean_lhm_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_BECHER='
                             || v_ccg_ean_lke_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD='
                             || v_ccg_mhd_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD_MONAT='
                             || v_ccg_mhd_monat
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_KARTON='
                             || lpad(v_ccg_lhm_menge, 5, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_BECHER='
                             || lpad(v_ccg_lke_menge, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_IN_KARTON='
                             || lpad(v_ccg_menge_in_lhm, 7, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_LAGEN='
                             || lpad(v_ccg_lagen, 7, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_KARTON='
                             || lpad(v_ccg_anz_karton, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_BECHER='
                             || lpad(v_ccg_anz_becher, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_KARTON_PRO_LAGE='
                             || lpad(v_ccg_lhm_pro_lage, 6, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_PRO_LAGE='
                             || lpad(v_ccg_menge_pro_lage, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL='
                             || v_ccg_arttext_kurz
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_ANZ_LAGEN='
                             || v_ccg_kom_lagen
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_KARTON_L_LAGE='
                             || v_ccg_lhm_l_lage
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL_NR='
                             || v_ccg_artikel_nr
                             || chr(13)
                             || chr(10)
                             || 'CCG_LAGE_LAGEN='
                             || v_ccg_lage_lagen
                             || chr(13)
                             || chr(10)
                             || 'CCG_CHARGE='
                             || v_ccg_charge
                             || chr(13)
                             || chr(10)
                             || 'CCG_GEWICHT_KG='
                             || v_ccg_gewicht_kg
                             || chr(13)
                             || chr(10)
                             || 'CCG_PID='
                             || v_ccg_pid
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEA='
                             || v_ccg_barcodea
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEA_STRING='
                             || v_ccg_barcodea_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB='
                             || v_ccg_barcodeb
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB_STRING='
                             || v_ccg_barcodeb_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC='
                             || v_ccg_barcodec
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC_STRING='
                             || v_ccg_barcodec_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED='
                             || v_ccg_barcoded
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED_STRING='
                             || v_ccg_barcoded_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE='
                             || v_ccg_barcodee
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE_STRING='
                             || v_ccg_barcodee_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF='
                             || v_ccg_barcodef
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF_STRING='
                             || v_ccg_barcodef_string;
        else
            v_print_daten := 'CCG_FIRMANAME ='
                             || nvl(v_adresse.name_1, 'Name')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMASTRASSE ='
                             || nvl(v_adresse.strasse, 'Str.')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMAPLZORT ='
                             || nvl(v_adresse.plz, 'PLZ')
                             || ' '
                             || nvl(v_adresse.ort, 'PLZ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR1 ='
                             || 'INTERPORTO S. PALOMBA S.R.L.'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR2 ='
                             || 'Interrporto Palomba'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR3 ='
                             || 'VIA ADREANTINA, KM 22.000'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR4 ='
                             || '00040 S. PALOMBA-POMEZIA RM'
                             || chr(13)
                             || chr(10)
                             || 'CCG_NVE='
                             || v_ccg_nve
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTTEXT='
                             || 'Mischpalette'
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_BECHER='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD_MONAT='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_BECHER='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_IN_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_BECHER='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_PRO_LAGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_KARTON_PRO_LAGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL_NR='
                             || ''
                             || chr(13)
                             || chr(10)
                             || 'CCG_LAGE_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_ANZ_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_KARTON_L_LAGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_CHARGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_GEWICHT_KG='
                             || v_ccg_gewicht_kg
                             || chr(13)
                             || chr(10)
                             || 'CCG_PID='
                             || v_ccg_pid
                             || chr(13)
                             || chr(10)
                             ||
                       --'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string || CHR(13) || CHR(10) ||
                       --'CCG_BARCODEA=' || v_ccg_barcodea || CHR(13) || CHR(10) ||
                              'CCG_BARCODEA='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEA_STRING='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB='
                             || v_ccg_barcodeb
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB_STRING='
                             || v_ccg_barcodeb_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC='
                             || v_ccg_barcodec
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC_STRING='
                             || v_ccg_barcodec_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED='
                             || v_ccg_barcoded
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED_STRING='
                             || v_ccg_barcoded_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE='
                             || v_ccg_barcodee
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE_STRING='
                             || v_ccg_barcodee_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF='
                             || v_ccg_barcodef
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF_STRING='
                             || v_ccg_barcodef_string;
        end if;

        return ( v_print_daten );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
    end ccg_etikett;

  -------------------------------------------------------------------------------------------------------
  -- STD-Etikett druck
  -------------------------------------------------------------------------------------------------------
    function std_etikett (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_id                  in lvs_lte.lte_id%type,
        in_waren_typ           in lvs_lte.waren_typ%type,
        in_format_spez_barcode in isi_adressen.lte_etiketten_spez_barcode%type
    ) return varchar2 is

        i                              number;
        v_artikel                      isi_artikel%rowtype;
        v_charge_bez                   varchar2(100);
        v_prod_datum                   date;
        v_menge                        number;
        v_ean                          varchar2(100);
        v_lfd_nr_str                   varchar2(100);
        v_linie_str                    varchar2(20);
        v_lfd_nr                       number;
        v_print_daten                  varchar2(4096);
        v_found                        boolean;
        v_pos                          isi_order_pos%rowtype;
        v_kopf                         isi_order_kopf%rowtype;
        v_adr                          isi_adressen%rowtype;
        v_art_cfg                      isi_artikel_cfg%rowtype;
        v_art                          isi_artikel%rowtype;
        v_art_kd                       isi_artikel_kunde%rowtype;
        v_charge                       lvs_charge%rowtype;
        v_lte_c                        lvs_lte_cfg%rowtype;
        v_lhm_c                        lvs_lhm_cfg%rowtype;
        v_art_ctrl                     isi_artikel_ctrl%rowtype;
        v_hersteller                   isi_hersteller%rowtype;
        v_id_basis                     varchar2(10);
        v_lte_sid                      lvs_lte.sid%type;
        v_lte_firma_nr                 lvs_lte.firma_nr%type;
        v_lte_lte_id                   lvs_lte.lte_id%type;
        v_lhm_lte_id                   lvs_lte.lte_id%type;
        v_lte_lte_name                 lvs_lte.lte_name%type;
        v_lte_ziel_lgr_platz           lvs_lte.ziel_lgr_platz%type;
        v_lte_lgrort                   lvs_lte.ziel_lgr_ort%type;
        v_lte_lte_akt_lhm              lvs_lte.lte_akt_lhm%type;
        v_lte_order_vorgang_id         lvs_lte.order_vorgang_id%type;
        v_lhm_lhm_name                 lvs_lhm.lhm_name%type;
        v_lam_charge_id                lvs_lam.charge_id%type;
        v_lam_kunden_nr                lvs_lam.kunden_nr%type;
        v_lam_memge                    lvs_lam.menge%type;
        v_lam_memge_basis              lvs_lam.menge_basis%type;
        v_lam_leitzahl                 lvs_lam.leitzahl%type;
        v_lam_zug_datum                lvs_lam.prod_datum%type;
        v_lam_mhd_datum                lvs_lam.prod_datum%type;
        v_lam_prod_datum               lvs_lam.prod_datum%type;
        v_order_pos_auf_id             isi_order_pos.auf_id%type;
        v_lte_id_b                     varchar2(100);
        v_lte_lte_voll                 lvs_lte.lte_voll%type;
        v_lam_zeichnung                lvs_lam.zeichnung%type;
        v_lam_zeichnung_index          lvs_lam.zeichnung_index%type;
        v_lam_best_nr                  lvs_lam.best_nr%type;
        v_fa_auftrag                   bde_fa_auftrag%rowtype;
        v_firma                        isi_firma%rowtype;
        v_bc_format                    isi_firma.lte_barcode_kopf%type;
        v_bc_typ                       isi_firma.lte_barcode_type%type;
        v_hersteller_kuerzel_liste     varchar2(200);
        v_typ                          varchar2(10);
        v_h_tag                        isi_hersteller.tag%type;
        v_netto                        number;
        v_brutto                       number;
        vs_netto                       number;
        vs_brutto                      number;
        vs_tara                        number;
        v_adr_nr                       isi_adressen.adr_nr%type;
        v_adr_liefer                   isi_adressen.adr_liefer%type;
        v_adr_id                       isi_adressen.adress_id%type;
        v_lam_order_pos_auf_id         isi_order_pos.auf_id%type;
        v_lam_lhm_lfd_nr               lvs_lam.lhm_lfd_nr%type;
        v_lam_c_lhm_lfd_nr             lvs_lam.lhm_c_lfd_nr%type;
        v_lam_artikel_id               isi_artikel.artikel_id%type;
        v_lam_art_fanr                 lvs_lam.leitzahl%type;
        v_lam_art_faag                 lvs_lam.fa_ag%type;
        v_lam_art_faupos               lvs_lam.fa_upos%type;
        v_artikel_artikel              isi_artikel.artikel%type;
        v_lieferanten_nr               isi_adressen.adr_nr%type;
        v_best_nr_kunde                isi_order_pos.best_nr_kunde%type;
        v_li_nr_lief                   lvs_lam.li_nr_lief%type;
        v_naechste_maschine            isi_resource.res_ext_name%type;
        v_laborstatus                  lvs_lam.labor_status%type;
        v_laborstatustext              lvs_lam.labor_text%type;
        v_stddatenfeldfuerlieferanten  varchar2(255);
        v_stdgewichtbrutto             varchar2(255);
        v_stdgewichtnetto              varchar2(255);
        v_stdgewichtbrutto_xxxxkxx_me  varchar2(255);
        v_stdgewichtnetto_xxxxkxx_me   varchar2(255);
        v_stdlieferscheinnrbestnr      varchar2(255);
        v_stdlieferscheinnr            varchar2(255);
        v_stdlieferscheinnrlief        varchar2(255);
        v_stdwarenempfaengerkurz       varchar2(255);
        v_stdwarenempfaengerlang1      varchar2(255);
        v_stdwarenempfaengerlang2      varchar2(255);
        v_stdwarenempfaengerlang3      varchar2(255);
        v_stdlagerort                  varchar2(255);
        v_stdabladestelle              varchar2(255);
        v_stdlaborstatus               varchar2(255);
        v_stdlaborstatustext           varchar2(255);
        v_stdanzahlpackstuecke         varchar2(255);
        v_stdfuellmenge                varchar2(255);
        v_stdfuellmengemengeneinheit   varchar2(255);
        v_stdbezeichnunglieferungl     varchar2(255);
        v_stdsachnrlieferant           varchar2(255);
        v_stdsachnrlieferantiskdpackm  varchar2(255);
        v_stdsachnrlieferantzusangaben varchar2(255);
        v_stdsachnrlieferantprodnr     varchar2(255);
        v_stdsachnrlieferantabmessung  varchar2(255);
        v_stdsachnrkunde               varchar2(255);
        v_stddatum                     varchar2(255);
        v_stdproddatum                 varchar2(255);
        v_stdzugdatum                  varchar2(255);
        v_stdmhddatum                  varchar2(255);
        v_stdaenderungkonstruktion     varchar2(255);
        v_stdaenderungkonstruktiono    varchar2(255);
        v_stdaenderungkonstruktionz    varchar2(255);
        v_stdpackstuecknr              varchar2(255);
        v_stdchargennr                 varchar2(255);
        v_stdsachnrkundebarcode        varchar2(255);
        v_stdfuellmengebarcode         varchar2(255);
        v_stdpackstuecknrbarcode       varchar2(255);
        v_stdsachnrlieferantbarcode    varchar2(255);
        v_stdchargennrbarcode          varchar2(255);
        v_stdsachnrlieferantprodnrbarc varchar2(255);
        v_stdnrkundebarcode            varchar2(255);
        v_stdlieferanschriftkurz       varchar2(255);
        v_stdlieferantennr             varchar2(255);
        v_stdlieferantennrbarcode      varchar2(255);
        v_stdlieferantenanschrift1     varchar2(255);
        v_stdlieferantenanschrift2     varchar2(255);
        v_stdlieferantenanschrift3     varchar2(255);
        v_stdlieferantenanschrift4     varchar2(255);
        v_stdbestellnummerkunde        varchar2(255);
        v_stdspezbarcode               varchar2(255);
        v_stdlfdnlteid                 varchar2(255);
        v_stdlfdnlhmid                 varchar2(255);
        v_stdeinsvonx                  varchar2(255);
        v_stdartikelp1                 varchar2(50);
        v_stdartikelp2                 varchar2(50);
        v_stdartikelp3                 varchar2(50);
        v_stdartikelp4                 varchar2(50);
        v_stdartikelp5                 varchar2(50);
        v_stdartikelp6                 varchar2(50);
        v_stdartikelp7                 varchar2(50);
        v_stdartikelp8                 varchar2(50);
        v_stdartikelp9                 varchar2(50);
        v_stdartikelp10                varchar2(50);
        v_stdpackstuecknrmenge         varchar2(255);
        v_stdpackstuecknrsollmenge     varchar2(255);
        v_artsollmenge                 varchar2(255);
        v_stdfelgentyp                 varchar2(255);
        v_stdventil                    varchar2(255);
        v_stdreifentyp                 varchar2(255);
        v_stdreifenhersteller          varchar2(255);
        v_stdtyp                       varchar2(255);
        v_stdetidatum                  varchar2(255);
        v_stdetizeit                   varchar2(255);
        cursor c_lte is
        select
            lte.sid,
            lte.firma_nr,
            lte.lte_id,
            lte.lte_id,
            lte.lte_name,
            nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
            nvl(lte.ziel_lgr_ort, lte.lgr_ort)     lgr_ort,
            stradd_distinct(lam.labor_status)      labor_status,
            stradd_distinct(lam.labor_text)        labor_text,
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
            decode(
                min(lam.charge_id),
                max(lam.charge_id),
                min(lam.charge_id),
                null
            )                                      charge_id,
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
                trunc(min(lam.lam_mhd)),
                trunc(max(lam.lam_mhd)),
                trunc(min(lam.lam_mhd)),
                null
            )                                      lam_mhd,
            decode(
                trunc(min(lam.zug_datum)),
                trunc(max(lam.zug_datum)),
                trunc(min(lam.zug_datum)),
                null
            )                                      zug_datum,
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
                min(lam.fa_upos),
                max(lam.fa_upos),
                min(lam.fa_upos),
                null
            )                                      fa_upos,
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
            stradd_distinct(lam.hersteller_kuerzel_liste)
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
            lte.lgr_platz,
            lte.lgr_ort,
            lte.ziel_lgr_ort;

        cursor c_lhm is
        select
            lam.sid,
            lam.firma_nr,
            lhm.lhm_id,
            lam.lte_id,
            lhm.lhm_name,
            nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
            nvl(lte.ziel_lgr_ort, lte.lgr_ort)     lgr_ort,
            stradd_distinct(lam.labor_status)      labor_status,
            stradd_distinct(lam.labor_text)        labor_text,
            '1',
            lte.order_vorgang_id,
            'V',
            decode(
                min(lhm.lhm_name),
                max(lhm.lhm_name),
                min(lhm.lhm_name),
                null
            )                                      lhm_name,
            decode(
                min(lam.charge_id),
                max(lam.charge_id),
                min(lam.charge_id),
                null
            )                                      charge_id,
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
                trunc(min(lam.lam_mhd)),
                trunc(max(lam.lam_mhd)),
                trunc(min(lam.lam_mhd)),
                null
            )                                      lam_mhd,
            decode(
                trunc(min(lam.zug_datum)),
                trunc(max(lam.zug_datum)),
                trunc(min(lam.zug_datum)),
                null
            )                                      zug_datum,
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
                min(lam.fa_upos),
                max(lam.fa_upos),
                min(lam.fa_upos),
                null
            )                                      fa_upos,
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
            max(lam.lhm_lfd_nr),
            max(lam.lhm_c_lfd_nr),
            stradd_distinct(lam.hersteller_kuerzel_liste)
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
            lam.lte_id,
            lhm.lhm_id,
            lhm.lhm_name,
            lte.ziel_lgr_platz,
            lte.lgr_platz,
            lte.lgr_ort,
            lte.ziel_lgr_ort;

        cursor c_firma is
        select
            *
        from
            isi_firma t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr;

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

        cursor c_art_artikel is
        select
            art.bezeichnung1
        from
            isi_artikel art
        where
                art.sid = v_lte_sid
            and art.artikel = v_artikel_artikel;

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
        v_stddatenfeldfuerlieferanten := null;
        v_stdgewichtnetto := null;
        v_stdgewichtbrutto := null;
        v_stdgewichtnetto_xxxxkxx_me := null;
        v_stdgewichtbrutto_xxxxkxx_me := null;
        v_stdlieferscheinnrbestnr := null;
        v_stdlieferscheinnr := null;
        v_stdlieferscheinnrlief := null;
        v_stdwarenempfaengerkurz := null;
        v_stdwarenempfaengerlang1 := null;
        v_stdwarenempfaengerlang2 := null;
        v_stdwarenempfaengerlang3 := null;
        v_stdlagerort := null;
        v_stdabladestelle := null;
        v_stdlaborstatus := null;
        v_stdlaborstatustext := null;
        v_stdanzahlpackstuecke := null;
        v_stdfuellmenge := null;
        v_stdfuellmengemengeneinheit := null;
        v_stdbezeichnunglieferungl := null;
        v_stdsachnrlieferant := null;
        v_stdsachnrlieferantiskdpackm := null;
        v_stdsachnrlieferantzusangaben := null;
        v_stdsachnrlieferantprodnr := null;
        v_stdsachnrlieferantabmessung := null;
        v_stdsachnrkunde := null;
        v_stddatum := null;
        v_stdproddatum := null;
        v_stdzugdatum := null;
        v_stdmhddatum := null;
        v_stdaenderungkonstruktion := null;
        v_stdaenderungkonstruktiono := null;
        v_stdaenderungkonstruktionz := null;
        v_stdpackstuecknr := null;
        v_stdchargennr := null;
        v_stdlieferantennr := null;
        v_stdsachnrkundebarcode := null;
        v_stdfuellmengebarcode := null;
        v_stdpackstuecknrbarcode := null;
        v_stdsachnrlieferantbarcode := null;
        v_stdchargennrbarcode := null;
        v_stdsachnrlieferantprodnrbarc := null;
        v_stdnrkundebarcode := null;
        v_stdlieferantennrbarcode := null;
        v_stdlieferantenanschrift1 := null;
        v_stdlieferantenanschrift2 := null;
        v_stdlieferantenanschrift3 := null;
        v_stdlieferantenanschrift4 := null;
        v_stdspezbarcode := null;
        v_stdlfdnlteid := null;
        v_stdlfdnlhmid := null;
        v_stdeinsvonx := null;
        v_stdpackstuecknrmenge := null;
        v_stdpackstuecknrsollmenge := null;
        v_stdfelgentyp := null;
        v_stdventil := null;
        v_stdreifentyp := null;
        v_stdreifenhersteller := null;
        v_stdtyp := null;
        v_stdetidatum := to_char(sysdate, 'dd.mm.yy');
        v_stdetizeit := to_char(sysdate, 'hh24:mi:ss');
        open c_firma;
        fetch c_firma into v_firma;
        close c_firma;
        v_lam_art_fanr := null;
        v_lam_art_faag := null;
        v_lam_art_faupos := null;
        if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = c.basis_lte then
            v_id_basis := 'LTE';
            open c_lte;
            fetch c_lte into
                v_lte_sid,
                v_lte_firma_nr,
                v_lte_lte_id,
                v_lhm_lte_id,
                v_lte_lte_name,
                v_lte_ziel_lgr_platz,
                v_lte_lgrort,
                v_laborstatus,
                v_laborstatustext,
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
                v_lam_mhd_datum,
                v_lam_zug_datum,
                v_lam_prod_datum,
                v_lam_zeichnung,
                v_lam_zeichnung_index,
                v_lam_artikel_id,
                v_lam_art_fanr,
                v_lam_art_faag,
                v_lam_art_faupos,
                v_lieferanten_nr,
                v_li_nr_lief,
                v_hersteller_kuerzel_liste;

            v_found := c_lte%found;
            close c_lte;
            open c_lte_c;
            fetch c_lte_c into v_lte_c;
            if c_lte_c%found then
                v_stddatenfeldfuerlieferanten := v_lte_c.lte_text;
            end if;
            close c_lte_c;
            open c_fa_auf_lte;
            fetch c_fa_auf_lte into v_stdbestellnummerkunde;
            if c_fa_auf_lte%notfound then
                v_stdbestellnummerkunde := null;
            end if;
            close c_fa_auf_lte;
            open c_pos_lte_all;
            fetch c_pos_lte_all into v_best_nr_kunde;
            if c_pos_lte_all%found then
                v_stdbestellnummerkunde := v_best_nr_kunde;
            end if;
            close c_pos_lte_all;
        elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = c.basis_lhm then
            v_id_basis := 'LHM';
            open c_lhm;
            fetch c_lhm into
                v_lte_sid,
                v_lte_firma_nr,
                v_lte_lte_id,
                v_lhm_lte_id,
                v_lte_lte_name,
                v_lte_ziel_lgr_platz,
                v_lte_lgrort,
                v_laborstatus,
                v_laborstatustext,
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
                v_lam_mhd_datum,
                v_lam_zug_datum,
                v_lam_prod_datum,
                v_lam_zeichnung,
                v_lam_zeichnung_index,
                v_lam_artikel_id,
                v_lam_art_fanr,
                v_lam_art_faag,
                v_lam_art_faupos,
                v_lieferanten_nr,
                v_li_nr_lief,
                v_lam_lhm_lfd_nr,
                v_lam_c_lhm_lfd_nr,
                v_hersteller_kuerzel_liste;

            v_found := c_lhm%found;
            close c_lhm;
            open c_lhm_c;
            fetch c_lhm_c into v_lhm_c;
            if c_lhm_c%found then
                v_stddatenfeldfuerlieferanten := v_lhm_c.lhm_text;
            end if;
            close c_lhm_c;
            open c_fa_auf_lhm;
            fetch c_fa_auf_lhm into v_stdbestellnummerkunde;
            if c_fa_auf_lhm%notfound then
                v_stdbestellnummerkunde := null;
            end if;
            close c_fa_auf_lhm;
            open c_pos_lhm_all;
            fetch c_pos_lhm_all into v_best_nr_kunde;
            if c_pos_lhm_all%found then
                v_stdbestellnummerkunde := v_best_nr_kunde;
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

    -- Wenn Artikelrein, dann wird der Artikelstamm jetzt gelesen
        open c_art;
        fetch c_art into v_art;
        if c_art%notfound then
            v_art := null;
        end if;
        close c_art;
        v_stdlaborstatus := v_laborstatus;
        v_stdlaborstatustext := v_laborstatustext;
        if
            v_hersteller_kuerzel_liste is not null
            and v_hersteller_kuerzel_liste != ';'
            and isi_p_base.get_artikel_ctrl_typ(in_sid,
                                                v_lam_artikel_id,
                                                substr(v_hersteller_kuerzel_liste,
                                                       1,
                                                       length(v_hersteller_kuerzel_liste) - 1),
                                                v_art_ctrl)
        then
            v_typ := v_art_ctrl.prod_params;
            v_stdtyp := v_art_ctrl.prod_params;
        else
            v_typ := '0000000000';
        end if;

        if
            v_hersteller_kuerzel_liste is not null
            and v_hersteller_kuerzel_liste != ';'
            and isi_p_base.get_hersteller(
                substr(v_hersteller_kuerzel_liste,
                       1,
                       length(v_hersteller_kuerzel_liste) - 1),
                v_hersteller
            )
        then
            v_h_tag := v_hersteller.tag;
            v_stdreifenhersteller := v_hersteller.hersteller;
        else
            v_h_tag := rpad('0', 20, '0');
        end if;

        v_stdartikelp1 := v_art.artikel_p1;  -- Hersteller Reifen
        v_stdartikelp2 := v_art.artikel_p2;  -- Hersteller Reifen TAG
        v_stdartikelp3 := v_art.artikel_p3;  -- ???
        v_stdartikelp4 := v_art.artikel_p4;  -- Laufrichtung
        v_stdartikelp5 := v_art.artikel_p5;  -- Ehmals Schenk Typ
        v_stdartikelp6 := v_art.artikel_p6;  -- Artikel Reifen
        v_stdartikelp7 := v_art.artikel_p7;  -- Artikel Felge
        v_stdartikelp8 := v_art.artikel_p8;  -- Artikel Ventil
        v_stdartikelp9 := v_art.artikel_p9;  -- Artikel Gewicht
        v_stdartikelp10 := v_art.artikel_p10;
        v_artikel_artikel := v_stdartikelp6;
        open c_art_artikel;
        fetch c_art_artikel into v_stdreifentyp;
        close c_art_artikel;
        v_artikel_artikel := v_art.artikel_p7;
        open c_art_artikel;
        fetch c_art_artikel into v_stdfelgentyp;
        close c_art_artikel;
        v_artikel_artikel := v_art.artikel_p8;
        open c_art_artikel;
        fetch c_art_artikel into v_stdventil;
        close c_art_artikel;
        if v_art.lte_lhm_menge = 0 then
            v_art.lte_lhm_menge := 1;
        end if;
        if v_id_basis = 'LHM' then
            v_artsollmenge := v_art.lhm_menge;
            vs_netto := v_art.abfuell_soll / v_art.lte_lhm_menge;
            vs_brutto := v_art.lhm_gewicht_kg;
            if isi_allg.get_artikel_cfg(in_sid, v_art_cfg) then
                case v_art_cfg.artikel_p1_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p1 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p1 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p2_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p2 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p2 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p3_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p3 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p3 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p4_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p4 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p4 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p5_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p5 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p5 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p6_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p6 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p6 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p7_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p7 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p7 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p8_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p8 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p8 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p9_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p9 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p9 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p10_text
                    when 'ART_ETI_SACKGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p10 );
                    when 'ART_GROSS_EINZEL_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p10 );
                    else
                        null;
                end case;

            end if;

            vs_tara := vs_brutto - vs_netto;
      -- -AG- Nur wenn gewicht genau passt dann aus Vorgabe
      --if  v_art.abfuell_toleranz_plus  < v_lam_memge
      --or v_art.abfuell_toleranz_minus > v_lam_memge
            if v_art.lhm_menge != v_lam_memge then
                v_brutto := v_netto + nvl(vs_tara, 0);
            else
                v_brutto := vs_brutto;
                v_netto := vs_netto;
            end if;

        else
            v_artsollmenge := v_art.lte_menge;
            vs_netto := v_art.abfuell_soll;
            vs_brutto := v_art.lte_gewicht_kg;
            if isi_allg.get_artikel_cfg(in_sid, v_art_cfg) then
                case v_art_cfg.artikel_p1_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p1 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p1 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p2_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p2 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p2 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p3_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p3 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p3 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p4_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p4 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p4 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p5_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p5 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p5 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p6_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p6 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p6 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p7_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p7 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p7 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p8_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p8 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p8 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p9_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p9 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p9 );
                    else
                        null;
                end case;

                case v_art_cfg.artikel_p10_text
                    when 'ART_ETI_PALGEWICHT' then
                        vs_netto := to_number ( v_art.artikel_p10 );
                    when 'ART_GROSS_GESAMT_GEBINDE' then
                        vs_brutto := to_number ( v_art.artikel_p10 );
                    else
                        null;
                end case;

            end if;

            vs_tara := vs_brutto - vs_netto;

      -- -AG- Nur wenn gewicht genau passt dann aus Vorgabe
      --if  v_art.abfuell_toleranz_plus  < v_lam_memge / v_art.lte_lhm_menge
      --or v_art.abfuell_toleranz_minus > v_lam_memge / v_art.lte_lhm_menge
            if v_art.lhm_menge != v_lam_memge / v_art.lte_lhm_menge then
                v_brutto := v_netto + nvl(vs_tara, 0);
            else
                v_brutto := vs_brutto;
                v_netto := vs_netto;
            end if;

        end if;

        if v_found then
            v_stdgewichtnetto := v_netto;
            v_stdgewichtbrutto := v_brutto;
            v_stdgewichtnetto_xxxxkxx_me := to_char(v_netto * 100, '9990,99')
                                            || ' '
                                            || v_art.mengeneinheit_basis;

            v_stdgewichtbrutto_xxxxkxx_me := to_char(v_brutto * 100, '9990,99')
                                             || ' '
                                             || v_art.mengeneinheit_basis;

            v_stdlieferscheinnrbestnr := v_lam_best_nr;
            v_stdabladestelle := v_lte_ziel_lgr_platz;
            v_stdlagerort := v_lte_lgrort;
            v_stdsachnrlieferantprodnr := v_lam_leitzahl;
            v_stdsachnrlieferantiskdpackm := v_lte_lte_name;
            v_stdsachnrlieferantzusangaben := v_lhm_lhm_name;
            v_stdanzahlpackstuecke := v_lte_lte_akt_lhm;
            v_stdsachnrlieferant := v_art.artikel;
            v_stdfuellmenge := v_lam_memge;
            v_stdbezeichnunglieferungl := v_art.bezeichnung1;
            v_stdsachnrlieferantabmessung := v_art.bezeichnung2;
            v_stdaenderungkonstruktiono := v_art.bezeichnung3;
            if v_lam_prod_datum is not null then
                v_stddatum := to_char(v_lam_prod_datum, 'YYMMDD');
                v_stdproddatum := to_char(v_lam_prod_datum, 'dd.mm.yyyy');
            end if;

            if v_lam_mhd_datum is not null then
                v_stdmhddatum := to_char(v_lam_mhd_datum, 'dd.mm.yyyy');
            end if;

            if v_lam_zug_datum is not null then
                v_stdzugdatum := to_char(v_lam_zug_datum, 'dd.mm.yyyy');
            end if;

            v_stdaenderungkonstruktionz := v_lam_zeichnung;
            v_stdaenderungkonstruktion := v_lam_zeichnung_index;
            if v_lam_leitzahl is not null then
                v_stdsachnrlieferantprodnrbarc := v_lam_leitzahl;
            end if;
            if v_art.artikel is not null then
                v_stdsachnrlieferantbarcode := v_art.artikel;
            end if;
            v_stdfuellmengebarcode := v_lam_memge;
            open c_charge;
            fetch c_charge into v_charge;
            v_found := c_charge%found;
            close c_charge;
            if v_found then
                v_stdchargennr := v_charge.charge_bez;
                v_stdchargennrbarcode := v_charge.charge_bez;
            end if;

            v_stdlieferantennr := v_lieferanten_nr;
            v_stdlieferscheinnrlief := v_li_nr_lief;
            v_stdlieferantennrbarcode := v_lieferanten_nr;
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
                    v_stdwarenempfaengerkurz := v_adr.name_1;
                    v_stdwarenempfaengerlang1 := v_adr.name_1;
                    v_stdwarenempfaengerlang2 := v_adr.name_2;
                    v_stdwarenempfaengerlang3 := v_adr.plz
                                                 || ' '
                                                 || v_adr.ort;
                end if;

            else
                open c_kopf;
                fetch c_kopf into v_kopf;
                if v_found then
                    v_adr_id := v_kopf.adress_id;
                    v_stdlieferscheinnr := to_char(v_kopf.vorgang_id);
                    if v_kopf.wae_ziel is not null then
                        v_stdabladestelle := v_kopf.wae_ziel;
                    end if;
                    open c_adr;
                    fetch c_adr into v_adr;
                    v_found := c_adr%found;
                    if v_found then
                        v_stdwarenempfaengerkurz := v_adr.name_1;
                        v_stdwarenempfaengerlang1 := v_adr.name_1;
                        v_stdwarenempfaengerlang2 := v_adr.name_2;
                        v_stdwarenempfaengerlang3 := v_adr.plz
                                                     || ' '
                                                     || v_adr.ort;
                        v_stdabladestelle := nvl(v_kopf.wae_ziel, v_stdabladestelle);
                        v_adr_nr := v_adr.adr_nr;
                    end if;

                    close c_adr;
                    v_adr_id := v_kopf.order_adress_id;
                    open c_adr;
                    fetch c_adr into v_adr;
                    v_found := c_adr%found;
                    close c_adr;
                    if v_found then
                        v_stdlieferanschriftkurz := v_adr.name_1;
                    end if;
                else
                    v_adr_nr := v_lam_kunden_nr;
                    open c_kunde;
                    fetch c_kunde into v_adr;
                    v_found := c_kunde%found;
                    close c_kunde;
                    if v_found then
                        v_stdwarenempfaengerkurz := v_adr.name_1
                                                    || ' '
                                                    || v_adr.name_2
                                                    || ' '
                                                    || v_adr.plz
                                                    || ' '
                                                    || v_adr.ort;

                        v_stdwarenempfaengerlang1 := v_adr.name_1;
                        v_stdwarenempfaengerlang2 := v_adr.name_2;
                        v_stdwarenempfaengerlang3 := v_adr.plz
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
                v_stdlieferantenanschrift1 := v_adr.name_1;
                v_stdlieferantenanschrift2 := v_adr.name_2;
                v_stdlieferantenanschrift3 := v_adr.name_3;
                v_stdlieferantenanschrift4 := v_adr.name_1
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
                    v_stdsachnrkundebarcode := v_art_kd.kd_art_nr;
                    v_stdsachnrkunde := v_art_kd.kd_art_nr;
                end if;

            end if;

        end if;

        v_print_daten := '';
        v_stdpackstuecknr := in_id;
        v_stdpackstuecknrbarcode := in_id;
        if v_id_basis = 'LTE' then
            v_bc_format := v_firma.lte_barcode_kopf;
            v_bc_typ := v_firma.lte_barcode_type;
        else
            v_bc_format := v_firma.lhm_barcode_kopf;
            v_bc_typ := v_firma.lhm_barcode_type;
        end if;

        if isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,

         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,

         'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                         'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                         'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                         'BOOLEAN') = c.c_true     -- in_default_param_typ
                                         then
            v_stdpackstuecknr := v_lhm_lte_id;
            v_stdpackstuecknrbarcode := v_lhm_lte_id;
            v_bc_format := v_firma.lte_barcode_kopf;
            v_bc_typ := v_firma.lte_barcode_type;
        end if;

        v_stdspezbarcode := null;
        if in_format_spez_barcode is not null then
            v_lfd_nr := lvs_p_lte.get_barcode_lfdn(in_sid, in_format_spez_barcode, v_lte_lte_id);
            v_stdspezbarcode := lvs_p_lte.format_barcode(in_sid,                         -- in_sid        in lvs_charge.sid%type,
                                                         in_format_spez_barcode,         -- in_format     in varchar2,
                                                         v_lfd_nr,                       -- in_nummer     in number,
                                                         length(in_format_spez_barcode), -- in_laenge     in number,
                                                         null,                           -- in_seq_basis  in varchar2,
                                                         v_stdchargennrbarcode,          -- in_charge     in lvs_charge.charge_bez%type,
                                                         v_lam_artikel_id,               -- in_artikel_id in isi_artikel.artikel_id%type,
                                                         null,                           -- in_basis_id   in varchar2
                                                         v_lam_memge,
                                                         v_typ,                   -- Typ für Barcode hier nicht bekannt, Pruefen
                                                         v_h_tag);

        end if;

        if v_bc_typ = 'SPEZ' then
            lvs_p_lte_lhm.spez_barcode_result(in_sid,                      -- in_sid        in lvs_charge.sid%type,
             in_firma_nr, v_stdpackstuecknr,            -- in  lvs_lam.lhm_id%type,
             v_bc_format,                 -- in  isi_firma_cfg.parameter_wert%type,
             v_artikel,                   -- out_artikel
                                              v_charge_bez,                -- out varchar2,
                                               v_prod_datum,                -- out date,
                                               v_menge,                     -- out number,
                                               v_ean,                       -- out varchar2
                                               v_lfd_nr_str,            -- out varchar2
                                              v_linie_str);            -- out varchar2
     -- BugFix LHM-Druck mit lfdn der Einheit
            if v_id_basis = 'LTE' then
                v_stdlfdnlteid := lpad(v_lfd_nr_str, 2, '0');
            else
                if isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'ET_CHARGE_LHM_LFDN',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                 'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                 'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                 'BOOLEAN') = c.c_true     -- in_default_param_typ
                                                 then
                    v_stdlfdnlhmid := lpad(v_lam_c_lhm_lfd_nr, 2, '0');
                else
                    v_stdlfdnlhmid := lpad(v_lam_lhm_lfd_nr, 2, '0');
                end if;
            end if;

            v_lfd_nr := lvs_p_lte.get_barcode_lfdn(in_sid, v_bc_format, v_stdpackstuecknr);
     -- Sollmenge wie als Barcodemenge ermitteln
            v_stdpackstuecknr := lvs_p_lte.format_barcode(in_sid,                           -- in_sid        in lvs_charge.sid%type,
                                                          v_bc_format,                      -- in_format     in varchar2,
                                                          v_lfd_nr,                         -- in_nummer     in number,
                                                          length(v_bc_format),              -- in_laenge     in number,
                                                          null,                             -- in_seq_basis  in varchar2,
                                                          v_stdchargennrbarcode,            -- in_charge     in lvs_charge.charge_bez%type,
                                                          v_lam_artikel_id,                 -- in_artikel_id in isi_artikel.artikel_id%type,
                                                          null,                             -- in_basis_id   in varchar2
                                                          v_artsollmenge,
                                                          v_typ,
                                                          v_h_tag);

            v_stdpackstuecknrbarcode := v_stdpackstuecknr;
            for i in 1..length(v_stdpackstuecknr) loop
                if upper(substr(v_bc_format, i, 1)) = 'M' then
                    if v_stdpackstuecknrsollmenge is null then
                        v_stdpackstuecknrsollmenge := substr(v_stdpackstuecknr, i, 1);
                    else
                        v_stdpackstuecknrsollmenge := v_stdpackstuecknrsollmenge
                                                      || substr(v_stdpackstuecknr, i, 1);
                    end if;

                end if;
            end loop;

            v_stdpackstuecknr := lvs_p_lte.format_barcode(in_sid,                           -- in_sid        in lvs_charge.sid%type,
                                                          v_bc_format,                      -- in_format     in varchar2,
                                                          v_lfd_nr,                         -- in_nummer     in number,
                                                          length(v_bc_format),              -- in_laenge     in number,
                                                          null,                             -- in_seq_basis  in varchar2,
                                                          v_stdchargennrbarcode,            -- in_charge     in lvs_charge.charge_bez%type,
                                                          v_lam_artikel_id,                 -- in_artikel_id in isi_artikel.artikel_id%type,
                                                          null,                             -- in_basis_id   in varchar2
                                                          v_lam_memge,
                                                          v_typ,
                                                          v_h_tag);

            v_stdpackstuecknrbarcode := v_stdpackstuecknr;
            for i in 1..length(v_stdpackstuecknr) loop
                if upper(substr(v_bc_format, i, 1)) = 'M' then
                    if v_stdpackstuecknrmenge is null then
                        v_stdpackstuecknrmenge := substr(v_stdpackstuecknr, i, 1);
                    else
                        v_stdpackstuecknrmenge := v_stdpackstuecknrmenge
                                                  || substr(v_stdpackstuecknr, i, 1);
                    end if;

                end if;
            end loop;

        end if;

        if
            v_firma.lhm_barcode_type = 'SPEZ'
            and v_id_basis = 'LHM'
            and ( isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                'BOOLEAN') = c.c_true )    -- in_default_param_typ
        then
            lvs_p_lte_lhm.spez_barcode_result(in_sid, in_firma_nr, in_id,                       -- in  lvs_lam.lhm_id%type,
             v_firma.lhm_barcode_kopf,    -- in  isi_firma_cfg.parameter_wert%type,
             v_artikel,                   -- out_artikel
                                              v_charge_bez,                -- out varchar2,
                                               v_prod_datum,                -- out date,
                                               v_menge,                     -- out number,
                                               v_ean,                       -- out varchar2
                                               v_lfd_nr_str,            -- out varchar2
                                              v_linie_str);            -- out varchar2
            if v_id_basis = 'LTE' then
                v_stdlfdnlhmid := to_char(to_number(v_lfd_nr_str));
            else
                v_stdlfdnlhmid := to_char(to_number(v_lam_lhm_lfd_nr));
            end if;

            if length(v_stdlfdnlhmid) < 2 then
                v_stdlfdnlhmid := lpad(v_stdlfdnlhmid, 2, '0');
            end if;

        end if;

        if bde_p_base.get_fa_ag(v_lte_sid, v_lte_firma_nr, v_lam_art_fanr, v_lam_art_faag, v_lam_art_faupos,
                                v_fa_auftrag) then
            if v_fa_auftrag.lte_name = 'Faß' then
                v_fa_auftrag.lte_name := 'Fass';
            end if;
            v_stdeinsvonx := v_fa_auftrag.lte_name
                             || ' 1-'
                             || to_char(v_fa_auftrag.lhm_anz);
        else
            v_stdeinsvonx := null;
        end if;
   
   --Herstellerkuerzel immer hinter der Artikel Bezeichnung
        if v_hersteller.kuerzel is not null then
            v_stdsachnrlieferant := v_stdsachnrlieferant
                                    || ' ('
                                    || v_hersteller.kuerzel
                                    || ')';
        end if;

        v_print_daten := 'stdSachNrLieferantDatenfeldFuerLieferanten='
                         || v_stddatenfeldfuerlieferanten
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtBrutto='
                         || v_stdgewichtbrutto
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtNetto='
                         || v_stdgewichtnetto
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtBrutto_xxxxKxx_Einheit='
                         || v_stdgewichtbrutto_xxxxkxx_me
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtNetto_xxxxKxx_Einheit='
                         || v_stdgewichtnetto_xxxxkxx_me
                         || chr(13)
                         || chr(10)
                         || 'stdLieferscheinNrBestellnummer='
                         || v_stdlieferscheinnrbestnr
                         || chr(13)
                         || chr(10)
                         || 'stdLieferscheinNr='
                         || v_stdlieferscheinnr
                         || chr(13)
                         || chr(10)
                         || 'stdLieferscheinNrLief='
                         || v_stdlieferscheinnrlief
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerKurz='
                         || v_stdwarenempfaengerkurz
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerLang1='
                         || v_stdwarenempfaengerlang1
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerLang2='
                         || v_stdwarenempfaengerlang2
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerLang3='
                         || v_stdwarenempfaengerlang3
                         || chr(13)
                         || chr(10)
                         || 'stdLagerOrt='
                         || v_stdlagerort
                         || chr(13)
                         || chr(10)
                         || 'stdLaborStatus='
                         || v_stdlaborstatus
                         || chr(13)
                         || chr(10)
                         || 'stdLaborStatusText='
                         || v_stdlaborstatustext
                         || chr(13)
                         || chr(10)
                         || 'stdAbladestelle='
                         || v_stdabladestelle
                         || chr(13)
                         || chr(10)
                         || 'stdAnzahlPackstuecke='
                         || v_stdanzahlpackstuecke
                         || chr(13)
                         || chr(10)
                         || 'stdFuellmenge='
                         || v_stdfuellmenge
                         || chr(13)
                         || chr(10)
                         || 'stdFuellmengeMengeneinheit='
                         || v_stdfuellmengemengeneinheit
                         || chr(13)
                         || chr(10)
                         || 'stdBezeichnungLieferungLeistung='
                         || v_stdbezeichnunglieferungl
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferant='
                         || v_stdsachnrlieferant
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantISKDPackmittel='
                         || v_stdsachnrlieferantiskdpackm
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantZusAngaben='
                         || v_stdsachnrlieferantzusangaben
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantProduktionsNr='
                         || v_stdsachnrlieferantprodnr
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantAbmessung='
                         || v_stdsachnrlieferantabmessung
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrKunde='
                         || v_stdsachnrkunde
                         || chr(13)
                         || chr(10)
                         || 'stdTyp='
                         || v_stdtyp
                         || chr(13)
                         || chr(10)
                         || 'stdDatum='
                         || v_stddatum
                         || chr(13)
                         || chr(10)
                         || 'stdProdDatum='
                         || v_stdproddatum
                         || chr(13)
                         || chr(10)
                         || 'stdZugDatum='
                         || v_stdzugdatum
                         || chr(13)
                         || chr(10)
                         || 'stdMhdDatum='
                         || v_stdmhddatum
                         || chr(13)
                         || chr(10)
                         || 'stdAenderungKonstruktion='
                         || v_stdaenderungkonstruktion
                         || chr(13)
                         || chr(10)
                         || 'stdAenderungKonstruktionOberflaeche='
                         || v_stdaenderungkonstruktiono
                         || chr(13)
                         || chr(10)
                         || 'stdAenderungKonstruktionZeichnung='
                         || v_stdaenderungkonstruktionz
                         || chr(13)
                         || chr(10)
                         || 'stdPackstueckNr='
                         || v_stdpackstuecknr
                         || chr(13)
                         || chr(10)
                         || 'stdChargenNr='
                         || v_stdchargennr
                         || chr(13)
                         || chr(10)
                         || 'stdLieferantenNr='
                         || v_stdlieferantennr
                         || chr(13)
                         || chr(10)
                         || 'stdLieferantenanschriftLang='
                         || v_stdlieferantenanschrift4
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrKundeBarcode='
                         || v_stdsachnrkundebarcode
                         || chr(13)
                         || chr(10)
                         || 'stdFuellmengeBarcode='
                         || v_stdfuellmengebarcode
                         || chr(13)
                         || chr(10)
                         || 'stdPackstueckNrBarcode='
                         || v_stdpackstuecknrbarcode
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantBarcode='
                         || v_stdsachnrlieferantbarcode
                         || chr(13)
                         || chr(10)
                         || 'stdChangenNrBarcode='
                         || v_stdchargennrbarcode
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantProduktionsNrBarcode='
                         || v_stdsachnrlieferantprodnrbarc
                         || chr(13)
                         || chr(10)
                         || 'stdNrKundeBarcode='
                         || v_stdnrkundebarcode
                         || chr(13)
                         || chr(10)
                         || 'stdLieferantenNrBarcode='
                         || v_stdlieferantennrbarcode
                         || chr(13)
                         || chr(10)
                         || 'stdLfdnLteID='
                         || v_stdlfdnlteid
                         || chr(13)
                         || chr(10)
                         || 'stdLfdnLhmID='
                         || v_stdlfdnlhmid
                         || chr(13)
                         || chr(10)
                         || 'stdEinsVonX='
                         || v_stdeinsvonx
                         || chr(13)
                         || chr(10)
                         || 'stdSpezBarcode='
                         || v_stdspezbarcode
                         || chr(13)
                         || chr(10)
                         || 'stdPackstueckNrMenge='
                         || v_stdpackstuecknrmenge
                         || chr(13)
                         || chr(10)
                         || 'stdPackstueckNrSollMenge='
                         || v_stdpackstuecknrsollmenge
                         || chr(13)
                         || chr(10)
                         || 'stdReifenTyp='
                         || v_stdreifentyp
                         || chr(13)
                         || chr(10)
                         || 'stdFelgenTyp='
                         || v_stdfelgentyp
                         || chr(13)
                         || chr(10)
                         || 'stdVentil='
                         || v_stdventil
                         || chr(13)
                         || chr(10)
                         || 'stdstdTyp='
                         || v_stdtyp
                         || chr(13)
                         || chr(10)
                         || 'stdReifenHersteller='
                         || v_stdreifenhersteller
                         || chr(13)
                         || chr(10)
                         || 'stdEtiDatum='
                         || v_stdetidatum
                         || chr(13)
                         || chr(10)
                         || 'stdEtiZeit='
                         || v_stdetizeit
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP1='
                         || v_stdartikelp1
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP2='
                         || v_stdartikelp2
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP3='
                         || v_stdartikelp3
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP4='
                         || v_stdartikelp4
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP5='
                         || v_stdartikelp5
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP6='
                         || v_stdartikelp6
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP7='
                         || v_stdartikelp7
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP8='
                         || v_stdartikelp8
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP9='
                         || v_stdartikelp9
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP10='
                         || v_stdartikelp10;

        return ( v_print_daten );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
    end std_etikett;

    procedure c_test_etikett (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_drucker  in pe_drucker_cfg.drucker_name%type
    ) is

        v_print_daten varchar2(4096);
        v_firma       isi_firma%rowtype;
        v_etikett     isi_etiketten%rowtype;
        v_job_nr      number;
        v_found       boolean;
        cursor c_etikett is
        select
            *
        from
            isi_etiketten t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.etiketten_name = v_firma.lhm_etikett_fw;

    begin
        if not isi_p_base.get_isi_firma(in_sid, in_firma_nr, v_firma) then
            return;
        end if;
        open c_etikett;
        fetch c_etikett into v_etikett;
        v_found := c_etikett%found;
        close c_etikett;
        if not v_found then
            return;
        end if;
        v_print_daten := 'stdSachNrLieferantDatenfeldFuerLieferanten='
                         || 'DatFeld'
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtBrutto='
                         || '125'
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtNetto='
                         || '100'
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtBrutto_xxxxKxx_Einheit='
                         || '120,00 Kg'
                         || chr(13)
                         || chr(10)
                         || 'stdGewichtNetto_xxxxKxx_Einheit='
                         || '100,00 Kg'
                         || chr(13)
                         || chr(10)
                         || 'stdLieferscheinNrBestellnummer='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdLieferscheinNr='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdLieferscheinNrLief='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerKurz='
                         || 'EmpfKurz'
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerLang1='
                         || 'EmpfLang1'
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerLang2='
                         || 'EmpfLang2'
                         || chr(13)
                         || chr(10)
                         || 'stdWarenempfaengerLang3='
                         || 'EmpfLang3'
                         || chr(13)
                         || chr(10)
                         || 'stdAbladestelle='
                         || 'Platz'
                         || chr(13)
                         || chr(10)
                         || 'stdAnzahlPackstuecke='
                         || '01'
                         || chr(13)
                         || chr(10)
                         || 'stdFuellmenge='
                         || '1234'
                         || chr(13)
                         || chr(10)
                         || 'stdFuellmengeMengeneinheit='
                         || 'Stk'
                         || chr(13)
                         || chr(10)
                         || 'stdBezeichnungLieferungLeistung='
                         || 'Test'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferant='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantISKDPackmittel='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantZusAngaben='
                         || 'Zus.Angabe'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantProduktionsNr='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantAbmessung='
                         || '01-20-30'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrKunde='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdDatum='
                         || '01.01.2000'
                         || chr(13)
                         || chr(10)
                         || 'stdAenderungKonstruktion='
                         || 'KONST'
                         || chr(13)
                         || chr(10)
                         || 'stdAenderungKonstruktionOberflaeche='
                         || 'OBERF'
                         || chr(13)
                         || chr(10)
                         || 'stdAenderungKonstruktionZeichnung='
                         || 'ZEICH'
                         || chr(13)
                         || chr(10)
                         || 'stdPackstueckNr='
                         || '01'
                         || chr(13)
                         || chr(10)
                         || 'stdChangenNr='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdLieferantenNr='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdLieferantenanschriftLang='
                         || 'LiefAnsch4'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrKundeBarcode='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdFuellmengeBarcode='
                         || '1234'
                         || chr(13)
                         || chr(10)
                         || 'stdPackstueckNrBarcode='
                         || '12345612345601010000'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantBarcode='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdChangenNrBarcode='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdSachNrLieferantProduktionsNrBarcode='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdNrKundeBarcode='
                         || '1234567890'
                         || chr(13)
                         || chr(10)
                         || 'stdLieferantenNrBarcode='
                         || '123456'
                         || chr(13)
                         || chr(10)
                         || 'stdLfdnLteID='
                         || '01'
                         || chr(13)
                         || chr(10)
                         || 'stdLfdnLhmID='
                         || '01'
                         || chr(13)
                         || chr(10)
                         || 'stdEinsVonX='
                         || '1-1'
                         || chr(13)
                         || chr(10)
                         || 'stdSpezBarcode='
                         || '1234567890'
                         || chr(13)
                         || chr(10)
                         || 'stdEinsVonX='
                         || '1-1'
                         || chr(13)
                         || chr(10)
                         || 'stdSpezBarcode='
                         || '1234567890'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP1='
                         || '4'
                         || chr(13)
                         || chr(10)
                         || -- Layout 4 bei Sasol
                          'stdArtikelP2='
                         || 'P2'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP3='
                         || 'P3'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP4='
                         || 'P4'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP5='
                         || 'P5'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP6='
                         || 'P6'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP7='
                         || 'P7'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP8='
                         || 'P8'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP9='
                         || 'P9'
                         || chr(13)
                         || chr(10)
                         || 'stdArtikelP10='
                         || 'P10';

        print_engine.insert_new_job(in_sid, in_firma_nr, v_etikett.rave_datei, v_etikett.rave_report, print_engine.jdt_pv_liste,
                                    v_print_daten, in_drucker, 1, v_job_nr);

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
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
    end c_test_etikett;

  --------------------------------------------------------------------------------
    function format_artikel (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_str      in varchar2
    ) return varchar2 is

        str_code   varchar2(18) := null;
        str_out    varchar2(23) := null;
        str_layout varchar2(23) := null;
        i          number;
        pos        number;
    begin
        str_layout := isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'ET_ARTIKEL_AUSGABE',     -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                   'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                    'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                    null,                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                    'STRING');     -- in_default_param_typ
        if str_layout is not null then
            str_code := substr(in_str, 1, 18);
            i := 1;
            pos := 1;
            loop
                exit when pos > 23
                or i > length(str_code);
                if ( pos <= length(str_layout) ) then
                    if substr(str_layout, pos, 1) = '_' then
                        str_out := nvl(str_out,
                                       substr(str_code, i, 1))
                                   || substr(str_code, i, 1);

                        i := i + 1;
                    else
                        str_out := nvl(str_out,
                                       substr(str_layout, pos, 1))
                                   || substr(str_layout, pos, 1);
                    end if;

                else
                    str_out := nvl(str_out,
                                   substr(str_code, i, 1))
                               || substr(str_code, i, 1);

                    i := i + 1;
                end if;

                pos := pos + 1;
            end loop;

        else
            str_out := in_str;
        end if;

        return ( str_out );
    end;

--begin
  -- Initialization
  --<Statement>;
end z_dir_druck;
/


-- sqlcl_snapshot {"hash":"a9118b6fdaec26874a342dac4ce172f763502feb","type":"PACKAGE_BODY","name":"Z_DIR_DRUCK","schemaName":"DIRKSPZM32","sxml":""}