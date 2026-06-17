create or replace 
package body DIRKSPZM32.c is

  function get_isi_product_release return varchar2 is
  begin
    return(v_isi_product_release);
  end;

function DECODE_FUNCTION_FEHLER (
  return_value in integer) return varchar2 is
begin
  if return_value = TRANSPORT_FEHLT     then return (c.TRANSPORT_TXT_FEHLT);     end if;
  if return_value = LTE_FEHLT           then return (c.LTE_TXT_FEHLT);           end if;
  if return_value = LGR_FEHLT           then return (c.LGR_TXT_FEHLT);           end if;
  if return_value = LGR_LTE_FEHLT       then return (c.LGR_LTE_TXT_FEHLT);       end if;
  if return_value = LGR_Q_FEHLT         then return (c.LGR_Q_TXT_FEHLT);         end if;
  if return_value = LGR_Z_FEHLT         then return (c.LGR_Z_TXT_FEHLT);         end if;
  if return_value = LGR_TRANSP_BEGONNEN then return (c.LGR_TRANSP_TXT_BEGONNEN); end if;
  if return_value = LGR_RES_FEHLT       then return (c.LGR_RES_TXT_FEHLT);       end if;
  if return_value = LGR_REIHENFOLGE_FALSCH
                                        then return (c.LGR_REIHENF_TXT_FALSCH);  end if;
  if return_value = LGR_VOLL            then return (c.LGR_TXT_VOLL);            end if;
  if return_value = LGR_DISPO_VOLL      then return (c.LGR_DISPO_TXT_VOLL);      end if;
  if return_value = LGR_RES_STRING      then return (c.LGR_RES_TXT_STRING);      end if;
  if return_value = LGR_ZIEL_TYP_FALSCH then return (c.LGR_ZIEL_TYP_TXT_FALSCH); end if;

  return('?');
end DECODE_FUNCTION_FEHLER;

function DECODE_LTE_VOLL (
  return_value in varchar2) return varchar2 is
begin
  if return_value = LTE_VOLL_V then return (c.LTE_VOLL_TXT_V); end if;
  if return_value = LTE_VOLL_A then return (c.LTE_VOLL_TXT_A); end if;
  if return_value is NULL then return (c.LTE_VOLL_TXT_V); end if;

  return('?');
end DECODE_LTE_VOLL;

function R_LORT_LAENGE return number is begin return(LORT_LAENGE); end R_LORT_LAENGE;

function R_LGR_PLATZ_RES_STRING return number is begin return(LGR_PLATZ_RES_STRING); end R_LGR_PLATZ_RES_STRING;
function R_LGR_PLATZ_LEER return number is begin return(LGR_PLATZ_LEER); end R_LGR_PLATZ_LEER;
function R_LGR_PLATZ_MISCH_KANAL return number is begin return(LGR_PLATZ_MISCH_KANAL); end R_LGR_PLATZ_MISCH_KANAL;
function R_LGR_PLATZ_MISCH_PAL return number is begin return(LGR_PLATZ_MISCH_PAL); end R_LGR_PLATZ_MISCH_PAL;
function R_LGR_PLATZ_FALSCH return number is begin return(LGR_PLATZ_FALSCH); end R_LGR_PLATZ_FALSCH;

function R_SAT1 return varchar2 is begin return(SAT1); end R_SAT1;
function R_SAT_EPL1 return varchar2 is begin return(SAT_EPL1); end R_SAT_EPL1;
function R_EPL1 return varchar2 is begin return(EPL1); end R_EPL1;
function R_SAT_EPL2 return varchar2 is begin return(SAT_EPL2); end R_SAT_EPL2;
function R_KANAL1 return varchar2 is begin return(KANAL1); end R_KANAL1;
function R_KANAL_BKL1 return varchar2 is begin return(KANAL_BKL1); end R_KANAL_BKL1;
function R_BKL1 return varchar2 is begin return(BKL1); end R_BKL1;
function R_REG_FACH1 return varchar2 is begin return(REG_FACH1); end R_REG_FACH1;
function R_SEG1 return varchar2 is begin return(SEG1); end R_SEG1;
function R_SEG_DUEDO1 return varchar2 is begin return(SEG_DUEDO1); end R_SEG_DUEDO1;
function R_PP_EPL1 return varchar2 is begin return(PP_EPL1); end R_PP_EPL1;
function R_DURCHL1 return varchar2 is begin return(DURCHL1); end R_DURCHL1;
function R_STAP_FLAE1 return varchar2 is begin return(STAP_FLAE1); end R_STAP_FLAE1;
function R_STAP_FLAE2 return varchar2 is begin return(STAP_FLAE2); end R_STAP_FLAE2;


function R_C_FALSE return varchar2 is begin return(C_FALSE); end R_C_FALSE;
function R_C_TRUE return varchar2 is begin return(C_TRUE); end R_C_TRUE;
function DECODE_TRUE_FALSE (
  return_value in varchar2) return varchar2 is
begin
  if return_value = C_FALSE then return (c.C_TXT_FALSE); end if;
  if return_value = C_TRUE then return (c.C_TXT_TRUE); end if;
end DECODE_TRUE_FALSE;

function R_LTE_VOLL_V return varchar2 is begin return(LTE_VOLL_V); end R_LTE_VOLL_V;
function R_LTE_VOLL_A return varchar2 is begin return(LTE_VOLL_A); end R_LTE_VOLL_A;
function R_C_ANBRUCH_AUSNAHME return varchar2 is begin return(C_ANBRUCH_AUSNAHME); end R_C_ANBRUCH_AUSNAHME;
function R_C_ANBRUCH_VORZUG return varchar2 is begin return(C_ANBRUCH_VORZUG); end R_C_ANBRUCH_VORZUG;
function R_C_ANBRUCH_IGNORE return varchar2 is begin return(C_ANBRUCH_IGNORE); end R_C_ANBRUCH_IGNORE;
function R_C_VOLLE_BEHAELTER return varchar2 is begin return(C_VOLLE_BEHAELTER); end R_C_VOLLE_BEHAELTER;

function R_LGR_GESPERRT_F return varchar2 is begin return(LGR_GESPERRT_F); end R_LGR_GESPERRT_F;
function R_LGR_ABSTAND_FAKTOR return integer is begin return(LGR_ABSTAND_FAKTOR); end R_LGR_ABSTAND_FAKTOR;
function R_LGR_PLATZ_R_FAKTOR return integer is begin return(LGR_PLATZ_R_FAKTOR); end R_LGR_PLATZ_R_FAKTOR;

function R_MHD_MS_MIN_TAGE return integer is begin return(MHD_MS_MIN_TAGE); end R_MHD_MS_MIN_TAGE;
function R_MHD_RW_MIN_TAGE return integer is begin return(MHD_RW_MIN_TAGE); end R_MHD_RW_MIN_TAGE;
function R_MHD_HW_MIN_TAGE return integer is begin return(MHD_HW_MIN_TAGE); end R_MHD_HW_MIN_TAGE;
function R_MHD_FW_MIN_TAGE return integer is begin return(MHD_FW_MIN_TAGE); end R_MHD_FW_MIN_TAGE;

function R_LAM_BH_BUS_INV return integer is begin return(LAM_BH_BUS_INV); end R_LAM_BH_BUS_INV;
function R_LAM_BH_BUS_ZUG return integer is begin return(LAM_BH_BUS_ZUG); end R_LAM_BH_BUS_ZUG;
function R_LAM_BH_BUS_ABG return integer is begin return(LAM_BH_BUS_ABG); end R_LAM_BH_BUS_ABG;
function R_LAM_BH_BUS_UML return integer is begin return(LAM_BH_BUS_UML); end R_LAM_BH_BUS_UML;
function R_LAM_BH_BUS_SP  return integer is begin return(LAM_BH_BUS_SP);  end R_LAM_BH_BUS_SP;
function R_LAM_BH_BUS_UP  return integer is begin return(LAM_BH_BUS_UP);  end R_LAM_BH_BUS_UP;
function R_LAM_BH_BUS_Q   return integer is begin return(LAM_BH_BUS_Q);   end R_LAM_BH_BUS_Q;
function R_LAM_BH_BUS_ZUG_KOMM return integer is begin return(LAM_BH_BUS_ZUG_KOMM); end R_LAM_BH_BUS_ZUG_KOMM;
function R_LAM_BH_BUS_ABG_KOMM return integer is begin return(LAM_BH_BUS_ABG_KOMM); end R_LAM_BH_BUS_ABG_KOMM;
function R_LAM_BH_BUS_GEZAE_INV return integer is begin return(LAM_BH_BUS_IVZ); end R_LAM_BH_BUS_GEZAE_INV;
function R_LAM_BH_BUS_ZUG_KONSI return integer is begin return(LAM_BH_BUS_ZUG_KONSI); end R_LAM_BH_BUS_ZUG_KONSI;
function R_LAM_BH_BUS_ABG_KONSI return integer is begin return(LAM_BH_BUS_ABG_KONSI); end R_LAM_BH_BUS_ABG_KONSI;
function R_LAM_BH_BUS_UML_KONSI return integer is begin return(LAM_BH_BUS_WKE_KONSI); end R_LAM_BH_BUS_UML_KONSI;

function R_Lgr_Typ_We return varchar2 is begin return(Lgr_Typ_We); end R_Lgr_Typ_We;
function R_Lgr_Typ_Wa return varchar2 is begin return(Lgr_Typ_Wa); end R_Lgr_Typ_Wa;
function R_Lgr_Typ_Lager return varchar2 is begin return(Lgr_Typ_Lager); end R_Lgr_Typ_Lager;
function R_Lgr_Typ_Puffer return varchar2 is begin return(Lgr_Typ_Puffer); end R_Lgr_Typ_Puffer;
function R_Lgr_Typ_Wep return varchar2 is begin return(Lgr_Typ_Wep); end R_Lgr_Typ_Wep;
function R_Lgr_Typ_LagerP return varchar2 is begin return(Lgr_Typ_LagerP); end R_Lgr_Typ_LagerP;

function R_LTE_FF_STAT return varchar2 is begin return(LTE_FF_STAT); end R_LTE_FF_STAT;
function R_LTE_PF_STAT return varchar2 is begin return(LTE_PF_STAT); end R_LTE_PF_STAT;
function R_LTE_KF_STAT return varchar2 is begin return(LTE_KF_STAT); end R_LTE_KF_STAT;
function R_LTE_BS_STAT return varchar2 is begin return(LTE_BS_STAT); end R_LTE_BS_STAT;
function R_LTE_BF_STAT return varchar2 is begin return(LTE_BF_STAT); end R_LTE_BF_STAT;
function R_LTE_ED_STAT return varchar2 is begin return(LTE_ED_STAT); end R_LTE_ED_STAT;
function R_LTE_ET_STAT return varchar2 is begin return(LTE_ET_STAT); end R_LTE_ET_STAT;
function R_LTE_LF_STAT return varchar2 is begin return(LTE_LF_STAT); end R_LTE_LF_STAT;
function R_LTE_AD_STAT return varchar2 is begin return(LTE_AD_STAT); end R_LTE_AD_STAT;
function R_LTE_AF_STAT return varchar2 is begin return(LTE_AF_STAT); end R_LTE_AF_STAT;
function R_LTE_AG_STAT return varchar2 is begin return(LTE_AG_STAT); end R_LTE_AG_STAT;
function R_LTE_UD_STAT return varchar2 is begin return(LTE_UD_STAT); end R_LTE_UD_STAT;
function R_LTE_UT_STAT return varchar2 is begin return(LTE_UT_STAT); end R_LTE_UT_STAT;

function R_LAB_STAT_Q  return varchar2 is begin return (LAB_STAT_Q); end R_LAB_STAT_Q;
function R_LAB_STAT_U  return varchar2 is begin return (LAB_STAT_U); end R_LAB_STAT_U;
function R_LAB_STAT_B  return varchar2 is begin return (LAB_STAT_B); end R_LAB_STAT_B;
function R_LAB_STAT_G  return varchar2 is begin return (LAB_STAT_G); end R_LAB_STAT_G;
function R_LAB_STAT_F  return varchar2 is begin return (LAB_STAT_F); end R_LAB_STAT_F;

function R_LGR_TRANSP_STD_PRIO_MS return varchar2 is begin return(LGR_TRANSP_STD_PRIO_MS); end R_LGR_TRANSP_STD_PRIO_MS;
function R_LGR_TRANSP_STD_PRIO_WA return varchar2 is begin return(LGR_TRANSP_STD_PRIO_WA); end R_LGR_TRANSP_STD_PRIO_WA;
function R_LGR_TRANSP_STD_PRIO_WE return varchar2 is begin return(LGR_TRANSP_STD_PRIO_WE); end R_LGR_TRANSP_STD_PRIO_WE;
function R_LGR_TRANSP_STD_PRIO_UL return varchar2 is begin return(LGR_TRANSP_STD_PRIO_UL); end R_LGR_TRANSP_STD_PRIO_UL;
function R_LGR_TRANSP_STD_PRIO_FF return varchar2 is begin return(LGR_TRANSP_STD_PRIO_FF); end R_LGR_TRANSP_STD_PRIO_FF;

function R_MAX_ANZ_LIEFS_TAGE return number is begin return(MAX_ANZ_LIEFS_TAGE); end R_MAX_ANZ_LIEFS_TAGE;

function R_FMID_Quelle_Existiert_Nicht return integer is begin return(FMID_Quelle_Existiert_Nicht);  end R_FMID_Quelle_Existiert_Nicht;
function R_FMID_Ziel_Existiert_Nicht   return integer is begin return(FMID_Ziel_Existiert_Nicht  );  end R_FMID_Ziel_Existiert_Nicht;
function R_FMID_LTE_ID_Null            return integer is begin return(FMID_LTE_ID_Null            ); end R_FMID_LTE_ID_Null;
function R_FMID_LTE_ID_SCHON_VORHANDEN return integer is begin return(FMID_LTE_ID_SCHON_VORHANDEN);  end R_FMID_LTE_ID_SCHON_VORHANDEN;
function R_FMID_QuellKanal_Leer        return integer is begin return(FMID_QuellKanal_Leer       );  end R_FMID_QuellKanal_Leer;
function R_FMID_Quelle_Nicht_BELEGT    return integer is begin return(FMID_Quelle_Nicht_BELEGT   );  end R_FMID_Quelle_Nicht_BELEGT;
function R_FMID_Ziel_Voll              return integer is begin return(FMID_Ziel_Voll             );  end R_FMID_Ziel_Voll;
function R_FMID_Artikelnummer_Fehlt   return integer is begin return(FMID_Artikelnummer_Fehlt );   end R_FMID_Artikelnummer_Fehlt;
function R_FMID_PaletteTyp_Fehlt       return integer is begin return(FMID_PaletteTyp_Fehlt     );   end R_FMID_PaletteTyp_Fehlt;
function R_FMID_Lagerplatz_Gesperrt    return integer is begin return(FMID_Lagerplatz_Gesperrt  );   end R_FMID_Lagerplatz_Gesperrt;
function R_FMID_Platz_kein_WE          return integer is begin return(FMID_Platz_kein_WE        );   end R_FMID_Platz_kein_WE;
function R_FMID_LTE_ID_Fehlt           return integer is begin return(FMID_LTE_ID_Fehlt         );   end R_FMID_LTE_ID_Fehlt;
function R_FMID_Lager_Platz_fehlt      return integer is begin return(FMID_Lager_Platz_fehlt    );   end R_FMID_Lager_Platz_fehlt;
function R_FMID_Falscher_LTE_Status    return integer is begin return(FMID_Falscher_LTE_Status  );   end R_FMID_Falscher_LTE_Status;
function R_FMID_Platz_Nicht_IO         return integer is begin return(FMID_Platz_Nicht_IO       );   end R_FMID_Platz_Nicht_IO;
function R_FMID_LTE_hat_Transport      return integer is begin return(FMID_LTE_hat_Transport    );   end R_FMID_LTE_hat_Transport;
function R_FMID_Lte_falscher_Platz     return integer is begin return(FMID_Lte_falscher_Platz   );   end R_FMID_Lte_falscher_Platz;
function R_FMID_Weg_von_nach_falsch   return integer is begin return(FMID_Weg_von_nach_falsch );   end R_FMID_Weg_von_nach_falsch;
function R_FMID_Falscher_LTE_Type      return integer is begin return(FMID_Falscher_LTE_Type    );   end R_FMID_Falscher_LTE_Type;
function R_FMID_Falsche_Temperatur     return integer is begin return(FMID_Falsche_Temperatur   );   end R_FMID_Falsche_Temperatur;
function R_FMID_Falsche_Wertklasse     return integer is begin return(FMID_Falsche_Wertklasse   );   end R_FMID_Falsche_Wertklasse;
function R_FMID_Falsche_Gefahrenklasse  return integer is begin return(FMID_Falsche_Gefahrenklasse);   end R_FMID_Falsche_GefahrenKlasse;
function R_FMID_LTE_ist_zu_schwer      return integer is begin return(FMID_LTE_ist_zu_schwer    );   end R_FMID_LTE_ist_zu_schwer;
function R_FMID_LTE_zu_gross           return integer is begin return(FMID_LTE_zu_gross         );   end R_FMID_LTE_zu_gross;
function R_FMID_LGR_Type_unbekannt     return integer is begin return(FMID_LGR_Type_unbekannt   );   end R_FMID_LGR_Type_unbekannt;
function R_FMID_Keine_Lagerorte        return integer is begin return(FMID_Keine_Lagerorte      );   end R_FMID_Keine_Lagerorte;
function R_FMID_Kein_Platz_fuer_LTE    return integer is begin return(FMID_Kein_Platz_fuer_LTE  );   end R_FMID_Kein_Platz_fuer_LTE;
function R_FMID_Falscher_BearbModul    return integer is begin return(FMID_Falscher_BearbModul  );   end R_FMID_Falscher_BearbModul;
function R_FMID_Falsche_Buchungsart    return integer is begin return(FMID_Falsche_Buchungsart  );   end R_FMID_Falsche_Buchungsart;
function R_FMID_Zuggang_Buchen         return integer is begin return(FMID_Zuggang_Buchen       );   end R_FMID_Zuggang_Buchen;
function R_FMID_Alle_Fahrz_Ausgelastet return integer is begin return(FMID_Alle_Fahrz_Ausgelastet);  end R_FMID_Alle_Fahrz_Ausgelastet;
function R_FMID_Kein_Fahrz_bereit_orte return integer is begin return(FMID_Kein_Fahrz_bereit_orte);  end R_FMID_Kein_Fahrz_bereit_orte;


function sql_count (in_nr      in integer,
                    in_gleich  in varchar2,
                    in_ts      in timestamp)
                    return integer is
begin
  if v_ts is NULL
  or v_ts != in_ts
  then
     v_ts := in_ts;
     v_nr := in_nr;
     v_gleich := nvl(in_gleich, c.leer);
  else
    if   v_ts = in_ts
    and  v_gleich != nvl(in_gleich, c.leer)
    then
     v_gleich := nvl(in_gleich, c.leer);
      v_nr := v_nr + 1;
    end if;
  end if;

  return (v_nr);
end sql_count;

  function DECODE_LGR_SPERRE(Gesperrt in LVS_LGR.Gesperrt%TYPE)
    return varchar2 is
  BEGIN
    if Gesperrt = C.LGR_GESPERRT_F then
      return(c.LGR_GESPERRT_TXT_F);
    end if;
    if Gesperrt = c.LGR_GESPERRT_G then
      return(c.LGR_GESPERRT_TXT_G);
    end if;
    return(Gesperrt);
  END;
  function DECODE_LGR_SPERRE_FARBE(Gesperrt in LVS_LGR.Gesperrt%TYPE)
    return varchar2 is
  BEGIN
    if Gesperrt = c.LGR_GESPERRT_F then
      return(c.LGR_GESPERRT_TXT_F || c.LGR_GESPERRT_COL_F);
    end if;
    if Gesperrt = c.LGR_GESPERRT_G then
      return(c.LGR_GESPERRT_TXT_G || c.LGR_GESPERRT_COL_G);
    end if;
    return(Gesperrt);
  END;

  function DECODE_LABOR_STATUS(labor_status in LVS_LAM.labor_status%TYPE)
    return varchar2 is
  BEGIN
    if labor_status = c.LAB_STAT_Q then
      return(c.LAB_STAT_TXT_Q);
    end if;
    if labor_status = c.LAB_STAT_U then
      return(c.LAB_STAT_TXT_U);
    end if;
    if labor_status = c.LAB_STAT_B then
      return(c.LAB_STAT_TXT_B);
    end if;
    if labor_status = c.LAB_STAT_G then
      return(c.LAB_STAT_TXT_G);
    end if;
    if labor_status = c.LAB_STAT_F then
      return(c.LAB_STAT_TXT_F);
    end if;
    return(labor_status);
  END;
  function DECODE_LABOR_STATUS_FARBE(labor_status in LVS_LAM.labor_status%TYPE)
    return varchar2 is
  BEGIN
    if labor_status = c.LAB_STAT_Q then
      return(c.LAB_STAT_TXT_Q || c.LAB_STAT_COL_Q);
    end if;
    if labor_status = c.LAB_STAT_U then
      return(c.LAB_STAT_TXT_U || c.LAB_STAT_COL_U);
    end if;
    if labor_status = c.LAB_STAT_B then
      return(c.LAB_STAT_TXT_B || c.LAB_STAT_COL_B);
    end if;
    if labor_status = c.LAB_STAT_G then
      return(c.LAB_STAT_TXT_G || c.LAB_STAT_COL_G);
    end if;
    if labor_status = c.LAB_STAT_F then
      return(c.LAB_STAT_TXT_F || c.LAB_STAT_COL_F);
    end if;
    return(labor_status);
  END;

end c;
/



-- sqlcl_snapshot {"hash":"f52945ebf8ac8b81ccf7b9878176891ae4feb133","type":"PACKAGE_BODY","name":"C","schemaName":"DIRKSPZM32","sxml":""}