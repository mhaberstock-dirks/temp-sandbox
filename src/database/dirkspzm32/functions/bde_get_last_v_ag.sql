create or replace 
function DIRKSPZM32.bde_get_last_v_ag
/*
  Gibt den letzten ...Arbeitsgang zurueck
  ---- HISTORY ---
  21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
  @param in_sid SID der Maschine
  @param in_firma_nr Nummer der Firma
  @param in_leitzahl Fertigungsleitzahl
  @param in_fa_ag Fertigungsauftrag_Arbeitsgang
  @return 
*/
(
in_sid           in isi_sid.sid%type,
in_firma_nr      in isi_firma.firma_nr%type,
in_leitzahl      in bde_fa_auftrag.leitzahl%type,
in_fa_ag         in bde_fa_auftrag.fa_ag%type
)
return number is
  Result number;
  CURSOR c_fa is
    select fa.fa_ag
      from bde_fa_auftrag fa
     where fa.sid = in_sid
       and fa.firma_nr = in_firma_nr
       and fa.leitzahl = in_leitzahl
       and fa.fa_ag    < in_fa_ag
       and fa.satzart  like ('V%')
       and fa.satzart  != 'VR'
     order by fa.fa_ag desc;
begin
  OPEN c_fa;
  FETCH c_fa into Result;
  if c_fa%NOTFOUND
  then
    Result := NULL;
  end if;
  CLOSE c_fa;
  return(Result);
end bde_get_last_v_ag;
/



-- sqlcl_snapshot {"hash":"608a99e64d7fbe71147451ab69138ca33e0ee7ea","type":"FUNCTION","name":"BDE_GET_LAST_V_AG","schemaName":"DIRKSPZM32","sxml":""}