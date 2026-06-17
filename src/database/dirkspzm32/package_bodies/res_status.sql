create or replace 
package body DIRKSPZM32.res_status is
	-------------------------------------------------------------------------------------------------------
	-- Standard Fehler-Variablen für eine Exception
	-------------------------------------------------------------------------------------------------------
	v_error exception;
	v_err_nr   number;
	v_err_text varchar2(255);

	-------------------------------------------------------------------------------------------------------
	-- procedure res_status_beg(...)
	-------------------------------------------------------------------------------------------------------
	/* Status an einer Resource beginnen */
	procedure res_status_beg(in_sid           in isi_sid.sid%type,
													 in_firma_nr      in isi_firma.firma_nr%type,
													 in_res_id        in isi_resource.res_id%type,
													 in_ls_login_id   in isi_user.login_id%type,
													 in_res_st_id     in isi_res_status_cfg.res_st_id%type,
													 in_res_typ       in isi_res_status_cfg.res_typ%type,
													 in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
													 in_fehler_res_id in isi_res_status.fehler_res_id%type,
													 in_sysdate       in date default null) is
		v_sysdate date;

		v_res_status_cfg isi_res_status_cfg%rowtype;
		v_res_status     isi_res_status%rowtype;
		v_resource       isi_resource%rowtype;
    v_found          boolean;

    cursor c_resource is
      select *
        from isi_resource r
       where r.sid = in_sid
         and r.res_id = in_res_id;

		cursor c_res_status_cfg is
			select t.*
				from isi_res_status_cfg t
			 where t.sid = in_sid
				 and t.firma_nr = in_firma_nr
				 and t.res_st_id = in_res_st_id
         and t.fehler_schluessel = nvl(v_resource.fehler_schluessel, 0)
				 and t.res_typ = in_res_typ;
         
    CURSOR c_res_status is
      select *
        from isi_res_status t
       where t.sid = in_sid
				 and t.firma_nr = in_firma_nr
				 and t.res_id = in_res_id
         and t.st_start = v_sysdate;
	begin
		v_sysdate := nvl(in_sysdate, sysdate);

    OPEN c_resource;
    FETCH c_resource into v_resource;
    CLOSE c_resource;
    
    OPEN c_res_status;
    FETCH c_res_status into v_res_status;
    v_found := c_res_status%FOUND;
    CLOSE c_res_status;

    if not v_found     -- Status für diesen Zeitpunkt nicht vorhanden - Dann anlegen
    then
      /* ggf. offenen Status schliessen */
      res_status_end(in_sid, in_firma_nr, in_res_id, v_sysdate);

      insert into isi_res_status
      values
        (in_sid,
         in_firma_nr,
         in_res_id,
         v_sysdate,
         null,
         in_res_st_id,
         in_res_typ,
         in_res_st_ug_id,
         in_ls_login_id,
         in_fehler_res_id);
    else
      update isi_res_status t
         set t.res_st_id = in_res_st_id,
             t.res_typ = in_res_typ,
             t.res_st_ug_id = in_res_st_ug_id,
             t.ls_login_id = in_ls_login_id,
             t.fehler_res_id = in_fehler_res_id
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.res_id = in_res_id
         and t.st_start = v_sysdate;
    end if;

		v_res_status_cfg := null;

		open c_res_status_cfg;
		fetch c_res_status_cfg
			into v_res_status_cfg;
		close c_res_status_cfg;

		-- Update des aktuellen Zustands der Maschine
		update isi_resource_zust_akt res_akt
			 set res_akt.status_id   = in_res_st_id,
					 res_akt.status_seit = v_sysdate,
					 res_akt.status_text = v_res_status_cfg.st_text
		 where res_akt.sid = in_sid
			 and res_akt.firma_nr = in_firma_nr
			 and res_akt.res_id = in_res_id;
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
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure res_status_end(...)
	-------------------------------------------------------------------------------------------------------
	/* aktuellen Status an einer Resource beenden */
	procedure res_status_end(in_sid      in isi_sid.sid%type,
													 in_firma_nr in isi_firma.firma_nr%type,
													 in_res_id   in isi_resource.res_id%type,
													 in_sysdate  in date default null) is

		v_sysdate date;
	begin
		v_sysdate := nvl(in_sysdate, sysdate);

    -- -AG- SID und Firma rausgenommen, damit ein besserer Index genommen wird
		update isi_res_status t
			 set t.st_ende = v_sysdate
		 where t.res_id = in_res_id
			 and t.st_ende is null;

		/* Messungen bzw. Aktualisierungen von Störzeiten z.B. in den BDE Tabellen
    werden im Trigger vorgenommen da diese Trigger auch weggelassen werden können */
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
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure res_status_unt(...)
	-------------------------------------------------------------------------------------------------------
	/* aktuellen Status an einer Resource unterbrechen (z.B. wegen Schichtwechsel) */
	procedure res_status_unterb(in_sid         in isi_sid.sid%type,
															in_firma_nr    in isi_firma.firma_nr%type,
															in_res_id      in isi_resource.res_id%type,
															in_ls_login_id in isi_user.login_id%type,
															in_sysdate     in date default null) is
		v_sysdate    date;
		v_res_status isi_res_status%rowtype;

		cursor c_res_status is
      -- -AG- SID und Firma rausgenommen, damit ein besserer Index genommen wird
			select t.*
				from isi_res_status t
			 where t.res_id = in_res_id
				 and t.st_ende is null;
	begin
		v_sysdate := nvl(in_sysdate, sysdate);

		open c_res_status;

		fetch c_res_status
			into v_res_status;
		if c_res_status%found
		then
			res_status_beg(in_sid,
										 in_firma_nr,
										 in_res_id,
                     -- 27.08.2008 -AG- Immer die login_id der Auslösung übernehmen, Sonst bleiben MDE Fehler hängen
										 -- nvl(in_ls_login_id, v_res_status.ls_login_id),
										 v_res_status.ls_login_id,
										 v_res_status.res_st_id,
										 v_res_status.res_typ,
										 v_res_status.res_st_ug_id,
										 v_res_status.fehler_res_id,
										 v_sysdate);
		end if;

		close c_res_status;
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
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure res_status_aend(...)
	-------------------------------------------------------------------------------------------------------
	/* aktuellen Status an einer Resource ändern / weitere Details anpassen */
	procedure res_status_grund(in_sid           in isi_sid.sid%type,
														 in_firma_nr      in isi_firma.firma_nr%type,
														 in_res_id        in isi_resource.res_id%type,
														 in_ls_login_id   in isi_user.login_id%type,
														 in_res_st_id     in isi_res_status_cfg.res_st_id%type,
														 in_res_typ       in isi_res_status_cfg.res_typ%type,
														 in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
														 in_fehler_res_id in isi_res_status.fehler_res_id%type) is
		v_res_status     isi_res_status%rowtype;
		v_res_status_cfg isi_res_status_cfg%rowtype;
		v_resource       isi_resource%rowtype;

		cursor c_res_status is
      -- -AG- SID und Firma rausgenommen, damit ein besserer Index genommen wird
			select t.*
				from isi_res_status t
			 where t.res_id = in_res_id
				 and t.st_ende is null;

    cursor c_resource is
      select *
        from isi_resource r
       where r.sid = in_sid
         and r.res_id = in_res_id;

		cursor c_res_status_cfg is
			select t.*
				from isi_res_status_cfg t
			 where t.sid = in_sid
				 and t.firma_nr = in_firma_nr
				 and t.res_st_id = in_res_st_id
         and t.fehler_schluessel = nvl(v_resource.fehler_schluessel, 0)
				 and t.res_typ = in_res_typ;

		v_found boolean;
	begin
    OPEN c_resource;
    FETCH c_resource into v_resource;
    CLOSE c_resource;

		open c_res_status;

		fetch c_res_status
			into v_res_status;
		v_found := c_res_status%found;

		close c_res_status;

		if v_found
		then
			update isi_res_status t
				 set t.ls_login_id   = in_ls_login_id,
						 t.res_st_id     = in_res_st_id,
						 t.res_typ       = in_res_typ,
						 t.res_st_ug_id  = in_res_st_ug_id,
						 t.fehler_res_id = in_fehler_res_id
			 where t.sid = v_res_status.sid
				 and t.firma_nr = v_res_status.firma_nr
				 and t.res_id = v_res_status.res_id
				 and t.st_start = v_res_status.st_start;

			open c_res_status_cfg;

			fetch c_res_status_cfg
				into v_res_status_cfg;
			v_found := c_res_status_cfg%found;

			close c_res_status_cfg;

			if not v_found
			then
				v_err_nr   := 10;
				v_err_text := 'Fehler: Status <' || in_res_typ || '/' ||
											in_res_st_id || '> nicht vorhanden.';
				raise v_error;
			end if;

			-- Update des aktuellen Zustands der Maschine
			update isi_resource_zust_akt res_akt
				 set res_akt.status_id   = in_res_st_id,
						 res_akt.status_text = v_res_status_cfg.st_text
			 where res_akt.sid = in_sid
				 and res_akt.firma_nr = in_firma_nr
				 and res_akt.res_id = in_res_id;
		end if;
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
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure c_res_status_beg(...)
	-------------------------------------------------------------------------------------------------------
	/* (commited) Status beginnen */
	procedure c_res_status_beg(in_sid           in isi_sid.sid%type,
														 in_firma_nr      in isi_firma.firma_nr%type,
														 in_res_id        in isi_resource.res_id%type,
														 in_ls_login_id   in isi_user.login_id%type,
														 in_res_st_id     in isi_res_status_cfg.res_st_id%type,
														 in_res_typ       in isi_res_status_cfg.res_typ%type,
														 in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
														 in_fehler_res_id in isi_res_status.fehler_res_id%type,
														 in_sysdate       in date default null) is
	begin
		res_status_beg(in_sid,
									 in_firma_nr,
									 in_res_id,
									 in_ls_login_id,
									 in_res_st_id,
									 in_res_typ,
									 in_res_st_ug_id,
									 in_fehler_res_id,
									 in_sysdate);
		commit;
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure c_res_status_end(...)
	-------------------------------------------------------------------------------------------------------
	/* (commited) aktuellen Status beenden */
	procedure c_res_status_end(in_sid      in isi_sid.sid%type,
														 in_firma_nr in isi_firma.firma_nr%type,
														 in_res_id   in isi_resource.res_id%type,
														 in_sysdate  in date default null) is
	begin
		res_status_end(in_sid, in_firma_nr, in_res_id, in_sysdate);
		commit;
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure c_res_status_unt(...)
	-------------------------------------------------------------------------------------------------------
	/* (commited) aktuellen Status unterbrechen */
	procedure c_res_status_unterb(in_sid         in isi_sid.sid%type,
																in_firma_nr    in isi_firma.firma_nr%type,
																in_res_id      in isi_resource.res_id%type,
																in_ls_login_id in isi_user.login_id%type,
																in_sysdate     in date default null) is
	begin
		res_status_unterb(in_sid,
											in_firma_nr,
											in_res_id,
											in_ls_login_id,
											in_sysdate);
		commit;
	end;

	-------------------------------------------------------------------------------------------------------
	-- procedure c_res_status_aend(...)
	-------------------------------------------------------------------------------------------------------
	/* (commited) aktuellen Status ändern */
	procedure c_res_status_grund(in_sid           in isi_sid.sid%type,
															 in_firma_nr      in isi_firma.firma_nr%type,
															 in_res_id        in isi_resource.res_id%type,
															 in_ls_login_id   in isi_user.login_id%type,
															 in_res_st_id     in isi_res_status_cfg.res_st_id%type,
															 in_res_typ       in isi_res_status_cfg.res_typ%type,
															 in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
															 in_fehler_res_id in isi_res_status.fehler_res_id%type) is
	begin
		res_status_grund(in_sid,
										 in_firma_nr,
										 in_res_id,
										 in_ls_login_id,
										 in_res_st_id,
										 in_res_typ,
										 in_res_st_ug_id,
										 in_fehler_res_id);
		commit;
	end;

  -- Diese Procedure kann mehrfach mit dem gleichen Grund aufgerufen werden.
  -- Wenn der Grund bereits gebucht ist, werden nur die Status ID in der
  -- Stücklistenreferenz gebucht.
	procedure c_res_status_beg_stl_ref(in_sid           in isi_sid.sid%type,
                                     in_firma_nr      in isi_firma.firma_nr%type,
                                     in_res_id        in isi_resource.res_id%type,
                                     in_ls_login_id   in isi_user.login_id%type,
                                     in_res_st_id     in isi_res_status_cfg.res_st_id%type,
                                     in_res_typ       in isi_res_status_cfg.res_typ%type,
                                     in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
                                     in_fehler_res_id in isi_res_status.fehler_res_id%type,
                                     in_stl_fa_ag     in bde_fa_auftrag_stl.ma_fa_ag%type,
                                     in_stl_fa_upos   in bde_fa_auftrag_stl.ma_fa_upos%type,
                                     in_stl_fa_mg_ix  in bde_fa_auftrag_stl.prod_menge_ix%type,
        														 in_sysdate       in date default null) is

    v_res_zust_akt                   isi_resource_zust_akt%rowtype;
    v_res_zust_akt_ok                boolean;
    v_pd_lam_stl_daten               bde_pd_lam_stl_daten%rowtype;

    CURSOR c_lam_stl is
      select t.*
        from bde_pd_lam_stl_daten t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.res_id = in_res_id
         and t.fa_nr = v_res_zust_akt.leitzahl
         and t.fa_ag = v_res_zust_akt.fa_ag
         and t.fa_upos = v_res_zust_akt.fa_upos
       order by t.pd_lam_stl_daten_id;
  begin
    v_res_zust_akt_ok := isi_p_base.get_res_zust_akt(in_sid, in_res_id, v_res_zust_akt);

    if v_res_zust_akt.status_id != in_res_st_id
    or v_res_zust_akt.status_id is NULL
    then
      res_status_beg(in_sid,
                     in_firma_nr,
                     in_res_id,
                     in_ls_login_id,
                     in_res_st_id,
                     in_res_typ,
                     in_res_st_ug_id,
                     in_fehler_res_id,
                     in_sysdate);
    end if;

    if  in_stl_fa_ag is not NULL
    and in_stl_fa_upos is not NULL
    and in_stl_fa_mg_ix is not NULL
    and v_res_zust_akt_ok
    then
      if in_res_st_id = 0
      then
        update bde_pd_lam_stl_daten t
           set t.res_status_id = in_res_st_id
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.res_id = in_res_id
           and t.fa_nr = v_res_zust_akt.leitzahl
           and t.fa_ag = v_res_zust_akt.fa_ag
           and t.fa_upos = v_res_zust_akt.fa_upos;

      else
        v_pd_lam_stl_daten := NULL;

        OPEN c_lam_stl;
        LOOP
          FETCH c_lam_stl into v_pd_lam_stl_daten;
          EXIT when c_lam_stl%notfound
                 or v_pd_lam_stl_daten.stl_lam_ab_menge > v_pd_lam_stl_daten.stl_lam_ist_menge;
        end LOOP;

        if v_pd_lam_stl_daten.stl_lam_ab_menge is not NULL
        then
          update bde_pd_lam_stl_daten t
             set t.res_status_id = in_res_st_id
           where t.pd_lam_stl_daten_id = v_pd_lam_stl_daten.pd_lam_stl_daten_id;
        end if;
      end if;
    end if;

  end;
begin
	-- globale Initialisierung
	-- Erst mal kein Fehler
	v_err_nr   := null;
	v_err_text := null;
end res_status;
/



-- sqlcl_snapshot {"hash":"9770b6624a488b62f2cbda813e1a15399a3f3ca9","type":"PACKAGE_BODY","name":"RES_STATUS","schemaName":"DIRKSPZM32","sxml":""}