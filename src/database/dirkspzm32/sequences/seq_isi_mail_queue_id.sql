create sequence dirkspzm32.seq_isi_mail_queue_id minvalue 1 maxvalue 99999999 increment by 1 /* start with n */ cache 5 noorder cycle
nokeep noscale global;


-- sqlcl_snapshot {"hash":"941f125a41d131561e1f3d41f77338539bae9934","type":"SEQUENCE","name":"SEQ_ISI_MAIL_QUEUE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <SEQUENCE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>SEQ_ISI_MAIL_QUEUE_ID</NAME>\n   \n   <INCREMENT>1</INCREMENT>\n   <MINVALUE>1</MINVALUE>\n   <MAXVALUE>99999999</MAXVALUE>\n   <CYCLE></CYCLE>\n   <CACHE>5</CACHE>\n   <SCALE>NOSCALE</SCALE>\n</SEQUENCE>"}