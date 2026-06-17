create or replace 
package body DIRKSPZM32.bde_tms_push is

/*
Funktionen für die Erzeugung von Fertigungsaufträgen über PPS-Tabellen Hier werden
Deckel zur Verfügung gestell, die dann Funktionrn im pps_p_bde aufrufen. Da die
hier benötigten Aufrufe aus Triggern aufgerufen werden, und einen Commit haben,
werden die Methoden hier mit pragma autonomous_transaction bereitgestellt.


@author -HJG- Hans Joachim Gödeke

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--27.11.2009   3.4.4.1     (-HJG-)  erstellt
--11.02.2015   3.5.8.x     (-HJG-)  Kommentare in JavaDoc-Style geändert

*/

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end;
  procedure raise_isi_error(in_err_nr in number, in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;
  -------------------------------------------------------------------------------------------------------

/*
procedure c_create_tms_pusch_transport
Erzeugt transpoerte für die Rohstoffversorgung (PUSH).
Damit eine PUSH für eien FA durchgeführt wird, muss der FA ware im Lager reserviert haben
Jeder BDE Auftrag wird durchsucht und nach Bedarf geprüft.

@author -HJG- Hans Joachim Gödeke


-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--05.10.2016   3.5.10      (-HJG-)  erstellt
  06.07.2022   DB31_11     (-CMe-)  Anpassung, es kann jetzt geprüft werden ob das ziel vom
                                    Typ DURCHL1 ist. Wenn ja und die Option aktib geschaltet ist
                                    wird geprüft ob auf den Ziel oder Transporte zu dem Ziel hin unterwegs sind,
                                    die eine höhere Leitzahl haben.

*/

  procedure c_create_tms_push_transport(in_sid               in isi_sid.sid%type,
                                        in_firma_nr          in isi_firma.firma_nr%type,
                                        in_ICE               in varchar2) is
  begin
    bde_tms_push.c_crt_tms_push_transport_db31(in_sid => in_sid,
                                               in_firma_nr => in_firma_nr,
                                               in_ice => in_ice,
                                               in_leitzahl => null);
  end;

  -- -AG- Funktion führt eine Inventur durch wenn nötig und pass ggf. den FA in den Menge an
  --      Zus. wird der FA-AG ggf. fertig gemeldet und an der Reasource abgemeldet.
  function c_tms_push_inventur (in_sid               in isi_sid.sid%type,
                                in_firma_nr          in isi_firma.firma_nr%type,
                                in_leitzahl          in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag             in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos           in bde_fa_auftrag.fa_upos%type,
                                in_res_id            in isi_resource.res_id%type,
                                in_login_id          in isi_user.login_id%type,
                                in_lte_id            in lvs_lte.lte_id%type,
                                in_menge             in lvs_lam_bh.menge%type)
                                return varchar2 is
    
    v_lam                   lvs_lam%rowtype;
    v_lam_bh                lvs_lam_bh%rowtype;
    v_lte                   lvs_lte%rowtype;
    v_bde_fa                bde_fa_auftrag%rowtype;
    v_art_ctrl              isi_artikel_ctrl%rowtype;
    v_hersteller            isi_hersteller%rowtype;    -- Daten aus isi-Hersteller
    v_charge                lvs_charge%rowtype;
    v_art                   isi_artikel%rowtype;
    v_dispo_charge_rein     varchar2(1);

    v_vorg_id               lvs_lam_bh.vorg_id%TYPE;   -- Neu VORGang_ID aus Sequenz
    v_lam_bh_id             lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_menge                 lvs_lam.menge%type;
    v_menge_rest            lvs_lam.menge%type;
    v_lhm_id                lvs_lam.lhm_id%type;               -- Neu LHM Karton ID
    v_lam_id                lvs_lam.lam_id%type;               -- Neu LAM_ID aus Sequenz
    v_typ                   varchar2(10);
    v_h_tag                 isi_hersteller.tag%type;

    v_bde_faktor_reduzieren number;
    v_bde_ma_res_menge      number;
    v_result                varchar2(1);
    v_result_res            number;

    v_found                 boolean;
    
    v_org_lhm               lvs_lhm%rowtype;
    v_lhm_vol               lvs_lhm.lhm_vol%type;
    v_lhm_cfg               lvs_lhm_cfg%rowtype;
    
    v_chk_on_res_lam        varchar2(1);
    
    -- CMe 20221124 (W23910-304): Es muss geprüft werden, ob es eine lam mit leerer order_pos_auf_id gibt,
    --                            wenn Menge nicht auf bereits reservierte LAM's dazu gebucht werden sollen  
    CURSOR c_chk_lam_available is
      select *
        from lvs_lam t
       where t.sid  = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
         and (t.order_pos_auf_id is null or 
              v_chk_on_res_lam = 'T')
       order by decode(t.order_pos_auf_id,
                       NULL, 0,
                       v_bde_fa.auf_id, 1,
                       2);
    CURSOR c_lam is
      select *
        from lvs_lam t
       where t.sid  = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
       order by decode(t.order_pos_auf_id,
                       NULL, 0,
                       v_bde_fa.auf_id, 1,
                       2);
    CURSOR c_lam_bh is
      select lam.*,
             lte.lgr_platz lte_lgr_platz,
             t.menge bh_menge,
             t.lam_bh_kg bh_lam_bh_kg
        from lvs_lam_bh t,
             lvs_lam lam,
             lvs_lte lte
       where t.sid  = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
         and t.lte_id = lte.lte_id
         and lam.lam_id = t.lam_id
       order by t.buch_datum desc;
    
    v_lam_lte_lgr           c_lam_bh%rowtype;

    CURSOR c_charge is
      select t.*
        from lvs_charge t
       where t.charge_id = v_lam_lte_lgr.charge_id;
       
    cursor c_lhm_cfg is
      select t.*
        from lvs_lhm_cfg t
       where t.sid = v_art.sid
         and t.lhm_name = v_art.lhm_name;
    
    cursor c_get_org_lhm is
      select lhm.* 
        from lvs_lhm lhm
       where 1=1
         and lhm.sid = v_lam_lte_lgr.sid
         and lhm.firma_nr = v_lam_lte_lgr.firma_nr
         and lhm.lhm_id = v_lam_lte_lgr.lhm_id;

  begin
    v_chk_on_res_lam := isi_allg.get_firma_cfg_param(in_sid => in_sid,
                                                     in_firma_nr => in_firma_nr,
                                                     in_kategorie => 'CFG',
                                                     in_kategorie_ix => null,
                                                     in_parameter_name => 'CHK_TMS_PUSH_INV_ON_RES_LAM',
                                                     in_modul_name => 'transport',
                                                     in_typ => 'CFG',
                                                     in_default_param_wert => 'F',
                                                     in_default_param_typ => 'String');
    v_bde_fa := NULL;
    v_result := c.C_TRUE;
    if not bde_p_base.get_fa_ag(in_sid,
                                in_firma_nr,
                                in_leitzahl,
                                in_fa_ag,
                                in_fa_upos,
                                v_bde_fa)
    then
      v_bde_fa.auf_id := NULL;
    end if;
    v_lam_lte_lgr.bh_lam_bh_kg := NULL;
    v_lam_lte_lgr.bh_menge := NULL;

    if in_menge > 0  -- Menge zubuchen
    then
      -- CMe 20221124 (W23910-304): Es muss geprüft werden, ob es eine lam mit leerer order_pos_auf_id gibt,
      --                            wenn Menge nicht auf bereits reservierte LAM's dazu gebucht werden sollen 
      OPEN c_chk_lam_available;
      FETCH c_chk_lam_available into v_lam;
      v_found := c_chk_lam_available%FOUND;
      CLOSE c_chk_lam_available;
      if not v_found -- LAM leer, keine LTE-ID mehr
      then
        OPEN c_lam_bh;
        FETCH c_lam_bh into v_lam_lte_lgr;
        v_found := c_lam_bh%FOUND;
        CLOSE c_lam_bh;
        if v_found
        then
          -- AG 20170308 Neue LAM dafür anlegen mit Menge 0
          OPEN c_charge;
          FETCH c_charge into v_charge;
          CLOSE c_charge;
          if not isi_p_base.get_isi_artikel(in_sid,
                                            v_lam.artikel_id,
                                            v_art)
          then
            v_art.artikel_fuer_kunde_etikett := NULL;
          end if;

          if  v_lam_lte_lgr.hersteller_kuerzel_liste is not NULL
          and v_lam_lte_lgr.hersteller_kuerzel_liste != ';'
          and isi_p_base.get_artikel_ctrl_typ(v_lam_lte_lgr.sid,
                                              v_lam_lte_lgr.artikel_id,
                                              substr(v_lam_lte_lgr.hersteller_kuerzel_liste, 1, length(v_lam_lte_lgr.hersteller_kuerzel_liste) -1),
                                              v_art_ctrl)
          then
            v_typ := v_art_ctrl.prod_params;
          else
            v_typ := '0000000000';
          end if;

          if  v_lam_lte_lgr.hersteller_kuerzel_liste is not NULL
          and v_lam_lte_lgr.hersteller_kuerzel_liste != ';'
          and isi_p_base.get_hersteller(substr(v_lam_lte_lgr.hersteller_kuerzel_liste, 1, length(v_lam_lte_lgr.hersteller_kuerzel_liste) -1),
                                        v_hersteller)
          then
            v_h_tag := v_hersteller.tag;
          else
            v_h_tag := rpad('0', 20, '0');
          end if;

          v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (v_lam_lte_lgr.sid,
                                                         v_lam_lte_lgr.firma_nr,
                                                         c.BASIS_LHM,
                                                         v_charge.charge_bez,
                                                         v_lam_lte_lgr.artikel_id,
                                                         v_art.artikel_fuer_kunde_etikett,
                                                         v_typ,
                                                         v_h_tag);
          
          --CMe 20220909 (W23910-279): Alte Variante geht davon, dass die original LHM immer vorhanden ist.
          --                           Fix: Jetzt wird geprüft ob die alte LHM noch gibt bzw. ob in lvs_lam
          --                           eine LHM ID vorhanden ist. Wenn ja wird werden von der LHM die Daten als Vorlage 
          --                           verwendet. Sonst werden die Daten aus der LHM CFG geladen und eingetragen
      
          open c_get_org_lhm;
          fetch c_get_org_lhm into v_org_lhm;
          v_found := c_get_org_lhm%found;
          close c_get_org_lhm;
          
          if (v_found)
          then
            insert into lvs_lhm
                   (sid,
                    firma_nr,
                    lhm_id,
                    lte_id,
                    lhm_name,
                    lgr_platz,
                    lhm_vol_hoehe,
                    lhm_vol_breite,
                    lhm_vol_tiefe,
                    lhm_vol,
                    lhm_akt_kg,
                    lhm_letzte_buchung,
                    lhm_eti_druck_status,
                    komm_quell_lte_id,
                    komm_quell_lgr_platz,
                    komm_neu_lhm_name)
            values (v_lam_lte_lgr.sid,
                    v_lam_lte_lgr.firma_nr,
                    v_lhm_id,
                    in_lte_id,
                    v_org_lhm.lhm_name,
                    v_lam_lte_lgr.lte_lgr_platz,
                    nvl(v_org_lhm.lhm_vol_hoehe, 0),
                    nvl(v_org_lhm.lhm_vol_breite, 0),
                    nvl(v_org_lhm.lhm_vol_tiefe, 0),
                    nvl(v_org_lhm.lhm_vol, 0),
                    nvl(v_org_lhm.lhm_akt_kg, 0),
                    sysdate,
                    null,
                    null,
                    null,
                    null);
          else
            open c_lhm_cfg;
            fetch c_lhm_cfg into v_lhm_cfg;
            close c_lhm_cfg;
        
            v_lhm_vol := nvl(v_lhm_cfg.lhm_vol_hoehe, 0) * nvl(v_lhm_cfg.lhm_vol_breite, 0) * nvl(v_lhm_cfg.lhm_vol_tiefe, 0) / 1000000000;
            
            insert into lvs_lhm
                   (sid,
                    firma_nr,
                    lhm_id,
                    lte_id,
                    lhm_name,
                    lgr_platz,
                    lhm_vol_hoehe,
                    lhm_vol_breite,
                    lhm_vol_tiefe,
                    lhm_vol,
                    lhm_akt_kg,
                    lhm_letzte_buchung,
                    lhm_eti_druck_status,
                    komm_quell_lte_id,
                    komm_quell_lgr_platz,
                    komm_neu_lhm_name)
            values (v_lam_lte_lgr.sid,
                    v_lam_lte_lgr.firma_nr,
                    v_lhm_id,
                    in_lte_id,
                    v_lhm_cfg.lhm_name,
                    v_lam_lte_lgr.lte_lgr_platz,
                    nvl(v_lhm_cfg.lhm_vol_hoehe, 0),
                    nvl(v_lhm_cfg.lhm_vol_breite, 0),
                    nvl(v_lhm_cfg.lhm_vol_tiefe, 0),
                    nvl(v_lhm_vol, 0),
                    0,
                    sysdate,
                    null,
                    null,
                    null,
                    null);
          end if;

          select seq_lam.nextval
            into v_lam_id
            from dual;

          insert into lvs_lam
               values (v_lam_lte_lgr.sid,                 -- SID                 VARCHAR2(2) not null,
                       v_lam_lte_lgr.firma_nr,            -- FIRMA_NR            NUMBER(2) not null,
                       v_lam_id,                          -- LAM_ID              NUMBER not null,
                       v_lam_lte_lgr.artikel_id,          -- ARTIKEL_ID          NUMBER,
                       v_lam_lte_lgr.lte_lgr_platz,       -- LGR_PLATZ           VARCHAR2(30),
                       in_lte_id,                         -- LTE_ID              VARCHAR2(19),
                       v_lhm_id,                          -- LHM_ID              VARCHAR2(19),
                       v_lam_lte_lgr.charge_id,           -- CHARGE_ID           NUMBER,
                       v_lam_lte_lgr.serie_id,            -- SERIE_ID            NUMBER,
                       v_lam_lte_lgr.leitzahl,            -- LEITZAHL            NUMBER,
                       v_lam_lte_lgr.fa_ag,               -- FA_AG               NUMBER,
                       v_lam_lte_lgr.fa_upos,             -- FA_UPOS             NUMBER,
                       v_lam_lte_lgr.abnr,                -- ABNR                VARCHAR2(20),
                       NULL,                              -- BEST_NR             VARCHAR2(20),
                       NULL,                              -- BEST_POS            VARCHAR2(5),
                       v_lam_lte_lgr.res_id,              -- RES_ID              NUMBER,
                       v_lam_lte_lgr.prod_datum,          -- PROD_DATUM          DATE,
                       v_lam_lte_lgr.zug_datum,           -- ZUG_DATUM           DATE,
                       v_lam_lte_lgr.ls_login_id,         -- LS_LOGIN_ID         NUMBER,
                       0,                                 -- MENGE               NUMBER,
                       0,                                 -- LAM_KG              NUMBER,
                       v_lam_lte_lgr.lam_text,            -- LAM_TEXT            VARCHAR2(20),
                       v_lam_lte_lgr.labor_status,        -- LABOR_STATUS        CHAR(1),
                       v_lam_lte_lgr.labor_text,          -- LABOR_TEXT          VARCHAR2(30),
                       v_lam_lte_lgr.lam_mhd,             -- LAM_MHD             DATE,
                       v_lam_lte_lgr.kunden_nr,           -- KUNDEN_NR           VARCHAR2(10),
                       v_lam_lte_lgr.kd_art_nr,           -- KD_ART_NR           VARCHAR2(30),
                       v_lam_lte_lgr.lieferant_nr,        -- LIEFERANT_NR        VARCHAR2(10),
                       v_lam_lte_lgr.lam_mhd_ausgabe,     -- LAM_MHD_AUSGABE     DATE,
                       v_lam_lte_lgr.menge_basis,         -- MENGE_BASIS         VARCHAR2(3) default 'LKE' not null,
                       v_lam_lte_lgr.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
                       NULL,                              -- ORDER_POS_AUF_ID    NUMBER
                       v_lam_lte_lgr.zeichnung,
                       v_lam_lte_lgr.zeichnung_index,
                       v_lam_lte_lgr.li_nr_lief,
                       v_lam_lte_lgr.lte_id_lieferant,
                       v_lam_lte_lgr.sonst_id_lieferant,
                       v_lam_lte_lgr.akt_inventur_id,
                       v_lam_lte_lgr.letzte_inventur_id,
                       v_lam_lte_lgr.letzte_inventur_datum,
                       v_lam_lte_lgr.letzte_inventur_login_id,
                       v_lam_lte_lgr.lam_p1,
                       v_lam_lte_lgr.lam_p2,
                       v_lam_lte_lgr.lam_p3,
                       v_lam_lte_lgr.lam_p4,
                       v_lam_lte_lgr.lam_p5,
                       v_lam_lte_lgr.lam_p6,
                       v_lam_lte_lgr.lam_p7,
                       v_lam_lte_lgr.lam_p8,
                       v_lam_lte_lgr.lam_p9,
                       v_lam_lte_lgr.lam_p10,
                       NULL,
                       NULL,
                       v_lam_lte_lgr.res_login_id,
                       v_lam_lte_lgr.check_ware_transp_id,
                       v_lam_lte_lgr.fae_id,
                       v_lam_lte_lgr.fae_id_position,
                       v_lam_lte_lgr.qs_status,
                       v_lam_lte_lgr.waren_typ,
                       v_lam_lte_lgr.lhm_lfd_nr,
                       lvs_komm.get_packschema_kopf_id(in_sid, in_firma_nr, in_lte_id),
                       lvs_komm.get_packschema_lfdn(in_sid, in_firma_nr, in_lte_id),
                       v_lam_lte_lgr.lhm_c_lfd_nr,
                       v_lam_lte_lgr.owner_address_id,             -- Besitzer wird aus der LAM übernommen
                       v_lam_lte_lgr.lam_sel1,                       -- LAM_SEL1  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel2,                       -- LAM_SEL2  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel3,                       -- LAM_SEL3  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel4,                       -- LAM_SEL4  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel5,                       -- LAM_SEL5  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel6,                       -- LAM_SEL6  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel7,                       -- LAM_SEL7  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel8,                       -- LAM_SEL8  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel9,                       -- LAM_SEL9  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.lam_sel10,                      -- LAM_SEL10  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
                       v_lam_lte_lgr.hersteller_kuerzel_liste,
                       v_lam.nr_pruefung);

        end if;
      end if;
    end if;

    v_menge_rest := in_menge * -1;

    if in_menge != 0
    then
      OPEN c_lam;
      LOOP
        FETCH c_lam into v_lam;
        EXIT when c_lam%NOTFOUND or v_menge_rest = 0;

        if v_lam.lgr_platz is not NULL
        and in_menge > 0
        then
          if bde_p_base.get_fa_ag(in_sid,
                                  in_firma_nr,
                                  in_leitzahl,
                                  in_fa_ag,
                                  in_fa_upos,
                                  v_bde_fa)
          and v_bde_fa.ma_res_menge <= v_bde_fa.ma_res_menge_komm         -- Alles mas möglich war ist aufgelegt
          and v_bde_fa.ma_reserviert = c.C_TRUE
          then
            update bde_fa_auftrag t      -- Wegen der Fehlmenge auch den Rest reduzieren
               set t.freig_status = 'F'
             where t.sid = in_sid
               and t.firma_nr = in_firma_nr
               and t.leitzahl = v_bde_fa.leitzahl
               and t.fa_ag = v_bde_fa.fa_ag
               and t.fa_upos = in_fa_upos;
            begin
              bde_p_base.c_bde_pd_set_deaktiv_ag(in_sid,
                                                 in_firma_nr,
                                                 in_res_id,
                                                 NULL,
                                                 in_login_id);
            exception
              when others then NULL; -- Wenn fehler, dann bleit der Auftrag angemeldet
            end;
          end if;
          
          select seq_vorg_id.nextval into v_vorg_id from dual;
          select seq_lam_bh.nextval into v_lam_bh_id from dual;
          insert into lvs_lam_bh t
               values(v_lam.sid,                                        -- SID               VARCHAR2(2) not null,
                      v_lam.firma_nr,                                   -- FIRMA_NR          NUMBER(2) not null,
                      v_vorg_id,                                        -- VORG_ID           NUMBER not null,
                      c.LAM_BH_INV,                                     -- VORG_TYP          VARCHAR2(2) not null,
                      v_lam_bh_id,                                      -- LAM_BH_ID         NUMBER not null,
                      v_lam.lam_id,                                     -- LAM_ID            NUMBER not null,
                      v_lam.artikel_id,                                 -- ARTIKEL_ID        NUMBER,
                      c.LAM_BH_BUS_IVZ,                                 -- BUS               NUMBER,
                      sysdate,                                          -- BUCH_DATUM        DATE,
                      in_login_id,                                      -- LS_LOGIN_ID       NUMBER,
                      v_lam.lgr_platz,                                  -- LGR_PLATZ         VARCHAR2(30),
                      v_lam.lte_id,                                     -- LTE_ID            VARCHAR2(19),
                      v_lam.lhm_id,                                     -- LHM_ID            VARCHAR2(19),
                      v_lam.charge_id,                                  -- CHARGE_ID         NUMBER,
                      v_lam.serie_id,                                   -- SERIE_ID          NUMBER,
                      NULL,                                             -- ABNR              VARCHAR2(20),
                      in_menge,                                         -- MENGE             NUMBER,
                      nvl(v_lam_lte_lgr.bh_lam_bh_kg, v_lam.lam_kg)
                       / nvl(v_lam_lte_lgr.bh_menge, v_lam.menge)
                       * (in_menge),                                    -- LAM_BH_KG         NUMBER,
                      nvl(v_lam_lte_lgr.bh_lam_bh_kg, v_lam.lam_kg) /
                      nvl(v_lam_lte_lgr.bh_menge, v_lam.menge),         -- LAM_BH_KG_EINHEIT NUMBER,
                      in_res_id,                                        -- RES_ID            NUMBER
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      sysdate,                                          -- CREATED_DATE          creation date+time of this dataset
                      in_login_id,                                      -- CREATED_LOGIN_ID      login id of the user creating this dataset
                      sysdate,                                          -- LAST_CHANGE_DATE      change date+time of this dataset
                      in_login_id,                                      -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                      null,                                             -- CHANGE_MENGE          Menge die geändert wurde
                      v_lam.owner_address_id,                           -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                      null);                                            -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
          v_menge_rest := 0;
        else
          if v_menge_rest > v_lam.menge
          then
            v_menge := v_lam.menge * -1;
            v_menge_rest := v_menge_rest + v_menge;
          else
            v_menge := v_menge_rest * -1;
            v_menge_rest := 0;
          end if;

          select seq_vorg_id.nextval into v_vorg_id from dual;
          select seq_lam_bh.nextval into v_lam_bh_id from dual;
          insert into lvs_lam_bh t
            values(v_lam.sid,                   -- SID               VARCHAR2(2) not null,
                   v_lam.firma_nr,              -- FIRMA_NR          NUMBER(2) not null,
                   v_vorg_id,                   -- VORG_ID           NUMBER not null,
                   c.LAM_BH_INV,                -- VORG_TYP          VARCHAR2(2) not null,
                   v_lam_bh_id,                 -- LAM_BH_ID         NUMBER not null,
                   v_lam.lam_id,                -- LAM_ID            NUMBER not null,
                   v_lam.artikel_id,            -- ARTIKEL_ID        NUMBER,
                   c.LAM_BH_BUS_IVZ,            -- BUS               NUMBER,
                   sysdate,                     -- BUCH_DATUM        DATE,
                   in_login_id,                 -- LS_LOGIN_ID       NUMBER,
                   v_lam.lgr_platz,             -- LGR_PLATZ         VARCHAR2(30),
                   v_lam.lte_id,                -- LTE_ID            VARCHAR2(19),
                   v_lam.lhm_id,                -- LHM_ID            VARCHAR2(19),
                   v_lam.charge_id,             -- CHARGE_ID         NUMBER,
                   v_lam.serie_id,              -- SERIE_ID          NUMBER,
                   NULL,                        -- ABNR              VARCHAR2(20),
                   v_menge,                     -- MENGE             NUMBER,
                   v_lam.lam_kg / v_lam.menge
                   * (v_menge),                 -- LAM_BH_KG         NUMBER,
                   v_lam.lam_kg / v_lam.menge,  -- LAM_BH_KG_EINHEIT NUMBER,
                   in_res_id,                   -- RES_ID            NUMBER
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                   in_login_id,                 -- CREATED_LOGIN_ID      login id of the user creating this dataset
                   sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                   in_login_id,                 -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                   null,                        -- CHANGE_MENGE          Menge die geändert wurde
                   v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                   null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
          if v_lam.order_pos_auf_id is not NULL
          then
            update lvs_lam t
               set t.res_menge = t.res_menge + v_menge
             where t.lam_id = v_lam.lam_id
               and t.order_pos_auf_id is not NULL;
            -- FA grade rücken
            if v_lam.res_menge + v_menge = 0                           -- Reservierung ist raus
            then
              v_result_res := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                                         in_firma_nr,
                                                         v_bde_fa.leitzahl,
                                                         v_bde_fa.auf_id,
                                                         v_lam.lte_id,
                                                         v_bde_fa.leitzahl,
                                                         v_bde_fa.auf_id,
                                                         c.C_TRUE);
            end if;

            if bde_p_base.get_fa_by_auf_id (in_sid,                    -- FA Einlesen
                                            in_firma_nr,
                                            v_lam.order_pos_auf_id,
                                            v_bde_fa)
            and v_bde_fa.ma_reserviert = c.C_TRUE
            and v_bde_fa.auf_id = v_lam.order_pos_auf_id
            then
              v_bde_ma_res_menge := v_bde_fa.ma_res_menge + v_menge;
              update bde_fa_auftrag t                                   -- Reservierte Menge korrigieren
                 set t.ma_res_menge = t.ma_res_menge + v_menge
               where t.sid = in_sid
                 and t.firma_nr = in_firma_nr
                 and t.leitzahl = v_bde_fa.leitzahl
                 and t.fa_ag = v_bde_fa.fa_ag
                 and t.fa_upos = v_bde_fa.fa_upos
                 and t.auf_id = v_lam.order_pos_auf_id;
              commit;
              if v_bde_fa.ma_hersteller_kuerzel_liste is not NULL       -- DISPO vorbereiten
              then
                v_dispo_charge_rein := 'H';
              elsif v_bde_fa.ma_res_charge_id is not NULL
              then
                v_dispo_charge_rein := c.C_TRUE;
              else
                v_dispo_charge_rein := c.C_FALSE;
              end if;

              pps_p_bde.create_bde_fa_dispo(in_sid,                     -- Disponieren nach FA-Vorgabe
                                            in_firma_nr,
                                            v_dispo_charge_rein,
                                            v_bde_fa.ma_hersteller_kuerzel_liste,
                                            v_bde_fa.leitzahl,
                                            v_bde_fa.fa_ag,
                                            v_bde_fa.fa_upos,
                                            'F',                       -- Nachreservieren was geht
                                            -1,
                                            c.C_TRUE);                 -- in_ice -> express-Platz
              v_bde_faktor_reduzieren := v_bde_fa.ag_soll_mg;

              if  v_bde_fa.ma_res_menge = v_bde_fa.ag_soll_mg          -- War komplett reserviert,
              and bde_p_base.get_fa_by_auf_id (in_sid,
                                               in_firma_nr,
                                               v_lam.order_pos_auf_id,
                                               v_bde_fa)
              and v_bde_fa.ma_res_menge != v_bde_fa.ag_soll_mg         -- konnte aber nicht komplett Nachreserviert werden
              then
                if v_bde_fa.ma_res_menge = v_bde_ma_res_menge          -- Es konnte nichts nachreserviert werden
                then
                  v_result := c.C_FALSE;
                end if;
                if v_bde_faktor_reduzieren != 0
                then
                  v_bde_faktor_reduzieren := v_bde_fa.ma_res_menge / v_bde_faktor_reduzieren;
                end if;
                update bde_fa_auftrag t      -- Genau diesen reduzieren
                   set t.ag_soll_mg = t.ma_res_menge,
                       t.freig_status = decode(t.ma_res_menge_komm,
                                               t.ma_res_menge, 'F',
                                               t.freig_status)
                 where t.sid = in_sid
                   and t.firma_nr = in_firma_nr
                   and t.leitzahl = v_bde_fa.leitzahl
                   and t.fa_ag = v_bde_fa.fa_ag
                   and t.fa_upos = v_bde_fa.fa_upos
                   and t.auf_id = v_lam.order_pos_auf_id;
                if v_bde_fa.ma_res_menge = v_bde_fa.ma_res_menge_komm -- Alles aufgelegt dann abmelden
                then
                  begin
                    bde_p_base.c_bde_pd_set_deaktiv_ag(in_sid,
                                                       in_firma_nr,
                                                       in_res_id,
                                                       NULL,
                                                       in_login_id);
                  exception
                    when others then NULL; -- Wenn fehler, dann bleit der Auftrag angemeldet
                  end;
                end if;

                update bde_fa_auftrag t      -- Wegen der Fehlmenge auch den Rest reduzieren
                   set t.ag_soll_mg = round((t.ag_soll_mg * v_bde_faktor_reduzieren), 0)
                 where t.sid = in_sid
                   and t.firma_nr = in_firma_nr
                   and t.leitzahl = v_bde_fa.leitzahl
                   and t.fa_ag > v_bde_fa.fa_ag
                   and t.fa_upos = in_fa_upos
                   and (t.satzart like 'V%'
                     or t.ma_reserviert = c.C_TRUE);
                commit;
              end if;
            end if;
            --CMe 20220832: Leitzahl muss übergeben werden, da ansonsten alle Sachen zum Expressplatz gesendet werden
            bde_tms_push.c_crt_tms_push_transport_db31(in_sid, in_firma_nr, 'T', in_leitzahl); -- Nachreservieren und Transport falls nötig
          else
            if bde_p_base.get_fa_ag(in_sid,
                                    in_firma_nr,
                                    in_leitzahl,
                                    in_fa_ag,
                                    in_fa_upos,
                                    v_bde_fa)
            and v_bde_fa.ma_res_menge <= v_bde_fa.ma_res_menge_komm         -- Alles mas möglich war ist aufgelegt
            and v_bde_fa.ma_reserviert = c.C_TRUE
            then
              update bde_fa_auftrag t      -- Wegen der Fehlmenge auch den Rest reduzieren
                 set t.freig_status = 'F'
               where t.sid = in_sid
                 and t.firma_nr = in_firma_nr
                 and t.leitzahl = v_bde_fa.leitzahl
                 and t.fa_ag = v_bde_fa.fa_ag
                 and t.fa_upos = in_fa_upos;
              begin
                bde_p_base.c_bde_pd_set_deaktiv_ag(in_sid,
                                                   in_firma_nr,
                                                   in_res_id,
                                                   NULL,
                                                   in_login_id);
              exception
                when others then NULL; -- Wenn fehler, dann bleit der Auftrag angemeldet
              end;
            end if;
          end if;
        end if;
      end LOOP;
      CLOSE c_lam;
    else  -- Nur FA prüfen auf fertig
      if bde_p_base.get_fa_ag(in_sid,
                              in_firma_nr,
                              in_leitzahl,
                              in_fa_ag,
                              in_fa_upos,
                              v_bde_fa)
      and v_bde_fa.ma_res_menge <= v_bde_fa.ma_res_menge_komm         -- Alles mas möglich war ist aufgelegt
      and v_bde_fa.ma_reserviert = c.C_TRUE
      then
        update bde_fa_auftrag t      -- Wegen der Fehlmenge auch den Rest reduzieren
           set t.freig_status = 'F'
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.leitzahl = v_bde_fa.leitzahl
           and t.fa_ag = v_bde_fa.fa_ag
           and t.fa_upos = in_fa_upos;
        begin
          bde_p_base.c_bde_pd_set_deaktiv_ag(in_sid,
                                             in_firma_nr,
                                             in_res_id,
                                             NULL,
                                             in_login_id);
        exception
          when others then NULL; -- Wenn fehler, dann bleit der Auftrag angemeldet
        end;
      end if;
    end if;
    OPEN c_lam;
    FETCH c_lam into v_lam;
    if c_lam%NOTFOUND
    then
      if lvs_p_base.get_lte(in_lte_id, v_lte)
      then
        update lvs_lte t
           set t.lte_akt_lhm = 0
         where t.lte_id = in_lte_id;
        lvs_p_lte.lvs_korr_te_ausbuchen(in_sid, in_firma_nr, v_lte.lte_id, v_lte.lte_status, in_sid, in_firma_nr,
                                        v_lte.lgr_ort, v_lte.lgr_platz, in_login_id);
      end if;
    end if;
    CLOSE c_lam;
    commit;
    return(v_result);
  end;

  procedure c_tms_push_res_red (in_sid               in isi_sid.sid%type,
                                in_firma_nr          in isi_firma.firma_nr%type,
                                in_leitzahl          in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag             in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos           in bde_fa_auftrag.fa_upos%type,
                                in_res_id            in isi_resource.res_id%type,
                                in_login_id          in isi_user.login_id%type,
                                in_lte_id            in lvs_lte.lte_id%type,
                                in_menge             in lvs_lam_bh.menge%type)
                                is
    v_lam                                             lvs_lam%rowtype;
    v_bde_fa                                          bde_fa_auftrag%rowtype;
    v_in_menge                                        number;
    v_b_menge                                         number;

    v_result_res                           number;

    CURSOR c_lam is
      select t.*
        from lvs_lam t,
             lvs_lte lte
       where t.sid  = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = lte.lte_id
         and t.order_pos_auf_id = v_bde_fa.auf_id
       order by lte.lte_letzte_buchung desc;

  begin
    v_bde_fa := NULL;
    if bde_p_base.get_fa_ag(in_sid,
                            in_firma_nr,
                            in_leitzahl,
                            in_fa_ag,
                            in_fa_upos,
                            v_bde_fa)
    then
      v_in_menge := in_menge;
      OPEN c_lam;
      loop
        FETCH c_lam into v_lam;
        exit when c_lam%notfound
               or v_in_menge = 0;

        if v_lam.res_menge + v_in_menge >= 0
        then
          v_b_menge := v_in_menge;
        else
          v_b_menge := v_lam.res_menge * -1;
        end if;
        v_in_menge := v_in_menge - v_b_menge;

        update lvs_lam t
           set t.res_menge = t.res_menge + v_b_menge
         where t.lam_id = v_lam.lam_id;

        if v_lam.res_menge + v_b_menge = 0  -- Nicht mehr reserviert
        and v_in_menge = 0
        then
          v_result_res := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                                     in_firma_nr,
                                                     v_bde_fa.leitzahl,
                                                     v_bde_fa.auf_id,
                                                     v_lam.lte_id,
                                                     v_bde_fa.leitzahl,
                                                     v_bde_fa.auf_id,
                                                     c.C_TRUE);

        end if;
      end loop;
      CLOSE c_lam;

      update bde_fa_auftrag t                                   -- Reservierte Menge korrigieren
         set t.ma_res_menge = t.ma_res_menge + in_menge
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.leitzahl = v_bde_fa.leitzahl
         and t.fa_ag = v_bde_fa.fa_ag
         and t.fa_upos = v_bde_fa.fa_upos
         and t.auf_id = v_bde_fa.auf_id;

    end if;
    commit;
  end;
  
  procedure c_crt_tms_push_transport_db31(in_sid               in isi_sid.sid%type,
                                          in_firma_nr          in isi_firma.firma_nr%type,
                                          in_ICE               in varchar2,
                                          in_leitzahl          in bde_fa_auftrag.leitzahl%type) is

  begin
    bde_tms_push.crt_tms_push_transport_db31(in_sid => in_sid,
                                             in_firma_nr => in_firma_nr,
                                             in_ice => in_ice,
                                             in_leitzahl => in_leitzahl);
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
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
  end c_crt_tms_push_transport_db31;
  
  procedure crt_tms_push_transport_db31(in_sid               in isi_sid.sid%type,
                                        in_firma_nr          in isi_firma.firma_nr%type,
                                        in_ICE               in varchar2,
                                        in_leitzahl          in bde_fa_auftrag.leitzahl%type) is
  
  v_bde_fa                            bde_fa_auftrag%rowtype;
  v_bde_fak                           bde_fa_kopf%rowtype;
  v_lvs_lgr_ort_ue_platz              lvs_lgr_ort_ue_platz%rowtype;
  v_lgr_ue                            lvs_lgr%rowtype;

  v_dispo_charge_rein                 varchar2(1);
  v_transport_count                   number;
  v_transport_ue_platz_count          number;

  v_res                               isi_resource%rowtype;
  v_lgr                               lvs_lgr%rowtype;
  v_lgr_grp                           lvs_lgr%rowtype;
  v_transp_id                         isi_transport.transp_id%type;
  v_transp_grp                        isi_transport.transport_gruppe%type;
  v_result                            number;
  v_wa_type                           lvs_lgr.wa_typ%type;
  v_lgr_platz                         lvs_lgr.lgr_platz%type;

  v_bde_push_q_chk varchar2(1);


  v_streng_fifo             varchar2(1);
  
  v_check_z_durchl          varchar2(1);
  
  v_chk_sum_target          number;
  v_chk_sum_trans_to_target number;
  v_change_wa_type          boolean;
  v_chk_lgr_platz           lvs_lgr.lgr_platz%type;

  -- AG 2017.10.10 BugFix
  CURSOR c_transport_count is
    select count(t.transp_id)
      from isi_transport t
     where t.lgr_platz_ziel = v_lgr_platz;

  CURSOR c_lgr_grp is
    select *
      from lvs_lgr t
     where t.sid = v_lgr.sid
       and t.firma_nr = v_lgr.firma_nr
       and t.lgr_verwendung = 'WA'
       and t.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
       and t.gesperrt = 'F'
     order by t.lgr_platz;

  CURSOR c_bde_fa is
    select *
      from bde_fa_auftrag fa
     where fa.ma_reserviert = 'T'
       and fa.res_id is not NULL
       and fa.freig_status not in ('F', 'TF')
       and fa.ag_soll_mg > fa.ma_res_menge_komm
       and fa.leitzahl = nvl(in_leitzahl, fa.leitzahl)
       
     order by fa.termin_start_gepl,
              fa.abnr,
              fa.leitzahl,
              fa.fa_ag;

  CURSOR c_bde_fak is
    select *
      from bde_fa_kopf fak
     where fak.sid = v_bde_fa.sid
       and fak.firma_nr = v_bde_fa.firma_nr
       and fak.fa_nr = v_bde_fa.leitzahl;

  CURSOR c_res_lte is
    select lte.*,
           cfg.basis_lte_name,
           trunc(lvs_ausl.lvs_lte_platz_bewerten(in_sid, in_firma_nr, 'FIFO', 'I',
                                                 lte.lte_voll, nvl(t.lam_mhd, lte.res_mhd), trunc(t.prod_datum),
                                                 lte.lte_id, lte.lgr_platz, lte.res_string,
                                                 lgr.lgr_platz_gruppe, lgr.lgr_typ, v_bde_fa.ag_artikel_id)) ausl_sort,
           lvs_ausl.lvs_lte_platz_bewerten(in_sid, in_firma_nr, 'FIFO', 'I',
                                           lte.lte_voll, nvl(t.lam_mhd, lte.res_mhd), trunc(t.prod_datum),
                                           lte.lte_id, lte.lgr_platz, lte.res_string,
                                           lgr.lgr_platz_gruppe, lgr.lgr_typ, t.artikel_id) ausl_sort2
      from lvs_lam t,                                     -- In der LAM ist die resservierng
           lvs_lte lte,                                   -- Lte für Lagerplatzgruppe und Status
           lvs_lte_cfg cfg,                               -- Zur Ermittlung der Basistypen (Prüfen gegen Lagerplatz)
           lvs_lgr lgr
     where t.sid = v_bde_fa.sid
       and t.firma_nr = v_bde_fa.firma_nr
       and t.order_pos_auf_id = v_bde_fa.auf_id           -- Reserviert für diesen Auftrag
       and t.lte_id = lte.lte_id
       and lte.lgr_platz_gruppe != v_lgr.lgr_platz_gruppe -- Palette ist bereits da
       and lte.lte_status not like '%T'
       and lte.lte_status not like '%D'
       and lte.lgr_platz = lgr.lgr_platz
       and (lgr.wa_typ = 'BDEPUSH' or v_bde_push_q_chk = c.C_FALSE) -- BDE-Push eingestellt auf der Quelle oder ist nich Pflicht
       and lte.sid = cfg.sid(+)
       and lte.firma_nr = cfg.firma_nr(+)
       and lte.lte_name = cfg.lte_name(+)
       and not exists (select lgr_grp.lgr_platz -- Keine LTE transportieren die auf einem Maschinenplat steht
                         from lvs_lgr lgr,
                              isi_resource r,
                              lvs_lgr lgr_grp
                        where  (lgr.lgr_platz = r.lager_roh
                             or lgr.lgr_platz = r.lager_fertig)
                          and lgr.lgr_platz_gruppe = lgr_grp.lgr_platz_gruppe
                          and lgr_grp.lgr_platz = lte.lgr_platz)
    order by decode(lgr.lgr_typ, c.R_DURCHL1, lgr.lgr_dim_platz, 0) desc,
             decode(lgr.lgr_typ, c.R_DURCHL1, to_number(lte.lte_letzte_buchung), 0),
             decode(v_streng_fifo, 'T', t.prod_datum - sysdate, 0),
             ausl_sort,
             ausl_sort2,
             decode(v_streng_fifo, 'T', t.prod_datum - sysdate, 0);
  
  CURSOR c_get_check_lgr is
    select lgr.lgr_platz
      from lvs_lgr lgr
     where lgr.sid = v_lgr.sid
       and lgr.firma_nr = v_lgr.firma_nr
       and lgr.lgr_verwendung = 'WA'
       and lgr.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
       and lgr.wa_typ = v_wa_type
     order by lgr.lgr_platz;
    
  
  CURSOR c_check_lgr_target is
    select nvl(count(lam.lam_id), 0) anz
      from lvs_lgr lgr
      join lvs_lam lam on lam.lgr_platz = lgr.lgr_platz
     where 1=1
       and lgr.sid = v_lgr.sid
       and lgr.firma_nr = v_lgr.firma_nr
       and lgr.lgr_verwendung = 'WA'
       and lgr.lgr_typ = 'DURCHL1'
       and lgr.lgr_platz = v_chk_lgr_platz
       and lam.order_pos_auf_id > v_bde_fa.auf_id;
  
  CURSOR c_check_t_to_target is
    select nvl(count(lam.lam_id),0) anz
      from isi_transport tr
      join lvs_lgr lgr on lgr.lgr_platz = tr.lgr_platz_ziel
      join lvs_lam lam on lam.lgr_platz = lgr.lgr_platz
     where 1=1
       and lgr.sid = v_lgr.sid
       and lgr.firma_nr = v_lgr.firma_nr
       and lgr.lgr_verwendung = 'WA'
       and lgr.lgr_typ = 'DURCHL1'
       and lgr.lgr_platz = v_chk_lgr_platz
       and lam.order_pos_auf_id > v_bde_fa.auf_id;

  v_lte                               c_res_lte%rowtype;

  begin
    v_streng_fifo := isi_allg.get_firma_cfg_param(in_sid,
                                                  in_firma_nr,
                                                  'AUSL_STRAT',
                                                  null,
                                                  'STRENG_FIFO',
                                                  'LVS',
                                                  'CFG',
                                                  'F',
                                                  'BOOLEAN');

    v_bde_push_q_chk := isi_allg.get_firma_cfg_param(in_sid,
                                                     in_firma_nr,
                                                     'AUSL_BDE_PUSH',
                                                     'TRANSPORT',
                                                     'BDE_AUSL_QPLATZ_PUSH_SET',
                                                     'BDE',
                                                     'CFG',
                                                     'F',
                                                     'BOOLEAN');
    
    v_check_z_durchl := isi_allg.get_firma_cfg_param(in_sid,
                                                     in_firma_nr,
                                                     'AUSL_BDE_PUSH',
                                                     'TRANSPORT',
                                                     'BDE_AUSL_CHK_Z_DURCHL',
                                                     'BDE',
                                                     'CFG',
                                                     'T',
                                                     'BOOLEAN');

    OPEN c_bde_fa;
    LOOP
      FETCH c_bde_fa into v_bde_fa;
      EXIT when c_bde_fa%NOTFOUND;

      v_bde_fak := NULL;
      OPEN c_bde_fak;
      FETCH c_bde_fak into v_bde_fak;
      CLOSE c_bde_fak;

      if in_ICE = c.C_TRUE
      or v_bde_fak.soll_betriebsart = 'JITSEQ'
      or v_bde_fak.soll_betriebsart = 'EXPRESS'
      then
        v_wa_type := 'BDEICEPUSH';
      else
        v_wa_type := 'BDEPUSH';
      end if;
      v_lgr_grp := NULL;
      v_lgr := NULL;

      if  v_bde_fa.ag_soll_mg > v_bde_fa.ma_res_menge -- Es fehlt reservierte Menge
      --CMe 20220822: Schwachsinn hier, kann auch komplett fehlen
      --and v_bde_fa.ma_res_menge > 0                   -- Es wurde bereits etwas Reaserviert (Fehlmenge)
      then
        if v_bde_fa.ma_hersteller_kuerzel_liste is not NULL
        then
          v_dispo_charge_rein := 'H';
        elsif v_bde_fa.ma_res_charge_id is not NULL
        then
          v_dispo_charge_rein := c.C_TRUE;
        else
          v_dispo_charge_rein := c.C_FALSE;
        end if;

        pps_p_bde.create_bde_fa_dispo(in_sid,
                                      in_firma_nr,
                                      v_dispo_charge_rein,
                                      v_bde_fa.ma_hersteller_kuerzel_liste,
                                      v_bde_fa.leitzahl,
                                      v_bde_fa.fa_ag,
                                      v_bde_fa.fa_upos,
                                      'F',                       -- War nicht komplett reserviert, dann Nachreservieren was geht
                                      -1,
                                      c.C_FALSE);                -- in ICE

      end if;

      if isi_p_base.get_resource(in_sid,
                                 v_bde_fa.res_id,
                                 v_res)
      then
        if lvs_p_base.get_lgr_platz(v_res.lager_roh,
                                    v_lgr)
        then
          -- CMe 20220706: Prüfung der Transporte und Transportziele
          if (v_check_z_durchl = 'T') 
          then
            open c_get_check_lgr;
            loop
              fetch c_get_check_lgr into v_chk_lgr_platz;
              exit when c_get_check_lgr%notfound;
              
              open c_check_lgr_target;
              fetch c_check_lgr_target into v_chk_sum_target;
              close c_check_lgr_target;
            
              open c_check_t_to_target;
              fetch c_check_t_to_target into v_chk_sum_trans_to_target;
              close c_check_t_to_target;
            
              if (v_chk_sum_target > 0) or
                 (v_chk_sum_trans_to_target > 0)
              then
                v_change_wa_type := true;
              else
                v_change_wa_type := false;
              end if;
            end loop;
            close c_get_check_lgr;
            
            if (v_change_wa_type)
            then
              v_wa_type := 'BDEICEPUSH';
            end if;
          end if;
          
          OPEN c_res_lte;
          LOOP
            FETCH c_res_lte into v_lte;
            EXIT when c_res_lte%NOTFOUND;

            OPEN c_lgr_grp;
            LOOP
              fetch c_lgr_grp into v_lgr_grp;
              EXIT when c_lgr_grp%NOTFOUND;

               -- AG 2017.10.10 BugFix
              v_lgr_platz := v_lgr_grp.lgr_platz;
              OPEN c_transport_count;
              FETCH c_transport_count into v_transport_count;
              CLOSE c_transport_count;

              if not lvs_p_base.get_lvs_lgr_ort_ue_platz(v_lgr_grp.sid,
                                                         v_lgr_grp.firma_nr,
                                                         v_lte.lgr_ort,
                                                         v_lgr_grp.lgr_ort,
                                                         v_lgr_grp.lgr_platz,      -- in_lgr_platz => nicht nötig - Standard lesen
                                                         v_lte.lte_name,
                                                         v_lvs_lgr_ort_ue_platz)
              then
                v_lvs_lgr_ort_ue_platz := NULL;
                v_lvs_lgr_ort_ue_platz.lte_name_ziel := NULL;
                v_transport_ue_platz_count := NULL;
              else
                v_lgr_platz := v_lvs_lgr_ort_ue_platz.lgr_platz;
                OPEN c_transport_count;
                FETCH c_transport_count into v_transport_ue_platz_count;
                CLOSE c_transport_count;
                if not lvs_p_base.get_lgr_platz(v_lgr_platz, v_lgr_ue)
                then
                  v_lgr_ue := NULL;
                  v_lgr_ue.lgr_akt_te := NULL;
                else
                  if not lvs_p_base.get_lgr_platz(v_lgr_platz, v_lgr_grp)  -- Der Transport geht dann hier hin
                  then
                    v_lgr_grp := NULL;
                    v_lgr_grp.lgr_akt_te := NULL;
                  end if;
                end if;
              end if;

              -- erst mal prüfen, ob der LTE_NAME in der liste der LTE_Namen_liste auftaucht
              if  v_lgr_grp.wa_typ = v_wa_type
              and ((   (v_lgr_grp.lte_namen like '%' || nvl(v_lte.basis_lte_name, ';') || ';' || '%')
                    or (v_lgr_grp.lte_namen like '%' || v_lte.lte_name || ';' || '%')
                   )
                   and (     (nvl(v_lgr_grp.lgr_akt_te, 0) + nvl(v_lgr_grp.lgr_dispo_einl_te, 0) + 1 <= v_lgr_grp.lgr_max_te)
                          -- AG 2017.10.10 BugFix
                          --     Fehler, hier werden die EINL_DISPO im LGR_PLATZ scheinbar manchmal falsch gesetzt.
                          --            das korigiert sich dann wieder selbstaendig.
                         and (nvl(v_lgr_grp.lgr_akt_te, 0) + nvl(v_transport_count, 0) + 1 <= v_lgr_grp.lgr_max_te)
                         and (nvl(v_lgr_grp.lgr_max_te, 0) > nvl(v_transport_count, 0))
                       )
                  )
               or
                  (       (v_lvs_lgr_ort_ue_platz.lte_name = v_lte.lte_name)    -- Wird am Übergabepltz von in LTE-Name umgepackt
                      and (nvl(v_lgr_grp.lte_namen, v_lvs_lgr_ort_ue_platz.lte_name_ziel || ';') like '%' || v_lvs_lgr_ort_ue_platz.lte_name_ziel || ';' || '%')
                      and (nvl(v_lgr_ue.lgr_akt_te, 0) + nvl(v_transport_ue_platz_count, 0) + 1 <= v_lgr_ue.lgr_max_te)
                      and (nvl(v_lgr_ue.lgr_max_te, 0) > nvl(v_transport_ue_platz_count, 0))
                  )
             then
                begin
                  v_result   := lvs_transport.lvs_transp_lte_353(in_sid,
                                                                 in_firma_nr,
                                                                 'BDE',
                                                                 NULL,
                                                                 'F',
                                                                 'A',
                                                                 -1,
                                                                 v_bde_fa.auf_id,
                                                                 NULL,
                                                                 c.LGR_TRANSP_STD_PRIO_MS,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 v_lte.lgr_platz,
                                                                 v_lgr_grp.lgr_platz,
                                                                 v_lte.lte_id,
                                                                 NULL,
                                                                 'F',
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 NULL,
                                                                 v_transp_grp,
                                                                 v_transp_id);
                  EXIT;  -- LTE ist erledigt
                exception
                  when others then NULL;
                end;
              end if;
            end loop;
            CLOSE c_lgr_grp;
          end loop;
          CLOSE c_res_lte;
        else
          raise_isi_error (c.FMID_Lager_Platz_fehlt, lc.ec_p1(lc.O_TP1_LAGERPLATZ_FEHLT, v_res.lager_roh));
        end if;
      else
        raise_isi_error (c.FMID_Ziel_Existiert_Nicht, lc.ec_p1(lc.O_TP1_RESOURCE_FEHLT, v_bde_fa.res_id));
      end if;
    end LOOP;
    CLOSE c_bde_fa;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      if c_bde_fa%isopen
      then
        CLOSE c_bde_fa;
      end if;
      if c_lgr_grp%isopen
      then
        CLOSE c_lgr_grp;
      end if;
      if c_res_lte%isopen
      then
        CLOSE c_res_lte;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
      if c_bde_fa%isopen
      then
        CLOSE c_bde_fa;
      end if;
      if c_lgr_grp%isopen
      then
        CLOSE c_lgr_grp;
      end if;
      if c_res_lte%isopen
      then
        CLOSE c_res_lte;
      end if;
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
  end crt_tms_push_transport_db31;                                                                      
end bde_tms_push;
/



-- sqlcl_snapshot {"hash":"cb2cc06e1d1e98146367352c25547ce5c90aa920","type":"PACKAGE_BODY","name":"BDE_TMS_PUSH","schemaName":"DIRKSPZM32","sxml":""}