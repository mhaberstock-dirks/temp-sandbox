create or replace 
procedure DIRKSPZM32.bde_pd_prod_p_ag_b
/*
Deckel zu bde_pd_prod_p_ag_b_f Meldet eine Auftrag an der Maschine oder an allen Mschinen einer Linie oder Produktionsgruppe zur Produktion an. 

-- Die procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_akt_term        in isi_arbeitsplatz.ip_name          Name der Arbeitstation, von der gebucht wird          
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

*/
(in_sid         in isi_sid.sid%type,
 in_firma_nr    in isi_firma.firma_nr%type,
 in_leitzahl    in bde_fa_auftrag.leitzahl%type,
 in_fa_ag       in bde_fa_auftrag.fa_ag%type,
 in_fa_upos     in bde_fa_auftrag.fa_upos%type,
 in_res_id      in isi_resource.res_id%type,
 in_akt_term    in isi_arbeitsplatz.ip_name%type,
 in_ls_login_id in isi_user.login_id%type) is

	v_vorg_id bde_pd_prod.vorg_id%type; --  ID des Vorgangs
begin
  v_vorg_id := bde_pd_prod_p_ag_b_f(in_sid,                   -- in isi_sid.sid%type,
																    in_firma_nr,              -- in isi_firma.firma_nr%type,
																	  in_leitzahl,              -- in bde_fa_auftrag.leitzahl%type,
																		in_fa_ag,                 -- in bde_fa_auftrag.fa_ag%type,
																		in_fa_upos,               -- in bde_fa_auftrag.fa_upos%type,
																		in_res_id,                -- in isi_resource.res_id%type,
																		in_akt_term,              -- in isi_arbeitsplatz.ip_name%type,
																		in_ls_login_id);          -- in isi_user.login_id%type)
	commit;
end bde_pd_prod_p_ag_b;
/



-- sqlcl_snapshot {"hash":"3dc9df3185f94bb5da451d164bb7e070c8339bec","type":"PROCEDURE","name":"BDE_PD_PROD_P_AG_B","schemaName":"DIRKSPZM32","sxml":""}