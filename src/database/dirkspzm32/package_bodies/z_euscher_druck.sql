create or replace 
package body DIRKSPZM32.z_euscher_druck is

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
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);
  -- Function and procedure implementations
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
    v_GraphoLhmId                                         varchar2(50);
    v_ChargeId                                            varchar2(50);
    v_InfoHinweis                                         varchar2(50);

    CURSOR c_lte is
      select lte.sid,
             lte.firma_nr,
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

    CURSOR c_lhm is
      select lam.sid,
             lam.firma_nr,
             lhm.lhm_id,
             lhm.lhm_name,
             nvl(lte.ziel_lgr_platz, lte.lgr_platz) lgr_platz,
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
    v_VdaBezeichnungKunde      := NULL;
    v_GraphoLhmId              := NULL;
    v_ChargeId                 := NULL;
    v_InfoHinweis              := null;
    v_lam_art_fanr := NULL;
    v_lam_art_faag := NULL;

    if lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lte then
      OPEN c_lte;
      FETCH c_lte into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz,
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
    elsif lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_id) = C.Basis_Lhm then
      OPEN c_lhm;
      FETCH c_lhm into     v_lte_sid, v_lte_firma_nr, v_lte_lte_id, v_lte_lte_name, v_lte_ziel_lgr_platz,
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

    if v_found then
      v_VdaGewichtNetto              := v_netto;
      v_VdaGewichtBrutto             := v_brutto;
      v_VdaLieferscheinNrBestNr      := v_lam_best_nr;
      v_Vdaabladestelle              := v_lte_ziel_lgr_platz;
      v_Vdasachnrlieferantprodnr     := v_lam_leitzahl;
      v_Vdasachnrlieferantiskdpackm  := v_lte_lte_name;
      v_Vdasachnrlieferantzusangaben := v_lhm_lhm_name;
      v_Vdaanzahlpackstuecke         := v_lte_lte_akt_lhm;
      v_Vdasachnrlieferant           := v_art.artikel;

      -- -CMe 20190211- Es soll nur noch die Artikelnummer angezeigt werden. Ticket:W20310-215
      --v_Vdasachnrlieferant           := v_art.artikel_p1; -- Bei Euscher QS-Prüftext
      -- Falls der Parameter P1 nicht gefüllt, dann nur die Artikelnummer eintragen
      --if v_Vdasachnrlieferant is NULL
      --then
      --  v_Vdasachnrlieferant           := v_art.artikel;
      --else
      --  v_Vdasachnrlieferant           := v_Vdasachnrlieferant || ' ' || v_art.artikel;
      --end if;

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
   v_GraphoLhmId := 'E' || lpad(substr(to_char(v_Vdapackstucknr), 10), 10, '0');

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
    'GraphoLhmId='                                        || v_GraphoLhmId || cr_lf() ||
    'GraphoArtBez='                                       || substr(v_VdaBezeichnungLieferungL, 1, 10) || cr_lf() ||
    'GraphoChargeId='                                     || 'E' || v_ChargeId || cr_lf() ||
    'InfoHinweis='                                        || v_InfoHinweis;

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

end;
/



-- sqlcl_snapshot {"hash":"8f2a928e83d6df0f9ea2fba3a566fe3b13050d76","type":"PACKAGE_BODY","name":"Z_EUSCHER_DRUCK","schemaName":"DIRKSPZM32","sxml":""}