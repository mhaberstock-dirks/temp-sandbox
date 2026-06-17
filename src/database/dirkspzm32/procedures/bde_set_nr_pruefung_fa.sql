create or replace 
procedure DIRKSPZM32.BDE_SET_NR_PRUEFUNG_FA (in_sid isi_sid.sid%type,
                                                    in_firma_nr         bde_fa_auftrag.firma_nr%type,
                                                    in_nr_pruefung      bde_fa_auftrag.nr_pruefung%type,
                                                    in_leitzahl         bde_fa_auftrag.leitzahl%type,
                                                    in_fa_ag            bde_fa_auftrag.fa_ag%type,
                                                    in_res_name         isi_resource.res_name%type,
                                                    in_up_verrichten    varchar2,
                                                    in_up_prim          varchar2) is
   /*
  __________________________________________________
  Author    : CMe
  Created   : 22.05.2020 13:15:55
  __________________________________________________
  Description
  Prozedur setzt für einen Fertigungsauftrag die übergebenen
  Prüfplannummer. Wird kein Fertigungsauftrag mit übergaben wird
  der aktuell angemeldete Auftrag an der Maschine genommen.

  in_up_verrichten = 'T' übergeben bekommen alle Einträge der
  Leitzahl mit Satzart 'V'errichten die Prüfplannummer eingetragen

  Ohne commit
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  22.05.2020   DB31_1      (-CMe-)  Prozedur erstellt
                                    Ticket: P70397-658
  */
  v_error             exception;
  v_err_nr            number;
  v_err_text          varchar2(2550);

  v_bde_fa_auftrag    bde_fa_auftrag%rowtype;
  v_isi_resource      isi_resource%rowtype;
  v_isi_res_zust_akt  isi_resource_zust_akt%rowtype;
  v_leitzahl          bde_fa_auftrag.leitzahl%type;
  v_fa_ag             bde_fa_auftrag.fa_ag%type;
  v_found             boolean;

  cursor c_get_bde_fa_auftrag is
    select bde.*
      from bde_fa_auftrag bde
     where bde.sid = in_sid
       and bde.firma_nr = in_firma_nr
       and bde.leitzahl = v_leitzahl
       and bde.fa_ag =nvl(v_fa_ag, bde.fa_ag);
begin
  v_found := (isi_p_base.get_resource_by_name(in_res_name => in_res_name,
                                              out_resource => v_isi_resource));
  if (in_leitzahl is not null)
  then
    v_leitzahl := in_leitzahl;
    if (in_fa_ag is not null)
    then
       v_fa_ag := in_fa_ag;
    else
      --Wenn kein Arbeitsgang bekannt ist und nicht alle Verrichten Arbeitsgänge die Nummer bekommen sollen
      -- muss die Resource bekannt sein, an den der auftrag verrichtet werden soll
      if not (v_found) and (in_up_verrichten <> 'T')
      then
        v_err_nr := c.FMID_Resource_Fehlt;
        v_err_text := LC.ec_p1(LC.O_TP1_RESOURCE_FEHLT, in_res_name);
        raise v_error;
      end if;
    end if;
  else
      -- Ohne Leitzahl und Resource kann der Auftrag nicht gefunden werden
      if not (v_found)
      then
        v_err_nr := c.FMID_Resource_Fehlt;
        v_err_text := LC.ec_p1(LC.O_TP1_RESOURCE_FEHLT, in_res_name);
        raise v_error;
      end if;
      if(isi_p_base.get_resource_zust_akt(in_sid => in_sid,
                                          in_res_id => v_isi_resource.res_id,
                                          out_resource_zust_akt => v_isi_res_zust_akt))
      then
        v_leitzahl := v_isi_res_zust_akt.leitzahl;
        v_fa_ag := v_isi_res_zust_akt.fa_ag;
      else
        v_err_nr := 10;
        v_err_text := LC.ec_p1(LC.O_TP1_RESOURCENZUSTAND_FEHLT, in_res_name);
        raise v_error;
      end if;
  end if;
  open c_get_bde_fa_auftrag;
  fetch c_get_bde_fa_auftrag into v_bde_fa_auftrag;
  v_found := c_get_bde_fa_auftrag%found;
  close c_get_bde_fa_auftrag;
  if (v_found)
  then
    -- Wenn Arbeitsgang angegeben das für alle 'V'errichten einträge die Pruefplannummer setzen
    if (in_up_verrichten = 'T')
    then
      update bde_fa_auftrag bde
         set bde.nr_pruefung = in_nr_pruefung
       where  bde.sid = in_sid
         and bde.firma_nr = in_firma_nr
         and bde.leitzahl = v_leitzahl
         and bde.satzart = 'V';
    else
      update bde_fa_auftrag bde
         set bde.nr_pruefung = in_nr_pruefung
       where  bde.sid = in_sid
         and bde.firma_nr = in_firma_nr
         and bde.leitzahl = v_leitzahl
         and (bde.fa_ag = v_fa_ag or
             (bde.res_id = v_isi_resource.res_id and bde.satzart = 'V'));
    end if;
    if (in_up_prim = 'T')
    then
      update bde_fa_auftrag bde
         set bde.nr_pruefung = in_nr_pruefung
       where bde.sid = in_sid
         and bde.firma_nr = in_firma_nr
         and bde.leitzahl = v_bde_fa_auftrag.primaer_leitzahl
         and bde.satzart = 'V';
    end if;
  end if;
exception
 -- Im Fehlerfall is der Fehlertext bereits gesetzt.
 when v_error then
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
end BDE_SET_NR_PRUEFUNG_FA;
/



-- sqlcl_snapshot {"hash":"b141ac8b7e5e4d0ce55d5217138a5ce19d8da4b4","type":"PROCEDURE","name":"BDE_SET_NR_PRUEFUNG_FA","schemaName":"DIRKSPZM32","sxml":""}