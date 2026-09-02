create or replace 
function current_unit_name return varchar2 is
  -----------------------------------------------------------------------------------------------
  -- Liefert den Namen der aufrufenden Prozedur/Funktion (ohne Package-Praefix), ermittelt zur
  -- Laufzeit ueber den Call-Stack. Gedacht fuer die Verwendung in der Deklarationssektion einer
  -- Prozedur/Funktion, z.B.:
  --   c_module_name constant varchar2(50) := current_unit_name();
  -- Dadurch entfaellt das manuelle, fehleranfaellige Wiederholen des eigenen Prozedurnamens als
  -- String-Literal an jeder Log-Aufrufstelle (p_module=>'...').
  --
  -- Tiefe 1 = current_unit_name selbst, Tiefe 2 = ihr direkter Aufrufer (die Prozedur/Funktion,
  -- deren Deklarationssektion diese Funktion aufruft).
  -----------------------------------------------------------------------------------------------
  v_name utl_call_stack.unit_qualified_name;
begin
  v_name := utl_call_stack.subprogram(2);
  return lower(v_name(v_name.count)); -- letztes Element = reiner Prozedur-/Funktionsname, UTL_CALL_STACK
                                       -- liefert PL/SQL-typisch GROSSSCHREIBUNG - die bestehenden
                                       -- Modulname-Literale im Code sind aber durchgaengig kleingeschrieben.
end current_unit_name;
/



-- sqlcl_snapshot {"hash":"43e2e421a8f472d56cab845d80bf65ee1c1a10df","type":"FUNCTION","name":"CURRENT_UNIT_NAME","schemaName":"DIRKSPZM32","sxml":""}