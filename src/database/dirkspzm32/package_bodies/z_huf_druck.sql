create or replace 
package body DIRKSPZM32.z_huf_druck is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- Function and procedure implementations
  function format_artikel(in_artikel in varchar2) return varchar2 is
    v_result varchar2(255);
  begin
    v_result := in_artikel;
    -- Huf Formatierung
    if length(in_artikel) = 8
    then
      v_result := substr(in_artikel, 1, 2);
      v_result := v_result || '.' || substr(in_artikel, 3, 3);
      v_result := v_result || '.' || substr(in_artikel, 6, 3);
    end if;

    return(v_result);
  end;

  procedure c_lte_label_nr_eintr(in_sid        in lvs_lam.sid%type,
                                 in_firma_nr   in lvs_lam.firma_nr%type,
                                 in_lte_id     in lvs_lam.lhm_id%type,
                                 in_artikel_id in lvs_lam.artikel_id%type) is
  begin
    execute immediate 'begin s_huf_data_integration.c_label_nummer_fuer_lte_eintr(''' || in_sid || ''', ' ||
                                                                                         in_firma_nr || ', ' ||
                                                                                         '''' || in_lte_id || ''', ' ||
                                                                                         nvl(to_char(in_artikel_id), 'null') || '); end;';
  end;

  procedure c_lhm_label_nr_eintr(in_sid      in lvs_lam.sid%type,
                                 in_firma_nr in lvs_lam.firma_nr%type,
                                 in_lhm_id   in lvs_lam.lhm_id%type) is
  begin
    execute immediate 'begin s_huf_data_integration.c_label_nummer_fuer_lhm_eintr(''' || in_sid || ''', ' ||
                                                                                         in_firma_nr || ', ' ||
                                                                                         '''' || in_lhm_id || '''); end;';
  end;

  function get_lte_label_nr(in_sid        in lvs_lam.sid%type,
                            in_firma_nr   in lvs_lam.firma_nr%type,
                            in_lte_id     in lvs_lam.lte_id%type,
                            in_artikel_id in lvs_lam.artikel_id%type) return varchar2 is
    v_result lvs_lam.lam_p5%type;
    cursor c_lte_label_nr is
      select lam.lam_p5
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lte_id = in_lte_id
         and lam.artikel_id = in_artikel_id;
  begin
    v_result := null;
    open c_lte_label_nr;
    fetch c_lte_label_nr into v_result;
    close c_lte_label_nr;
    return (v_result);
  end;

  function get_lhm_label_nr(in_sid      in lvs_lam.sid%type,
                            in_firma_nr in lvs_lam.firma_nr%type,
                            in_lhm_id   in lvs_lam.lhm_id%type) return varchar2 is
    v_result lvs_lam.lam_p4%type;
    cursor c_lhm_label_nr is
      select lam.lam_p4
        from lvs_lam lam
       where lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.lhm_id = in_lhm_id;
  begin
    v_result := null;
    open c_lhm_label_nr;
    fetch c_lhm_label_nr into v_result;
    close c_lhm_label_nr;
    return (v_result);
  end;

  procedure get_ausl_datum(in_sid           in lvs_lam.sid%type,
                           in_firma_nr      in lvs_lam.firma_nr%type,
                           in_lte_id        in lvs_lam.lte_id%type,
                           out_ausl_datum   out date) is

    v_transport isi_transport%rowtype;
    cursor c_transport is
      select *
        from isi_transport t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
         and t.freifahrauftrag = c.c_false;

    cursor c_lam_bh is
      select max(t.buch_datum)
        from lvs_lam_bh t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
         and t.bus = c.LAM_BH_BUS_UML
         and t.menge > 0
         and t.vorg_typ = c.LAM_BH_ABGAGNG;
  begin
    out_ausl_datum := null;

    open c_transport;
    fetch c_transport into v_transport;
    if c_transport%found
    then
      if (v_transport.transp_typ = 'A')
         or (v_transport.transp_typ = 'E' and v_transport.lgr_verwendung_ziel = 'WA')
      then
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

  procedure get_lgr_platz_ort_texte(in_sid             in lvs_lam.sid%type,
                                    in_firma_nr        in lvs_lam.firma_nr%type,
                                    in_lgr_platz       in lvs_lgr.lgr_platz%type,
                                    in_artikel         in isi_artikel%rowtype,
                                    out_lgr_ort_text   out varchar2,
                                    out_lgr_platz_text out varchar2,
                                    out_lgr_verwend    out lvs_lgr.lgr_verwendung%type) is

    --v_lgr_verwendung lvs_lgr.lgr_verwendung%type;
    v_lgr_ort_text   lvs_lgr_ort.lgr_ort_text%type;
    cursor c_lgr is
      select t.lgr_verwendung,
             lo.lgr_ort_text
        from lvs_lgr t,
             lvs_lgr_ort lo
       where t.sid = in_sid
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
    fetch c_lgr into out_lgr_verwend, v_lgr_ort_text;
    if c_lgr%found
    then
      if out_lgr_verwend = c.LGR_TYP_Lager
      then
        out_lgr_ort_text := '(' || substr(in_lgr_platz, 1, v_punkt_pos - 1) || ') ';
        out_lgr_ort_text := out_lgr_ort_text || v_lgr_ort_text;
        out_lgr_platz_text := substr(in_lgr_platz, v_punkt_pos + 1);
      elsif out_lgr_verwend = c.LGR_TYP_WE
         or out_lgr_verwend = c.LGR_TYP_LAGERP
      then
        if in_artikel.waren_typ like 'V%'
        then
          out_lgr_ort_text := 'Vorserie';
        else
          out_lgr_ort_text := 'Vorbestellung';
        end if;
        out_lgr_platz_text := ' ';
      end if;
    else
      -- Wenn die LTE von keinem Platz auf WA gebucht wird, dann ist es eine Durchlagerung
      if in_artikel.waren_typ like 'V%'
      then
        out_lgr_ort_text := 'Vorserie';
      else
        out_lgr_ort_text := 'Vorbestellung';
      end if;
      out_lgr_platz_text := ' ';
      out_lgr_verwend := c.LGR_TYP_WE;
    end if;
    close c_lgr;
  end;

  procedure get_ausl_art_lgr_info(in_sid             in lvs_lam.sid%type,
                                  in_firma_nr        in lvs_lam.firma_nr%type,
                                  in_lgr_platz       in lvs_lgr.lgr_platz%type,
                                  in_artikel         in isi_artikel%rowtype,
                                  out_ausl_eti_info  out varchar2) is
    v_lgr lvs_lgr%rowtype;

    cursor c_art_lgr_info is
      select t.ausl_etikett_info
        from lvs_artikel_lgr_info t
       where t.artikel_id = in_artikel.artikel_id
         and (t.lgr_platz = in_lgr_platz or t.lgr_ort = v_lgr.lgr_ort and t.lgr_platz is null)
         and t.firma_nr = in_firma_nr
         and t.sid = in_sid;
  begin
    --out_ausl_eti_info := null;
    if lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr)
    then
      open c_art_lgr_info;
      fetch c_art_lgr_info into out_ausl_eti_info;
      close c_art_lgr_info;
    end if;
  end;

  function vda_etikett(in_sid         in isi_sid.sid%type,
                       in_firma_nr    in isi_firma.firma_nr%type,
                       in_id          in lvs_lte.lte_id%type,
                       in_waren_typ   in lvs_lte.waren_typ%type,
                       in_artikel_id  in lvs_lam.artikel_id%type)
                       return varchar2 is

    v_print_daten     varchar2(4096);

    v_found           boolean;
    v_pos                     isi_order_pos%rowtype;
    v_kopf                    isi_order_kopf%rowtype;
    v_adr                     isi_adressen%rowtype;
    v_art                     isi_artikel%rowtype;
    v_art_kd                  isi_artikel_kunde%rowtype;
    v_charge                  lvs_charge%rowtype;
    v_lte_c                   lvs_lte_cfg%rowtype;
    v_lhm_c                   lvs_lhm_cfg%rowtype;

    v_lte_sid                 lvs_lte.sid%type;
    v_lte_firma_nr            lvs_lte.firma_nr%type;
    v_lte_lte_id              lvs_lte.lte_id%type;
    v_lte_id                  lvs_lte.lte_id%type;
    v_lte_lte_name            lvs_lte.lte_name%type;
    v_lte_ziel_lgr_platz      lvs_lte.ziel_lgr_platz%type;
    v_lte_lgr_platz           lvs_lte.lgr_platz%type;
    v_lte_lte_akt_lhm         lvs_lte.lte_akt_lhm%type;
    v_lte_order_vorgang_id    lvs_lte.order_vorgang_id%type;
    v_lhm_lhm_name            lvs_lhm.lhm_name%type;
    v_lam_charge_id           lvs_lam.charge_id%type;
    v_lam_kunden_nr           lvs_lam.kunden_nr%type;
    v_lam_memge               lvs_lam.menge%type;
    v_lam_memge_basis         lvs_lam.menge_basis%type;
    v_lam_leitzahl            lvs_lam.leitzahl%type;
    v_lam_prod_datum          lvs_lam.prod_datum%type;
    v_order_pos_auf_id        isi_order_pos.auf_id%type;
    v_lte_lte_voll            lvs_lte.lte_voll%type;
    v_lam_zeichnung           lvs_lam.zeichnung%type;
    v_lam_zeichnung_index     lvs_lam.zeichnung_index%type;
    v_lam_best_nr             lvs_lam.best_nr%type;
    v_fa_auftrag              bde_fa_auftrag%rowtype;

    v_netto                   number;
    v_brutto                  number;

    v_adr_nr                  isi_adressen.adr_nr%type;
    v_adr_id                  isi_adressen.adress_id%type;
    v_lam_order_pos_auf_id    isi_order_pos.auf_id%type;

    v_lam_artikel_id          isi_artikel.artikel_id%type;
    v_lam_art_fanr            lvs_lam.leitzahl%type;
    v_lam_art_faag            lvs_lam.fa_ag%type;

    v_lieferanten_nr          isi_adressen.adr_nr%type;
    --v_best_nr_kunde           isi_order_pos.best_nr_kunde%type;
    v_li_nr_lief              lvs_lam.li_nr_lief%type;
    v_naechste_maschine       isi_resource.res_ext_name%type;

    v_lam_p1                  lvs_lam.lam_p1%type;
    v_lam_p2                  lvs_lam.lam_p2%type;
    v_lam_p4                  lvs_lam.lam_p4%type;
    v_lam_p5                  lvs_lam.lam_p5%type;
    v_lam_p6                  lvs_lam.lam_p6%type;
    v_res_menge               number;

    v_VdaDatenfeldFuerLieferanten                         varchar2(255);
    v_VdaGewichtBrutto                                    varchar2(255);
    v_VdaGewichtNetto                                     varchar2(255);
    v_VdaLieferscheinNrBestNr                             varchar2(255);
    v_VdaLieferscheinNr                                   varchar2(255);
    v_VdaLieferscheinNrLief                               varchar2(255);
    v_VdaWarenempfaengerKurz                              varchar2(255);
    v_VdaWarenempfaengerLang1                             varchar2(255);
    v_VdaWarenempfaengerLang2                             varchar2(255);
    v_VdaWarenempfaengerLang3                             varchar2(255);
    v_VdaAbladestelle                                     varchar2(255);
    v_VdaAnzahlPackstuecke                                varchar2(255);
    v_VdaFuellmenge                                       varchar2(255);
    v_VdaFuellmengeMengeneinheit                          varchar2(255);
    v_VdaBezeichnungLieferungL                            varchar2(255);
    v_VdaSachNrLieferant                                  varchar2(255);
    v_VdaSachNrLieferantISKDPackm                         varchar2(255);
    v_VdaSachNrLieferantZusAngaben                        varchar2(255);
    v_VdaSachNrLieferantProdNr                            varchar2(255);
    v_VdaSachNrLieferantAbmessung                         varchar2(255);
    v_VdaSachNrKunde                                      varchar2(255);
    v_VdaDatum                                            varchar2(255);
    v_VdaAenderungKonstruktion                            varchar2(255);
    v_VdaAenderungKonstruktionO                           varchar2(255);
    v_VdaAenderungKonstruktionZ                           varchar2(255);
    v_VdaPackstuckNr                                      varchar2(255);
    v_VdaChangenNr                                        varchar2(255);
    v_VdaSachNrKundeBarcode                               varchar2(255);
    v_VdaFuellmengeBarcode                                varchar2(255);
    v_VdaPackstuckNrBarcode                               varchar2(255);
    v_VdaPackstuckNrBarcodeBez                            varchar2(1);
    v_VdaSachNrLieferantBarcode                           varchar2(255);
    v_VdaChangenNrBarcode                                 varchar2(255);
    v_VdaSachNrLieferantProdNrBarc                        varchar2(255);
    v_VdaNrKundeBarcode                                   varchar2(255);
    --v_VdaLieferanschriftkurz                              varchar2(255);
    v_VdaLieferantenNr                                    varchar2(255);
    v_VdaLieferantenNrBarcode                             varchar2(255);
    --v_VdaLieferantenAnschrift1                            varchar2(255);
    --v_VdaLieferantenAnschrift2                            varchar2(255);
    --v_VdaLieferantenAnschrift3                            varchar2(255);
    v_VdaLieferantenAnschrift4                            varchar2(255);
    v_VdaBestellNummerKunde                               varchar2(255);

    CURSOR c_lte is
      select lte.sid,
             lte.firma_nr,
             lte.lte_id,
             lte.lte_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) ziel_lgr_platz,
             lte.lgr_platz,
             lte.lte_akt_lhm,
             lte.order_vorgang_id,
             lte.lte_voll,
             (select decode(min(lhm.lhm_name), max(lhm.lhm_name), min(lhm.lhm_name) , NULL)
                from lvs_lhm lhm
               where lte.sid = lhm.sid (+)
                 and lte.lte_id = lhm.lte_id (+)) lhm_name,
             decode(min(lam.charge_id), max(lam.charge_id), min(lam.charge_id) , NULL) charge_id,
             decode(min(lam.kunden_nr), max(lam.kunden_nr), min(lam.kunden_nr) , NULL) kunden_nr,
             decode(min(lam.best_nr), max(lam.best_nr), min(lam.best_nr) , NULL) best_nr,
             min(lte.lte_akt_kg),
             sum(lam.lam_kg) netto,
             min(lam.order_pos_auf_id) order_pos_auf_id,
             sum(lam.menge),
             decode(min(lam.mengeneinheit_basis), max(lam.mengeneinheit_basis), min(lam.mengeneinheit_basis), null) menge_basis,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), null) leitzahl,
             decode(min(lam.prod_datum), max(lam.prod_datum), min(lam.prod_datum), null) prod_datum,
             decode(min(lam.zeichnung), max(lam.zeichnung), min(lam.zeichnung), NULL) zeichnung,
             decode(min(lam.zeichnung_index), max(lam.zeichnung_index), min(lam.zeichnung_index), null) zeichnung_index,
             decode(min(lam.artikel_id), max(lam.artikel_id), min(lam.artikel_id) , NULL) artikel_id,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), NULL) leitzahl,
             decode(min(lam.fa_ag), max(lam.fa_ag), min(lam.fa_ag), NULL) fa_ag,
             decode(min(lam.lieferant_nr), max(lam.lieferant_nr), min(lam.lieferant_nr) , NULL) lieferanten_nr,
             decode(min(lam.li_nr_lief), max(lam.li_nr_lief), min(lam.li_nr_lief), NULL) li_nr_lief,
             decode(min(lam.lam_p1), max(lam.lam_p1), min(lam.lam_p1), NULL) lam_p1,
             decode(min(lam.lam_p2), max(lam.lam_p2), min(lam.lam_p2), NULL) lam_p2,
             decode(min(lam.lam_p5), max(lam.lam_p5), min(lam.lam_p5), NULL) lam_p5,
             decode(min(lam.lam_p6), max(lam.lam_p6), min(lam.lam_p6), NULL) lam_p6,
             decode(min(lam.lam_mhd), max(lam.lam_mhd), min(lam.lam_mhd) , NULL) lam_mhd,
             nvl(sum(lam.res_menge), 0) res_menge,
             count(lam.lhm_id) artikel_anz_lhm,
             min(lte.res_ziel_lgr_platz) res_ziel_lgr_platz,
             decode(min(lam.zug_datum), max(lam.zug_datum), min(lam.zug_datum), null) lam_zug_datum,
             decode(min(a.artikel_p6), max(a.artikel_p6), min(a.artikel_p6), null) puffer_platz,
             min(lam.prod_datum),
             decode(min(lam.lte_id_lieferant), max(lam.lte_id_lieferant), decode(min(lam.sonst_id_lieferant), null, min(lam.lte_id_lieferant), null), null) lte_id_lieferant
        from lvs_lte lte,
             lvs_lam lam,
             isi_artikel a
       where lte.sid = lam.sid (+)
         and lte.lte_id = in_id
         and lte.lte_id = lam.lte_id (+)
         and (lam.artikel_id = in_artikel_id or in_artikel_id is null)
         and lam.artikel_id = a.artikel_id(+)
       group by lte.sid, lte.firma_nr, lte.order_vorgang_id, lte.lte_voll, lte.lte_id, lte.lte_name, lte.ziel_lgr_platz,
                lte.lte_akt_lhm, lte.lgr_platz;

    CURSOR c_lhm is
      select lam.sid,
             lam.firma_nr,
             lhm.lhm_id,
             lam.lte_id,
             lhm.lhm_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) ziel_lgr_platz,
             lte.lgr_platz,
             '1',
             lte.order_vorgang_id,
             'V',
             decode(min(lhm.lhm_name), max(lhm.lhm_name), min(lhm.lhm_name) , NULL) lhm_name,
             decode(min(lam.charge_id), max(lam.charge_id), min(lam.charge_id) , NULL) charge_id,
             decode(min(lam.kunden_nr), max(lam.kunden_nr), min(lam.kunden_nr) , NULL) kunden_nr,
             decode(min(lam.best_nr), max(lam.best_nr), min(lam.best_nr) , NULL) best_nr,
             min(lhm.lhm_akt_kg) brutto,
             sum(lam.lam_kg) netto,
             min(lam.order_pos_auf_id) order_pos_auf_id,
             sum(lam.menge),
             decode(min(lam.menge_basis), max(lam.menge_basis), min(lam.menge_basis), NULL) menge_basis,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl) , NULL) leitzahl,
             decode(min(lam.prod_datum), max(lam.prod_datum), min(lam.prod_datum), NULL) prod_datum,
             decode(min(lam.zeichnung), max(lam.zeichnung), min(lam.zeichnung), NULL) zeichnung,
             decode(min(lam.zeichnung_index), max(lam.zeichnung_index), min(lam.zeichnung_index) , NULL) zeichnung_index,
             decode(min(lam.artikel_id), max(lam.artikel_id), min(lam.artikel_id) , NULL) artikel_id,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), NULL) leitzahl,
             decode(min(lam.fa_ag), max(lam.fa_ag), min(lam.fa_ag), NULL) fa_ag,
             decode(min(lam.lieferant_nr), max(lam.lieferant_nr), min(lam.lieferant_nr), NULL) lieferanten_nr,
             decode(min(lam.li_nr_lief), max(lam.li_nr_lief), min(lam.li_nr_lief), null) li_nr_lief,
             decode(min(lam.lam_p1), max(lam.lam_p1), min(lam.lam_p1), null) lam_p1,
             decode(min(lam.lam_p2), max(lam.lam_p2), min(lam.lam_p2), null) lam_p2,
             decode(min(lam.lam_p4), max(lam.lam_p4), min(lam.lam_p4), null) lam_p4,
             decode(min(lam.lam_p6), max(lam.lam_p6), min(lam.lam_p6), null) lam_p6,
             decode(min(lam.lam_mhd), max(lam.lam_mhd), min(lam.lam_mhd), null) lam_mhd,
             nvl(sum(lam.res_menge), 0) res_menge,
             decode(min(lhm.komm_quell_lgr_platz), max(lhm.komm_quell_lgr_platz), min(lhm.komm_quell_lgr_platz), null) komm_quell_lgr_platz,
             min(lte.res_ziel_lgr_platz) res_ziel_lgr_platz,
             decode(min(lam.zug_datum), max(lam.zug_datum), min(lam.zug_datum), null) lam_zug_datum,
             decode(min(a.artikel_p6), max(a.artikel_p6), min(a.artikel_p6), null) puffer_platz,
             decode(min(lam.lte_id_lieferant), max(lam.lte_id_lieferant), decode(min(lam.sonst_id_lieferant), null, min(lam.lte_id_lieferant), null), null) lte_id_lieferant
        from lvs_lhm lhm,
             lvs_lte lte,
             lvs_lam lam,
             isi_artikel a
       where lam.lhm_id = in_id
         and lam.lte_id = lte.lte_id
         and lhm.lhm_id = lam.lhm_id
         and lam.artikel_id = a.artikel_id(+)
       group by lam.sid, lam.firma_nr, lte.order_vorgang_id, lhm.lhm_id, lam.lte_id, lhm.lhm_name, lte.ziel_lgr_platz, lte.lgr_platz;

    CURSOR c_art is
      select *
        from isi_artikel art
       where art.sid = v_lte_sid
         and art.artikel_id = v_lam_artikel_id;

    CURSOR c_art_kd is
      select *
        from isi_artikel_kunde art
       where art.sid = v_lte_sid
         and art.artikel_id = v_lam_artikel_id
         and art.kunden_nr = v_adr_nr;

    CURSOR c_pos is
      select *
        from isi_order_pos pos
       where pos.sid = v_lte_sid
         and pos.firma_nr = v_lte_firma_nr
         and pos.auf_id = v_lam_order_pos_auf_id;

    CURSOR c_kopf is
      select *
        from isi_order_kopf kopf
       where kopf.sid = v_lte_sid
         and kopf.firma_nr = v_lte_firma_nr
         and kopf.vorgang_typ = 'WAE'
         and kopf.vorgang_id = v_lte_order_vorgang_id
         and kopf.li_nr = v_pos.li_nr;

    CURSOR c_resource is
      select r.res_ext_name
        from isi_resource r
       where r.sid = v_fa_auftrag.sid
         and r.res_id = v_fa_auftrag.res_id;

    CURSOR c_fa_next_ag is
      select fa.*
        from bde_fa_auftrag fa
       where fa.sid = v_lte_sid
         and fa.firma_nr = v_lte_firma_nr
         and fa.leitzahl = v_lam_art_fanr
         and fa.fa_ag > v_lam_art_faag;

    CURSOR c_fa_auf_lte is
      select decode(min(fa.best_nr_kunde), max(fa.best_nr_kunde), min(fa.best_nr_kunde), NULL)
        from bde_fa_auftrag fa,
             lvs_lam lam
       where fa.sid = v_lte_sid
         and fa.firma_nr = v_lte_firma_nr
         and (lam.lte_id = v_lte_lte_id
           or lam.lhm_id = v_lte_lte_id)
         and fa.leitzahl = lam.leitzahl
         and decode(fa.kenz_letzt_ag, 1, fa.fa_ag, 0) = nvl(lam.fa_ag, 0);

    CURSOR c_fa_auf_lhm is
      select decode(min(fa.best_nr_kunde), max(fa.best_nr_kunde), min(fa.best_nr_kunde), NULL)
        from bde_fa_auftrag fa,
             lvs_lam lam
       where fa.sid = v_lte_sid
         and fa.firma_nr = v_lte_firma_nr
         and lam.lhm_id = v_lte_lte_id
         and fa.leitzahl = lam.leitzahl
         and decode(fa.kenz_letzt_ag, 1, fa.fa_ag, 0) = nvl(lam.fa_ag, 0);

    CURSOR c_kunde is
      select *
        from isi_adressen adr
       where adr.sid = v_lte_sid
         and adr.firma_nr = v_lte_firma_nr
         and adr.adr_art = 'K'
         and adr.adr_nr = v_adr_nr
         and adr.adr_liefer = 0;

    CURSOR c_lieferant is
      select *
        from isi_adressen adr
       where adr.sid = v_lte_sid
         and adr.firma_nr = v_lte_firma_nr
         and adr.adr_art = 'L'
         and adr.adr_nr = v_lieferanten_nr
         and adr.adr_liefer = 0;

    CURSOR c_adr is
      select *
        from isi_adressen adr
       where adr.sid = v_lte_sid
         and adr.adress_id = v_adr_id;

    CURSOR c_charge is
      select *
        from lvs_charge c
       where c.sid = v_lte_sid
         and c.charge_id = v_lam_charge_id;

    CURSOR c_lhm_c is
      select *
        from lvs_lhm_cfg lhm_c
       where lhm_c.sid = v_lte_sid
         and lhm_c.firma_nr = v_lte_firma_nr
         and lhm_c.lhm_name = v_lte_lte_name;

    CURSOR c_lte_c is
      select *
        from lvs_lte_cfg lte_c
       where lte_c.sid = v_lte_sid
         and lte_c.firma_nr = v_lte_firma_nr
         and lte_c.lte_name = v_lte_lte_name;


    v_huf_label_nr       number;
    v_ausl_datum         date;
    v_ausl_puffer_platz  isi_artikel.artikel_p6%type;
    v_lagerort           varchar2(255);
    v_lgr_verwend        lvs_lgr.lgr_verwendung%type;
    v_grp                varchar2(255);
    v_mhd                date;
    v_lam_zug_datum      date;
    v_etikett_basis      varchar2(10);
    v_etikett_typ        varchar2(10);
    v_artikel_anz_lhm    number;
    v_lam_min_prod_datum lvs_lam.prod_datum%type;

    v_lhm_komm_quell_lgr_platz  lvs_lhm.komm_quell_lgr_platz%type;
    v_res_ziel_lgr_platz        lvs_lte.res_ziel_lgr_platz%type;
    v_ziel_lgr                  lvs_lgr%rowtype;
    v_wa_verw_puffer_wa         boolean;
    v_index_hinweis             varchar2(50);
    v_puffer_platz_feld_markier varchar2(10);
  begin
    v_VdaDatenfeldFuerLieferanten := NULL;
    v_VdaGewichtNetto := NULL;
    v_VdaGewichtBrutto := NULL;
    v_VdaLieferscheinNrBestNr := NULL;
    v_VdaLieferscheinNr := NULL;
    v_VdaLieferscheinNrLief := NULL;
    v_VdaWarenempfaengerKurz := NULL;
    v_VdaWarenempfaengerLang1 := NULL;
    v_VdaWarenempfaengerLang2 := NULL;
    v_VdaWarenempfaengerLang3 := NULL;
    v_VdaAbladestelle := NULL;
    v_VdaAnzahlPackstuecke := NULL;
    v_VdaFuellmenge := NULL;
    v_VdaFuellmengeMengeneinheit := NULL;
    v_VdaBezeichnungLieferungL := NULL;
    v_VdaSachNrLieferant := NULL;
    v_VdaSachNrLieferantISKDPackm := NULL;
    v_VdaSachNrLieferantZusAngaben := NULL;
    v_Vdasachnrlieferantprodnr := NULL;
    v_VdaSachNrLieferantAbmessung := NULL;
    v_VdaSachNrKunde := NULL;
    v_VdaDatum := NULL;
    v_VdaAenderungKonstruktion := NULL;
    v_Vdaaenderungkonstruktiono := NULL;
    v_VdaAenderungKonstruktionZ := NULL;
    v_VdaChangenNr := NULL;
    v_VdaLieferantenNr := NULL;
    v_VdaSachNrKundeBarcode := NULL;
    v_VdaFuellmengeBarcode := NULL;
    --v_VdaPackstuckNrBarcode := NULL;
    v_VdaSachNrLieferantBarcode := NULL;
    v_VdaChangenNrBarcode := NULL;
    v_Vdasachnrlieferantprodnrbarc := NULL;
    v_VdaNrKundeBarcode := NULL;
    v_VdaLieferantenNrBarcode := NULL;
    v_VdaLieferantenAnschrift4 := NULL;

    v_lam_art_fanr := NULL;
    v_lam_art_faag := NULL;
    v_huf_label_nr := null;
    v_ausl_datum   := null;
    v_lhm_komm_quell_lgr_platz := null;
    v_etikett_typ  := 'E';

    if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lte
    then
      v_etikett_basis := C.Basis_Lte;

      OPEN c_lte;
      FETCH c_lte into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz, v_lte_lgr_platz,
                           v_lte_lte_akt_lhm,v_lte_order_vorgang_id,  v_lte_lte_voll, v_lhm_lhm_name, v_lam_charge_id,
                           v_lam_kunden_nr, v_lam_best_nr, v_brutto, v_netto,
                           v_order_pos_auf_id, v_lam_memge, v_lam_memge_basis, v_lam_leitzahl,
                           v_lam_prod_datum, v_lam_zeichnung, v_lam_zeichnung_index,
                           v_lam_artikel_id, v_lam_art_fanr, v_lam_art_faag, v_lieferanten_nr,
                           v_li_nr_lief, v_lam_p1, v_lam_p2, v_lam_p5, v_lam_p6, v_mhd, v_res_menge, v_artikel_anz_lhm,
                           v_res_ziel_lgr_platz, v_lam_zug_datum, v_ausl_puffer_platz, v_lam_min_prod_datum, v_huf_label_nr;

      v_found := c_lte%FOUND;
      CLOSE c_lte;

      if v_found
      then
        v_artikel_anz_lhm := nvl(v_artikel_anz_lhm, 0);
        v_lte_id := v_lte_lte_id;
        get_ausl_datum(in_sid, in_firma_nr, v_lte_id, v_ausl_datum);
        if v_ausl_datum is not null
        then
          -- !! Achtung !! Huf spezifisch (Nur Auslagerungen)
          c_lte_label_nr_eintr(in_sid, in_firma_nr, in_id, in_artikel_id);
          v_huf_label_nr := get_lte_label_nr(in_sid, in_firma_nr, v_lte_id, v_lam_artikel_id);
        end if;
      end if;

      OPEN c_lte_c;
      FETCH c_lte_c into v_lte_c;
      if c_lte_c%found
      then
        -- Anforderung von P. Bergfink am 06.09.2007
        --if v_lte_c.verwaltet_von = 'HOST'
        --then
        v_VdaDatenfeldFuerLieferanten := v_lte_c.lte_text;
        --end if;
      end if;
      CLOSE c_lte_c;

      v_VdaBestellNummerKunde := null;
      OPEN c_fa_auf_lte;
      FETCH c_fa_auf_lte into v_VdaBestellNummerKunde;
      CLOSE c_fa_auf_lte;
    elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lhm
    then
      v_etikett_basis := C.Basis_Lhm;

      OPEN c_lhm;
      FETCH c_lhm into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz, v_lte_lgr_platz,
                           v_lte_lte_akt_lhm,v_lte_order_vorgang_id,  v_lte_lte_voll, v_lhm_lhm_name, v_lam_charge_id,
                           v_lam_kunden_nr, v_lam_best_nr, v_brutto, v_netto,
                           v_order_pos_auf_id, v_lam_memge, v_lam_memge_basis, v_lam_leitzahl,
                           v_lam_prod_datum, v_lam_zeichnung, v_lam_zeichnung_index,
                           v_lam_artikel_id, v_lam_art_fanr, v_lam_art_faag, v_lieferanten_nr,
                           v_li_nr_lief, v_lam_p1, v_lam_p2, v_lam_p4, v_lam_p6, v_mhd, v_res_menge, v_lhm_komm_quell_lgr_platz,
                           v_res_ziel_lgr_platz, v_lam_zug_datum, v_ausl_puffer_platz, v_huf_label_nr;

      v_found := c_lhm%FOUND;
      CLOSE c_lhm;

      if v_found
      then
        get_ausl_datum(in_sid, in_firma_nr, v_lte_id, v_ausl_datum);
        if v_ausl_datum is not null
        then
          -- !! Achtung !! Huf spezifisch (Nur Auslagerungen)
          c_lhm_label_nr_eintr(in_sid, in_firma_nr, in_id);
          v_huf_label_nr := get_lhm_label_nr(in_sid, in_firma_nr, in_id);
        end if;
      end if;

      OPEN c_lhm_c;
      FETCH c_lhm_c into v_lhm_c;
      if c_lhm_c%FOUND then
        -- Bei Huf nur Soll-Behälter drucken
        -- Anforderung von P. Bergfink am 06.09.2007
        --if v_lhm_c.verwaltet_von = 'HOST'
        --then
        v_VdaDatenfeldFuerLieferanten := v_lhm_c.lhm_text;
        --end if;
      end if;
      CLOSE c_lhm_c;

      v_VdaBestellNummerKunde := NULL;
      OPEN c_fa_auf_lhm;
      FETCH c_fa_auf_lhm into v_VdaBestellNummerKunde;
      CLOSE c_fa_auf_lhm;
    end if;

    if v_huf_label_nr = 0
    then
      v_huf_label_nr := null;
    end if;

    v_wa_verw_puffer_wa := false;
    if lvs_p_base.get_lgr_platz(v_lte_ziel_lgr_platz, v_ziel_lgr)
    then
      if v_ziel_lgr.lgr_verwendung_proj = 'PUFFER_WA'
      then
        v_wa_verw_puffer_wa := true;
      end if;
    end if;

    v_naechste_maschine := NULL;
    if v_lam_art_fanr is not NULL
    then
      OPEN c_fa_next_ag;
      FETCH c_fa_next_ag into v_fa_auftrag;
      if c_fa_next_ag%FOUND
      then
        OPEN c_resource;
        FETCH c_resource into v_naechste_maschine;
        CLOSE c_resource;
      end if;
      CLOSE c_fa_next_ag;
    end if;

    OPEN c_art;
    FETCH c_art into v_art;
    if c_art%NOTFOUND then
      v_art := NULL;
    end if;
    CLOSE c_art;

    if v_found
    then
      v_VdaGewichtNetto              := v_netto;
      v_VdaGewichtBrutto             := v_brutto;
      v_VdaLieferscheinNrBestNr      := v_lam_best_nr;
      v_Vdaabladestelle              := v_lte_ziel_lgr_platz;
      v_Vdasachnrlieferantprodnr     := v_lam_leitzahl;
      v_Vdasachnrlieferantiskdpackm  := v_lte_lte_name;
      v_Vdasachnrlieferantzusangaben := v_lhm_lhm_name;
      v_Vdaanzahlpackstuecke         := v_lte_lte_akt_lhm;
      if in_artikel_id is not null
      then
        -- Bei Artikelbezogenen Etiketten nur die Anzahl des jew. Artikels anziegen
        v_Vdaanzahlpackstuecke       := v_artikel_anz_lhm;
      end if;
      v_Vdasachnrlieferant           := format_artikel(nvl(v_art.artikel, 'VERSCHIEDENE'));
      if v_art.artikel is not null
      then
        v_Vdasachnrlieferant := v_Vdasachnrlieferant || ' / ' || nvl(v_lam_zeichnung_index, '0000');
      end if;

      if v_art.waren_typ like 'V%'
      then
        if v_lam_p1 is null
        then
          v_lam_p1 := 'V';
        else
          v_lam_p1 := 'V / ' || v_lam_p1;
        end if;
      end if;

      v_Vdabezeichnunglieferungl     := v_art.bezeichnung1;
      v_Vdasachnrlieferantabmessung  := v_art.bezeichnung2;
      v_Vdaaenderungkonstruktiono    := v_art.bezeichnung3;
      if v_lam_prod_datum is not NULL then
        v_Vdadatum                   := 'P' || to_char(v_lam_prod_datum, 'YYMMDD');
      end if;
      v_Vdaaenderungkonstruktionz    := v_lam_zeichnung;
      v_Vdaaenderungkonstruktion     := v_lam_zeichnung_index;

      if v_lam_leitzahl is not NULL then
        v_Vdasachnrlieferantprodnrbarc := '20S' || v_lam_leitzahl;
      end if;
      if v_art.artikel is not NULL then
        v_Vdasachnrlieferantbarcode := v_art.artikel;
      end if;
      v_Vdafuellmengebarcode := 'Q' || v_lam_memge;

      OPEN c_charge;
      FETCH c_charge into v_charge;
      v_found := c_charge%FOUND;
      CLOSE c_charge;

      if v_found then
        v_Vdachangennr := v_charge.charge_bez;
        v_Vdachangennrbarcode := 'H' || v_charge.charge_bez;
      end if;
      v_VdaLieferantenNr := v_lieferanten_nr;
      v_VdaLieferscheinNrLief := v_li_nr_lief;
      v_VdaLieferantenNrBarcode := 'V' || v_lieferanten_nr;

      OPEN c_pos;
      FETCH c_pos into v_pos;
      v_found := c_pos%FOUND;
      if not v_found then
        v_adr_nr := v_lam_kunden_nr;
        OPEN c_kunde;
        FETCH c_kunde into v_adr;
        v_found := c_kunde%FOUND;
        CLOSE c_kunde;
        if v_found then
          v_VdaWarenempfaengerKurz := v_adr.name_1;
          v_VdaWarenempfaengerLang1 := v_adr.name_1;
          v_VdaWarenempfaengerLang2 := v_adr.name_2;
          v_VdaWarenempfaengerLang3 := v_adr.plz || ' ' || v_adr.ort;
        end if;
      else
        OPEN c_kopf;
        FETCH c_kopf into v_kopf;
        if v_found then
          v_adr_id := v_kopf.adress_id;
          v_VdaLieferscheinNr := to_char(v_kopf.vorgang_id);
          if v_kopf.wae_ziel is not NULL
          then
            v_Vdaabladestelle := v_kopf.wae_ziel;
          end if;
          OPEN c_adr;
          FETCH c_adr into v_adr;
          v_found := c_adr%FOUND;
          if v_found then
            v_Vdawarenempfaengerkurz := v_adr.name_1;
            v_VdaWarenempfaengerLang1 := v_adr.name_1;
            v_VdaWarenempfaengerLang2 := v_adr.name_2;
            v_VdaWarenempfaengerLang3 := v_adr.plz || ' ' || v_adr.ort;
            v_Vdaabladestelle := nvl(v_kopf.wae_ziel, v_vdaabladestelle);
            v_adr_nr := v_adr.adr_nr;
          end if;
          CLOSE c_adr;
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
          OPEN c_kunde;
          FETCH c_kunde into v_adr;
          v_found := c_kunde%FOUND;
          CLOSE c_kunde;
          if v_found then
            v_VdaWarenempfaengerKurz := v_adr.name_1 || ' ' || v_adr.name_2 || ' ' || v_adr.plz || ' ' || v_adr.ort;
            v_VdaWarenempfaengerLang1 := v_adr.name_1;
            v_VdaWarenempfaengerLang2 := v_adr.name_2;
            v_VdaWarenempfaengerLang3 := v_adr.plz || ' ' || v_adr.ort;
          end if;
        end if;
        CLOSE c_kopf;
      end if;
      CLOSE c_pos;

      OPEN c_lieferant;
      FETCH c_lieferant into v_adr;
      v_found := c_lieferant%FOUND;
      CLOSE c_lieferant;
      if v_found then
        --v_VdaLieferantenAnschrift1 := v_adr.name_1;
        --v_VdaLieferantenAnschrift2 := v_adr.name_2;
        --v_VdaLieferantenAnschrift3 := v_adr.name_3;
        v_VdaLieferantenAnschrift4 := v_adr.name_1 || ', ' || v_adr.name_2 || ', ' || v_adr.plz || ', ' || v_adr.ort;
      end if;

      if v_art.artikel is not NULL then
        OPEN c_art_kd;
        FETCH c_art_kd into v_art_kd;
        v_found := c_art_kd%FOUND;
        CLOSE c_art_kd;
        if  v_found
        and v_art_kd.kd_art_nr is not NULL
        and v_lam_art_faag is NULL
        then
          v_VdaSachnrkundebarcode := 'P' || v_art_kd.kd_art_nr;
          v_VdaSachnrkunde := v_art_kd.kd_art_nr;
       end if;
     end if;

     if v_ausl_datum is null
     then
       v_etikett_typ  := 'E';
       -- Keine Auslagerung, also auch keine Abladestelle
       v_VdaAbladestelle := null;
       v_Vdafuellmenge   := v_lam_memge;
       if v_lam_memge > nvl(v_res_menge, 0) and nvl(v_res_menge, 0) > 0
       then
         -- bei Teilentnahme
         v_Vdafuellmenge   := v_lam_memge - v_res_menge;
       end if;
       get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lte_lgr_platz, v_art, v_lagerort, v_grp, v_lgr_verwend);
       if v_lgr_verwend = c.LGR_TYP_Lager
       then
         v_etikett_typ := 'U';
       end if;
       get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lte_ziel_lgr_platz, v_art, v_lagerort, v_grp, v_lgr_verwend);
     else
       v_etikett_typ  := 'A';

       -- -WK- 20080627: Hinweis fehlte seit Migration von V2
       if v_lam_zeichnung_index is not null and v_art.zeichnung_index is not null
          and v_art.zeichnung_index != ' ' and v_art.zeichnung_index != '   ' -- bei Huf in den Stammdaten sind Felder mit Leerzeichen gefüllt, wenn sie nicht belegt sind
          and v_lam_zeichnung_index != v_art.zeichnung_index
       then
         v_index_hinweis := 'ACHTUNG: Wechsel Teile-Index!';
       end if;

       v_Vdafuellmenge   := v_lam_memge;

       if v_VdaAbladestelle != v_res_ziel_lgr_platz
       then
         v_VdaAbladestelle := v_VdaAbladestelle || ' - ' || v_res_ziel_lgr_platz;
         v_Vdafuellmenge   := v_res_menge;
       end if;

       -- -WK- 16.04.2008 nicht mehr die Sonderteilenummer benutzen
       get_ausl_art_lgr_info(in_sid, in_firma_nr, v_VdaAbladestelle, v_art, v_ausl_puffer_platz);

       if v_ausl_puffer_platz is not null and v_wa_verw_puffer_wa
       then
         v_VdaAbladestelle := v_VdaAbladestelle || ' / ' || v_ausl_puffer_platz;
       end if;

       -- Bei einer Auslagerung aktuellen Platz anzeigen
       get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lte_lgr_platz, v_art, v_lagerort, v_grp, v_lgr_verwend);
       if v_lgr_verwend = c.LGR_TYP_WE
       or v_lgr_verwend = c.LGR_TYP_LagerP
       then
         v_etikett_typ := 'D';
       else
         if v_lhm_komm_quell_lgr_platz is not null
         then
           -- Auf dem LHM Etikett den Lagerplatz der Entnahme drucken
           get_lgr_platz_ort_texte(in_sid, in_firma_nr, v_lhm_komm_quell_lgr_platz, v_art, v_lagerort, v_grp, v_lgr_verwend);
         end if;
       end if;
     end if;

     if nvl(v_lam_p6, 0) = 0
     then
       -- wenn kein Zähler gesetzt ist, dann auch kein MHD Ausgeben
       v_mhd := null;
     end if;

     if v_etikett_basis = c.BASIS_LTE
     then
       update lvs_lte t
          set t.lte_eti_druck_status = c.ETI_STATUS_GEDRUCKT
        where t.lte_id = in_id;

       commit;
     elsif v_etikett_basis = c.BASIS_LHM
     then
       update lvs_lhm t
          set t.lhm_eti_druck_status = c.ETI_STATUS_GEDRUCKT
        where t.lhm_id = in_id;

       commit;
     end if;
   end if;

   v_VdaPackstuckNrBarcodeBez := 'M';
   if in_waren_typ = 'MP' then
     v_VdaPackstuckNrBarcodeBez := 'G';
   elsif v_lte_lte_voll = C.Lte_Voll_v then
     v_VdaPackstuckNrBarcodeBez := 'S';
   end if;
   v_Vdapackstucknr               := in_id;
   v_VdaPackstuckNrBarcode := v_VdaPackstuckNrBarcodeBez || in_id;

   -- -WK- 20080910: graue Feldmarkierung soll bei Pufferplätzen mit Ausnahme von
   -- Teile-Nr. die als Ersatz-Teil deklariert sind und
   -- Verpackung = Styropor-Lagen (SQL-Abfrage "ELT EPS%"), aktiv sein.
   v_puffer_platz_feld_markier := '';
   if v_ausl_puffer_platz is not null and v_wa_verw_puffer_wa
      and not (v_art.ersatzteil = 'T')
      and not (v_VdaDatenfeldFuerLieferanten like 'ELT EPS%')
   then
     v_puffer_platz_feld_markier := 'T';
   end if;

   v_print_daten :=
    'etikett_typ='                                        || v_etikett_typ || CHR(13) || CHR(10) ||
    'artikel_id='                                         || nvl(v_lam_artikel_id, '') || CHR(13) || CHR(10) ||
    'fa_ag='                                              || nvl(v_lam_art_faag, '') || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantDatenfeldFuerLieferanten='         || v_VdaDatenfeldFuerLieferanten || CHR(13) || CHR(10) ||
    'VdaGewichtBrutto='                                   || v_VdaGewichtBrutto || CHR(13) || CHR(10) ||
    'VdaGewichtNetto='                                    || v_VdaGewichtNetto || CHR(13) || CHR(10) ||
    'VdaLieferscheinNrBestellnummer='                     || v_VdaLieferscheinNrBestNr || CHR(13) || CHR(10) ||
    'VdaLieferscheinNr='                                  || nvl(v_VdaLieferscheinNr, 'VERSCHIEDENE') || CHR(13) || CHR(10) ||
    'VdaLieferscheinNrLief='                              || v_VdaLieferscheinNrLief || CHR(13) || CHR(10) ||
    'VdaWarenempfaengerKurz='                             || v_VdaWarenempfaengerKurz || CHR(13) || CHR(10) ||
    'VdaWarenempfaengerLang1='                            || v_VdaWarenempfaengerLang1 || CHR(13) || CHR(10) ||
    'VdaWarenempfaengerLang2='                            || v_VdaWarenempfaengerLang2 || CHR(13) || CHR(10) ||
    'VdaWarenempfaengerLang3='                            || v_VdaWarenempfaengerLang3 || CHR(13) || CHR(10) ||
    'VdaAbladestelle='                                    || v_VdaAbladestelle || CHR(13) || CHR(10) ||
    'VdaAnzahlPackstuecke='                               || v_VdaAnzahlPackstuecke || CHR(13) || CHR(10) ||
    'VdaFuellmenge='                                      || v_VdaFuellmenge || CHR(13) || CHR(10) ||
    'VdaFuellmengeMengeneinheit='                         || v_VdaFuellmengeMengeneinheit || CHR(13) || CHR(10) ||
    'VdaBezeichnungLieferungLeistung='                    || v_VdaBezeichnungLieferungL || CHR(13) || CHR(10) ||
    'VdaSachNrLieferant='                                 || v_VdaSachNrLieferant || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantISKDPackmittel='                   || v_VdaSachNrLieferantISKDPackm || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantZusAngaben='                       || v_VdaSachNrLieferantZusAngaben || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantProduktionsNr='                    || v_VdaSachNrLieferantProdNr || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantAbmessung='                        || v_VdaSachNrLieferantAbmessung || CHR(13) || CHR(10) ||
    'VdaSachNrKunde='                                     || v_VdaSachNrKunde || CHR(13) || CHR(10) ||
    'VdaDatum='                                           || v_VdaDatum || CHR(13) || CHR(10) ||
    'VdaAenderungKonstruktion='                           || v_VdaAenderungKonstruktion || CHR(13) || CHR(10) ||
    'VdaAenderungKonstruktionOberflaeche='                || v_VdaAenderungKonstruktionO || CHR(13) || CHR(10) ||
    'VdaAenderungKonstruktionZeichnung='                  || v_VdaAenderungKonstruktionZ || CHR(13) || CHR(10) ||
    'VdaPackstuckNr='                                     || v_VdaPackstuckNr || CHR(13) || CHR(10) ||
    'VdaChangenNr='                                       || nvl(v_VdaChangenNr, 'VERSCHIEDENE') || CHR(13) || CHR(10) ||
    'VdaLieferantenNr='                                   || v_VdaLieferantenNr || CHR(13) || CHR(10) ||
    'VdaLieferantenanschriftLang='                        || v_VdaLieferantenAnschrift4 || CHR(13) || CHR(10) ||
    'VdaSachNrKundeBarcode='                              || v_VdaSachNrKundeBarcode || CHR(13) || CHR(10) ||
    'VdaFuellmengeBarcode='                               || v_VdaFuellmengeBarcode || CHR(13) || CHR(10) ||
    'VdaPackstuckNrBarcode='                              || v_VdaPackstuckNrBarcode || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantBarcode='                          || v_VdaSachNrLieferantBarcode || CHR(13) || CHR(10) ||
    'VdaChangenNrBarcode='                                || v_VdaChangenNrBarcode || CHR(13) || CHR(10) ||
    'VdaSachNrLieferantProduktionsNrBarcode='             || v_Vdasachnrlieferantprodnrbarc || CHR(13) || CHR(10) ||
    'VdaNrKundeBarcode='                                  || v_VdaNrKundeBarcode || CHR(13) || CHR(10) ||
    'VdaLieferantenNrBarcode='                            || v_VdaLieferantenNrBarcode || CHR(13) || CHR(10) ||
    'Labelnummer='                                        || v_huf_label_nr || CHR(13) || CHR(10) ||
    'KennD='                                              || nvl(v_lam_p1, '') || CHR(13) || CHR(10) ||
    'KennEGB='                                            || nvl(v_lam_p2, '') || CHR(13) || CHR(10) ||
    'PosNr_Knr='                                          || nvl(lpad(v_lam_art_faag, 3, '0'), '') || ' / ' || nvl(v_lam_kunden_nr, '') || CHR(13) || CHR(10) ||
    'Auslagerdatum='                                      || nvl(to_char(v_ausl_datum, 'dd.mm.yyyy hh24:mi:ss'), '') || CHR(13) || CHR(10) ||
    'Einlagerdatum='                                      || nvl(to_char(v_lam_prod_datum, 'dd.mm.yyyy hh24:mi:ss'), nvl(to_char(v_lam_min_prod_datum, 'dd.mm.yyyy') || ' / VERSCH', 'VERSCHIEDENE')) || CHR(13) || CHR(10) ||
    'MHD='                                                || nvl(to_char(v_mhd, 'dd.mm.yyyy'), '') || CHR(13) || CHR(10) ||
    'MHDAnz='                                             || nvl(v_lam_p6, '') || CHR(13) || CHR(10) || -- Anzahl der Veränderungen am MHD duch Labor
    'Lagerort='                                           || nvl(v_lagerort, '') || CHR(13) || CHR(10) ||
    'GRP='                                                || nvl(v_grp, '') || CHR(13) || CHR(10) ||
    'Ladungstraeger='                                     || nvl(v_VdaDatenfeldFuerLieferanten, '') || CHR(13) || CHR(10) ||
    'LTE_ID='                                             || v_lte_id || CHR(13) || CHR(10) ||
    'LTE_IDBarcode='                                      || v_VdaPackstuckNrBarcodeBez || v_lte_id || CHR(13) || CHR(10) ||
    'TIndexHinweis='                                      || v_index_hinweis || CHR(13) || CHR(10) ||
    'PufferPlatzFeldMarkier='                             || v_puffer_platz_feld_markier || CHR(13) || CHR(10) ||
    'AuslPufferPlatz='                                    || v_ausl_puffer_platz || CHR(13) || CHR(10);

    return (v_print_daten);
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
    when v_error then
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text);
    when others then
      if v_err_nr is not NULL then
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end vda_etikett;

end;
/



-- sqlcl_snapshot {"hash":"97d50e3b91b7e3f2678203ae6356fef8796e04ea","type":"PACKAGE_BODY","name":"Z_HUF_DRUCK","schemaName":"DIRKSPZM32","sxml":""}