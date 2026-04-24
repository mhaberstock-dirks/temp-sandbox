create index dirkspzm32.ix_isi_transport_h_res_id on
    dirkspzm32.isi_transport_hist (
        res_id
    );


-- sqlcl_snapshot {"hash":"f557533510bc473c8936bf23536b70d4a483b5c8","type":"INDEX","name":"IX_ISI_TRANSPORT_H_RES_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_H_RES_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}