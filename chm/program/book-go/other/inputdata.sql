drop table aueictmp.tmp ;
create table aueictmp.tmp (
id               string         ,                             
ymd			     string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';


load data local inpath '/home/aueic/xz/inputDatas/1.tsv' overwrite into table aueictmp.tmp ;

set hive.mapred.mode=nonstrict;
set hive.exec.dynamic.partition.mode=nonstrict ;
set hive.exec.max.dynamic.partitions=10000;
set hive.exec.max.dynamic.partitions.pernode=1000 ;

insert overwrite table aueic.tmp partition (ymd)
select 
id               ,                             
ymd  from aueictmp.tmp ;		            