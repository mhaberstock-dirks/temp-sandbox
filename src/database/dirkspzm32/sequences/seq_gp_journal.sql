create sequence dirkspzm32.seq_gp_journal minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 /* start with n */ cache 20
noorder nocycle nokeep noscale global;


-- sqlcl_snapshot {"hash":"35ae814ecc513a1a856c5c1d00ff5f589cc670b6","type":"SEQUENCE","name":"SEQ_GP_JOURNAL","schemaName":"DIRKSPZM32","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>SEQ_GP_JOURNAL</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n   <CACHE>20</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}