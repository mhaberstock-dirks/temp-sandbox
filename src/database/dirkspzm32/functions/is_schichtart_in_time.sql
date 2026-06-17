create or replace 
function DIRKSPZM32.is_schichtart_in_time
/*
  Modul: PZM
  Kommentare:

  ---- HISTORIE ---

*/
(
  p_sa_kurzname      in varchar2,
  p_stempel_zeit     in date,
  p_schicht_datum    in date,
  p_sm_d_arb_std_tag in number,
  p_sa_beginn        out date,
  p_sa_ende          out date,
  p_sa_std           out number
) return integer is


  v_result integer;
  v_ToleranzMin  integer; -- Std.
  --v_ToleranzMax  integer; -- Std.

  v_schichtart pzm_schichtarten%rowtype;

  cursor c_SchichtArt is
    select t.*
      from pzm_schichtarten t
     where t.sa_kurzname = p_sa_kurzname;
begin
  v_ToleranzMin := 1;
  --v_ToleranzMax := 1;

  v_result := 0;

  open c_SchichtArt;
  fetch c_SchichtArt into v_schichtart;

  if c_SchichtArt%found
  then
    if v_schichtart.calc_basis = 'GLEITZ'
    then
      -- Rahmenzeit bei Gleitzeit berücksichhtigen (Kernzeit wird nicht für Berechnungen genutzt)
      p_sa_beginn := trunc(p_schicht_datum) + fraction_of_day(v_schichtart.sa_beginn); -- p_sa_beginn);
      if p_stempel_zeit > p_sa_beginn
      then
        p_sa_beginn := p_stempel_zeit;
      end if;

      -- erwartetes Ende anhand der Soll-Arbeitszeit berechnen
      p_sa_ende := p_sa_beginn + (v_schichtart.sa_std_pro_tag / 24);
      p_sa_std := v_schichtart.sa_std_pro_tag;
      -- Pausen werden anhand des Gleitzeitmodells abgezogen
      v_result := 1;
    else
      -- auf den Tag von p_schicht_datum umrechnen
      p_sa_beginn := trunc(p_schicht_datum) + fraction_of_day(v_schichtart.sa_beginn); -- p_sa_beginn);
      p_sa_ende := trunc(p_schicht_datum) + fraction_of_day(v_schichtart.sa_ende); --p_sa_ende);
      p_sa_std := v_schichtart.sa_std_pro_tag;

      if p_sa_ende <= p_sa_beginn
      then -- wenn das Ende vor dem Beginn liegt
        p_sa_ende := p_sa_ende + 1; -- nächster Tag
      elsif p_sa_beginn < trunc(p_sa_beginn) + 4/24
      then
        -- von 00:00 Uhr bis 04:00 Uhr beginnt die Schicht am nächsten Tag,
        -- aber immer noch für den aktuellen Schichttag
        p_sa_beginn := p_sa_beginn + 1;
        p_sa_ende := p_sa_ende + 1;
      end if;

      if p_stempel_zeit between (p_sa_beginn - (v_ToleranzMin / 24))
                            and (p_sa_ende - ((v_ToleranzMin * 2) / 24))
      then
        v_result := 1; -- gefunden!!
      end if;

      if p_stempel_zeit = trunc(p_stempel_zeit)
      then
        v_result := 1; -- bei einem Ganztageseintrag wird die 1. Schicht, die gefunden wird akzeptiert
      end if;
    end if;
  end if;

  close c_SchichtArt;

  if nvl(p_sm_d_arb_std_tag, 0) > 0 and p_sa_kurzname != pzm_utils.get_standard_schicht_by_calc_basis(v_schichtart.calc_basis) and nvl(p_sa_std, 1) != 0
  then
    -- Berechnung anhand der durchschnittlichen Arbeitsstunden hat vorrang auch
    -- bei festen Arbeitszeiten
    -- AG 08.01.2025 das ist quatsch
    -- p_sa_std := p_sm_d_arb_std_tag;
    -- p_sa_ende := p_sa_beginn + (p_sm_d_arb_std_tag / 24);

    -- MWe 2018.05.16 Ticket:P70460-14
    -- Die Bewertung auf das Schichtende (1) setzten, maximal Schichtzeit bzw. maximal 6h
    if v_schichtart.sa_bewertung_beginn = 1 then
       if v_schichtart.sa_std_pro_tag > 6 then
          p_sa_beginn := p_sa_beginn  + interval '6' hour;
          p_sa_ende   := p_sa_ende    + interval '6' hour;
       else
          p_sa_beginn := p_sa_beginn  + v_schichtart.sa_std_pro_tag;
          p_sa_ende   := p_sa_ende    + v_schichtart.sa_std_pro_tag;
       end if;
    end if;

  end if;

  return(v_result);
end is_schichtart_in_time;
/



-- sqlcl_snapshot {"hash":"ac1cd390fcdde5194b40afc0db897200483c9e85","type":"FUNCTION","name":"IS_SCHICHTART_IN_TIME","schemaName":"DIRKSPZM32","sxml":""}