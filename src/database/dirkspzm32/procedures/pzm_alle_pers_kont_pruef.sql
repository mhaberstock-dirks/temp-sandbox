create or replace 
procedure DIRKSPZM32.pzm_alle_pers_kont_pruef is
  v_pers_nr pzm_personal.pers_nr%type;

  cursor c_personal is
    select pers_nr
      from pzm_personal t;
begin
  open c_personal;

  loop
    fetch c_personal into v_pers_nr;
    exit when c_personal%notfound;

    -- diese Funktion wird zur zeit nirgendwo benutzt (-WK- 02.02.2006)
    -- deshalb auch keine anpassung

    --pzm_kontoverwaltung.init_konto('UK', v_pers_nr);
    --pzm_kontoverwaltung.init_konto('FK', v_pers_nr);
    --pzm_kontoverwaltung.init_konto('ZK', v_pers_nr);
  end loop;

  close c_personal;
end pzm_alle_pers_kont_pruef;
/



-- sqlcl_snapshot {"hash":"21bad6030bded251de15cbd2d2fa391037804f06","type":"PROCEDURE","name":"PZM_ALLE_PERS_KONT_PRUEF","schemaName":"DIRKSPZM32","sxml":""}