create or replace 
package body DIRKSPZM32.isi_print is


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
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(4096);

  -- Function and procedure implementations
  -------------------------------------------------------------------------------------------------------
  -- VDA-Etikett druck
  -------------------------------------------------------------------------------------------------------
  function vda_etikett(in_sid         in isi_sid.sid%type,
                       in_firma_nr    in isi_firma.firma_nr%type,
                       in_id          in lvs_lte.lte_id%type,
                       in_waren_typ   in lvs_lte.waren_typ%type)
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
    v_lte_lte_name            lvs_lte.lte_name%type;
    v_lte_ziel_lgr_platz      lvs_lte.ziel_lgr_platz%type;
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
    v_lte_id_b                varchar2(100);
    v_lte_lte_voll            lvs_lte.lte_voll%type;
    v_lam_zeichnung           lvs_lam.zeichnung%type;
    v_lam_zeichnung_index     lvs_lam.zeichnung_index%type;
    v_lam_best_nr             lvs_lam.best_nr%type;
    v_fa_auftrag              bde_fa_auftrag%rowtype;

    v_netto                   number;
    v_brutto                  number;

    v_adr_nr                  isi_adressen.adr_nr%type;
    v_adr_liefer              isi_adressen.adr_liefer%type;
    v_adr_id                  isi_adressen.adress_id%type;
    v_lam_order_pos_auf_id    isi_order_pos.auf_id%type;

    v_lam_artikel_id          isi_artikel.artikel_id%type;
    v_lam_art_fanr            lvs_lam.leitzahl%type;
    v_lam_art_faag            lvs_lam.fa_ag%type;

    v_lieferanten_nr          isi_adressen.adr_nr%type;
    v_best_nr_kunde           isi_order_pos.best_nr_kunde%type;
    v_li_nr_lief              lvs_lam.li_nr_lief%type;
    v_naechste_maschine       isi_resource.res_ext_name%type;
    v_LaborStatus             lvs_lam.Labor_Status%type;
    v_LaborStatusText         lvs_lam.labor_text%type;

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
    v_VdaSachNrLieferantBarcode                           varchar2(255);
    v_VdaChangenNrBarcode                                 varchar2(255);
    v_VdaSachNrLieferantProdNrBarc                        varchar2(255);
    v_VdaNrKundeBarcode                                   varchar2(255);
    v_VdaLieferanschriftkurz                              varchar2(255);
    v_VdaLieferantenNr                                    varchar2(255);
    v_VdaLieferantenNrBarcode                             varchar2(255);
    v_VdaLieferantenAnschrift1                            varchar2(255);
    v_VdaLieferantenAnschrift2                            varchar2(255);
    v_VdaLieferantenAnschrift3                            varchar2(255);
    v_VdaLieferantenAnschrift4                            varchar2(255);
    v_VdaBestellNummerKunde                               varchar2(255);
    v_VdaBezeichnungKunde                                 varchar2(50);
    v_VdaLaborStatus                                      varchar2(255);
    v_VdaLaborStatusText                                  varchar2(255);
    v_VdaEtiDatum                                         varchar2(255);
    v_VdaEtiZeit                                          varchar2(255);


    v_ChargeId                                            varchar2(50);
    v_InfoHinweis                                         varchar2(50);

    i                                                     number;

    CURSOR c_lte is
      select lte.sid,
             lte.firma_nr,
             lte.lte_id,
             lte.lte_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
             stradd_distinct(lam.labor_status) Labor_status,
             stradd_distinct(lam.labor_text) Labor_text,
             lte.lte_akt_lhm,
             lte.order_vorgang_id,
             lte.lte_voll,
             (select decode(min(lhm.lhm_name), max(lhm.lhm_name), min(lhm.lhm_name) , NULL)
                from lvs_lhm lhm
               where lte.sid = lhm.sid (+)
                 and lte.lte_id = lhm.lte_id (+)) lhm_name,
             min(lam.charge_id) charge_id,   -- -AG- Erste Charge der Palette andrucken
             decode(min(lam.kunden_nr), max(lam.kunden_nr), min(lam.kunden_nr) , NULL) kunden_nr,
             decode(min(lam.best_nr), max(lam.best_nr), min(lam.best_nr) , NULL) best_nr,
             min(lte.lte_akt_kg),
             sum(lam.lam_kg) netto,
             min(lam.order_pos_auf_id) order_pos_auf_id,
             sum(lam.menge),
             decode(min(lam.mengeneinheit_basis), max(lam.mengeneinheit_basis), min(lam.mengeneinheit_basis) , NULL) menge_basis,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl) , NULL) leitzahl,
             decode(trunc(min(lam.prod_datum)), trunc(max(lam.prod_datum)), trunc(min(lam.prod_datum)) , NULL) prod_datum,
             decode(min(lam.zeichnung), max(lam.zeichnung), min(lam.zeichnung) , NULL) zeichnung,
             decode(min(lam.zeichnung_index), max(lam.zeichnung_index), min(lam.zeichnung_index) , NULL) zeichnung_index,
             decode(min(lam.artikel_id), max(lam.artikel_id), min(lam.artikel_id) , NULL) artikel_id,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), NULL) leitzahl,
             decode(min(lam.fa_ag), max(lam.fa_ag), min(lam.fa_ag), NULL) fa_ag,
             decode(min(lam.lieferant_nr), max(lam.lieferant_nr), min(lam.lieferant_nr) , NULL) lieferanten_nr,
             decode(min(lam.li_nr_lief), max(lam.li_nr_lief), min(lam.li_nr_lief) , NULL) li_nr_lief,
             decode(min(lam.charge_id), max(lam.charge_id), min(lam.charge_id) , NULL) charge_id,
             decode(min(nvl(lam.owner_address_id, 0)), 0, null, 'Konsi-Ware!') info_hinweis
        from lvs_lte lte,
             lvs_lam lam
       where  lte.sid = lam.sid (+)
         and lte.lte_id = in_id
         and lte.lte_id = lam.lte_id (+)
       group by lte.sid, lte.firma_nr, lte.order_vorgang_id, lte.lte_voll, lte.lte_id, lte.lte_name, lte.ziel_lgr_platz,
                lte.lte_akt_lhm, lte.lgr_platz;

    CURSOR c_lte_all_lam is
      select nvl(lpad(to_char(op.auftrag),6, ' '), '        ') || '   ' ||
             nvl(substr (op.li_nr, 3), '      ') || '   ' ||
             rpad(nvl(a.artikel, ' '), 22, ' ') || '   ' ||
             a.bezeichnung1
        from lvs_lte lte,
             lvs_lam lam,
             isi_order_pos op,
             isi_artikel alam,
             isi_artikel a
       where  lte.sid = lam.sid (+)
         and lte.lte_id = in_id
         and lte.lte_id = lam.lte_id
         and lam.order_pos_auf_id = op.auf_id
         and lam.artikel_id = alam.artikel_id
         and (alam.artikel_p6 = a.artikel
           or alam.artikel_p7 = a.artikel
           or alam.artikel_p8 = a.artikel)
        group by op.li_nr, op.li_pos_nr, a.artikel, lam.prod_datum, op.auftrag, a.bezeichnung1
        order by op.li_nr, op.li_pos_nr, a.artikel, lam.prod_datum;

    CURSOR c_lhm is
      select lam.sid,
             lam.firma_nr,
             lhm.lhm_id,
             lhm.lhm_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
             stradd_distinct(lam.labor_status) Labor_status,
             stradd_distinct(lam.labor_text) Labor_text,
             '1',
             lte.order_vorgang_id,
             'V',
             decode(min(lhm.lhm_name), max(lhm.lhm_name), min(lhm.lhm_name) , NULL) lhm_name,
             min(lam.charge_id) charge_id,    -- -AG- Erste Charge der Palette andrucken
             decode(min(lam.kunden_nr), max(lam.kunden_nr), min(lam.kunden_nr) , NULL) kunden_nr,
             decode(min(lam.best_nr), max(lam.best_nr), min(lam.best_nr) , NULL) best_nr,
             min(lhm.lhm_akt_kg) brutto,
             sum(lam.lam_kg) netto,
             min(lam.order_pos_auf_id) order_pos_auf_id,
             sum(lam.menge),
             decode(min(lam.menge_basis), max(lam.menge_basis), min(lam.menge_basis) , NULL) menge_basis,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl) , NULL) leitzahl,
             decode(trunc(min(lam.prod_datum)), trunc(max(lam.prod_datum)), trunc(min(lam.prod_datum)) , NULL) prod_datum,
             decode(min(lam.zeichnung), max(lam.zeichnung), min(lam.zeichnung), NULL) zeichnung,
             decode(min(lam.zeichnung_index), max(lam.zeichnung_index), min(lam.zeichnung_index) , NULL) zeichnung_index,
             decode(min(lam.artikel_id), max(lam.artikel_id), min(lam.artikel_id) , NULL) artikel_id,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), NULL) leitzahl,
             decode(min(lam.fa_ag), max(lam.fa_ag), min(lam.fa_ag), NULL) fa_ag,
             decode(min(lam.lieferant_nr), max(lam.lieferant_nr), min(lam.lieferant_nr) , NULL) lieferanten_nr,
             decode(min(lam.li_nr_lief), max(lam.li_nr_lief), min(lam.li_nr_lief) , NULL) li_nr_lief,
             decode(min(lam.charge_id), max(lam.charge_id), min(lam.charge_id) , NULL) charge_id
        from lvs_lhm lhm, lvs_lte lte, lvs_lam lam
       where lhm.lhm_id = in_id
         and lhm.lte_id = lte.lte_id
         and lhm.lhm_id = lam.lhm_id
       group by lam.sid, lam.firma_nr, lte.order_vorgang_id, lhm.lhm_id, lhm.lhm_name, lte.ziel_lgr_platz, lte.lgr_platz;

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

    CURSOR c_pos_lte_all is
      select decode(min(pos.best_nr_kunde), max(pos.best_nr_kunde), min(pos.best_nr_kunde), NULL)
        from isi_order_pos pos,
             lvs_lam lam
       where pos.sid = v_lte_sid
         and pos.firma_nr = v_lte_firma_nr
         and pos.auf_id = lam.order_pos_auf_id
         and lam.sid = v_lte_sid
         and lam.firma_nr = v_lte_firma_nr
         and lam.lte_id = v_lte_lte_id;

    CURSOR c_pos_lhm_all is
      select decode(min(pos.best_nr_kunde), max(pos.best_nr_kunde), min(pos.best_nr_kunde), NULL)
        from isi_order_pos pos,
             lvs_lam lam
       where pos.sid = v_lte_sid
         and pos.firma_nr = v_lte_firma_nr
         and pos.auf_id = lam.order_pos_auf_id
         and lam.sid = v_lte_sid
         and lam.firma_nr = v_lte_firma_nr
         and lam.lhm_id = v_lte_lte_id;

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
         and fa.fa_ag > v_lam_art_faag
       order by fa_ag;

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
    v_VdaPackstuckNr := NULL;
    v_VdaChangenNr := NULL;
    v_VdaLieferantenNr := NULL;
    v_VdaSachNrKundeBarcode := NULL;
    v_VdaFuellmengeBarcode := NULL;
    v_VdaPackstuckNrBarcode := NULL;
    v_VdaSachNrLieferantBarcode := NULL;
    v_VdaChangenNrBarcode := NULL;
    v_Vdasachnrlieferantprodnrbarc := NULL;
    v_VdaNrKundeBarcode := NULL;
    v_VdaLieferantenNrBarcode := NULL;
    v_VdaLieferantenAnschrift1 := NULL;
    v_VdaLieferantenAnschrift2 := NULL;
    v_VdaLieferantenAnschrift3 := NULL;
    v_VdaLieferantenAnschrift4 := NULL;
    v_VdaLaborStatus := NULL;
    v_VdaLaborStatusText := NULL;

    v_VdaBezeichnungKunde      := NULL;
    v_ChargeId                 := NULL;
    v_InfoHinweis              := null;

    v_lam_art_fanr := NULL;
    v_lam_art_faag := NULL;

    if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lte then
      OPEN c_lte;
      FETCH c_lte into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz,
                           v_LaborStatus, v_LaborStatusText,
                           v_lte_lte_akt_lhm,v_lte_order_vorgang_id,  v_lte_lte_voll, v_lhm_lhm_name, v_lam_charge_id,
                           v_lam_kunden_nr, v_lam_best_nr, v_brutto, v_netto,
                           v_order_pos_auf_id, v_lam_memge, v_lam_memge_basis, v_lam_leitzahl,
                           v_lam_prod_datum, v_lam_zeichnung, v_lam_zeichnung_index,
                           v_lam_artikel_id, v_lam_art_fanr, v_lam_art_faag, v_lieferanten_nr,
                           v_li_nr_lief, v_ChargeId, v_InfoHinweis;

      v_found := c_lte%FOUND;
      CLOSE c_lte;
      OPEN c_lte_c;
      FETCH c_lte_c into v_lte_c;
      if c_lte_c%FOUND then
        v_VdaDatenfeldFuerLieferanten := v_lte_c.lte_text;
      end if;
      CLOSE c_lte_c;


      OPEN c_fa_auf_lte;
      FETCH c_fa_auf_lte into v_VdaBestellNummerKunde;
      if c_fa_auf_lte%NOTFOUND then
        v_VdaBestellNummerKunde := NULL;
      end if;
      CLOSE c_fa_auf_lte;

      OPEN c_pos_lte_all;
      FETCH c_pos_lte_all into v_best_nr_kunde;
      if c_pos_lte_all%FOUND then
        v_VdaBestellNummerKunde := v_best_nr_kunde;
      end if;
      CLOSE c_pos_lte_all;

      v_hag_ausg_zeile := v_hag_ausg_zeile_empty;
      i := 1;
      OPEN c_lte_all_lam;
      LOOP
        FETCH c_lte_all_lam into v_hag_ausg_zeile(i);
        exit when c_lte_all_lam%NOTFOUND;
        i := i + 1;
      end LOOP;
      CLOSE c_lte_all_lam;
    elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lhm then
      OPEN c_lhm;
      FETCH c_lhm into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz,
                           v_LaborStatus, v_LaborStatusText,
                           v_lte_lte_akt_lhm,v_lte_order_vorgang_id,  v_lte_lte_voll, v_lhm_lhm_name, v_lam_charge_id,
                           v_lam_kunden_nr, v_lam_best_nr, v_brutto, v_netto,
                           v_order_pos_auf_id, v_lam_memge, v_lam_memge_basis, v_lam_leitzahl,
                           v_lam_prod_datum, v_lam_zeichnung, v_lam_zeichnung_index,
                           v_lam_artikel_id, v_lam_art_fanr, v_lam_art_faag, v_lieferanten_nr,
                           v_li_nr_lief, v_ChargeId;

      v_found := c_lhm%FOUND;
      CLOSE c_lhm;
      OPEN c_lhm_c;
      FETCH c_lhm_c into v_lhm_c;
      if c_lhm_c%FOUND then
        v_VdaDatenfeldFuerLieferanten := v_lhm_c.lhm_text;
      end if;
      CLOSE c_lhm_c;

      OPEN c_fa_auf_lhm;
      FETCH c_fa_auf_lhm into v_VdaBestellNummerKunde;
      if c_fa_auf_lhm%NOTFOUND then
        v_VdaBestellNummerKunde := NULL;
      end if;
      CLOSE c_fa_auf_lhm;

      OPEN c_pos_lhm_all;
      FETCH c_pos_lhm_all into v_best_nr_kunde;
      if c_pos_lhm_all%FOUND then
        v_VdaBestellNummerKunde := v_best_nr_kunde;
      end if;
      CLOSE c_pos_lhm_all;
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

    v_VdaLaborStatus := v_LaborStatus;
    v_VdaLaborStatusText := v_LaborStatusText;

    if v_found then
      v_VdaGewichtNetto              := v_netto;
      v_VdaGewichtBrutto             := v_brutto;
      v_VdaLieferscheinNrBestNr      := v_lam_best_nr;
      v_Vdaabladestelle              := v_lte_ziel_lgr_platz;
      v_Vdasachnrlieferantprodnr     := v_lam_leitzahl;
      v_Vdasachnrlieferantiskdpackm  := v_lte_lte_name;
      v_Vdasachnrlieferantzusangaben := v_lhm_lhm_name;
      v_Vdaanzahlpackstuecke         := v_lte_lte_akt_lhm;
      v_Vdasachnrlieferant           := v_art.artikel_p1; -- Bei Euscher QS-Prüftext
      -- Falls der Parameter P1 nicht gefüllt, dann nur die Artikelnummer eintragen
      if v_Vdasachnrlieferant is NULL
      then
        v_Vdasachnrlieferant           := v_art.artikel;
      else
        v_Vdasachnrlieferant           := v_Vdasachnrlieferant || ' ' || v_art.artikel;
      end if;
      if v_lam_art_faag is not NULL
      then
        v_Vdasachnrlieferant := v_Vdasachnrlieferant || '-' || nvl(to_char(v_lam_art_fanr), 'X') || '/' || to_char(v_lam_art_faag);
        if v_naechste_maschine is not NULL
        then
          v_Vdasachnrlieferant := v_Vdasachnrlieferant || ' --> ' || v_naechste_maschine;
        end if;
      end if;
      v_Vdafuellmenge                := v_lam_memge;
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
        v_Vdasachnrlieferantbarcode := '30S' || v_art.artikel;
        if v_lam_art_faag is not NULL
        then
          v_Vdasachnrlieferantbarcode := v_Vdasachnrlieferantbarcode || '-' || nvl(to_char(v_lam_art_fanr), 'X') || '/' || to_char(v_lam_art_faag);
        end if;
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
          v_adr_id := v_kopf.order_adress_id;
          OPEN c_adr;
          FETCH c_adr into v_adr;
          v_found := c_adr%FOUND;
          CLOSE c_adr;
          if v_found then
            v_Vdalieferanschriftkurz := v_adr.name_1;
          end if;
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
        v_VdaLieferantenAnschrift1 := v_adr.name_1;
        v_VdaLieferantenAnschrift2 := v_adr.name_2;
        v_VdaLieferantenAnschrift3 := v_adr.name_3;
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
          v_VdaBezeichnungKunde := v_art_kd.kd_art_text1;
       end if;
      end if;
   end if;

   v_print_daten := '';
   if in_waren_typ = 'MP' then
     v_VdaPackstuckNrBarcode := 'G';
   elsif v_lte_lte_voll = C.Lte_Voll_v then
     v_VdaPackstuckNrBarcode := 'S';
   else
     v_VdaPackstuckNrBarcode := 'M';
   end if;
   v_Vdapackstucknr               := in_id;
   v_VdaPackstuckNrBarcode := v_VdaPackstuckNrBarcode || in_id;

   v_VdaEtiDatum := to_char(sysdate, 'dd.mm.yy');
   v_VdaEtiZeit := to_char(sysdate, 'hh24:mi:ss');

   v_print_daten :=
    'VdaSachNrLieferantDatenfeldFuerLieferanten='         || v_VdaDatenfeldFuerLieferanten || cr_lf() ||
    'VdaGewichtBrutto='                                   || v_VdaGewichtBrutto || cr_lf() ||
    'VdaGewichtNetto='                                    || v_VdaGewichtNetto || cr_lf() ||
    'VdaLieferscheinNrBestellnummer='                     || v_VdaLieferscheinNrBestNr || cr_lf() ||
    'VdaLieferscheinNr='                                  || v_VdaLieferscheinNr || cr_lf() ||
    'VdaLieferscheinNrLief='                              || v_VdaLieferscheinNrLief || cr_lf() ||
    'VdaWarenempfaengerKurz='                             || v_VdaWarenempfaengerKurz || cr_lf() ||
    'VdaWarenempfaengerLang1='                            || v_VdaWarenempfaengerLang1 || cr_lf() ||
    'VdaWarenempfaengerLang2='                            || v_VdaWarenempfaengerLang2 || cr_lf() ||
    'VdaWarenempfaengerLang3='                            || v_VdaWarenempfaengerLang3 || cr_lf() ||
    'VdaAbladestelle='                                    || v_VdaAbladestelle || cr_lf() ||
    'VdaAnzahlPackstuecke='                               || v_VdaAnzahlPackstuecke || cr_lf() ||
    'VdaFuellmenge='                                      || v_VdaFuellmenge || cr_lf() ||
    'VdaLaborStatus='                                     || v_VdaLaborStatus || CHR(13) || CHR(10) ||
    'VdaLaborStatusText='                                 || v_VdaLaborStatusText || CHR(13) || CHR(10) ||
    'VdaFuellmengeMengeneinheit='                         || v_VdaFuellmengeMengeneinheit || cr_lf() ||
    'VdaBezeichnungLieferungLeistung='                    || v_VdaBezeichnungLieferungL || cr_lf() ||
    'VdaSachNrLieferant='                                 || v_VdaSachNrLieferant || cr_lf() ||
    'VdaSachNrLieferantISKDPackmittel='                   || v_VdaSachNrLieferantISKDPackm || cr_lf() ||
    'VdaSachNrLieferantZusAngaben='                       || v_VdaSachNrLieferantZusAngaben || cr_lf() ||
    'VdaSachNrLieferantProduktionsNr='                    || v_VdaSachNrLieferantProdNr || cr_lf() ||
    'VdaSachNrLieferantAbmessung='                        || v_VdaSachNrLieferantAbmessung || cr_lf() ||
    'VdaSachNrKunde='                                     || v_VdaSachNrKunde || cr_lf() ||
    'VdaDatum='                                           || v_VdaDatum || cr_lf() ||
    'VdaAenderungKonstruktion='                           || v_VdaAenderungKonstruktion || cr_lf() ||
    'VdaAenderungKonstruktionOberflaeche='                || v_VdaAenderungKonstruktionO || cr_lf() ||
    'VdaAenderungKonstruktionZeichnung='                  || v_VdaAenderungKonstruktionZ || cr_lf() ||
    'VdaPackstuckNr='                                     || v_VdaPackstuckNr || cr_lf() ||
    'VdaChangenNr='                                       || v_VdaChangenNr || cr_lf() ||
    'VdaLieferantenNr='                                   || v_VdaLieferantenNr || cr_lf() ||
    'VdaLieferantenanschriftLang='                        || v_VdaLieferantenAnschrift4 || cr_lf() ||
    'VdaSachNrKundeBarcode='                              || v_VdaSachNrKundeBarcode || cr_lf() ||
    'VdaFuellmengeBarcode='                               || v_VdaFuellmengeBarcode || cr_lf() ||
    'VdaPackstuckNrBarcode='                              || v_VdaPackstuckNrBarcode || cr_lf() ||
    'VdaSachNrLieferantBarcode='                          || v_VdaSachNrLieferantBarcode || cr_lf() ||
    'VdaChangenNrBarcode='                                || v_VdaChangenNrBarcode || cr_lf() ||
    'VdaSachNrLieferantProduktionsNrBarcode='             || v_Vdasachnrlieferantprodnrbarc || cr_lf() ||
    'VdaNrKundeBarcode='                                  || v_VdaNrKundeBarcode || cr_lf() ||
    'VdaLieferantenNrBarcode='                            || v_VdaLieferantenNrBarcode || cr_lf() ||
    'VdaBezeichnungKunde='                                || v_VdaBezeichnungKunde || cr_lf() ||
    'VdaEtiDatum='                                        || v_VdaEtiDatum   || CHR(13) || CHR(10) ||
    'VdaEtiZeit='                                         || v_VdaEtiZeit      || CHR(13) || CHR(10) ||
    'InfoHinweis='                                        || v_InfoHinweis;

    i := 1;
    LOOP
      if v_hag_ausg_zeile.exists(i)
      then
        v_print_daten := v_print_daten || CHR(13) || CHR(10) ||
        'TurmZeile' || to_char(i) || '= '  || lpad(to_char(i), 2, '0') || '      ' || v_hag_ausg_zeile(i);
        i := i + 1;
      else
        exit;
      end if;
    end LOOP;

    LOOP
      if i < 34
      then
        v_print_daten := v_print_daten || CHR(13) || CHR(10) ||
        'TurmZeile' || to_char(i) || '= '  ;
        i := i + 1;
      else
        exit;
      end if;
    end LOOP;


    return (v_print_daten);
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then
      RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text);
      raise;
    when others then
      if v_err_nr is not NULL then
         RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text, true);
      else
         raise;
      end if;
  end vda_etikett;

  -------------------------------------------------------------------------------------------------------
  -- CCG-Etikett druck
  -------------------------------------------------------------------------------------------------------
  function ccg_etikett(in_lte_id      in lvs_lte.lte_id%type,
                       in_waren_typ   in lvs_lte.waren_typ%type)
                                      return varchar2 is

    v_menge_basis               varchar2(3);
    v_menge                     number;

    v_ccg_nve                   varchar2(100);  --1
    v_ccg_arttext               varchar2(100);  --2
    v_ccg_ean_lhm_string        varchar2(100);  --3
    v_ccg_ean_lke_string        varchar2(100);  --4
    v_ccg_mhd_string            varchar2(100);  --5
    v_ccg_lhm_menge             number;         --6
    v_ccg_lke_menge             number;         --7
    v_ccg_arttext_kurz          varchar2(100);  --8
    v_ccg_lage_lagen            varchar2(100);  --9
    v_ccg_charge                varchar2(100);  --10
    v_ccg_gewicht_kg            varchar2(100);  --11
    v_ccg_artikel_nr            varchar2(100);  --14
    v_ccg_mhd_monat             varchar2(100);  --15
    v_ccg_menge_in_lhm          number;         --16
    v_ccg_lhm_pro_lage          number;         --17
    v_ccg_menge_pro_lage        number;         --18
    v_ccg_lagen                 number;         --19
    v_ccg_pid                   varchar2(100);  --20
    v_ccg_anz_becher            number;         --21
    v_ccg_anz_karton            number;         --22
    v_artikel_nr                varchar2(100);  --23
    v_ccg_lhm_l_lage            number;         --24
    v_ccg_kom_lagen             number;         --25

    v_ccg_barcodea_string       varchar2(100);  --BC1_TEXT
    v_ccg_barcodeb_string       varchar2(100);  --BC2_TEXT
    v_ccg_barcodec_string       varchar2(100);  --BC3_TEXT
    v_ccg_barcoded_string       varchar2(100);  --BC4_TEXT
    v_ccg_barcodee_string       varchar2(100);  --BC5_TEXT
    v_ccg_barcodef_string       varchar2(100);  --BC5_TEXT
    v_ccg_barcodea              varchar2(100);  --BC1
    v_ccg_barcodeb              varchar2(100);  --BC2
    v_ccg_barcodec              varchar2(100);  --BC2
    v_ccg_barcoded              varchar2(100);  --BC4
    v_ccg_barcodee              varchar2(100);  --BC5
    v_ccg_barcodef              varchar2(100);  --BC5

    v_print_daten     varchar2(2048);

    v_found           boolean;
    v_adresse         isi_adressen%rowtype;

    cursor c_firma is
      select a.*
       from isi_firma t,
            isi_adressen a
      where t.sid       = v_adresse.sid
        and t.firma_nr  = v_adresse.firma_nr
        and a.sid       = t.sid
        and a.adress_id = t.adress_id;


    cursor c_et_daten is
      select
         lte.sid,
         lte.firma_nr,
         lvs_p_lte_lhm.format_nve(nvl(lte.nve_nr, lte.lte_id)) as "TF_1" ,
         nvl(art.bezeichnung3, art.bezeichnung1) as "TF_2",
         '0' || lvs_p_lte_lhm.format_EAN(art.lhm_ean)      as "TF_3",
         lvs_p_lte_lhm.FORMAT_EAN(art.ean)      as "TF_4",
         to_char(lam.lam_mhd_ausgabe, 'DD.MM.YY') as "TF_5",
         to_char(lam.lam_mhd_ausgabe, 'MM.YYYY') as "TF_15",
         lam.menge        as "TF_6",
         lam.menge_basis,
         art.lhm_menge as "TF_16",
         art.lte_lhm_pro_lage as "TF_17",
         art.lte_lhm_pro_lage * art.lhm_menge as "TF_18",
         art.lte_lhm_lagen as "TF_19",
         art.lte_menge as "TF_21",
         art.lte_lhm_menge as "TF_22",
         nvl(art.Artikel_Kurz, art.artikel)    as "TF_8",
         art.artikel  as "TF_14",
         '(' || art.lte_lhm_pro_lage || 'x'||art.lte_LHM_lagen||')'  as "TF_9",
         cha.charge_bez  as "TF_10",
         round(lte.lte_akt_kg, 2)     as "TF_11",
         lte.lte_id                   as "TF_20",
         '(93)'|| lte.lte_id || '(37)'|| lpad(lam.menge, 6, '0') || '(15)' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC1_Text",
         '(02)' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '(10)' || cha.charge_bez as "BC2_Text",
         '(00)' || nvl(lte.nve_nr, lte.lte_id)  as "BC3_Text",
         '(37)'|| lpad(lam.menge, 6, '0') || '(15)' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC4_Text",
         '(02)' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '(37)' || lpad(lam.menge, 6, '0') as "BC5_Text",
         '(10)' || cha.charge_bez  || '(15)' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC6_Text",
         '93'|| lte.lte_id || CHR(29) || '37' || lpad(lam.menge, 6, '0') || CHR(29) || '15' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC1",
         '02' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '10' || cha.charge_bez as "BC2",
         '00' || nvl(lte.nve_nr, lte.lte_id)  as "BC3",
         '37' || lpad(lam.menge, 6, '0') || CHR(29) || '15' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC4",
         '02' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '37' || lpad(lam.menge, 6, '0') as "BC5",
         '10' || cha.charge_bez  || CHR(29) || '15' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC6"
      from lvs_lte lte, LVS_LAM lam, isi_artikel art, lvs_charge cha

      where lte.lte_id=in_lte_id
        and lam.LTE_ID=in_lte_id
        and lam.artikel_ID= art.artikel_id(+)
        and lam.sid = art.sid(+)
        and cha.sid(+) = lam.sid
        and nvl(cha.charge_id(+), -1) = nvl(lam.charge_id, -1);

  begin

    OPEN c_et_daten;
    FETCH c_et_daten into v_adresse.sid,
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
    CLOSE c_et_daten;

    OPEN c_firma;
    FETCH c_firma into v_adresse;
    CLOSE c_firma;

    v_ccg_artikel_nr := FORMAT_ARTIKEL(v_adresse.sid, v_adresse.firma_nr, v_artikel_nr);

    if not v_found then
      v_err_nr := 10;
      v_err_text := 'Fehler beim lesen der Etikettendaten der Transporteinheit ' || in_lte_id;
      raise v_error;
    end if;

    if v_ccg_menge_in_lhm = 0
    then
      v_ccg_menge_in_lhm := 1;
    end if;
    if v_menge_basis = 'LHM'
    then
      v_ccg_lhm_menge := v_menge;
      v_ccg_lke_menge := v_menge * v_ccg_menge_in_lhm;
      v_ccg_anz_karton := v_ccg_lhm_menge;
    elsif v_menge_basis = 'LKE'
    then
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
      v_print_daten :=
                       'CCG_FIRMANAME='|| nvl(v_adresse.name_1, 'Name') || CHR(13) || CHR(10) ||
                       'CCG_FIRMASTRASSE='|| nvl(v_adresse.strasse, 'Str.') || CHR(13) || CHR(10) ||
                       'CCG_FIRMAPLZORT='|| nvl(v_adresse.plz, 'PLZ') || ' ' || nvl(v_adresse.ort, 'Ort') || CHR(13) || CHR(10) ||
                       'CCG_KADR1='|| 'INTERPORTO S. PALOMBA S.R.L.' || CHR(13) || CHR(10) ||
                       'CCG_KADR2='|| 'Interrporto Palomba' || CHR(13) || CHR(10) ||
                       'CCG_KADR3='|| 'VIA ADREANTINA, KM 22.000' || CHR(13) || CHR(10) ||
                       'CCG_KADR4='|| '00040 S. PALOMBA-POMEZIA RM' || CHR(13) || CHR(10) ||
                       'CCG_AUSLIEFERUNGSDATUM='|| '01.10.2003' || CHR(13) || CHR(10) ||
                       'CCG_NVE='|| v_ccg_nve || CHR(13) || CHR(10) ||
                       'CCG_ARTTEXT='|| v_ccg_arttext || CHR(13) || CHR(10) ||
                       'CCG_EAN_KARTON='|| v_ccg_ean_lhm_string || CHR(13) || CHR(10) ||
                       'CCG_EAN_BECHER='|| v_ccg_ean_lke_string || CHR(13) || CHR(10) ||
                       'CCG_MHD='|| v_ccg_mhd_string || CHR(13) || CHR(10) ||
                       'CCG_MHD_MONAT='|| v_ccg_mhd_monat || CHR(13) || CHR(10) ||
                       'CCG_MENGE_KARTON='|| lpad(v_ccg_lhm_menge, 5, ' ') || CHR(13) || CHR(10) ||
                       'CCG_MENGE_BECHER='|| lpad(v_ccg_lke_menge, 4, ' ') || CHR(13) || CHR(10) ||
                       'CCG_MENGE_IN_KARTON='|| lpad(v_ccg_menge_in_lhm, 7, ' ') || CHR(13) || CHR(10) ||
                       'CCG_ANZ_LAGEN='|| lpad(v_ccg_lagen, 7, ' ') || CHR(13) || CHR(10) ||
                       'CCG_ANZ_KARTON='|| lpad(v_ccg_anz_karton, 4, ' ') || CHR(13) || CHR(10) ||
                       'CCG_ANZ_BECHER='|| lpad(v_ccg_anz_becher, 4, ' ') || CHR(13) || CHR(10) ||
                       'CCG_KARTON_PRO_LAGE='|| lpad(v_ccg_lhm_pro_lage, 6, ' ') || CHR(13) || CHR(10) ||
                       'CCG_MENGE_PRO_LAGE='|| lpad(v_ccg_menge_pro_lage, 4, ' ') || CHR(13) || CHR(10) ||
                       'CCG_ARTIKEL='|| v_ccg_arttext_kurz || CHR(13) || CHR(10) ||
                       'CCG_KOM_ANZ_LAGEN='|| v_ccg_kom_lagen || CHR(13) || CHR(10) ||
                       'CCG_KOM_KARTON_L_LAGE='|| v_ccg_lhm_l_lage || CHR(13) || CHR(10) ||
                       'CCG_ARTIKEL_NR='|| v_ccg_artikel_nr || CHR(13) || CHR(10) ||
                       'CCG_LAGE_LAGEN='|| v_ccg_lage_lagen || CHR(13) || CHR(10) ||
                       'CCG_CHARGE='|| v_ccg_charge || CHR(13) || CHR(10) ||
                       'CCG_GEWICHT_KG='|| v_ccg_gewicht_kg || CHR(13) || CHR(10) ||
                       'CCG_PID='|| v_ccg_pid || CHR(13) || CHR(10) ||
                       'CCG_BARCODEA=' || v_ccg_barcodea || CHR(13) || CHR(10) ||
                       'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEB=' || v_ccg_barcodeb || CHR(13) || CHR(10) ||
                       'CCG_BARCODEB_STRING=' || v_ccg_barcodeb_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEC=' || v_ccg_barcodec || CHR(13) || CHR(10) ||
                       'CCG_BARCODEC_STRING=' || v_ccg_barcodec_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODED=' || v_ccg_barcoded || CHR(13) || CHR(10) ||
                       'CCG_BARCODED_STRING=' || v_ccg_barcoded_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEE=' || v_ccg_barcodee || CHR(13) || CHR(10) ||
                       'CCG_BARCODEE_STRING=' || v_ccg_barcodee_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEF=' || v_ccg_barcodef || CHR(13) || CHR(10) ||
                       'CCG_BARCODEF_STRING=' || v_ccg_barcodef_string;
    else
      v_print_daten :=
                       'CCG_FIRMANAME ='|| nvl(v_adresse.name_1, 'Name') || CHR(13) || CHR(10) ||
                       'CCG_FIRMASTRASSE ='|| nvl(v_adresse.strasse, 'Str.') || CHR(13) || CHR(10) ||
                       'CCG_FIRMAPLZORT ='|| nvl(v_adresse.plz, 'PLZ') || ' ' || nvl(v_adresse.ort, 'PLZ') || CHR(13) || CHR(10) ||
                       'CCG_KADR1 ='|| 'INTERPORTO S. PALOMBA S.R.L.' || CHR(13) || CHR(10) ||
                       'CCG_KADR2 ='|| 'Interrporto Palomba' || CHR(13) || CHR(10) ||
                       'CCG_KADR3 ='|| 'VIA ADREANTINA, KM 22.000' || CHR(13) || CHR(10) ||
                       'CCG_KADR4 ='|| '00040 S. PALOMBA-POMEZIA RM' || CHR(13) || CHR(10) ||
                       'CCG_NVE='|| v_ccg_nve || CHR(13) || CHR(10) ||
                       'CCG_ARTTEXT='|| 'Mischpalette' || CHR(13) || CHR(10) ||
                       'CCG_EAN_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_EAN_BECHER='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_MHD_MONAT='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_MHD='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_MENGE_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_MENGE_BECHER='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_MENGE_IN_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_ANZ_LAGEN='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_ANZ_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_ANZ_BECHER='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_MENGE_PRO_LAGE='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_KARTON_PRO_LAGE='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_ARTIKEL='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_ARTIKEL_NR='|| '' || CHR(13) || CHR(10) ||
                       'CCG_LAGE_LAGEN='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_KOM_ANZ_LAGEN='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_KOM_KARTON_L_LAGE='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_CHARGE='|| ' ' || CHR(13) || CHR(10) ||
                       'CCG_GEWICHT_KG='|| v_ccg_gewicht_kg || CHR(13) || CHR(10) ||
                       'CCG_PID='|| v_ccg_pid || CHR(13) || CHR(10) ||
                       --'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string || CHR(13) || CHR(10) ||
                       --'CCG_BARCODEA=' || v_ccg_barcodea || CHR(13) || CHR(10) ||
                       'CCG_BARCODEA=' || ' ' || CHR(13) || CHR(10) ||
                       'CCG_BARCODEA_STRING=' || ' ' || CHR(13) || CHR(10) ||
                       'CCG_BARCODEB=' || v_ccg_barcodeb || CHR(13) || CHR(10) ||
                       'CCG_BARCODEB_STRING=' || v_ccg_barcodeb_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEC=' || v_ccg_barcodec || CHR(13) || CHR(10) ||
                       'CCG_BARCODEC_STRING=' || v_ccg_barcodec_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODED=' || v_ccg_barcoded || CHR(13) || CHR(10) ||
                       'CCG_BARCODED_STRING=' || v_ccg_barcoded_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEE=' || v_ccg_barcodee || CHR(13) || CHR(10) ||
                       'CCG_BARCODEE_STRING=' || v_ccg_barcodee_string || CHR(13) || CHR(10) ||
                       'CCG_BARCODEF=' || v_ccg_barcodef || CHR(13) || CHR(10) ||
                       'CCG_BARCODEF_STRING=' || v_ccg_barcodef_string;
    end if;
    return (v_print_daten);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end ccg_etikett;

  -------------------------------------------------------------------------------------------------------
  -- STD-Etikett druck
  -------------------------------------------------------------------------------------------------------
  function std_etikett(in_sid                 in isi_sid.sid%type,
                       in_firma_nr            in isi_firma.firma_nr%type,
                       in_id                  in lvs_lte.lte_id%type,
                       in_waren_typ           in lvs_lte.waren_typ%type,
                       in_format_spez_barcode in isi_adressen.lte_etiketten_spez_barcode%type)
                       return varchar2 is

    i number;

    v_artikel                    isi_artikel%rowtype;
    v_charge_bez                 varchar2(100);
    v_prod_datum                 date;
    v_menge                      number;
    v_ean                        varchar2(100);
    v_lfd_nr_str                 varchar2(100);
    v_linie_str                   varchar2(20);
    v_lfd_nr                     number;

    v_print_daten     varchar2(4096);

    v_found           boolean;
    v_pos                     isi_order_pos%rowtype;
    v_kopf                    isi_order_kopf%rowtype;
    v_adr                     isi_adressen%rowtype;
    v_art_cfg                 isi_artikel_cfg%rowtype;
    v_art                     isi_artikel%rowtype;
    v_art_kd                  isi_artikel_kunde%rowtype;
    v_charge                  lvs_charge%rowtype;
    v_lte_c                   lvs_lte_cfg%rowtype;
    v_lhm_c                   lvs_lhm_cfg%rowtype;
    v_art_ctrl                isi_artikel_ctrl%rowtype;
    v_hersteller              isi_hersteller%rowtype;
    v_id_basis                varchar2(10);

    v_lte_sid                 lvs_lte.sid%type;
    v_lte_firma_nr            lvs_lte.firma_nr%type;
    v_lte_lte_id              lvs_lte.lte_id%type;
    v_lhm_lte_id              lvs_lte.lte_id%type;
    v_lte_lte_name            lvs_lte.lte_name%type;
    v_lte_ziel_lgr_platz      lvs_lte.ziel_lgr_platz%type;
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
    v_lte_id_b                varchar2(100);
    v_lte_lte_voll            lvs_lte.lte_voll%type;
    v_lam_zeichnung           lvs_lam.zeichnung%type;
    v_lam_zeichnung_index     lvs_lam.zeichnung_index%type;
    v_lam_best_nr             lvs_lam.best_nr%type;
    v_fa_auftrag              bde_fa_auftrag%rowtype;
    v_firma                   isi_firma%rowtype;
    v_bc_format               isi_firma.lte_barcode_kopf%type;
    v_bc_typ                  isi_firma.lte_barcode_type%type;
    v_hersteller_kuerzel_liste varchar2(200);
    v_typ                     varchar2(10);
    v_h_tag                   isi_hersteller.tag%type;

    v_netto                   number;
    v_brutto                  number;
    vs_netto                  number;
    vs_brutto                 number;
    vs_tara                   number;

    v_adr_nr                  isi_adressen.adr_nr%type;
    v_adr_liefer              isi_adressen.adr_liefer%type;
    v_adr_id                  isi_adressen.adress_id%type;
    v_lam_order_pos_auf_id    isi_order_pos.auf_id%type;
    v_lam_lhm_lfd_nr          lvs_lam.lhm_lfd_nr%type;
    v_lam_c_lhm_lfd_nr        lvs_lam.lhm_c_lfd_nr%type;

    v_lam_artikel_id          isi_artikel.artikel_id%type;
    v_lam_art_fanr            lvs_lam.leitzahl%type;
    v_lam_art_faag            lvs_lam.fa_ag%type;
    v_lam_art_faupos          lvs_lam.fa_upos%type;

    v_lieferanten_nr          isi_adressen.adr_nr%type;
    v_best_nr_kunde           isi_order_pos.best_nr_kunde%type;
    v_li_nr_lief              lvs_lam.li_nr_lief%type;
    v_naechste_maschine       isi_resource.res_ext_name%type;

    v_stdDatenfeldFuerLieferanten                         varchar2(255);
    v_stdGewichtBrutto                                    varchar2(255);
    v_stdGewichtNetto                                     varchar2(255);
    v_stdGewichtBrutto_xxxxKxx_ME                    varchar2(255);
    v_stdGewichtNetto_xxxxKxx_ME                     varchar2(255);
    v_stdLieferscheinNrBestNr                             varchar2(255);
    v_stdLieferscheinNr                                   varchar2(255);
    v_stdLieferscheinNrLief                               varchar2(255);
    v_stdWarenempfaengerKurz                              varchar2(255);
    v_stdWarenempfaengerLang1                             varchar2(255);
    v_stdWarenempfaengerLang2                             varchar2(255);
    v_stdWarenempfaengerLang3                             varchar2(255);
    v_stdAbladestelle                                     varchar2(255);
    v_stdAnzahlPackstuecke                                varchar2(255);
    v_stdFuellmenge                                       varchar2(255);
    v_stdFuellmengeMengeneinheit                          varchar2(255);
    v_stdBezeichnungLieferungL                            varchar2(255);
    v_stdSachNrLieferant                                  varchar2(255);
    v_stdSachNrLieferantISKDPackm                         varchar2(255);
    v_stdSachNrLieferantZusAngaben                        varchar2(255);
    v_stdSachNrLieferantProdNr                            varchar2(255);
    v_stdSachNrLieferantAbmessung                         varchar2(255);
    v_stdSachNrKunde                                      varchar2(255);
    v_stdDatum                                            varchar2(255);
    v_stdAenderungKonstruktion                            varchar2(255);
    v_stdAenderungKonstruktionO                           varchar2(255);
    v_stdAenderungKonstruktionZ                           varchar2(255);
    v_stdPackstuckNr                                      varchar2(255);
    v_stdChangenNr                                        varchar2(255);
    v_stdSachNrKundeBarcode                               varchar2(255);
    v_stdFuellmengeBarcode                                varchar2(255);
    v_stdPackstuckNrBarcode                               varchar2(255);
    v_stdSachNrLieferantBarcode                           varchar2(255);
    v_stdChangenNrBarcode                                 varchar2(255);
    v_stdSachNrLieferantProdNrBarc                        varchar2(255);
    v_stdNrKundeBarcode                                   varchar2(255);
    v_stdLieferanschriftkurz                              varchar2(255);
    v_stdLieferantenNr                                    varchar2(255);
    v_stdLieferantenNrBarcode                             varchar2(255);
    v_stdLieferantenAnschrift1                            varchar2(255);
    v_stdLieferantenAnschrift2                            varchar2(255);
    v_stdLieferantenAnschrift3                            varchar2(255);
    v_stdLieferantenAnschrift4                            varchar2(255);
    v_stdBestellNummerKunde                               varchar2(255);
    v_stdSpezBarcode                                      varchar2(255);
    v_stdLfdnLteID                                        varchar2(255);
    v_stdLfdnLhmID                                        varchar2(255);
    v_stdEinsVonX                                         varchar2(255);
    v_stdAtrikelP1                                        varchar2(50);
    v_stdAtrikelP2                                        varchar2(50);
    v_stdAtrikelP3                                        varchar2(50);
    v_stdAtrikelP4                                        varchar2(50);
    v_stdAtrikelP5                                        varchar2(50);
    v_stdAtrikelP6                                        varchar2(50);
    v_stdAtrikelP7                                        varchar2(50);
    v_stdAtrikelP8                                        varchar2(50);
    v_stdAtrikelP9                                        varchar2(50);
    v_stdAtrikelP10                                       varchar2(50);
    v_stdPackstuckNrMenge                                 varchar2(255);
    v_stdPackstuckNrSollMenge                             varchar2(255);
    v_ArtSollMenge                                        varchar2(255);

    CURSOR c_lte is
      select lte.sid,
             lte.firma_nr,
             lte.lte_id,
             lte.lte_id,
             lte.lte_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
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
             decode(min(lam.mengeneinheit_basis), max(lam.mengeneinheit_basis), min(lam.mengeneinheit_basis) , NULL) menge_basis,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl) , NULL) leitzahl,
             decode(trunc(min(lam.prod_datum)), trunc(max(lam.prod_datum)), trunc(min(lam.prod_datum)) , NULL) prod_datum,
             decode(min(lam.zeichnung), max(lam.zeichnung), min(lam.zeichnung) , NULL) zeichnung,
             decode(min(lam.zeichnung_index), max(lam.zeichnung_index), min(lam.zeichnung_index) , NULL) zeichnung_index,
             decode(min(lam.artikel_id), max(lam.artikel_id), min(lam.artikel_id) , NULL) artikel_id,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), NULL) leitzahl,
             decode(min(lam.fa_ag), max(lam.fa_ag), min(lam.fa_ag), NULL) fa_ag,
             decode(min(lam.fa_upos), max(lam.fa_upos), min(lam.fa_upos), NULL) fa_upos,
             decode(min(lam.lieferant_nr), max(lam.lieferant_nr), min(lam.lieferant_nr) , NULL) lieferanten_nr,
             decode(min(lam.li_nr_lief), max(lam.li_nr_lief), min(lam.li_nr_lief) , NULL) li_nr_lief,
             stradd_distinct(lam.hersteller_kuerzel_liste)
        from lvs_lte lte,
             lvs_lam lam
       where  lte.sid = lam.sid (+)
         and lte.lte_id = in_id
         and lte.lte_id = lam.lte_id (+)
       group by lte.sid, lte.firma_nr, lte.order_vorgang_id, lte.lte_voll, lte.lte_id, lte.lte_name, lte.ziel_lgr_platz,
                lte.lte_akt_lhm, lte.lgr_platz;


    CURSOR c_lhm is
      select lam.sid,
             lam.firma_nr,
             lhm.lhm_id,
             lam.lte_id,
             lhm.lhm_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
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
             decode(min(lam.menge_basis), max(lam.menge_basis), min(lam.menge_basis) , NULL) menge_basis,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl) , NULL) leitzahl,
             decode(trunc(min(lam.prod_datum)), trunc(max(lam.prod_datum)), trunc(min(lam.prod_datum)) , NULL) prod_datum,
             decode(min(lam.zeichnung), max(lam.zeichnung), min(lam.zeichnung), NULL) zeichnung,
             decode(min(lam.zeichnung_index), max(lam.zeichnung_index), min(lam.zeichnung_index) , NULL) zeichnung_index,
             decode(min(lam.artikel_id), max(lam.artikel_id), min(lam.artikel_id) , NULL) artikel_id,
             decode(min(lam.leitzahl), max(lam.leitzahl), min(lam.leitzahl), NULL) leitzahl,
             decode(min(lam.fa_ag), max(lam.fa_ag), min(lam.fa_ag), NULL) fa_ag,
             decode(min(lam.fa_upos), max(lam.fa_upos), min(lam.fa_upos), NULL) fa_upos,
             decode(min(lam.lieferant_nr), max(lam.lieferant_nr), min(lam.lieferant_nr) , NULL) lieferanten_nr,
             decode(min(lam.li_nr_lief), max(lam.li_nr_lief), min(lam.li_nr_lief) , NULL) li_nr_lief,
             max(lam.lhm_lfd_nr),
             max(lam.lhm_c_lfd_nr),
             stradd_distinct(lam.hersteller_kuerzel_liste)
        from lvs_lhm lhm, lvs_lte lte, lvs_lam lam
       where lhm.lhm_id = in_id
         and lhm.lte_id = lte.lte_id
         and lhm.lhm_id = lam.lhm_id
       group by lam.sid, lam.firma_nr, lte.order_vorgang_id, lam.lte_id, lhm.lhm_id, lhm.lhm_name, lte.ziel_lgr_platz, lte.lgr_platz;


    CURSOR c_firma is
      select *
        from isi_firma t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr;

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


    CURSOR c_pos_lte_all is
      select decode(min(pos.best_nr_kunde), max(pos.best_nr_kunde), min(pos.best_nr_kunde), NULL)
        from isi_order_pos pos,
             lvs_lam lam
       where pos.sid = v_lte_sid
         and pos.firma_nr = v_lte_firma_nr
         and pos.auf_id = lam.order_pos_auf_id
         and lam.sid = v_lte_sid
         and lam.firma_nr = v_lte_firma_nr
         and lam.lte_id = v_lte_lte_id;


    CURSOR c_pos_lhm_all is
      select decode(min(pos.best_nr_kunde), max(pos.best_nr_kunde), min(pos.best_nr_kunde), NULL)
        from isi_order_pos pos,
             lvs_lam lam
       where pos.sid = v_lte_sid
         and pos.firma_nr = v_lte_firma_nr
         and pos.auf_id = lam.order_pos_auf_id
         and lam.sid = v_lte_sid
         and lam.firma_nr = v_lte_firma_nr
         and lam.lhm_id = v_lte_lte_id;


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
         and fa.fa_ag > v_lam_art_faag
       order by fa_ag;

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


  begin
    v_stdDatenfeldFuerLieferanten := NULL;
    v_stdGewichtNetto := NULL;
    v_stdGewichtBrutto := NULL;
    v_stdGewichtNetto_xxxxKxx_ME := NULL;
    v_stdGewichtBrutto_xxxxKxx_ME := NULL;
    v_stdLieferscheinNrBestNr := NULL;
    v_stdLieferscheinNr := NULL;
    v_stdLieferscheinNrLief := NULL;
    v_stdWarenempfaengerKurz := NULL;
    v_stdWarenempfaengerLang1 := NULL;
    v_stdWarenempfaengerLang2 := NULL;
    v_stdWarenempfaengerLang3 := NULL;
    v_stdAbladestelle := NULL;
    v_stdAnzahlPackstuecke := NULL;
    v_stdFuellmenge := NULL;
    v_stdFuellmengeMengeneinheit := NULL;
    v_stdBezeichnungLieferungL := NULL;
    v_stdSachNrLieferant := NULL;
    v_stdSachNrLieferantISKDPackm := NULL;
    v_stdSachNrLieferantZusAngaben := NULL;
    v_stdsachnrlieferantprodnr := NULL;
    v_stdSachNrLieferantAbmessung := NULL;
    v_stdSachNrKunde := NULL;
    v_stdDatum := NULL;
    v_stdAenderungKonstruktion := NULL;
    v_stdaenderungkonstruktiono := NULL;
    v_stdAenderungKonstruktionZ := NULL;
    v_stdPackstuckNr := NULL;
    v_stdChangenNr := NULL;
    v_stdLieferantenNr := NULL;
    v_stdSachNrKundeBarcode := NULL;
    v_stdFuellmengeBarcode := NULL;
    v_stdPackstuckNrBarcode := NULL;
    v_stdSachNrLieferantBarcode := NULL;
    v_stdChangenNrBarcode := NULL;
    v_stdsachnrlieferantprodnrbarc := NULL;
    v_stdNrKundeBarcode := NULL;
    v_stdLieferantenNrBarcode := NULL;
    v_stdLieferantenAnschrift1 := NULL;
    v_stdLieferantenAnschrift2 := NULL;
    v_stdLieferantenAnschrift3 := NULL;
    v_stdLieferantenAnschrift4 := NULL;
    v_stdSpezBarcode := NULL;
    v_stdLfdnLteID := NULL;
    v_stdLfdnLhmID := NULL;
    v_stdEinsVonX := NULL;
    v_stdPackstuckNrMenge := NULL;
    v_stdPackstuckNrSollMenge := NULL;

    OPEN c_firma;
    FETCH c_firma into v_firma;
    CLOSE c_firma;

    v_lam_art_fanr := NULL;
    v_lam_art_faag := NULL;
    v_lam_art_faupos := NULL;

    if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lte
    then
      v_id_basis := 'LTE';
      OPEN c_lte;
      FETCH c_lte into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lhm_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz,
                           v_lte_lte_akt_lhm,v_lte_order_vorgang_id,  v_lte_lte_voll, v_lhm_lhm_name, v_lam_charge_id,
                           v_lam_kunden_nr, v_lam_best_nr, v_brutto, v_netto,
                           v_order_pos_auf_id, v_lam_memge, v_lam_memge_basis, v_lam_leitzahl,
                           v_lam_prod_datum, v_lam_zeichnung, v_lam_zeichnung_index,
                           v_lam_artikel_id, v_lam_art_fanr, v_lam_art_faag, v_lam_art_faupos,
                           v_lieferanten_nr, v_li_nr_lief, v_hersteller_kuerzel_liste;

      v_found := c_lte%FOUND;
      CLOSE c_lte;
      OPEN c_lte_c;
      FETCH c_lte_c into v_lte_c;
      if c_lte_c%FOUND then
        v_stdDatenfeldFuerLieferanten := v_lte_c.lte_text;
      end if;

      CLOSE c_lte_c;


      OPEN c_fa_auf_lte;
      FETCH c_fa_auf_lte into v_stdBestellNummerKunde;
      if c_fa_auf_lte%NOTFOUND then
        v_stdBestellNummerKunde := NULL;
      end if;

      CLOSE c_fa_auf_lte;

      OPEN c_pos_lte_all;
      FETCH c_pos_lte_all into v_best_nr_kunde;
      if c_pos_lte_all%FOUND then
        v_stdBestellNummerKunde := v_best_nr_kunde;
      end if;

      CLOSE c_pos_lte_all;
    elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lhm
    then
      v_id_basis := 'LHM';
      OPEN c_lhm;
      FETCH c_lhm into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lhm_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz,
                           v_lte_lte_akt_lhm,v_lte_order_vorgang_id,  v_lte_lte_voll, v_lhm_lhm_name, v_lam_charge_id,
                           v_lam_kunden_nr, v_lam_best_nr, v_brutto, v_netto,
                           v_order_pos_auf_id, v_lam_memge, v_lam_memge_basis, v_lam_leitzahl,
                           v_lam_prod_datum, v_lam_zeichnung, v_lam_zeichnung_index,
                           v_lam_artikel_id, v_lam_art_fanr, v_lam_art_faag, v_lam_art_faupos,
                           v_lieferanten_nr, v_li_nr_lief, v_lam_lhm_lfd_nr, v_lam_c_lhm_lfd_nr,
                           v_hersteller_kuerzel_liste;

      v_found := c_lhm%FOUND;
      CLOSE c_lhm;
      OPEN c_lhm_c;
      FETCH c_lhm_c into v_lhm_c;
      if c_lhm_c%FOUND then
        v_stdDatenfeldFuerLieferanten := v_lhm_c.lhm_text;
      end if;

      CLOSE c_lhm_c;

      OPEN c_fa_auf_lhm;
      FETCH c_fa_auf_lhm into v_stdBestellNummerKunde;
      if c_fa_auf_lhm%NOTFOUND then
        v_stdBestellNummerKunde := NULL;
      end if;

      CLOSE c_fa_auf_lhm;

      OPEN c_pos_lhm_all;
      FETCH c_pos_lhm_all into v_best_nr_kunde;
      if c_pos_lhm_all%FOUND then
        v_stdBestellNummerKunde := v_best_nr_kunde;
      end if;

      CLOSE c_pos_lhm_all;

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

    -- Wenn Artikelrein, dann wird der Artikelstamm jetzt gelesen
    OPEN c_art;
    FETCH c_art into v_art;
    if c_art%NOTFOUND then
      v_art := NULL;
    end if;
    CLOSE c_art;

    if  v_hersteller_kuerzel_liste is not NULL
    and v_hersteller_kuerzel_liste != ';'
    and isi_p_base.get_artikel_ctrl_typ(in_sid,
                                        v_lam_artikel_id,
                                        substr(v_hersteller_kuerzel_liste, 1, length(v_hersteller_kuerzel_liste) -1),
                                        v_art_ctrl)
    then
      v_typ := v_art_ctrl.prod_params;
    else
      v_typ := '0000000000';
    end if;
    if  v_hersteller_kuerzel_liste is not NULL
    and v_hersteller_kuerzel_liste != ';'
    and isi_p_base.get_hersteller(substr(v_hersteller_kuerzel_liste, 1, length(v_hersteller_kuerzel_liste) -1),
                                         v_hersteller)
    then
      v_h_tag := v_hersteller.tag;
    else
      v_h_tag := rpad('0', 20, '0');
    end if;


    v_stdAtrikelP1  := v_art.artikel_p1;
    v_stdAtrikelP2  := v_art.artikel_p2;
    v_stdAtrikelP3  := v_art.artikel_p3;
    v_stdAtrikelP4  := v_art.artikel_p4;
    v_stdAtrikelP5  := v_art.artikel_p5;
    v_stdAtrikelP6  := v_art.artikel_p6;
    v_stdAtrikelP7  := v_art.artikel_p7;
    v_stdAtrikelP8  := v_art.artikel_p8;
    v_stdAtrikelP9  := v_art.artikel_p9;
    v_stdAtrikelP10 := v_art.artikel_p10;

    if v_art.lte_lhm_menge = 0
    then
      v_art.lte_lhm_menge := 1;
    end if;


    if v_id_basis = 'LHM'
    then
      v_ArtSollMenge := v_art.lhm_menge;
      vs_netto := v_art.abfuell_soll / v_art.lte_lhm_menge;
      vs_brutto := v_art.lhm_gewicht_kg;
      if isi_allg.get_artikel_cfg(in_sid, v_art_cfg)
      then

        case v_art_cfg.artikel_p1_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p1);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p1);
             else NULL;
        end case;
        case v_art_cfg.artikel_p2_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p2);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p2);
             else NULL;
        end case;
        case v_art_cfg.artikel_p3_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p3);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p3);
             else NULL;
        end case;
        case v_art_cfg.artikel_p4_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p4);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p4);
             else NULL;
        end case;
        case v_art_cfg.artikel_p5_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p5);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p5);
             else NULL;
        end case;
        case v_art_cfg.artikel_p6_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p6);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p6);
             else NULL;
        end case;
        case v_art_cfg.artikel_p7_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p7);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p7);
             else NULL;
        end case;
        case v_art_cfg.artikel_p8_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p8);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p8);
             else NULL;
        end case;
        case v_art_cfg.artikel_p9_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p9);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p9);
             else NULL;
        end case;
        case v_art_cfg.artikel_p10_text
             when 'ART_ETI_SACKGEWICHT'      then vs_netto := to_number(v_art.artikel_p10);
             when 'ART_GROSS_EINZEL_GEBINDE' then vs_brutto := to_number(v_art.artikel_p10);
             else NULL;
        end case;
      end if;
      vs_tara := vs_brutto - vs_netto;
      -- -AG- Nur wenn gewicht genau passt dann aus Vorgabe
      --if  v_art.abfuell_toleranz_plus  < v_lam_memge
      --or v_art.abfuell_toleranz_minus > v_lam_memge
      if  v_art.lhm_menge != v_lam_memge
      then
        v_brutto := v_netto + nvl(vs_tara, 0);
      else
        v_brutto := vs_brutto;
        v_netto := vs_netto;
      end if;
    else
      v_ArtSollMenge := v_art.lte_menge;
      vs_netto := v_art.abfuell_soll;
      vs_brutto := v_art.lte_gewicht_kg;
      if isi_allg.get_artikel_cfg(in_sid, v_art_cfg)
      then

        case v_art_cfg.artikel_p1_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p1);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p1);
             else NULL;
        end case;
        case v_art_cfg.artikel_p2_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p2);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p2);
             else NULL;
        end case;
        case v_art_cfg.artikel_p3_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p3);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p3);
             else NULL;
        end case;
        case v_art_cfg.artikel_p4_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p4);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p4);
             else NULL;
        end case;
        case v_art_cfg.artikel_p5_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p5);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p5);
             else NULL;
        end case;
        case v_art_cfg.artikel_p6_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p6);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p6);
             else NULL;
        end case;
        case v_art_cfg.artikel_p7_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p7);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p7);
             else NULL;
        end case;
        case v_art_cfg.artikel_p8_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p8);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p8);
             else NULL;
        end case;
        case v_art_cfg.artikel_p9_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p9);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p9);
             else NULL;
        end case;
        case v_art_cfg.artikel_p10_text
             when 'ART_ETI_PALGEWICHT'       then vs_netto := to_number(v_art.artikel_p10);
             when 'ART_GROSS_GESAMT_GEBINDE' then vs_brutto := to_number(v_art.artikel_p10);
             else NULL;
        end case;
      end if;

      vs_tara := vs_brutto - vs_netto;

      -- -AG- Nur wenn gewicht genau passt dann aus Vorgabe
      --if  v_art.abfuell_toleranz_plus  < v_lam_memge / v_art.lte_lhm_menge
      --or v_art.abfuell_toleranz_minus > v_lam_memge / v_art.lte_lhm_menge
      if  v_art.lhm_menge != v_lam_memge / v_art.lte_lhm_menge
      then
        v_brutto := v_netto + nvl(vs_tara, 0);
      else
        v_brutto := vs_brutto;
        v_netto := vs_netto;
      end if;

    end if;

    if v_found then
      v_stdGewichtNetto              := v_netto;
      v_stdGewichtBrutto             := v_brutto;
      v_stdGewichtNetto_xxxxKxx_ME   := to_char(v_netto * 100, '9990,99') || ' ' || v_art.mengeneinheit_basis;
      v_stdGewichtBrutto_xxxxKxx_ME  := to_char(v_brutto * 100, '9990,99') || ' ' || v_art.mengeneinheit_basis;
      v_stdLieferscheinNrBestNr      := v_lam_best_nr;
      v_stdabladestelle              := v_lte_ziel_lgr_platz;
      v_stdsachnrlieferantprodnr     := v_lam_leitzahl;
      v_stdsachnrlieferantiskdpackm  := v_lte_lte_name;
      v_stdsachnrlieferantzusangaben := v_lhm_lhm_name;
      v_stdanzahlpackstuecke         := v_lte_lte_akt_lhm;
      v_stdsachnrlieferant           := v_art.artikel;
      if v_lam_art_faag is not NULL
      then
        v_stdsachnrlieferant := v_stdsachnrlieferant || '-' || nvl(to_char(v_lam_art_fanr), 'X') || '/' || to_char(v_lam_art_faag);
        if v_naechste_maschine is not NULL
        then
          v_stdsachnrlieferant := v_stdsachnrlieferant || ' --> ' || v_naechste_maschine;
        end if;

      end if;

      v_stdfuellmenge                := v_lam_memge;
      v_stdbezeichnunglieferungl     := v_art.bezeichnung1;
      v_stdsachnrlieferantabmessung  := v_art.bezeichnung2;
      v_stdaenderungkonstruktiono    := v_art.bezeichnung3;
      if v_lam_prod_datum is not NULL then
        v_stddatum                   := to_char(v_lam_prod_datum, 'YYMMDD');
      end if;

      v_stdaenderungkonstruktionz    := v_lam_zeichnung;
      v_stdaenderungkonstruktion     := v_lam_zeichnung_index;

      if v_lam_leitzahl is not NULL then
        v_stdsachnrlieferantprodnrbarc := v_lam_leitzahl;
      end if;

      if v_art.artikel is not NULL then
        v_stdsachnrlieferantbarcode := v_art.artikel;
        if v_lam_art_faag is not NULL
        then
          v_stdsachnrlieferantbarcode := v_stdsachnrlieferantbarcode || '-' || nvl(to_char(v_lam_art_fanr), 'X') || '/' || to_char(v_lam_art_faag);
        end if;

      end if;

      v_stdfuellmengebarcode := v_lam_memge;

      OPEN c_charge;
      FETCH c_charge into v_charge;
      v_found := c_charge%FOUND;
      CLOSE c_charge;

      if v_found then
        v_stdchangennr := v_charge.charge_bez;
        v_stdchangennrbarcode := v_charge.charge_bez;
      end if;

      v_stdLieferantenNr := v_lieferanten_nr;
      v_stdLieferscheinNrLief := v_li_nr_lief;
      v_stdLieferantenNrBarcode := v_lieferanten_nr;

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
           v_stdWarenempfaengerKurz := v_adr.name_1;
           v_stdWarenempfaengerLang1 := v_adr.name_1;
           v_stdWarenempfaengerLang2 := v_adr.name_2;
           v_stdWarenempfaengerLang3 := v_adr.plz || ' ' || v_adr.ort;
        end if;

      else
        OPEN c_kopf;
        FETCH c_kopf into v_kopf;
        if v_found then
          v_adr_id := v_kopf.adress_id;
          v_stdLieferscheinNr := to_char(v_kopf.vorgang_id);
          if v_kopf.wae_ziel is not NULL
          then
            v_stdabladestelle := v_kopf.wae_ziel;
          end if;

          OPEN c_adr;
          FETCH c_adr into v_adr;
          v_found := c_adr%FOUND;
          if v_found then
            v_stdwarenempfaengerkurz := v_adr.name_1;
            v_stdWarenempfaengerLang1 := v_adr.name_1;
            v_stdWarenempfaengerLang2 := v_adr.name_2;
            v_stdWarenempfaengerLang3 := v_adr.plz || ' ' || v_adr.ort;
            v_stdabladestelle := nvl(v_kopf.wae_ziel, v_stdabladestelle);
            v_adr_nr := v_adr.adr_nr;
          end if;

          CLOSE c_adr;
          v_adr_id := v_kopf.order_adress_id;
          OPEN c_adr;
          FETCH c_adr into v_adr;
          v_found := c_adr%FOUND;
          CLOSE c_adr;
          if v_found then
            v_stdlieferanschriftkurz := v_adr.name_1;
          end if;

        else
          v_adr_nr := v_lam_kunden_nr;
          OPEN c_kunde;
          FETCH c_kunde into v_adr;
          v_found := c_kunde%FOUND;
          CLOSE c_kunde;
          if v_found then
             v_stdWarenempfaengerKurz := v_adr.name_1 || ' ' || v_adr.name_2 || ' ' || v_adr.plz || ' ' || v_adr.ort;
             v_stdWarenempfaengerLang1 := v_adr.name_1;
             v_stdWarenempfaengerLang2 := v_adr.name_2;
             v_stdWarenempfaengerLang3 := v_adr.plz || ' ' || v_adr.ort;
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
        v_stdLieferantenAnschrift1 := v_adr.name_1;
        v_stdLieferantenAnschrift2 := v_adr.name_2;
        v_stdLieferantenAnschrift3 := v_adr.name_3;
        v_stdLieferantenAnschrift4 := v_adr.name_1 || ', ' || v_adr.name_2 || ', ' || v_adr.plz || ', ' || v_adr.ort;
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
          v_stdSachnrkundebarcode := v_art_kd.kd_art_nr;
          v_stdSachnrkunde := v_art_kd.kd_art_nr;
       end if;

      end if;

   end if;


   v_print_daten := '';

   v_stdpackstucknr        := in_id;
   v_stdPackstuckNrBarcode := in_id;

   if v_id_basis = 'LTE'
   then
     v_bc_format             := v_firma.lte_barcode_kopf;
     v_bc_typ                := v_firma.lte_barcode_type;
   else
     v_bc_format             := v_firma.lhm_barcode_kopf;
     v_bc_typ                := v_firma.lhm_barcode_type;
   end if;

   if isi_allg.get_firma_cfg_param (in_sid,
                                    in_firma_nr,
                                    'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                    NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                    'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                    'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                    'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                    'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                    'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
   then
     v_stdpackstucknr        := v_lhm_lte_id;
     v_stdPackstuckNrBarcode := v_lhm_lte_id;
     v_bc_format             := v_firma.lte_barcode_kopf;
     v_bc_typ                := v_firma.lte_barcode_type;
   end if;

   v_stdSpezBarcode := NULL;
   if in_format_spez_barcode is not NULL
   then
     v_lfd_nr := lvs_p_lte.get_barcode_lfdn(in_sid, in_format_spez_barcode, v_lte_lte_id);
     v_stdSpezBarcode := lvs_p_lte.format_barcode(in_sid,                         -- in_sid        in lvs_charge.sid%type,
                                                  in_format_spez_barcode,         -- in_format     in varchar2,
                                                  v_lfd_nr,                       -- in_nummer     in number,
                                                  length(in_format_spez_barcode), -- in_laenge     in number,
                                                  NULL,                           -- in_seq_basis  in varchar2,
                                                  v_stdchangennrbarcode,          -- in_charge     in lvs_charge.charge_bez%type,
                                                  v_lam_artikel_id,               -- in_artikel_id in isi_artikel.artikel_id%type,
                                                  null,                           -- in_basis_id   in varchar2
                                                  v_lam_memge,
                                                  v_typ,                   -- Typ für Barcode hier nicht bekannt, Pruefen
                                                  v_h_tag);
   end if;

   if v_bc_typ = 'SPEZ'
   then
     lvs_p_lte_lhm.spez_barcode_result(in_sid,                      -- in_sid        in lvs_charge.sid%type,
                                       in_firma_nr,
                                       v_stdpackstucknr,            -- in  lvs_lam.lhm_id%type,
                                       v_bc_format,                 -- in  isi_firma_cfg.parameter_wert%type,
                                       v_artikel,                   -- out_artikel
                                       v_charge_bez,                -- out varchar2,
                                       v_prod_datum,                -- out date,
                                       v_menge,                     -- out number,
                                       v_ean,                       -- out varchar2
                                       v_lfd_nr_str,            -- out varchar2
                                       v_linie_str);            -- out varchar2
     -- BugFix LHM-Druck mit lfdn der Einheit
     if v_id_basis = 'LTE'
     then
       v_stdLfdnLteID := lpad(v_lfd_nr_str, 2, '0');
     else
       if isi_allg.get_firma_cfg_param (in_sid,
                                        in_firma_nr,
                                        'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'ET_CHARGE_LHM_LFDN',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
       then
         v_stdLfdnLhmID := lpad(v_lam_c_lhm_lfd_nr, 2, '0');
       else
         v_stdLfdnLhmID := lpad(v_lam_lhm_lfd_nr, 2, '0');
       end if;
     end if;
     v_lfd_nr := lvs_p_lte.get_barcode_lfdn(in_sid, v_bc_format, v_stdpackstucknr);
     -- Sollmenge wie als Barcodemenge ermitteln
     v_stdpackstucknr := lvs_p_lte.format_barcode(in_sid,                           -- in_sid        in lvs_charge.sid%type,
                                                  v_bc_format,                      -- in_format     in varchar2,
                                                  v_lfd_nr,                         -- in_nummer     in number,
                                                  length(v_bc_format),              -- in_laenge     in number,
                                                  NULL,                             -- in_seq_basis  in varchar2,
                                                  v_stdchangennrbarcode,            -- in_charge     in lvs_charge.charge_bez%type,
                                                  v_lam_artikel_id,                 -- in_artikel_id in isi_artikel.artikel_id%type,
                                                  null,                             -- in_basis_id   in varchar2
                                                  v_ArtSollMenge,
                                                  v_typ,
                                                  v_h_tag);
     v_stdPackstuckNrBarcode := v_stdpackstucknr;
     for i in 1..length(v_stdPackstuckNr)
     loop
       if upper(substr(v_bc_format, i, 1)) = 'M'
       then
         if v_stdPackstuckNrSollMenge is NULL
         then
           v_stdPackstuckNrSollMenge := substr(v_stdPackstuckNr, i, 1);
         else
           v_stdPackstuckNrSollMenge := v_stdPackstuckNrSollMenge || substr(v_stdPackstuckNr, i, 1);
         end if;
       end if;
     end loop ;

     v_stdpackstucknr := lvs_p_lte.format_barcode(in_sid,                           -- in_sid        in lvs_charge.sid%type,
                                                  v_bc_format,                      -- in_format     in varchar2,
                                                  v_lfd_nr,                         -- in_nummer     in number,
                                                  length(v_bc_format),              -- in_laenge     in number,
                                                  NULL,                             -- in_seq_basis  in varchar2,
                                                  v_stdchangennrbarcode,            -- in_charge     in lvs_charge.charge_bez%type,
                                                  v_lam_artikel_id,                 -- in_artikel_id in isi_artikel.artikel_id%type,
                                                  null,                             -- in_basis_id   in varchar2
                                                  v_lam_memge,
                                                  v_typ,
                                                  v_h_tag);
     v_stdPackstuckNrBarcode := v_stdpackstucknr;
     for i in 1..length(v_stdPackstuckNr)
     loop
       if upper(substr(v_bc_format, i, 1)) = 'M'
       then
         if v_stdPackstuckNrMenge is NULL
         then
           v_stdPackstuckNrMenge := substr(v_stdPackstuckNr, i, 1);
         else
           v_stdPackstuckNrMenge := v_stdPackstuckNrMenge || substr(v_stdPackstuckNr, i, 1);
         end if;
       end if;
     end loop ;

   end if;

   if v_firma.lhm_barcode_type = 'SPEZ'
   and v_id_basis = 'LHM'
   and (isi_allg.get_firma_cfg_param (in_sid,
                                      in_firma_nr,
                                      'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'ET_LTE_ID_ON_ID_LHM',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                      'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') = c.C_TRUE)    -- in_default_param_typ
   then
     lvs_p_lte_lhm.spez_barcode_result(in_sid,
                                      in_firma_nr,
                                      in_id,                       -- in  lvs_lam.lhm_id%type,
                                       v_firma.lhm_barcode_kopf,    -- in  isi_firma_cfg.parameter_wert%type,
                                       v_artikel,                   -- out_artikel
                                       v_charge_bez,                -- out varchar2,
                                       v_prod_datum,                -- out date,
                                       v_menge,                     -- out number,
                                       v_ean,                       -- out varchar2
                                       v_lfd_nr_str,            -- out varchar2
                                       v_linie_str);            -- out varchar2

     if v_id_basis = 'LTE'
     then
       v_stdLfdnLhmID := to_char(to_number(v_lfd_nr_str));
     else
       v_stdLfdnLhmID := to_char(to_number(v_lam_lhm_lfd_nr));
     end if;
     if length(v_stdLfdnLhmID) < 2
     then
       v_stdLfdnLhmID := lpad(v_stdLfdnLhmID, 2, '0');
     end if;
   end if;

   if bde_p_base.get_fa_ag(v_lte_sid,
                           v_lte_firma_nr,
                           v_lam_art_fanr,
                           v_lam_art_faag,
                           v_lam_art_faupos,
                           v_fa_auftrag)
   then
     if v_fa_auftrag.lte_name = 'Faß'
     then
       v_fa_auftrag.lte_name := 'Fass';
     end if;
     v_stdEinsVonX := v_fa_auftrag.lte_name || ' 1-' || to_char(v_fa_auftrag.lhm_anz);
   else
     v_stdEinsVonX := NULL;
   end if;

   v_print_daten :=
    'stdSachNrLieferantDatenfeldFuerLieferanten='         || v_stdDatenfeldFuerLieferanten || CHR(13) || CHR(10) ||
    'stdGewichtBrutto='                                   || v_stdGewichtBrutto || CHR(13) || CHR(10) ||
    'stdGewichtNetto='                                    || v_stdGewichtNetto || CHR(13) || CHR(10) ||
    'stdGewichtBrutto_xxxxKxx_Einheit='                   || v_stdGewichtBrutto_xxxxKxx_ME || CHR(13) || CHR(10) ||
    'stdGewichtNetto_xxxxKxx_Einheit='                    || v_stdGewichtNetto_xxxxKxx_ME || CHR(13) || CHR(10) ||
    'stdLieferscheinNrBestellnummer='                     || v_stdLieferscheinNrBestNr || CHR(13) || CHR(10) ||
    'stdLieferscheinNr='                                  || v_stdLieferscheinNr || CHR(13) || CHR(10) ||
    'stdLieferscheinNrLief='                              || v_stdLieferscheinNrLief || CHR(13) || CHR(10) ||
    'stdWarenempfaengerKurz='                             || v_stdWarenempfaengerKurz || CHR(13) || CHR(10) ||
    'stdWarenempfaengerLang1='                            || v_stdWarenempfaengerLang1 || CHR(13) || CHR(10) ||
    'stdWarenempfaengerLang2='                            || v_stdWarenempfaengerLang2 || CHR(13) || CHR(10) ||
    'stdWarenempfaengerLang3='                            || v_stdWarenempfaengerLang3 || CHR(13) || CHR(10) ||
    'stdAbladestelle='                                    || v_stdAbladestelle || CHR(13) || CHR(10) ||
    'stdAnzahlPackstuecke='                               || v_stdAnzahlPackstuecke || CHR(13) || CHR(10) ||
    'stdFuellmenge='                                      || v_stdFuellmenge || CHR(13) || CHR(10) ||
    'stdFuellmengeMengeneinheit='                         || v_stdFuellmengeMengeneinheit || CHR(13) || CHR(10) ||
    'stdBezeichnungLieferungLeistung='                    || v_stdBezeichnungLieferungL || CHR(13) || CHR(10) ||
    'stdSachNrLieferant='                                 || v_stdSachNrLieferant || CHR(13) || CHR(10) ||
    'stdSachNrLieferantISKDPackmittel='                   || v_stdSachNrLieferantISKDPackm || CHR(13) || CHR(10) ||
    'stdSachNrLieferantZusAngaben='                       || v_stdSachNrLieferantZusAngaben || CHR(13) || CHR(10) ||
    'stdSachNrLieferantProduktionsNr='                    || v_stdSachNrLieferantProdNr || CHR(13) || CHR(10) ||
    'stdSachNrLieferantAbmessung='                        || v_stdSachNrLieferantAbmessung || CHR(13) || CHR(10) ||
    'stdSachNrKunde='                                     || v_stdSachNrKunde || CHR(13) || CHR(10) ||
    'stdDatum='                                           || v_stdDatum || CHR(13) || CHR(10) ||
    'stdAenderungKonstruktion='                           || v_stdAenderungKonstruktion || CHR(13) || CHR(10) ||
    'stdAenderungKonstruktionOberflaeche='                || v_stdAenderungKonstruktionO || CHR(13) || CHR(10) ||
    'stdAenderungKonstruktionZeichnung='                  || v_stdAenderungKonstruktionZ || CHR(13) || CHR(10) ||
    'stdPackstuckNr='                                     || v_stdPackstuckNr || CHR(13) || CHR(10) ||
    'stdChangenNr='                                       || v_stdChangenNr || CHR(13) || CHR(10) ||
    'stdLieferantenNr='                                   || v_stdLieferantenNr || CHR(13) || CHR(10) ||
    'stdLieferantenanschriftLang='                        || v_stdLieferantenAnschrift4 || CHR(13) || CHR(10) ||
    'stdSachNrKundeBarcode='                              || v_stdSachNrKundeBarcode || CHR(13) || CHR(10) ||
    'stdFuellmengeBarcode='                               || v_stdFuellmengeBarcode || CHR(13) || CHR(10) ||
    'stdPackstuckNrBarcode='                              || v_stdPackstuckNrBarcode || CHR(13) || CHR(10) ||
    'stdSachNrLieferantBarcode='                          || v_stdSachNrLieferantBarcode || CHR(13) || CHR(10) ||
    'stdChangenNrBarcode='                                || v_stdChangenNrBarcode || CHR(13) || CHR(10) ||
    'stdSachNrLieferantProduktionsNrBarcode='             || v_stdsachnrlieferantprodnrbarc || CHR(13) || CHR(10) ||
    'stdNrKundeBarcode='                                  || v_stdNrKundeBarcode || CHR(13) || CHR(10) ||
    'stdLieferantenNrBarcode='                            || v_stdLieferantenNrBarcode || CHR(13) || CHR(10) ||
    'stdLfdnLteID='                                       || v_stdLfdnLteID || CHR(13) || CHR(10) ||
    'stdLfdnLhmID='                                       || v_stdLfdnLhmID || CHR(13) || CHR(10) ||
    'stdEinsVonX='                                        || v_stdEinsVonX || CHR(13) || CHR(10) ||
    'stdSpezBarcode='                                     || v_stdSpezBarcode || CHR(13) || CHR(10) ||
    'stdPackstuckNrMenge='                                || v_stdPackstuckNrMenge || CHR(13) || CHR(10) ||
    'stdPackstuckNrSollMenge='                            || v_stdPackstuckNrSollMenge || CHR(13) || CHR(10) ||
    'stdAtrikelP1='                                       || v_stdAtrikelP1   || CHR(13) || CHR(10) ||
    'stdAtrikelP2='                                       || v_stdAtrikelP2   || CHR(13) || CHR(10) ||
    'stdAtrikelP3='                                       || v_stdAtrikelP3   || CHR(13) || CHR(10) ||
    'stdAtrikelP4='                                       || v_stdAtrikelP4   || CHR(13) || CHR(10) ||
    'stdAtrikelP5='                                       || v_stdAtrikelP5   || CHR(13) || CHR(10) ||
    'stdAtrikelP6='                                       || v_stdAtrikelP6   || CHR(13) || CHR(10) ||
    'stdAtrikelP7='                                       || v_stdAtrikelP7   || CHR(13) || CHR(10) ||
    'stdAtrikelP8='                                       || v_stdAtrikelP8   || CHR(13) || CHR(10) ||
    'stdAtrikelP9='                                       || v_stdAtrikelP9   || CHR(13) || CHR(10) ||
    'stdAtrikelP10='                                      || v_stdAtrikelP10;

    return (v_print_daten);
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end std_etikett;

  procedure c_test_etikett(in_sid                 in isi_sid.sid%type,
                           in_firma_nr            in isi_firma.firma_nr%type,
                           in_drucker in pe_drucker_cfg.drucker_name%type)
                           is
    v_print_daten     varchar2(4096);

    v_firma           isi_firma%rowtype;
    v_etikett         isi_etiketten%rowtype;
    v_job_nr          number;

    v_found           boolean;

    CURSOR c_etikett is
      select *
        from isi_etiketten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.etiketten_name = v_firma.lhm_etikett_fw;
  begin
    if not isi_p_base.get_isi_firma(in_sid, in_firma_nr, v_firma)
    then
      return;
    end if;

    OPEN c_etikett;
    FETCH c_etikett into v_etikett;
    v_found := c_etikett%found;
    CLOSE c_etikett;

    if not v_found
    then
      return;
    end if;

    v_print_daten :=
    'stdSachNrLieferantDatenfeldFuerLieferanten='         || 'DatFeld' || CHR(13) || CHR(10) ||
    'stdGewichtBrutto='                                   || '125' || CHR(13) || CHR(10) ||
    'stdGewichtNetto='                                    || '100' || CHR(13) || CHR(10) ||
    'stdGewichtBrutto_xxxxKxx_Einheit='                   || '120,00 Kg' || CHR(13) || CHR(10) ||
    'stdGewichtNetto_xxxxKxx_Einheit='                    || '100,00 Kg' || CHR(13) || CHR(10) ||
    'stdLieferscheinNrBestellnummer='                     || '123456' || CHR(13) || CHR(10) ||
    'stdLieferscheinNr='                                  || '123456' || CHR(13) || CHR(10) ||
    'stdLieferscheinNrLief='                              || '123456' || CHR(13) || CHR(10) ||
    'stdWarenempfaengerKurz='                             || 'EmpfKurz' || CHR(13) || CHR(10) ||
    'stdWarenempfaengerLang1='                            || 'EmpfLang1' || CHR(13) || CHR(10) ||
    'stdWarenempfaengerLang2='                            || 'EmpfLang2' || CHR(13) || CHR(10) ||
    'stdWarenempfaengerLang3='                            || 'EmpfLang3' || CHR(13) || CHR(10) ||
    'stdAbladestelle='                                    || 'Platz' || CHR(13) || CHR(10) ||
    'stdAnzahlPackstuecke='                               || '01' || CHR(13) || CHR(10) ||
    'stdFuellmenge='                                      || '1234' || CHR(13) || CHR(10) ||
    'stdFuellmengeMengeneinheit='                         || 'Stk' || CHR(13) || CHR(10) ||
    'stdBezeichnungLieferungLeistung='                    || 'Test' || CHR(13) || CHR(10) ||
    'stdSachNrLieferant='                                 || '123456' || CHR(13) || CHR(10) ||
    'stdSachNrLieferantISKDPackmittel='                   || '123456' || CHR(13) || CHR(10) ||
    'stdSachNrLieferantZusAngaben='                       || 'Zus.Angabe' || CHR(13) || CHR(10) ||
    'stdSachNrLieferantProduktionsNr='                    || '123456' || CHR(13) || CHR(10) ||
    'stdSachNrLieferantAbmessung='                        || '01-20-30' || CHR(13) || CHR(10) ||
    'stdSachNrKunde='                                     || '123456' || CHR(13) || CHR(10) ||
    'stdDatum='                                           || '01.01.2000' || CHR(13) || CHR(10) ||
    'stdAenderungKonstruktion='                           || 'KONST' || CHR(13) || CHR(10) ||
    'stdAenderungKonstruktionOberflaeche='                || 'OBERF' || CHR(13) || CHR(10) ||
    'stdAenderungKonstruktionZeichnung='                  || 'ZEICH' || CHR(13) || CHR(10) ||
    'stdPackstuckNr='                                     || '01' || CHR(13) || CHR(10) ||
    'stdChangenNr='                                       || '123456' || CHR(13) || CHR(10) ||
    'stdLieferantenNr='                                   || '123456' || CHR(13) || CHR(10) ||
    'stdLieferantenanschriftLang='                        || 'LiefAnsch4' || CHR(13) || CHR(10) ||
    'stdSachNrKundeBarcode='                              || '123456' || CHR(13) || CHR(10) ||
    'stdFuellmengeBarcode='                               || '1234' || CHR(13) || CHR(10) ||
    'stdPackstuckNrBarcode='                              || '12345612345601010000' || CHR(13) || CHR(10) ||
    'stdSachNrLieferantBarcode='                          || '123456' || CHR(13) || CHR(10) ||
    'stdChangenNrBarcode='                                || '123456' || CHR(13) || CHR(10) ||
    'stdSachNrLieferantProduktionsNrBarcode='             || '123456' || CHR(13) || CHR(10) ||
    'stdNrKundeBarcode='                                  || '1234567890' || CHR(13) || CHR(10) ||
    'stdLieferantenNrBarcode='                            || '123456' || CHR(13) || CHR(10) ||
    'stdLfdnLteID='                                       || '01' || CHR(13) || CHR(10) ||
    'stdLfdnLhmID='                                       || '01' || CHR(13) || CHR(10) ||
    'stdEinsVonX='                                        || '1-1' || CHR(13) || CHR(10) ||
    'stdSpezBarcode='                                     || '1234567890' || CHR(13) || CHR(10) ||
    'stdAtrikelP1='                                       || '4'    || CHR(13) || CHR(10) || -- Layout 4 bei Sasol
    'stdAtrikelP2='                                       || 'P2'   || CHR(13) || CHR(10) ||
    'stdAtrikelP3='                                       || 'P3'   || CHR(13) || CHR(10) ||
    'stdAtrikelP4='                                       || 'P4'   || CHR(13) || CHR(10) ||
    'stdAtrikelP5='                                       || 'P5'   || CHR(13) || CHR(10) ||
    'stdAtrikelP6='                                       || 'P6'   || CHR(13) || CHR(10) ||
    'stdAtrikelP7='                                       || 'P7'   || CHR(13) || CHR(10) ||
    'stdAtrikelP8='                                       || 'P8'   || CHR(13) || CHR(10) ||
    'stdAtrikelP9='                                       || 'P9'   || CHR(13) || CHR(10) ||
    'stdAtrikelP10='                                      || 'P10';

    PRINT_ENGINE.INSERT_NEW_JOB(in_sid,
                                in_firma_nr,
                                v_etikett.rave_datei,
                                v_etikett.rave_report,
                                PRINT_ENGINE.JDT_PV_LISTE,
                                v_print_daten,
                                in_drucker,
                                1,
                                v_job_nr);
     commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end c_test_etikett;

  --------------------------------------------------------------------------------
  function FORMAT_ARTIKEL(in_sid      in isi_sid.sid%type,
                          in_firma_nr in isi_firma.firma_nr%type,
                          in_str      in varchar2) return varchar2 is

    str_code   varchar2(18) := NULL;
    str_out    varchar2(23) := NULL;
    str_layout varchar2(23) := NULL;
    i number;
    pos number;
  begin
    str_layout := isi_allg.get_firma_cfg_param (in_sid,
                                                in_firma_nr,
                                                'PRINT',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                'ET_ARTIKEL_AUSGABE',     -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                'PrintEngine',            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                NULL,                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                'STRING');     -- in_default_param_typ
    if str_layout is not NULL
    then
      str_code := substr(in_str, 1, 18);

      i := 1;
      pos := 1;
      LOOP
        EXIT when pos > 23
               or i > length(str_code);
        if (pos <= length(str_layout))
        then
          if substr(str_layout, pos, 1) = '_'
          then
            str_out := nvl(str_out, substr(str_code, i, 1)) || substr(str_code, i, 1);
            i := i + 1;
          else
            str_out := nvl(str_out, substr(str_layout, pos, 1)) || substr(str_layout, pos, 1);
          end if;
        else
          str_out := nvl(str_out, substr(str_code, i, 1)) || substr(str_code, i, 1);
          i := i + 1;
        end if;

        pos := pos + 1;
      end LOOP;
    else
      str_out := in_str;
    end if;
    return(str_out);
  end;

--begin
  -- Initialization
  --<Statement>;
end isi_print;
/



-- sqlcl_snapshot {"hash":"17b641c060f4e20ac7db880ec50777e9f3c4f405","type":"PACKAGE_BODY","name":"ISI_PRINT","schemaName":"DIRKSPZM32","sxml":""}