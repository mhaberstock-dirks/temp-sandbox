create or replace package body dirkspzm32.z_huf_druck is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);

  -- Function and procedure implementations
    function format_artikel (
        in_artikel in varchar2
    ) return varchar2 is
        v_result varchar2(255);
    begin
        v_result := in_artikel;
    -- Huf Formatierung
        if length(in_artikel) = 8 then
            v_result := substr(in_artikel, 1, 2);
            v_result := v_result
                        || '.'
                        || substr(in_artikel, 3, 3);
            v_result := v_result
                        || '.'
                        || substr(in_artikel, 6, 3);
        end if;

        return ( v_result );
    end;

    procedure c_lte_label_nr_eintr (
        in_sid        in lvs_lam.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_lte_id     in lvs_lam.lhm_id%type,
        in_artikel_id in lvs_lam.artikel_id%type
    ) is
    begin
        execute immediate 'begin s_huf_data_integration.c_label_nummer_fuer_lte_eintr('''
                          || in_sid
                          || ''', '
                          || in_firma_nr
                          || ', '
                          || ''''
                          || in_lte_id
                          || ''', '
                          || nvl(
            to_char(in_artikel_id),
            'null'
        )
                          || '); end;';
    end;

    procedure c_lhm_label_nr_eintr (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lhm_id   in lvs_lam.lhm_id%type
    ) is
    begin
        execute immediate 'begin s_huf_data_integration.c_label_nummer_fuer_lhm_eintr('''
                          || in_sid
                          || ''', '
                          || in_firma_nr
                          || ', '
                          || ''''
                          || in_lhm_id
                          || '''); end;';
    end;

    function get_lte_label_nr (
        in_sid        in lvs_lam.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_lte_id     in lvs_lam.lte_id%type,
        in_artikel_id in lvs_lam.artikel_id%type
    ) return varchar2 is

        v_result lvs_lam.lam_p5%type;
        cursor c_lte_label_nr is
        select
            lam.lam_p5
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lte_id = in_lte_id
            and lam.artikel_id = in_artikel_id;

    begin
        v_result := null;
        open c_lte_label_nr;
        fetch c_lte_label_nr into v_result;
        close c_lte_label_nr;
        return ( v_result );
    end;

    function get_lhm_label_nr (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lhm_id   in lvs_lam.lhm_id%type
    ) return varchar2 is

        v_result lvs_lam.lam_p4%type;
        cursor c_lhm_label_nr is
        select
            lam.lam_p4
        from
            lvs_lam lam
        where
                lam.sid = in_sid
            and lam.firma_nr = in_firma_nr
            and lam.lhm_id = in_lhm_id;

    begin
        v_result := null;
        open c_lhm_label_nr;
        fetch c_lhm_label_nr into v_result;
        close c_lhm_label_nr;
        return ( v_result );
    end;

    procedure get_ausl_datum (
        in_sid         in lvs_lam.sid%type,
        in_firma_nr    in lvs_lam.firma_nr%type,
        in_lte_id      in lvs_lam.lte_id%type,
        out_ausl_datum out date
    ) is

        v_transport isi_transport%rowtype;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = in_lte_id
            and t.freifahrauftrag = c.c_false;

        cursor c_lam_bh is
        select
            max(t.buch_datum)
        from
            lvs_lam_bh t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = in_lte_id
            and t.bus = c.lam_bh_bus_uml
            and t.menge > 0
            and t.vorg_typ = c.lam_bh_abgagng;

    begin
        out_ausl_datum := null;
        open c_transport;
        fetch c_transport into v_transport;
        if c_transport%found then
            if ( v_transport.transp_typ = 'A' )
            or (
                v_transport.transp_typ = 'E'
                and v_transport.lgr_verwendung_ziel = 'WA'
            ) then
                out_ausl_datum := v_transport.ts;
            end if;
        else
      -- Es gibt keinen Transport mehr, also in der Buchungshistorie nachschlagen
            open c_lam_bh;
            fetch c_lam_bh into out_ausl_datum;
            close c_lam_bh;
        end if;

        close c_transport;
    end;

    procedure get_lgr_platz_ort_texte (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_lgr_platz       in lvs_lgr.lgr_platz%type,
        in_artikel         in isi_artikel%rowtype,
        out_lgr_ort_text   out varchar2,
        out_lgr_platz_text out varchar2,
        out_lgr_verwend    out lvs_lgr.lgr_verwendung%type
    ) is

    --v_lgr_verwendung lvs_lgr.lgr_verwendung%type;
        v_lgr_ort_text lvs_lgr_ort.lgr_ort_text%type;
        cursor c_lgr is
        select
            t.lgr_verwendung,
            lo.lgr_ort_text
        from
            lvs_lgr     t,
            lvs_lgr_ort lo
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_platz = in_lgr_platz
            and lo.sid = t.sid
            and lo.firma_nr = t.firma_nr
            and lo.lgr_ort = t.lgr_ort;

        v_punkt_pos    number;
    begin
        out_lgr_ort_text := null;
        out_lgr_platz_text := null;
        v_punkt_pos := instr(in_lgr_platz, '.'); -- Der erste Punkt im Lagerpltztext

        open c_lgr;
        fetch c_lgr into
            out_lgr_verwend,
            v_lgr_ort_text;
        if c_lgr%found then
            if out_lgr_verwend = c.lgr_typ_lager then
                out_lgr_ort_text := '('
                                    || substr(in_lgr_platz, 1, v_punkt_pos - 1)
                                    || ') ';

                out_lgr_ort_text := out_lgr_ort_text || v_lgr_ort_text;
                out_lgr_platz_text := substr(in_lgr_platz, v_punkt_pos + 1);
            elsif out_lgr_verwend = c.lgr_typ_we
            or out_lgr_verwend = c.lgr_typ_lagerp then
                if in_artikel.waren_typ like 'V%' then
                    out_lgr_ort_text := 'Vorserie';
                else
                    out_lgr_ort_text := 'Vorbestellung';
                end if;

                out_lgr_platz_text := ' ';
            end if;
        else
      -- Wenn die LTE von keinem Platz auf WA gebucht wird, dann ist es eine Durchlagerung
            if in_artikel.waren_typ like 'V%' then
                out_lgr_ort_text := 'Vorserie';
            else
                out_lgr_ort_text := 'Vorbestellung';
            end if;

            out_lgr_platz_text := ' ';
            out_lgr_verwend := c.lgr_typ_we;
        end if;

        close c_lgr;
    end;

    procedure get_ausl_art_lgr_info (
        in_sid            in lvs_lam.sid%type,
        in_firma_nr       in lvs_lam.firma_nr%type,
        in_lgr_platz      in lvs_lgr.lgr_platz%type,
        in_artikel        in isi_artikel%rowtype,
        out_ausl_eti_info out varchar2
    ) is

        v_lgr lvs_lgr%rowtype;
        cursor c_art_lgr_info is
        select
            t.ausl_etikett_info
        from
            lvs_artikel_lgr_info t
        where
                t.artikel_id = in_artikel.artikel_id
            and ( t.lgr_platz = in_lgr_platz
                  or t.lgr_ort = v_lgr.lgr_ort
                  and t.lgr_platz is null )
            and t.firma_nr = in_firma_nr
            and t.sid = in_sid;

    begin
    --out_ausl_eti_info := null;
        if lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr) then
            open c_art_lgr_info;
            fetch c_art_lgr_info into out_ausl_eti_info;
            close c_art_lgr_info;
        end if;
    end;

    function vda_etikett (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_id         in lvs_lte.lte_id%type,
        in_waren_typ  in lvs_lte.waren_typ%type,
        in_artikel_id in lvs_lam.artikel_id%type
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
        v_lte_id                       lvs_lte.lte_id%type;
        v_lte_lte_name                 lvs_lte.lte_name%type;
        v_lte_ziel_lgr_platz           lvs_lte.ziel_lgr_platz%type;
        v_lte_lgr_platz                lvs_lte.lgr_platz%type;
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
        v_lte_lte_voll                 lvs_lte.lte_voll%type;
        v_lam_zeichnung                lvs_lam.zeichnung%type;
        v_lam_zeichnung_index          lvs_lam.zeichnung_index%type;
        v_lam_best_nr                  lvs_lam.best_nr%type;
        v_fa_auftrag                   bde_fa_auftrag%rowtype;
        v_netto                        number;
        v_brutto                       number;
        v_adr_nr                       isi_adressen.adr_nr%type;
        v_adr_id                       isi_adressen.adress_id%type;
        v_lam_order_pos_auf_id         isi_order_pos.auf_id%type;
        v_lam_artikel_id               isi_artikel.artikel_id%type;
        v_lam_art_fanr                 lvs_lam.leitzahl%type;
        v_lam_art_faag                 lvs_lam.fa_ag%type;
        v_lieferanten_nr               isi_adressen.adr_nr%type;
    --v_best_nr_kunde           isi_order_pos.best_nr_kunde%type;
        v_li_nr_lief                   lvs_lam.li_nr_lief%type;
        v_naechste_maschine            isi_resource.res_ext_name%type;
        v_lam_p1                       lvs_lam.lam_p1%type;
        v_lam_p2                       lvs_lam.lam_p2%type;
        v_lam_p4                       lvs_lam.lam_p4%type;
        v_lam_p5                       lvs_lam.lam_p5%type;
        v_lam_p6                       lvs_lam.lam_p6%type;
        v_res_menge                    number;
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
        v_vdapackstucknrbarcodebez     varchar2(1);
        v_vdasachnrlieferantbarcode    varchar2(255);
        v_vdachangennrbarcode          varchar2(255);
        v_vdasachnrlieferantprodnrbarc varchar2(255);
        v_vdanrkundebarcode            varchar2(255);
    --v_VdaLieferanschriftkurz                              varchar2(255);
        v_vdalieferantennr             varchar2(255);
        v_vdalieferantennrbarcode      varchar2(255);
    --v_VdaLieferantenAnschrift1                            varchar2(255);
    --v_VdaLieferantenAnschrift2                            varchar2(255);
    --v_VdaLieferantenAnschrift3                            varchar2(255);
        v_vdalieferantenanschrift4     varchar2(255);
        v_vdabestellnummerkunde        varchar2(255);
        cursor c_lte is
        select
            lte.sid,
            lte.firma_nr,
            lte.lte_id,
            lte.lte_name,
            nvl(lte.ziel_lgr_platz, lte.lgr_platz) ziel_lgr_platz,
            lte.lgr_platz,
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
                min(lam.prod_datum),
                max(lam.prod_datum),
                min(lam.prod_datum),
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
                min(lam.lam_p1),
                max(lam.lam_p1),
                min(lam.lam_p1),
                null
            )                                      lam_p1,
            decode(
                min(lam.lam_p2),
                max(lam.lam_p2),
                min(lam.lam_p2),
                null
            )                                      lam_p2,
            decode(
                min(lam.lam_p5),
                max(lam.lam_p5),
                min(lam.lam_p5),
                null
            )                                      lam_p5,
            decode(
                min(lam.lam_p6),
                max(lam.lam_p6),
                min(lam.lam_p6),
                null
            )                                      lam_p6,
            decode(
                min(lam.lam_mhd),
                max(lam.lam_mhd),
                min(lam.lam_mhd),
                null
            )                                      lam_mhd,
            nvl(
                sum(lam.res_menge),
                0
            )                                      res_menge,
            count(lam.lhm_id)                      artikel_anz_lhm,
            min(lte.res_ziel_lgr_platz)            res_ziel_lgr_platz,
            decode(
                min(lam.zug_datum),
                max(lam.zug_datum),
                min(lam.zug_datum),
                null
            )                                      lam_zug_datum,
            decode(
                min(a.artikel_p6),
                max(a.artikel_p6),
                min(a.artikel_p6),
                null
            )                                      puffer_platz,
            min(lam.prod_datum),
            decode(
                min(lam.lte_id_lieferant),
                max(lam.lte_id_lieferant),
                decode(
                    min(lam.sonst_id_lieferant),
                    null,
                    min(lam.lte_id_lieferant),
                    null
                ),
                null
            )                                      lte_id_lieferant
        from
            lvs_lte     lte,
            lvs_lam     lam,
            isi_artikel a
        where
                lte.sid = lam.sid (+)
            and lte.lte_id = in_id
            and lte.lte_id = lam.lte_id (+)
            and ( lam.artikel_id = in_artikel_id
                  or in_artikel_id is null )
            and lam.artikel_id = a.artikel_id (+)
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
            lam.lte_id,
            lhm.lhm_name,
            nvl(lte.ziel_lgr_platz, lte.lgr_platz) ziel_lgr_platz,
            lte.lgr_platz,
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
                min(lam.prod_datum),
                max(lam.prod_datum),
                min(lam.prod_datum),
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
                min(lam.lam_p1),
                max(lam.lam_p1),
                min(lam.lam_p1),
                null
            )                                      lam_p1,
            decode(
                min(lam.lam_p2),
                max(lam.lam_p2),
                min(lam.lam_p2),
                null
            )                                      lam_p2,
            decode(
                min(lam.lam_p4),
                max(lam.lam_p4),
                min(lam.lam_p4),
                null
            )                                      lam_p4,
            decode(
                min(lam.lam_p6),
                max(lam.lam_p6),
                min(lam.lam_p6),
                null
            )                                      lam_p6,
            decode(
                min(lam.lam_mhd),
                max(lam.lam_mhd),
                min(lam.lam_mhd),
                null
            )                                      lam_mhd,
            nvl(
                sum(lam.res_menge),
                0
            )                                      res_menge,
            decode(
                min(lhm.komm_quell_lgr_platz),
                max(lhm.komm_quell_lgr_platz),
                min(lhm.komm_quell_lgr_platz),
                null
            )                                      komm_quell_lgr_platz,
            min(lte.res_ziel_lgr_platz)            res_ziel_lgr_platz,
            decode(
                min(lam.zug_datum),
                max(lam.zug_datum),
                min(lam.zug_datum),
                null
            )                                      lam_zug_datum,
            decode(
                min(a.artikel_p6),
                max(a.artikel_p6),
                min(a.artikel_p6),
                null
            )                                      puffer_platz,
            decode(
                min(lam.lte_id_lieferant),
                max(lam.lte_id_lieferant),
                decode(
                    min(lam.sonst_id_lieferant),
                    null,
                    min(lam.lte_id_lieferant),
                    null
                ),
                null
            )                                      lte_id_lieferant
        from
            lvs_lhm     lhm,
            lvs_lte     lte,
            lvs_lam     lam,
            isi_artikel a
        where
                lam.lhm_id = in_id
            and lam.lte_id = lte.lte_id
            and lhm.lhm_id = lam.lhm_id
            and lam.artikel_id = a.artikel_id (+)
        group by
            lam.sid,
            lam.firma_nr,
            lte.order_vorgang_id,
            lhm.lhm_id,
            lam.lte_id,
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
            and fa.fa_ag > v_lam_art_faag;

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

        v_huf_label_nr                 number;
        v_ausl_datum                   date;
        v_ausl_puffer_platz            isi_artikel.artikel_p6%type;
        v_lagerort                     varchar2(255);
        v_lgr_verwend                  lvs_lgr.lgr_verwendung%type;
        v_grp                          varchar2(255);
        v_mhd                          date;
        v_lam_zug_datum                date;
        v_etikett_basis                varchar2(10);
        v_etikett_typ                  varchar2(10);
        v_artikel_anz_lhm              number;
        v_lam_min_prod_datum           lvs_lam.prod_datum%type;
        v_lhm_komm_quell_lgr_platz     lvs_lhm.komm_quell_lgr_platz%type;
        v_res_ziel_lgr_platz           lvs_lte.res_ziel_lgr_platz%type;
        v_ziel_lgr                     lvs_lgr%rowtype;
        v_wa_verw_puffer_wa            boolean;
        v_index_hinweis                varchar2(50);
        v_puffer_platz_feld_markier    varchar2(10);
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
        v_vdachangennr := null;
        v_vdalieferantennr := null;
        v_vdasachnrkundebarcode := null;
        v_vdafuellmengebarcode := null;
    --v_VdaPackstuckNrBarcode := NULL;
        v_vdasachnrlieferantbarcode := null;
        v_vdachangennrbarcode := null;
        v_vdasachnrlieferantprodnrbarc := null;
        v_vdanrkundebarcode := null;
        v_vdalieferantennrbarcode := null;
        v_vdalieferantenanschrift4 := null;
        v_lam_art_fanr := null;
        v_lam_art_faag := null;
        v_huf_label_nr := null;
        v_ausl_datum := null;
        v_lhm_komm_quell_lgr_platz := null;
        v_etikett_typ := 'E';
        if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = c.basis_lte then
            v_etikett_basis := c.basis_lte;
            open c_lte;
            fetch c_lte into
                v_lte_sid,
                v_lte_firma_nr,
                v_lte_lte_id,
                v_lte_lte_name,
                v_lte_ziel_lgr_platz,
                v_lte_lgr_platz,
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
                v_lam_p1,
                v_lam_p2,
                v_lam_p5,
                v_lam_p6,
                v_mhd,
                v_res_menge,
                v_artikel_anz_lhm,
                v_res_ziel_lgr_platz,
                v_lam_zug_datum,
                v_ausl_puffer_platz,
                v_lam_min_prod_datum,
                v_huf_label_nr;

            v_found := c_lte%found;
            close c_lte;
            if v_found then
                v_artikel_anz_lhm := nvl(v_artikel_anz_lhm, 0);
                v_lte_id := v_lte_lte_id;
                get_ausl_datum(in_sid, in_firma_nr, v_lte_id, v_ausl_datum);
                if v_ausl_datum is not null then
          -- !! Achtung !! Huf spezifisch (Nur Auslagerungen)
                    c_lte_label_nr_eintr(in_sid, in_firma_nr, in_id, in_artikel_id);
                    v_huf_label_nr := get_lte_label_nr(in_sid, in_firma_nr, v_lte_id, v_lam_artikel_id);
                end if;

            end if;

            open c_lte_c;
            fetch c_lte_c into v_lte_c;
            if c_lte_c%found then
        -- Anforderung von P. Bergfink am 06.09.2007
        --if v_lte_c.verwaltet_von = 'HOST'
        --then
                v_vdadatenfeldfuerlieferanten := v_lte_c.lte_text;
        --end if;
            end if;
            close c_lte_c;
            v_vdabestellnummerkunde := null;
            open c_fa_auf_lte;
            fetch c_fa_auf_lte into v_vdabestellnummerkunde;
            close c_fa_auf_lte;
        elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = c.basis_lhm then
            v_etikett_basis := c.basis_lhm;
            open c_lhm;
            fetch c_lhm into
                v_lte_sid,
                v_lte_firma_nr,
                v_lte_lte_id,
                v_lte_id,
                v_lte_lte_name,
                v_lte_ziel_lgr_platz,
                v_lte_lgr_platz,
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
                v_lam_p1,
                v_lam_p2,
                v_lam_p4,
                v_lam_p6,
                v_mhd,
                v_res_menge,
                v_lhm_komm_quell_lgr_platz,
                v_res_ziel_lgr_platz,
                v_lam_zug_datum,
                v_ausl_puffer_platz,
                v_huf_label_nr;

            v_found := c_lhm%found;
            close c_lhm;
            if v_found then
                get_ausl_datum(in_sid, in_firma_nr, v_lte_id, v_ausl_datum);
                if v_ausl_datum is not null then
          -- !! Achtung !! Huf spezifisch (Nur Auslagerungen)
                    c_lhm_label_nr_eintr(in_sid, in_firma_nr, in_id);
                    v_huf_label_nr := get_lhm_label_nr(in_sid, in_firma_nr, in_id);
                end if;

            end if;

            open c_lhm_c;
            fetch c_lhm_c into v_lhm_c;
            if c_lhm_c%found then
        -- Bei Huf nur Soll-Behälter drucken
        -- Anforderung von P. Bergfink am 06.09.2007
        --if v_lhm_c.verwaltet_von = 'HOST'
        --then
                v_vdadatenfeldfuerlieferanten := v_lhm_c.lhm_text;
        --end if;
            end if;
            close c_lhm_c;
            v_vdabestellnummerkunde := null;
            open c_fa_auf_lhm;
            fetch c_fa_auf_lhm into v_vdabestellnummerkunde;
            close c_fa_auf_lhm;
        end if;

        if v_huf_label_nr = 0 then
            v_huf_label_nr := null;
        end if;
        v_wa_verw_puffer_wa := false;
        if lvs_p_base.get_lgr_platz(v_lte_ziel_lgr_platz, v_ziel_lgr) then
            if v_ziel_lgr.lgr_verwendung_proj = 'PUFFER_WA' then
                v_wa_verw_puffer_wa := true;
            end if;
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
            if in_artikel_id is not null then
        -- Bei Artikelbezogenen Etiketten nur die Anzahl des jew. Artikels anziegen
                v_vdaanzahlpackstuecke := v_artikel_anz_lhm;
            end if;
            v_vdasachnrlieferant := format_artikel(nvl(v_art.artikel, 'VERSCHIEDENE'));
            if v_art.artikel is not null then
                v_vdasachnrlieferant := v_vdasachnrlieferant
                                        || ' / '
                                        || nvl(v_lam_zeichnung_index, '0000');
            end if;

            if v_art.waren_typ like 'V%' then
                if v_lam_p1 is null then
                    v_lam_p1 := 'V';
                else
                    v_lam_p1 := 'V / ' || v_lam_p1;
                end if;
            end if;

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
                v_vdasachnrlieferantbarcode := v_art.artikel;
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
          --v_adr_id := v_kopf.order_adress_id;
          --OPEN c_adr;
          --FETCH c_adr into v_adr;
          --v_found := c_adr%FOUND;
          --CLOSE c_adr;
          --if v_found then
          --  v_Vdalieferanschriftkurz := v_adr.name_1;
          --end if;
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
        --v_VdaLieferantenAnschrift1 := v_adr.name_1;
        --v_VdaLieferantenAnschrift2 := v_adr.name_2;
        --v_VdaLieferantenAnschrift3 := v_adr.name_3;
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
                end if;

            end if;

            if v_ausl_datum is null then
                v_etikett_typ := 'E';
       -- Keine Auslagerung, also auch keine Abladestelle
                v_vdaabladestelle := null;
                v_vdafuellmenge := v_lam_memge;
                if
                    v_lam_memge > nvl(v_res_menge, 0)
                    and nvl(v_res_menge, 0) > 0
                then
         -- bei Teilentnahme
                    v_vdafuellmenge := v_lam_memge - v_res_menge;
                end if;

                get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lte_lgr_platz, v_art, v_lagerort,
                                        v_grp, v_lgr_verwend);
                if v_lgr_verwend = c.lgr_typ_lager then
                    v_etikett_typ := 'U';
                end if;
                get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lte_ziel_lgr_platz, v_art, v_lagerort,
                                        v_grp, v_lgr_verwend);
            else
                v_etikett_typ := 'A';

       -- -WK- 20080627: Hinweis fehlte seit Migration von V2
                if
                    v_lam_zeichnung_index is not null
                    and v_art.zeichnung_index is not null
                    and v_art.zeichnung_index != ' '
                    and v_art.zeichnung_index != '   ' -- bei Huf in den Stammdaten sind Felder mit Leerzeichen gefüllt, wenn sie nicht belegt sind
                    and v_lam_zeichnung_index != v_art.zeichnung_index
                then
                    v_index_hinweis := 'ACHTUNG: Wechsel Teile-Index!';
                end if;

                v_vdafuellmenge := v_lam_memge;
                if v_vdaabladestelle != v_res_ziel_lgr_platz then
                    v_vdaabladestelle := v_vdaabladestelle
                                         || ' - '
                                         || v_res_ziel_lgr_platz;
                    v_vdafuellmenge := v_res_menge;
                end if;

       -- -WK- 16.04.2008 nicht mehr die Sonderteilenummer benutzen
                get_ausl_art_lgr_info(in_sid, in_firma_nr, v_vdaabladestelle, v_art, v_ausl_puffer_platz);
                if
                    v_ausl_puffer_platz is not null
                    and v_wa_verw_puffer_wa
                then
                    v_vdaabladestelle := v_vdaabladestelle
                                         || ' / '
                                         || v_ausl_puffer_platz;
                end if;

       -- Bei einer Auslagerung aktuellen Platz anzeigen
                get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lte_lgr_platz, v_art, v_lagerort,
                                        v_grp, v_lgr_verwend);
                if v_lgr_verwend = c.lgr_typ_we
                or v_lgr_verwend = c.lgr_typ_lagerp then
                    v_etikett_typ := 'D';
                else
                    if v_lhm_komm_quell_lgr_platz is not null then
           -- Auf dem LHM Etikett den Lagerplatz der Entnahme drucken
                        get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lhm_komm_quell_lgr_platz, v_art, v_lagerort,
                                                v_grp, v_lgr_verwend);
                    end if;
                end if;

            end if;

            if nvl(v_lam_p6, 0) = 0 then
       -- wenn kein Zähler gesetzt ist, dann auch kein MHD Ausgeben
                v_mhd := null;
            end if;
            if v_etikett_basis = c.basis_lte then
                update lvs_lte t
                set
                    t.lte_eti_druck_status = c.eti_status_gedruckt
                where
                    t.lte_id = in_id;

                commit;
            elsif v_etikett_basis = c.basis_lhm then
                update lvs_lhm t
                set
                    t.lhm_eti_druck_status = c.eti_status_gedruckt
                where
                    t.lhm_id = in_id;

                commit;
            end if;

        end if;

        v_vdapackstucknrbarcodebez := 'M';
        if in_waren_typ = 'MP' then
            v_vdapackstucknrbarcodebez := 'G';
        elsif v_lte_lte_voll = c.lte_voll_v then
            v_vdapackstucknrbarcodebez := 'S';
        end if;

        v_vdapackstucknr := in_id;
        v_vdapackstucknrbarcode := v_vdapackstucknrbarcodebez || in_id;

   -- -WK- 20080910: graue Feldmarkierung soll bei Pufferplätzen mit Ausnahme von
   -- Teile-Nr. die als Ersatz-Teil deklariert sind und
   -- Verpackung = Styropor-Lagen (SQL-Abfrage "ELT EPS%"), aktiv sein.
        v_puffer_platz_feld_markier := '';
        if
            v_ausl_puffer_platz is not null
            and v_wa_verw_puffer_wa
            and not ( v_art.ersatzteil = 'T' )
            and not ( v_vdadatenfeldfuerlieferanten like 'ELT EPS%' )
        then
            v_puffer_platz_feld_markier := 'T';
        end if;

        v_print_daten := 'etikett_typ='
                         || v_etikett_typ
                         || chr(13)
                         || chr(10)
                         || 'artikel_id='
                         || nvl(v_lam_artikel_id, '')
                         || chr(13)
                         || chr(10)
                         || 'fa_ag='
                         || nvl(v_lam_art_faag, '')
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantDatenfeldFuerLieferanten='
                         || v_vdadatenfeldfuerlieferanten
                         || chr(13)
                         || chr(10)
                         || 'VdaGewichtBrutto='
                         || v_vdagewichtbrutto
                         || chr(13)
                         || chr(10)
                         || 'VdaGewichtNetto='
                         || v_vdagewichtnetto
                         || chr(13)
                         || chr(10)
                         || 'VdaLieferscheinNrBestellnummer='
                         || v_vdalieferscheinnrbestnr
                         || chr(13)
                         || chr(10)
                         || 'VdaLieferscheinNr='
                         || nvl(v_vdalieferscheinnr, 'VERSCHIEDENE')
                         || chr(13)
                         || chr(10)
                         || 'VdaLieferscheinNrLief='
                         || v_vdalieferscheinnrlief
                         || chr(13)
                         || chr(10)
                         || 'VdaWarenempfaengerKurz='
                         || v_vdawarenempfaengerkurz
                         || chr(13)
                         || chr(10)
                         || 'VdaWarenempfaengerLang1='
                         || v_vdawarenempfaengerlang1
                         || chr(13)
                         || chr(10)
                         || 'VdaWarenempfaengerLang2='
                         || v_vdawarenempfaengerlang2
                         || chr(13)
                         || chr(10)
                         || 'VdaWarenempfaengerLang3='
                         || v_vdawarenempfaengerlang3
                         || chr(13)
                         || chr(10)
                         || 'VdaAbladestelle='
                         || v_vdaabladestelle
                         || chr(13)
                         || chr(10)
                         || 'VdaAnzahlPackstuecke='
                         || v_vdaanzahlpackstuecke
                         || chr(13)
                         || chr(10)
                         || 'VdaFuellmenge='
                         || v_vdafuellmenge
                         || chr(13)
                         || chr(10)
                         || 'VdaFuellmengeMengeneinheit='
                         || v_vdafuellmengemengeneinheit
                         || chr(13)
                         || chr(10)
                         || 'VdaBezeichnungLieferungLeistung='
                         || v_vdabezeichnunglieferungl
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferant='
                         || v_vdasachnrlieferant
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantISKDPackmittel='
                         || v_vdasachnrlieferantiskdpackm
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantZusAngaben='
                         || v_vdasachnrlieferantzusangaben
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantProduktionsNr='
                         || v_vdasachnrlieferantprodnr
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantAbmessung='
                         || v_vdasachnrlieferantabmessung
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrKunde='
                         || v_vdasachnrkunde
                         || chr(13)
                         || chr(10)
                         || 'VdaDatum='
                         || v_vdadatum
                         || chr(13)
                         || chr(10)
                         || 'VdaAenderungKonstruktion='
                         || v_vdaaenderungkonstruktion
                         || chr(13)
                         || chr(10)
                         || 'VdaAenderungKonstruktionOberflaeche='
                         || v_vdaaenderungkonstruktiono
                         || chr(13)
                         || chr(10)
                         || 'VdaAenderungKonstruktionZeichnung='
                         || v_vdaaenderungkonstruktionz
                         || chr(13)
                         || chr(10)
                         || 'VdaPackstuckNr='
                         || v_vdapackstucknr
                         || chr(13)
                         || chr(10)
                         || 'VdaChangenNr='
                         || nvl(v_vdachangennr, 'VERSCHIEDENE')
                         || chr(13)
                         || chr(10)
                         || 'VdaLieferantenNr='
                         || v_vdalieferantennr
                         || chr(13)
                         || chr(10)
                         || 'VdaLieferantenanschriftLang='
                         || v_vdalieferantenanschrift4
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrKundeBarcode='
                         || v_vdasachnrkundebarcode
                         || chr(13)
                         || chr(10)
                         || 'VdaFuellmengeBarcode='
                         || v_vdafuellmengebarcode
                         || chr(13)
                         || chr(10)
                         || 'VdaPackstuckNrBarcode='
                         || v_vdapackstucknrbarcode
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantBarcode='
                         || v_vdasachnrlieferantbarcode
                         || chr(13)
                         || chr(10)
                         || 'VdaChangenNrBarcode='
                         || v_vdachangennrbarcode
                         || chr(13)
                         || chr(10)
                         || 'VdaSachNrLieferantProduktionsNrBarcode='
                         || v_vdasachnrlieferantprodnrbarc
                         || chr(13)
                         || chr(10)
                         || 'VdaNrKundeBarcode='
                         || v_vdanrkundebarcode
                         || chr(13)
                         || chr(10)
                         || 'VdaLieferantenNrBarcode='
                         || v_vdalieferantennrbarcode
                         || chr(13)
                         || chr(10)
                         || 'Labelnummer='
                         || v_huf_label_nr
                         || chr(13)
                         || chr(10)
                         || 'KennD='
                         || nvl(v_lam_p1, '')
                         || chr(13)
                         || chr(10)
                         || 'KennEGB='
                         || nvl(v_lam_p2, '')
                         || chr(13)
                         || chr(10)
                         || 'PosNr_Knr='
                         || nvl(
            lpad(v_lam_art_faag, 3, '0'),
            ''
        )
                         || ' / '
                         || nvl(v_lam_kunden_nr, '')
                         || chr(13)
                         || chr(10)
                         || 'Auslagerdatum='
                         || nvl(
            to_char(v_ausl_datum, 'dd.mm.yyyy hh24:mi:ss'),
            ''
        )
                         || chr(13)
                         || chr(10)
                         || 'Einlagerdatum='
                         || nvl(
            to_char(v_lam_prod_datum, 'dd.mm.yyyy hh24:mi:ss'),
            nvl(to_char(v_lam_min_prod_datum, 'dd.mm.yyyy')
                || ' / VERSCH',
                'VERSCHIEDENE')
        )
                         || chr(13)
                         || chr(10)
                         || 'MHD='
                         || nvl(
            to_char(v_mhd, 'dd.mm.yyyy'),
            ''
        )
                         || chr(13)
                         || chr(10)
                         || 'MHDAnz='
                         || nvl(v_lam_p6, '')
                         || chr(13)
                         || chr(10)
                         || -- Anzahl der Veränderungen am MHD duch Labor
                          'Lagerort='
                         || nvl(v_lagerort, '')
                         || chr(13)
                         || chr(10)
                         || 'GRP='
                         || nvl(v_grp, '')
                         || chr(13)
                         || chr(10)
                         || 'Ladungstraeger='
                         || nvl(v_vdadatenfeldfuerlieferanten, '')
                         || chr(13)
                         || chr(10)
                         || 'LTE_ID='
                         || v_lte_id
                         || chr(13)
                         || chr(10)
                         || 'LTE_IDBarcode='
                         || v_vdapackstucknrbarcodebez
                         || v_lte_id
                         || chr(13)
                         || chr(10)
                         || 'TIndexHinweis='
                         || v_index_hinweis
                         || chr(13)
                         || chr(10)
                         || 'PufferPlatzFeldMarkier='
                         || v_puffer_platz_feld_markier
                         || chr(13)
                         || chr(10)
                         || 'AuslPufferPlatz='
                         || v_ausl_puffer_platz
                         || chr(13)
                         || chr(10);

        return ( v_print_daten );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end vda_etikett;

end;
/


-- sqlcl_snapshot {"hash":"e65e13fbce189dafceb189fe5c5be8e4f357564f","type":"PACKAGE_BODY","name":"Z_HUF_DRUCK","schemaName":"DIRKSPZM32","sxml":""}