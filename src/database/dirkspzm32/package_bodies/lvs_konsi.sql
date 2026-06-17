create or replace 
package body DIRKSPZM32.lvs_konsi is
  /*
  __________________________________________________
  Author
  wkroeker (-WK-)  21.11.2013
  __________________________________________________
  Description
  Funktionen die zur Verwaltung von Konsignationswaren
  in Konsignationlägern erforderlich sind.
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        Author   Comment
  -----------  ---------   ------   ----------------
  21.11.2013   3.5.7.1     (-WK-)   Package created
  */

  v_build_number constant number := 1;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(
    in_err_nr   in number,
    in_err_text in varchar2
  ) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
    return(v_release_str);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure get_version_ex(
    out_rel_major   out number,
    out_rel_minor   out number,
    out_revision    out number,
    out_buid_number out number,
    out_rev_date    out varchar2
  ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Function and procedure implementations
  -------------------------------------------------------------------------------------------------------


  --------------------------------------------------------------------------------
/*
  procedure c_change_goods_owner
  Hier werden KONSI-Entnahmen gebucht
    Das bedeutet: Wenn die Menge > 0 dann wird von KONSI in den verfügbaren Bestand gebucht
                  Wenn die Menge < 0 dann wird von verfügbaren Bestand in den KONSI gebucht
  Diese Funktion kann nur eine komplette LTE buchen
  Die procedure fuehrt ein Commit durch
  Autor: WK

  ---- HISTORY ---
  21.11.2013 -WK- Erstellt

  @param in_lte_id           ID der Transporteinheit, deren Eigentümer umgebucht wird
  @param in_owner_address_id NULL = Von KONSI in den verfügbaren Bestand,
                             NOT NULL (gültige Adresse) = Von den verfügbaren in den KONSI Bestand
  @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
  @param in_res_id           Resource ID mit der die Buchung ausgeführt wird
*/
  --------------------------------------------------------------------------------
  procedure c_change_goods_owner (
    in_lte_id           in lvs_lte.lte_id%type,
    in_owner_address_id in lvs_lam.owner_address_id%type,
    in_login_id         in isi_user.login_id%type,
    in_res_id           in isi_resource.res_id%type
  ) is
  begin
    change_goods_owner (in_lte_id,
                        in_owner_address_id,
                        in_login_id,
                        in_res_id);
    commit;
  exception
    when others then
      rollback;
      raise;
  end;

  --------------------------------------------------------------------------------
/*
  procedure change_goods_owner
  Hier werden KONSI-Entnahmen gebucht
    Das bedeutet: Wenn die Menge > 0 dann wird von KONSI in den verfügbaren Bestand gebucht
                  Wenn die Menge < 0 dann wird von verfügbaren Bestand in den KONSI gebucht
  Diese Funktion kann nur eine komplette LTE buchen
  Ohne Commit

  Autor: AG

  ---- HISTORY ---
  21.11.2013 -WK- Erstellt

  @param in_lte_id           ID der Transporteinheit, deren Eigentümer umgebucht wird
  @param in_owner_address_id NULL = Von KONSI in den verfügbaren Bestand,
                             NOT NULL (gültige Adresse) = Von den verfügbaren in den KONSI Bestand
  @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
  @param in_res_id           Resource ID mit der die Buchung ausgeführt wird
*/
  --------------------------------------------------------------------------------
  procedure change_goods_owner (
    in_lte_id           in lvs_lte.lte_id%type,
    in_owner_address_id in lvs_lam.owner_address_id%type,
    in_login_id         in isi_user.login_id%type,
    in_res_id           in isi_resource.res_id%type
  ) is
    ----------------------------------------------------------------------------
    -- Lokale Variablen
    ----------------------------------------------------------------------------
    v_owner_adr_nr      isi_adressen.adr_nr%type;
    v_found             boolean;

    v_lgr               lvs_lgr%rowtype;
    v_lte               lvs_lte%rowtype;
    v_lam               lvs_lam%rowtype;

    v_lam_bh_id         lvs_lam_bh.lam_bh_id%type;         -- Schlüssel der Buchung
    v_lam_bh_menge      lvs_lam_bh.menge%type;             -- Gebuchte Menge einer LAM
    v_lam_bh_kg         lvs_lam_bh.lam_bh_kg%type;         -- Gewicht der Ware
    v_lam_bh_kg_einheit lvs_lam_bh.lam_bh_kg_einheit%type; -- Gewicht der Ware pro kleinste Einheit (innerhalb der LAM)

    v_res_string        lvs_lte.res_string%type;
    v_res_mhd           date; -- out parameter von get_res...
    v_lam_id            lvs_lam.lam_id%type;
    v_buch_vorg_id      lvs_lam_bh.vorg_id%type;
    v_order_pos         isi_order_pos%rowtype;

    -- Lesen des Lagerbestands für LAM
    CURSOR c_lam is
      select lam.*
        from lvs_lam lam
       where lam.lte_id = in_lte_id;
  begin
    if not lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      raise_isi_error(10, lc.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
    end if;

    if v_lte.lgr_platz is null
    then
      raise_isi_error(15, lc.ec_p1(LC.O_TP1_LTE_OHNE_LGR_PLATZ, in_lte_id));
    end if;

    if v_lte.lte_status != 'LF'
    then
      raise_isi_error(40, lc.ec_p1(lc.O_TP1_LTE_ID_W_TRANSPORTIERT, in_lte_id));
    end if;

    if in_owner_address_id is not null
       and not isi_p_base.get_adress_nr_by_id('01', in_owner_address_id, v_owner_adr_nr)
    then
      raise_isi_error(20, lc.ec_p1(lc.O_TP1_TXT_ADRESSE_NF, in_owner_address_id));
    end if;

    v_buch_vorg_id := null;
    open c_lam;
    loop
      fetch c_lam into v_lam;
      exit when c_lam%notfound;

      -- Merken letzte LAM für RES_STRING abholen
      v_lam_id := v_lam.lam_id;
      v_lam_bh_menge := nvl(v_lam.menge, 0);
      v_lam_bh_kg := 0;
      v_lam_bh_kg_einheit := 0;

      if v_buch_vorg_id is null
      then
        -- Einen gemeinsamen Buchungsvorgang für alle LAMs einer LTE erzeugen
        select seq_vorg_id.nextval into v_buch_vorg_id from dual;
      end if;

      reset_isi_error();

      begin
        if v_lam_bh_menge <> 0
        then
          -- Wenn die Menge > 0 dann wird von KONSI in den verfügbaren Bestand gebucht
          -- Wenn die Menge < 0 dann wird von verfügbaren Bestand in den KONSI gebucht

          v_lam_bh_kg := nvl(v_lam.lam_kg, 0);
          if in_owner_address_id is not null
          then
            -- Rückgabe = negativer Wert für Menge (nagative Entnahme)
            v_lam_bh_kg := v_lam_bh_kg * -1;
            v_lam_bh_menge := v_lam_bh_menge * -1;
          end if;
          v_lam_bh_kg_einheit := nvl(v_lam.lam_kg, 0) / v_lam.menge;
        end if;
      exception
        when others then -- <<<--- von HJG gebaut ...
          v_lam_bh_kg := 0;
          v_lam_bh_kg_einheit := 0;
      end;

      -- Eigentümerwechsel buchen
      insert into lvs_lam_bh (
        vorg_id,
        vorg_typ,
        lam_bh_id,
        lam_id,
        artikel_id,
        bus,
        buch_datum,
        ls_login_id,
        lgr_platz,
        lte_id,
        lhm_id,
        charge_id,
        serie_id,
        menge,
        lam_bh_kg,
        lam_bh_kg_einheit,
        res_id,
        vorgang_id, -- referenz auf Bestellung beim Lieferanten
        created_date,
        created_login_id,
        last_change_date,
        last_change_login_id,
        owner_address_id,
        owner_address_id_new
      ) values (
        v_buch_vorg_id,         -- VORG_ID           NUMBER not null,
        c.LAM_BH_WKE,           -- VORG_TYP          VARCHAR2(2) not null,
        seq_lam_bh.nextval,     -- LAM_BH_ID         NUMBER not null,
        v_lam_id,               -- LAM_ID            NUMBER not null,
        v_lam.artikel_id,       -- ARTIKEL_ID        NUMBER,
        c.LAM_BH_BUS_WKE_KONSI, -- BUS               NUMBER,
        sysdate,                -- BUCH_DATUM        DATE,
        in_login_id,            -- LS_LOGIN_ID       NUMBER,
        v_lte.lgr_platz,        -- LGR_PLATZ         VARCHAR2(30),
        in_lte_id,              -- LTE_ID            VARCHAR2(19),
        v_lam.lhm_id,           -- LHM_ID            VARCHAR2(19),
        v_lam.charge_id,        -- CHARGE_ID         NUMBER,
        v_lam.serie_id,         -- SERIE_ID          NUMBER,
        v_lam_bh_menge,         -- MENGE             NUMBER,
        v_lam_bh_kg,            -- LAM_BH_KG         NUMBER,
        v_lam_bh_kg_einheit,    -- LAM_BH_KG_EINHEIT NUMBER,
        in_res_id,              -- RES_ID            NUMBER,
        v_lam.best_nr,          -- VORGANG_ID        NUMBER, (ISI Order)
        sysdate,                -- CREATED_DATE      DATE,   creation date+time of this dataset
        in_login_id,            -- CREATED_LOGIN_ID  NUMBER  login id of the user creating this dataset
        sysdate,                -- LAST_CHANGE_DATE  DATE    change date+time of this dataset
        in_login_id,            -- LAST_CHANGE_LOGIN_ID  NUMBER  login id of the user changing this dataset
        v_lam.owner_address_id, -- OWNER_ADDRESS_ID      Aktueller Eigentümer
        in_owner_address_id     -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
      ) returning lam_bh_id into v_lam_bh_id;

      -- Eigentümer ändern
      update lvs_lam t
         set t.owner_address_id = in_owner_address_id
       where t.lam_id = v_lam_id;

      -- Erforderliche Daten für die Schnittstelle holen
      v_found := isi_p_order_base.get_order_pos_by_id_pos_type(
                   v_lam.best_nr, 'KWE', v_lam.best_pos, v_order_pos);

      v_found := lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr);

      -- Schnittstelle schreiben
      s_schnittstelle.write_host_bew(v_order_pos, v_lam, v_lam_bh_id,
        c.LAM_BH_BUS_WKE_KONSI, c.LAM_BH_WKE, 'S_AUF', 'UE', NULL, v_lgr,
        in_login_id, v_lam_bh_menge);
    end loop;
    close c_lam;

    if lvs_p_base.get_lam('01', 1, v_lam_id, v_lam)
    then
      -- Der Reservierungsstring muss für die neue
      -- Eigentümersituation ermittelt und gesetzt werden
      v_res_string := lvs_util.get_res_string_v359(v_lam.sid, v_lam.firma_nr,
                                                   v_lte.waren_typ, v_lte.res_artikel_id,
                                                   v_lam.hersteller_kuerzel_liste,
                                                   v_lam.fa_ag, v_lam.charge_id, v_lam.serie_id, v_lam.leitzahl,
                                                   v_lam.kunden_nr, v_lam.lieferant_nr, v_lam.best_nr,
                                                   v_lam.lam_mhd, 1, v_lam.labor_status, v_lte.lte_voll,
                                                   v_lam.owner_address_id, v_res_mhd);
      update lvs_lte lte
         set lte.res_string = v_res_string
       where lte.lte_id   = in_lte_id;
    end if;
  exception
    -- Im Fehlerfall is v_err_nr bereits gesetzt
    when v_error then  -- Update 2011 show Exception Source Line
      -- clean up cursors
      if c_lam%isopen
      then
        close c_lam;
      end if;
      -- raise error
      v_err_text := v_err_text  || cr_lf() || dbms_utility.format_error_backtrace;
      raise_application_error(-20000 - v_err_nr, v_err_text, true);
    when others then
      -- clean up cursors
      if c_lam%isopen
      then
        close c_lam;
      end if;
      -- raise error
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

  /* procedure c_reverse_changed_goods_owner
     Stornierung der Umbuchung des Eigentümers der Ware auf einer LTE.
     Abschließend Transaktion mit 'commit' abschliessen.

     ---- HISTORY ---
     26.11.2013 -WK- Erstellt

     @param in_lte_id           ID der Transporteinheit, deren Eigentümer-Umbuchung storniert werden soll
     @param in_lam_bh_id        ID des Buchungssatzes der Eigentümer-Umbuchung
     @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
   */
  procedure c_reverse_changed_goods_owner (
    in_lte_id           in lvs_lte.lte_id%type,
    in_lam_bh_id        in lvs_lam_bh.lam_bh_id%type,
    in_login_id         in isi_user.login_id%type
  ) is
  begin
    reverse_changed_goods_owner (in_lte_id, in_lam_bh_id, in_login_id);
    commit;
  exception
    when others then
      rollback;
      raise;
  end;

  /* procedure reverse_changed_goods_owner
     Stornierung der Umbuchung des Eigentümers der Ware auf einer LTE.

     ---- HISTORY ---
     26.11.2013 -WK- Erstellt

     @param in_lte_id           ID der Transporteinheit, deren Eigentümer-Umbuchung storniert werden soll
     @param in_lam_bh_id        ID des Buchungssatzes der Eigentümer-Umbuchung
     @param in_login_id         Benutzer ID des Benutzers der die Buchung ausführt
   */
  procedure reverse_changed_goods_owner (
    in_lte_id           in lvs_lte.lte_id%type,
    in_lam_bh_id        in lvs_lam_bh.lam_bh_id%type,
    in_login_id         in isi_user.login_id%type
  ) is
    ----------------------------------------------------------------------------
    -- Lokale Variablen
    ----------------------------------------------------------------------------
    v_lgr lvs_lgr%rowtype;
    v_lte lvs_lte%rowtype;
    v_lam lvs_lam%rowtype;
    v_lam_bh lvs_lam_bh%rowtype;

    v_lam_ref lvs_lam%rowtype;
    v_lam_bh_ref lvs_lam_bh%rowtype;

    v_order_pos isi_order_pos%rowtype;

    v_res_string lvs_lte.res_string%type;
    v_res_mhd date; -- out parameter von get_res...

    v_count_lam_bh number;
    v_count_lam number;

    v_found boolean;

    cursor c_lam_bh_vorg_count is
      select count(bh.lam_bh_id) count_lam_bh,
             nvl(count(lam.lam_id), 0) count_lam
        from lvs_lam_bh bh
             left outer join lvs_lam lam on (lam.lam_id = bh.lam_id
                                         and lam.lte_id = in_lte_id)
       where bh.vorg_id = v_lam_bh_ref.vorg_id
         and bh.lte_id = in_lte_id
         and bh.vorg_typ = 'KE'
         and bh.bus = c.LAM_BH_BUS_WKE_KONSI;

    cursor c_lam_bh is
      select *
        from lvs_lam_bh t
       where t.vorg_id = v_lam_bh_ref.vorg_id
         and t.lte_id = in_lte_id
         and t.vorg_typ = 'KE'
         and t.bus = c.LAM_BH_BUS_WKE_KONSI;
  begin
    -- Plausibilitäten prüfen
    if not lvs_p_base.get_lam_bh_by_id(in_lam_bh_id, v_lam_bh_ref)
    then
      raise_isi_error(10, 'Ungültige LAM Buchungshistorie ID: ' || in_lam_bh_id); --lc.ec_p1(lc.O_TP1_LTE_ID_FEHLT, in_lam_bh_id));
    end if;

    if not lvs_p_base.get_lte(in_lte_id, v_lte)
    then
      raise_isi_error(20, lc.ec_p1(lc.O_TP1_LTE_ID_FEHLT, in_lte_id));
    end if;

    if v_lte.lgr_platz is null
    then
      raise_isi_error(30, lc.ec_p1(lc.O_TP1_LTE_OHNE_LGR_PLATZ, in_lte_id));
    end if;

    if v_lte.lte_status != 'LF'
    then
      raise_isi_error(40, lc.ec_p1(lc.O_TP1_LTE_ID_W_TRANSPORTIERT, in_lte_id));
    end if;

    open c_lam_bh_vorg_count;
    fetch c_lam_bh_vorg_count into v_count_lam_bh, v_count_lam;
    v_found := c_lam_bh_vorg_count%found;
    close c_lam_bh_vorg_count;

    if not v_found
    then
      raise_isi_error(50, lc.ec_p1(lc.O_TP1_LTE_ID_UPDATE_ERR, in_lte_id));
    end if;

    if v_count_lam_bh != v_count_lam
    then
      raise_isi_error(50, 'Die Umbuchung der Konsignationsware (Entnahme) kann nicht storniert werden, da die LTE bereits angebrochen ist.');
    end if;

    open c_lam_bh;
    loop
      fetch c_lam_bh into v_lam_bh;
      exit when c_lam_bh%notfound;

      if (lvs_p_base.get_lam('01', 1, v_lam_bh.lam_id, v_lam))
      then
        -- Stornierung durchführen
        update lvs_lam_bh bh
           set bh.ls_login_id = in_login_id,
               bh.change_menge = bh.menge,
               bh.menge = 0,
               bh.last_change_date = sysdate,
               bh.last_change_login_id = in_login_id
         where bh.lam_bh_id = v_lam_bh.lam_bh_id;

        -- Eigentümer zurücksetzen
        update lvs_lam lam
           set lam.owner_address_id = v_lam_bh_ref.owner_address_id -- vorherigen Eigentümer eintragen
         where lam.lam_id = v_lam_bh.lam_id;

        -- Erforderliche Daten für die Schnittstelle holen
        v_found := isi_p_order_base.get_order_pos_by_id_pos_type(
                     v_lam.best_nr, 'KWE', v_lam.best_pos, v_order_pos);

        v_found := lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr);

        -- Schnittstelle schreiben
        s_schnittstelle.write_host_bew(v_order_pos, v_lam, v_lam_bh.lam_bh_id,
          c.LAM_BH_BUS_WKE_KONSI, c.LAM_BH_WKE, 'S_AUF', 'UE', NULL, v_lgr,
          in_login_id, (v_lam_bh.menge * -1));
      else
        raise_isi_error(60, lc.ec_p1(lc.O_TP1_LAM_ID_FEHLT, v_lam_bh.lam_id));
      end if;
    end loop;
    close c_lam_bh;

    if lvs_p_base.get_lam('01', 1, v_lam_bh_ref.lam_id, v_lam_ref)
    then
      -- Der Reservierungsstring muss für die neue
      -- Eigentümersituation ermittelt und gesetzt werden
      v_res_string := lvs_util.get_res_string_v359(v_lam_ref.sid, v_lam_ref.firma_nr,
                                                   v_lte.waren_typ, v_lte.res_artikel_id,
                                                   v_lam.hersteller_kuerzel_liste,
                                                   v_lam_ref.fa_ag, v_lam_ref.charge_id, v_lam_ref.serie_id, v_lam_ref.leitzahl,
                                                   v_lam_ref.kunden_nr, v_lam_ref.lieferant_nr, v_lam_ref.best_nr,
                                                   v_lam_ref.lam_mhd, 1, v_lam_ref.labor_status, v_lte.lte_voll,
                                                   v_lam_ref.owner_address_id, v_res_mhd);
      update lvs_lte lte
         set lte.res_string = v_res_string
       where lte.lte_id   = in_lte_id;
    end if;
  exception
    -- Im Fehlerfall is v_err_nr bereits gesetzt
    when v_error then  -- Update 2011 show Exception Source Line
      -- clean up cursors
      if c_lam_bh%isopen
      then
        close c_lam_bh;
      end if;
      -- raise error
      v_err_text := v_err_text  || cr_lf() || dbms_utility.format_error_backtrace;
      raise_application_error(-20000 - v_err_nr, v_err_text, true);
    when others then
      -- clean up cursors
      if c_lam_bh%isopen
      then
        close c_lam_bh;
      end if;
      -- raise error
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
end;
/



-- sqlcl_snapshot {"hash":"1fed1ee87d7420e1dbefbb91a9be3e13f2c38da8","type":"PACKAGE_BODY","name":"LVS_KONSI","schemaName":"DIRKSPZM32","sxml":""}