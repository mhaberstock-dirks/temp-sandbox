create or replace 
PROCEDURE DIRKSPZM32.SEQUENCE_NEWVALUE_mhk(
seqowner VARCHAR2,
seqname VARCHAR2,
newvalue NUMBER) AS
ln NUMBER;
ib NUMBER;
BEGIN
SELECT last_number, increment_by
INTO ln, ib
FROM all_sequences
WHERE sequence_owner = upper(seqowner)
AND sequence_name = upper(seqname);
EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seqowner || '.' || seqname ||
' INCREMENT BY ' || (newvalue - ln);
EXECUTE IMMEDIATE 'SELECT ' || seqowner || '.' || seqname ||
'.NEXTVAL FROM DUAL' INTO ln;
EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seqowner || '.' || seqname
|| ' INCREMENT BY ' || ib;
END;
/



-- sqlcl_snapshot {"hash":"225838d8d28480910df435562ed5dd5cb331f14f","type":"PROCEDURE","name":"SEQUENCE_NEWVALUE_MHK","schemaName":"DIRKSPZM32","sxml":""}