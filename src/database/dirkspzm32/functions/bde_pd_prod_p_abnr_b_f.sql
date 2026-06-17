create or replace 
function DIRKSPZM32.bde_pd_prod_p_abnr_b_f
/*
Meldet eine Auftrag an der Maschine oder an allen Mschinen einer Linie oder Produktionsgruppe zur Produktion an über die ABNR im FA. 

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_abnr            in bde_fa_auftrag.abnr               Fertigungsauftrag-ID
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_akt_term        in isi_arbeitsplatz.ip_name          Name der Arbeitstation, von der gebucht wird          
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

@return v_vorg_id bde_pd_prod.vorg_id ist die Vorgang-ID der Buchung
*/
(in_sid         in isi_sid.sid%type,
 in_firma_nr    in isi_firma.firma_nr%type,
 in_abnr        in bde_fa_auftrag.abnr%type,
 in_res_id      in isi_resource.res_id%type,
 in_akt_term    in isi_arbeitsplatz.ip_name%type,
 in_ls_login_id in isi_user.login_id%type)
 return number is

  v_anz_fas number;                 --  Merken ob nur von Ruesten nach Produktion geschaltet wurde; Dann keien zus. Resource
  v_fa_akt    bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl Aktuell
	v_res_id    isi_resource.res_id%type; --  Aktuelle Resource ID

	-------------------------------------------------------------------------------------------------------
	-- Standard Fehler Felder für Exception
	-------------------------------------------------------------------------------------------------------
	v_error exception;
	v_err_nr   number;
	v_err_text varchar2(255);

	-- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
	cursor c_bde_fa_auftrag_anz is
		select count(fa_a.abnr) 
			from bde_fa_auftrag fa_a
		 where fa_a.sid = in_sid
			 and fa_a.firma_nr = in_firma_nr
			 and fa_a.abnr = in_abnr;

	-- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
	cursor c_bde_fa_auftrag is
		select *
			from bde_fa_auftrag fa_a
		 where fa_a.sid = in_sid
			 and fa_a.firma_nr = in_firma_nr
			 and fa_a.abnr = in_abnr;

begin

  v_anz_fas := 0;
  
  OPEN c_bde_fa_auftrag_anz;
  FETCH c_bde_fa_auftrag_anz into v_anz_fas;
  CLOSE c_bde_fa_auftrag_anz;
  
  if nvl(v_anz_fas, 0) != 1
  then
    v_err_nr   := 1;
    v_err_text := 'Dieser FA Auftrag :' ||
                  in_abnr || ' hat ' || to_char(nvl(v_anz_fas, 0)) || ' Einträge. Erlaubt sind 1.';
    raise v_error;
  end if;

  OPEN c_bde_fa_auftrag;
  FETCH c_bde_fa_auftrag into v_fa_akt;
  CLOSE c_bde_fa_auftrag;
  
  v_res_id := in_res_id;

  v_res_id := bde_pd_prod_p_ag_b_f (in_sid,                -- in_sid         in isi_sid.sid%type,
                                    in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
                                    v_fa_akt.leitzahl,     -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                    v_fa_akt.fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                    v_fa_akt.fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                    v_res_id,          -- in_res_id      in isi_resource.res_id%type,
                                    in_akt_term,           -- in_akt_term    in isi_arbeitsplatz.ip_name%type,
                                    in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
	commit;
	return (v_res_id);
exception
	-- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
end bde_pd_prod_p_abnr_b_f;
/



-- sqlcl_snapshot {"hash":"51ff45e50421c4fc4fc9c65fcae60600cef0a237","type":"FUNCTION","name":"BDE_PD_PROD_P_ABNR_B_F","schemaName":"DIRKSPZM32","sxml":""}