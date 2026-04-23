create or replace function dirkspzm32.bde_get_last_v_ag
/*
  Gibt den letzten ...Arbeitsgang zurueck
  ---- HISTORY ---
  21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
  @param in_sid SID der Maschine
  @param in_firma_nr Nummer der Firma
  @param in_leitzahl Fertigungsleitzahl
  @param in_fa_ag Fertigungsauftrag_Arbeitsgang
  @return 
*/ (
    in_sid      in isi_sid.sid%type,
    in_firma_nr in isi_firma.firma_nr%type,
    in_leitzahl in bde_fa_auftrag.leitzahl%type,
    in_fa_ag    in bde_fa_auftrag.fa_ag%type
) return number is

    result number;
    cursor c_fa is
    select
        fa.fa_ag
    from
        bde_fa_auftrag fa
    where
            fa.sid = in_sid
        and fa.firma_nr = in_firma_nr
        and fa.leitzahl = in_leitzahl
        and fa.fa_ag < in_fa_ag
        and fa.satzart like ( 'V%' )
        and fa.satzart != 'VR'
    order by
        fa.fa_ag desc;

begin
    open c_fa;
    fetch c_fa into result;
    if c_fa%notfound then
        result := null;
    end if;
    close c_fa;
    return ( result );
end bde_get_last_v_ag;
/


-- sqlcl_snapshot {"hash":"7671bc3a20edd43461cfbef1fe1d721d3e57eb45","type":"FUNCTION","name":"BDE_GET_LAST_V_AG","schemaName":"DIRKSPZM32","sxml":""}