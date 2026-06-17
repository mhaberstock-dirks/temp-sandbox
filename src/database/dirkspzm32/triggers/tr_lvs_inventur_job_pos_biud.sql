
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_INVENTUR_JOB_POS_BIUD" 
  before insert or update or delete on DIRKSPZM32.lvs_inventur_job_pos
  for each row
declare

  -- Zum Lesen der LVS_LAM
  v_lam                                  lvs_lam%rowtype;
  v_lam_id                               lvs_lam.lam_id%type;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- Sonstige Var
  v_artikel                              isi_artikel.artikel%type;
  v_art_bez                              varchar2(200);
  v_vorg_id                              lvs_lam_bh.vorg_id%TYPE;   -- Neu VORGang_ID aus Sequenz
  v_lam_bh_id                            lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
  v_diff_menge                           lvs_lam_bh.menge%type;
  v_disp_einl_te                         lvs_lgr.lgr_dispo_einl_te%type;
  v_disp_ausl_te                         lvs_lgr.lgr_dispo_ausl_te%type;
  v_lte                                  lvs_lte%rowtype;

  CURSOR c_lam is
    select t.*
      from lvs_lam t
     where t.lam_id = v_lam_id
     for update of t.lgr_platz,
                   t.akt_inventur_id,
                   t.letzte_inventur_id,
                   t.letzte_inventur_datum,
                   t.letzte_inventur_login_id;

  CURSOR c_lam_daten is
    select a.artikel,
           a.bezeichnung1 || ' ' || a.bezeichnung2 || ' ' || a.bezeichnung3 bez,
           l.lgr_dispo_einl_te,
           l.lgr_dispo_ausl_te
      from isi_artikel a,
           lvs_lgr l
     where a.artikel_id = v_lam.artikel_id
       and l.lgr_platz = v_lam.lgr_platz;

  v_anz_tranporte                        number;
  cursor c_transporte is
    select count(*)
      from isi_transport t
     where t.lte_id = v_lam.lte_id;
begin
  -- Init Fehlervariablen
  v_err_nr := NULL;
  v_err_text := NULL;
  v_lam := NULL; -- Init noch nichts gelesen

  if inserting -- Inventur wird aktiviert. Es duerfen nur LAM's ohne Inventur vorkommen
               -- (Zwei Inventuren auf gleichen LAM sind verboten)
  then
    select seq_inventur_pos_id.nextval into :new.inventur_pk_id from dual;
    

    v_lam_id := :new.lam_id;
    OPEN c_lam;
    FETCH c_lam into v_lam;

    if lvs_p_base.get_lte(v_lam.lam_id, v_lte)
    and v_lte.akt_inventur_id is not NULL
    then
      v_err_nr := 11;
      v_err_text := 'Fehler: LTE mit LTE-ID ' || v_lam.lte_id ||
                    ' hat die Inventur ' || to_char(v_lte.akt_inventur_id) ||
                    ' und kann nicht für eine andere Inventur eingetragen werden.';
      raise v_error;
    end if;

    if c_lam%found
    then
      update lvs_lam l
         set l.akt_inventur_id = :new.inventur_id
       where current of c_lam;
    end if;
    CLOSE c_lam;

    if v_lam.order_pos_auf_id is NOT NULL
    then
      v_err_nr := 12;
      v_err_text := 'Fehler: LHM-ID ' || v_lam.lhm_id ||
                    ' auf Lagerplatz ' || nvl(v_lam.lgr_platz, 'keiner') ||
                    ' ist reserviert.';
      raise v_error;

    end if;

    OPEN c_lam_daten;
    FETCH c_lam_daten into v_artikel, v_art_bez, v_disp_einl_te, v_disp_ausl_te;
    CLOSE c_lam_daten;
    if v_lam.akt_inventur_id is not NULL
    then
      v_err_nr := 20;
      v_err_text := 'Fehler: Artikel ' || v_artikel || ' ' || trim(v_art_bez) ||
                    ' mit LHM-ID ' || v_lam.lhm_id ||
                    ' auf Lagerplatz ' || v_lam.lgr_platz ||
                    ' ist bereits für Inventur ID ' || v_lam.akt_inventur_id ||
                    ' reserviert.';
      raise v_error;
    end if;

    if (v_disp_ausl_te > 0 or v_disp_einl_te > 0)
    then
      v_anz_tranporte := 0;
      open c_transporte;
      fetch c_transporte into v_anz_tranporte;
      close c_transporte;

      if v_anz_tranporte > 0
      then
        v_err_nr := 30;
        v_err_text := 'Fehler: Für Artikel ' || v_artikel || ' ' || trim(v_art_bez) ||
                      ' mit LHM-ID ' || v_lam.lhm_id ||
                      ' auf Lagerplatz ' || v_lam.lgr_platz ||
                      ' ist bereits ein Transport eingetragen.';
        raise v_error;
      end if;
    end if;
  elsif updating
  then
    v_lam_id := :new.lam_id;
    if  :new.pruef_datum is not NULL
    and :old.pruef_datum is NULL
    then
      OPEN c_lam;
      FETCH c_lam into v_lam;
      if c_lam%found
      then
        update lvs_lam l
           set l.akt_inventur_id = NULL,
               l.letzte_inventur_id = :new.inventur_id,
               l.letzte_inventur_datum = :new.pruef_datum,
               l.letzte_inventur_login_id = :new.pruef_login_id
         where current of c_lam;

       :new.letzte_menge_lam := v_lam.menge;
       v_diff_menge := nvl(:new.ist_menge, v_lam.menge) - v_lam.menge;

       if v_diff_menge != 0
       then
         select seq_vorg_id.nextval into v_vorg_id from dual;
         select seq_lam_bh.nextval into v_lam_bh_id from dual;
         -- -AG- 07.03.2010 BugFix / Div 0
         if v_lam.menge = 0
         then
           v_lam.menge := 1;
         end if;
          -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
         insert into lvs_lam_bh t
           values (v_lam.sid,                   -- SID               VARCHAR2(2) not null,
                    v_lam.firma_nr,              -- FIRMA_NR          NUMBER(2) not null,
                   v_vorg_id,                   -- VORG_ID           NUMBER not null,
                   c.LAM_BH_INV,                -- VORG_TYP          VARCHAR2(2) not null,
                   v_lam_bh_id,                 -- LAM_BH_ID         NUMBER not null,
                   v_lam.lam_id,                -- LAM_ID            NUMBER not null,
                   v_lam.artikel_id,            -- ARTIKEL_ID        NUMBER,
                   c.LAM_BH_BUS_IVZ,            -- BUS               NUMBER,
                   sysdate,                     -- BUCH_DATUM        DATE,
                   :new.pruef_login_id,         -- LS_LOGIN_ID       NUMBER,
                   :new.lgr_platz,              -- LGR_PLATZ         VARCHAR2(30),
                   v_lam.lte_id,                -- LTE_ID            VARCHAR2(19),
                   v_lam.lhm_id,                -- LHM_ID            VARCHAR2(19),
                   v_lam.charge_id,             -- CHARGE_ID         NUMBER,
                   v_lam.serie_id,              -- SERIE_ID          NUMBER,
                   NULL,                        -- ABNR              VARCHAR2(20),
                   v_diff_menge,                -- MENGE             NUMBER,
                   v_lam.lam_kg / v_lam.menge
                   * v_diff_menge,              -- LAM_BH_KG         NUMBER,
                   v_lam.lam_kg / v_lam.menge,  -- LAM_BH_KG_EINHEIT NUMBER,
                   NULL,                        -- RES_ID            NUMBER
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   sysdate,                     -- CREATED_DATE          creation date+time of this dataset
                   :new.pruef_login_id,         -- CREATED_LOGIN_ID      login id of the user creating this dataset
                   sysdate,                     -- LAST_CHANGE_DATE      change date+time of this dataset
                   :new.pruef_login_id,         -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
                   null,                        -- CHANGE_MENGE          Menge die geändert wurde
                   v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                   null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
        end if;
      end if;
      CLOSE c_lam;
    end if;
  else
    v_lam_id := :old.lam_id;
    update lvs_lam l
       set l.akt_inventur_id = NULL
     where l.lam_id = :old.lam_id;
  end if;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    if c_lam%isopen
    then
      CLOSE c_lam;
    end if;
    v_err_text := v_err_text  || cr_lf() || dbms_utility.format_error_backtrace;
    raise_application_error(-20000 - v_err_nr, v_err_text, true);
  when others then
    if c_lam%isopen -- 2011 -BW- close
    then
      CLOSE c_lam;
    end if;
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || dbms_utility.format_error_backtrace;
      raise_application_error(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := dbms_utility.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := lc.ec(lc.O_TXT_DB_ERROR) || cr_lf() || dbms_utility.format_error_backtrace;
        raise_application_error(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_INVENTUR_JOB_POS_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"bb0ec8ed54b91dd38be05fe903bea43b9bccf28b","type":"TRIGGER","name":"TR_LVS_INVENTUR_JOB_POS_BIUD","schemaName":"DIRKSPZM32","sxml":""}