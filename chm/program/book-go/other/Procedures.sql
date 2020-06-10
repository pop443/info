CREATE OR REPLACE PROCEDURE p_c_magent_getwebchatrecord
  /*
    2014-06-27 邢舟 迁移c11 增加 部门等条件
  */
(
  i_startTime      in varchar2,
  i_endTime        in varchar2,
  i_replyMethod    in varchar2,
  i_acceptNo       in varchar2,
  i_sessionId      in varchar2,
  i_replyStaffNo   in varchar2,
  i_userGrade      in varchar2,
  i_requestContent in varchar2,
  i_satisfyFlag    in varchar2,
  i_replyEmail     in varchar2,
  i_deptCode       in varchar2,
  i_chatFlagYes    in varchar2,
  i_chatFlagNo     in varchar2,
  i_mediaType      in varchar2,
  i_belongCity     in varchar2,
  i_serviceId      in varchar2,
  o_ret          OUT NUMBER, --成功标志 0：成功；1：异常
  o_cur          OUT PACK_SERVICE.T_RETDATASET --返回结果
  --o_count        out number
)
IS
  v_startTime      VARCHAR2(30);
  v_endTime        VARCHAR2(30);
  v_replyMethod    t_magent_webchatrecord.replymethod%type;
  v_acceptNo       t_magent_webchatrecord.acceptno%type;
  v_sessionId      varchar2(2000);
  v_replyStaffNo   t_magent_webchatrecord.replystaffno%type;
  v_userGrade      t_Magent_Session.Usergrade%type;
  v_requestContent t_magent_webchatrecord.requestcontent%type;
  v_satisfyFlag    t_magent_satisfaction.satisfactiontflag%type;
  v_replyEmail     t_magent_webchatrecord.replyemail%type;

  v_deptCode       VARCHAR2(50);
  v_chatFlagYes    VARCHAR2(10);
  v_chatFlagNo     VARCHAR2(10);
  v_mediaType      t_magent_session.mediatype%type;
  v_belongCity     t_magent_session.belongcity%type;
  v_serviceId      t_magent_session.serviceid%type;
  --v_Index      NUMBER(4) := 1;
  --v_oneSessionId   t_magent_webchatrecord.sessionid%type;
  --v_sessionIds     varchar2(2000);

  v_sql1           VARCHAR2(2000);
  v_where1         VARCHAR2(3000):='';
  v_where1_1       VARCHAR2(3000):='';
  v_sql2           VARCHAR2(2000);
  v_where2         VARCHAR2(3000):='';
  v_where2_1       VARCHAR2(3000):='';

  v_sql            VARCHAR2(4000);
  --v_Count          pls_integer;
  PARAMETER_ERROR  exception;
BEGIN
  if (i_startTime is null or i_endTime is null) then
    raise PARAMETER_ERROR;
  end if;

  v_sql1 := 'SELECT /*+ index(C, PK_MAGENT_SAT_ACCNO_SATTIME IX_MAGENT_SAT_SESSIONID) index(A,IX_MAGENT_SESSION_STIME) index(B, IX_MAGENT_WEBRH_SID) */  to_number(B.Serialno) Serialno, A.Sessionid, A.STARTTIME,(A.Endtime - 1 / 48) AS Endtime, A.LOGINIP,B.ACCEPTNO,';
  v_sql1 := v_sql1 || ' B.REPLYMETHOD,B.REPLYSTAFFNO,A.USERGRADE,B.REPLYEMAIL,NVL(B.Replytype, 0) Replytype, B.REPLYTEL,C.SATISFACTIONTFLAG,decode(A.ENDCAUSE, NULL, ''0'', ''1'') STAFFHANGUP, NVL(A.QCFLAG, 0) QCFLAG, a.QCSTAFFNO,A.ENDCAUSE,';
  v_sql1 := v_sql1 || ' decode(B.Requesttime,null,''座席''||B.Replystaffno||''于''||to_char(B.Replytime,''yyyy-mm-dd hh24:mi:ss'')||''回复：''||B.Replycontent, ''用户''||B.Acceptno||''于''||to_char(B.Requesttime,''yyyy-mm-dd hh24:mi:ss'')||''发送：''||B.Requestcontent) chatcontent';
  v_sql1 := v_sql1 || '   FROM t_Magent_Session A, t_magent_webchatrecord B, t_magent_satisfaction C ';
  v_where1 := ' WHERE A.Sessionid = B.Sessionid ';
  v_where1 := v_where1 || 'AND B.REPLYSTAFFNO = C.REPLYSTAFFNO(+) AND B.SESSIONID = C.SESSIONID(+) AND B.Acceptno = C.Acceptno(+)';
  if (i_startTime is not null) then
    v_where1 := v_where1 || 'AND A.STARTTIME > TO_DATE(:startTime, ''YYYY-MM-DD HH24:MI:SS'')';
    v_startTime := i_startTime;
  else
    v_where1  := v_where1 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where1 := v_where1 || 'AND A.STARTTIME < TO_DATE(:endTime, ''YYYY-MM-DD HH24:MI:SS'')';
    v_endTime := i_endTime;
  else
    v_where1  := v_where1 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;

  /*if (i_startTime is not null) then
    v_where1 := v_where1 || 'AND C.SATISFACTIONTIME > TO_DATE(:startTime, ''YYYY-MM-DD HH24:MI:SS'')';
    v_startTime := i_startTime;
  else
    v_where1  := v_where1 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where1 := v_where1 || 'AND C.SATISFACTIONTIME < TO_DATE(:endTime, ''YYYY-MM-DD HH24:MI:SS'')';
    v_endTime := i_endTime;
  else
    v_where1  := v_where1 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;*/

  if (i_replyMethod is not null) then
    v_where1_1 := v_where1_1 || 'AND B.REPLYMETHOD = :replyMethod ';
    v_replyMethod := i_replyMethod;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :replyMethod ';
    v_replyMethod := '1';
  end if;

  if (i_acceptNo is not null) then
    v_where1_1 := v_where1_1 || 'AND B.ACCEPTNO = :acceptNo ';
    v_acceptNo := i_acceptNo;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :acceptNo ';
    v_acceptNo := '1';
  end if;

  if (i_sessionId is not null) then
    if Instr(i_sessionId, ';')!=0 then
/*      WHILE (GetParamStr(i_sessionId, ';', v_Index, v_oneSessionId) = 0)
       LOOP
        BEGIN
          --循环生成in语句
          if(v_sessionIds is null) then
            v_sessionIds := '''' || v_oneSessionId || '''';
          else
            v_sessionIds := v_sessionIds || ',''' || v_oneSessionId || '''';
          end if;
          v_Index:= v_Index + 1;
        END;
      END LOOP;*/
      --这里只需要替换掉，不是取出一个一个的值，因此用下面的方法。
      v_where1_1 := v_where1_1 || 'AND B.SESSIONID in (:sessionId, '''||replace(i_sessionId,';', ''',''')||''') ';
      v_sessionId := '1';
    else
      v_where1_1 := v_where1_1 || 'AND B.SESSIONID = :sessionId ';
      v_sessionId := i_sessionId;
    end if;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :sessionId ';
    v_sessionId := '1';
  end if;

  if (i_replyStaffNo is not null) then
    v_where1_1 := v_where1_1 || 'AND B.REPLYSTAFFNO = :replyStaffNo ';
    v_replyStaffNo := i_replyStaffNo;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :replyStaffNo ';
    v_replyStaffNo := '1';
  end if;

  if (i_userGrade is not null) then
    v_where1_1 := v_where1_1 || 'AND A.USERGRADE = :userGrade ';
    v_userGrade := i_userGrade;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :userGrade ';
    v_userGrade := '1';
  end if;

  if (i_requestContent is not null) then
    v_where1_1 := v_where1_1 || 'AND B.requestcontent LIKE ''%'' || :requestContent || ''%'' ';
    v_requestContent := i_requestContent;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :requestContent ';
    v_requestContent := '1';
  end if;

  if (i_satisfyFlag is not null) then
    v_where1_1 := v_where1_1 || ' AND C.SATISFACTIONTFLAG = :satisfactionFlag ';
    v_satisfyFlag := to_number(i_satisfyFlag);
  else
    v_where1_1  := v_where1_1 || ' and 1 = :satisfactionFlag ';
    v_satisfyFlag := 1;
  end if;

  if (i_replyEmail is not null) then
    v_where1_1 := v_where1_1 || ' AND B.REPLYEMAIL like ''%'' || :replyEmail || ''%'' ';
    v_replyEmail := i_replyEmail;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :replyEmail ';
    v_replyEmail := '1';
  end if;

  if(i_mediaType is not null) then
    v_where1_1 := v_where1_1 || ' AND A.MEDIATYPE = :v_mediaType';
    v_mediaType := i_mediaType;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :v_mediaType ';
    v_mediaType := '1';
  end if;

  if(i_belongCity is not null) then
    v_where1_1 := v_where1_1 || ' AND A.BELONGCITY = :v_belongCity';
    v_belongCity := i_belongCity;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :v_belongCity ';
    v_belongCity := '1';
  end if;

   if(i_serviceId is not null) then
    v_where1_1 := v_where1_1 || ' AND A.SERVICEID = :v_serviceId';
    v_serviceId := i_serviceId;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :v_serviceId ';
    v_serviceId := '1';
  end if;

  if(i_chatFlagYes is not null) then
    v_where1_1 := v_where1_1 || ' And exists(select 1 from t_c_magent_chatflag t1 where t1.sessionid=b.sessionid and t1.flag=:v_chatFlagYes)';
    v_chatFlagYes := i_chatFlagYes;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :v_chatFlagYes ';
    v_chatFlagYes := '1';
  end if ;

  if(i_chatFlagNo is not null) then
    v_where1_1 := v_where1_1 || ' And not exists(select 1 from t_c_magent_chatflag t3 where t3.sessionid=b.sessionid and t3.flag=:v_chatFlagNo)';
    v_chatFlagNo := i_chatFlagNo;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :v_chatFlagNo ';
    v_chatFlagNo := '1';
  end if ;

    if(i_deptCode is not null) then
    v_where1_1 := v_where1_1 || ' AND EXISTS (SELECT t1.staffid FROM  t_ucp_staffbasicinfo t1,t_ucp_orgainfo t2
                            where B.REPLYSTAFFNO=t1.staffid  and t1.orgaid=t2.orgaid and t2.orgacode LIKE (
                            select t2.orgacode||''%'' from t_ucp_orgainfo t2 where t2.orgaid=:v_deptCode))';
    v_deptCode := i_deptCode;
  else
    v_where1_1  := v_where1_1 || ' and ''1'' = :v_deptCode ';
    v_deptCode := '1';
  end if ;



  v_sql2 := ' UNION ALL SELECT /*+ index(A,IXL_MAGENT_SESSIONHIS_STIME) index(B, IX_MAGENT_WEBRH_SID) */  to_number(B.Serialno) Serialno, A.Sessionid,A.STARTTIME,(A.Endtime - 1 / 48) AS Endtime, A.LOGINIP,B.ACCEPTNO,B.REPLYMETHOD,B.REPLYSTAFFNO,A.USERGRADE,B.REPLYEMAIL,NVL(B.Replytype, 0) Replytype,B.REPLYTEL,C.SATISFACTIONTFLAG,decode(A.ENDCAUSE, NULL, ''0'', ''1'') STAFFHANGUP,NVL(A.QCFLAG, 0) QCFLAG, a.QCSTAFFNO,A.ENDCAUSE,';
  v_sql2 := v_sql2 || 'decode(B.Requesttime,null,''座席''||B.Replystaffno||''于''||to_char(B.Replytime,''yyyy-mm-dd hh24:mi:ss'')||''回复：''||B.Replycontent, ''用户''||B.Acceptno||''于''||to_char(B.Requesttime,''yyyy-mm-dd hh24:mi:ss'')||''发送：''||B.Requestcontent) chatcontent ';
  v_sql2 := v_sql2 || '  FROM t_Magent_Sessionhis A, t_magent_webchatrecordhis B, t_magent_satisfactionhis C ';
  v_where2 := ' WHERE A.Sessionid = B.Sessionid AND B.REPLYSTAFFNO = C.REPLYSTAFFNO(+) AND B.SESSIONID = C.SESSIONID(+) AND B.Acceptno = C.Acceptno(+) ';
  if (i_startTime is not null) then
    v_where2 := v_where2 || 'AND A.STARTTIME > TO_DATE(:startTime, ''YYYY-MM-DD HH24:MI:SS'') ';
    v_startTime := i_startTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where2 := v_where2 || 'AND A.STARTTIME < TO_DATE(:endTime, ''YYYY-MM-DD HH24:MI:SS'') ';
    v_endTime := i_endTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;

  /*if (i_startTime is not null) then
    v_where2 := v_where2 || 'AND C.SATISFACTIONTIME > TO_DATE(:startTime, ''YYYY-MM-DD HH24:MI:SS'') ';
    v_startTime := i_startTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where2 := v_where2 || 'AND C.SATISFACTIONTIME < TO_DATE(:endTime, ''YYYY-MM-DD HH24:MI:SS'') ';
    v_endTime := i_endTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;*/

  if (i_startTime is not null) then
    v_where2 := v_where2 || 'AND A.PARTID >= TO_CHAR(TO_DATE(:startTime, ''yyyy-mm-dd hh24:mi:ss''), ''yyyymmdd'') ';
    v_startTime := i_startTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where2 := v_where2 || 'AND A.PARTID <= TO_CHAR(TO_DATE(:endTime, ''yyyy-mm-dd hh24:mi:ss'') + 1, ''yyyymmdd'') ';
    v_endTime := i_endTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;

  if (i_startTime is not null) then
    v_where2 := v_where2 || 'AND B.PARTID >= TO_CHAR(TO_DATE(:startTime, ''yyyy-mm-dd hh24:mi:ss''), ''yyyymmdd'') ';
    v_startTime := i_startTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where2 := v_where2 || 'AND B.PARTID <= TO_CHAR(TO_DATE(:endTime, ''yyyy-mm-dd hh24:mi:ss'') + 1, ''yyyymmdd'') ';
    v_endTime := i_endTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;

  if (i_startTime is not null) then
    v_where2 := v_where2 || 'AND C.PARTID >= TO_CHAR(TO_DATE(:startTime, ''yyyy-mm-dd hh24:mi:ss''), ''yyyymmdd'') ';
    v_startTime := i_startTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :startTime ';
    v_startTime := '1';
  end if;
  if (i_endTime is not null) then
    v_where2 := v_where2 || 'AND C.PARTID <= TO_CHAR(TO_DATE(:endTime, ''yyyy-mm-dd hh24:mi:ss'') + 1, ''yyyymmdd'') ';
    v_endTime := i_endTime;
  else
    v_where2  := v_where2 || ' and ''1'' = :endTime ';
    v_endTime := '1';
  end if;

  if (i_replyMethod is not null) then
    v_where2_1    := v_where2_1 || 'AND B.REPLYMETHOD = :replyMethod ';
    v_replyMethod := i_replyMethod;
  else
    v_where2_1    := v_where2_1 || ' and ''1'' = :replyMethod ';
    v_replyMethod := '1';
  end if;

  if (i_acceptNo is not null) then
    v_where2_1 := v_where2_1 || 'AND B.ACCEPTNO = :acceptNo ';
    v_acceptNo := i_acceptNo;
  else
    v_where2_1 := v_where2_1 || ' and ''1'' = :acceptNo ';
    v_acceptNo := '1';
  end if;

  if (i_sessionId is not null) then
    v_where2_1  := v_where2_1 || 'AND B.SESSIONID = :sessionId ';
    v_sessionId := i_sessionId;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :sessionId ';
    v_sessionId := '1';
  end if;

  if (i_replyStaffNo is not null) then
    v_where2_1 := v_where2_1 || 'AND B.REPLYSTAFFNO = :replyStaffNo ';
    v_replyStaffNo := i_replyStaffNo;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :replyStaffNo ';
    v_replyStaffNo := '1';
  end if;

  if (i_userGrade is not null) then
    v_where2_1 := v_where2_1 || 'AND A.USERGRADE = :userGrade ';
    v_userGrade := i_userGrade;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :userGrade ';
    v_userGrade := '1';
  end if;

  if (i_requestContent is not null) then
    v_where2_1 := v_where2_1 || ' AND B.requestcontent LIKE ''%'' || :requestContent || ''%'' ';
    v_requestContent := i_requestContent;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :requestContent ';
    v_requestContent := '1';
  end if;

  if (i_satisfyFlag is not null) then
    v_where2_1 := v_where2_1 || ' AND C.SATISFACTIONTFLAG = :satisfactionFlag ';
    v_satisfyFlag := to_number(i_satisfyFlag);
  else
    v_where2_1  := v_where2_1 || ' and 1 = :satisfactionFlag ';
    v_satisfyFlag := 1;
  end if;

  if (i_replyEmail is not null) then
    v_where2_1 := v_where2_1 || ' AND B.REPLYEMAIL like ''%'' || :replyEmail || ''%'' ';
    v_replyEmail := i_replyEmail;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :replyEmail ';
    v_replyEmail := '1';
  end if;

  if(i_mediaType is not null) then
    v_where2_1 := v_where2_1 || ' AND A.MEDIATYPE = :v_mediaType';
    v_mediaType := i_mediaType;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :v_mediaType ';
    v_mediaType := '1';
  end if;

  if(i_belongCity is not null) then
    v_where2_1 := v_where2_1 || ' AND A.BELONGCITY = :v_belongCity';
    v_belongCity := i_belongCity;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :v_belongCity ';
    v_belongCity := '1';
  end if;

   if(i_serviceId is not null) then
    v_where2_1 := v_where2_1 || ' AND A.SERVICEID = :v_serviceId';
    v_serviceId := i_serviceId;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :v_serviceId ';
    v_serviceId := '1';
  end if;

    if(i_chatFlagYes is not null) then
    v_where2_1 := v_where2_1 || ' And exists(select 1 from t_c_magent_chatflag t1 where t1.sessionid=b.sessionid and t1.flag=:v_chatFlagYes)';
    v_chatFlagYes := i_chatFlagYes;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :v_chatFlagYes ';
    v_chatFlagYes := '1';
  end if ;

  if(i_chatFlagNo is not null) then
    v_where2_1 := v_where2_1 || ' And not exists(select 1 from t_c_magent_chatflag t3 where t3.sessionid=b.sessionid and t3.flag=:v_chatFlagNo)';
    v_chatFlagNo := i_chatFlagNo;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :v_chatFlagNo ';
    v_chatFlagNo := '1';
  end if ;

    if(i_deptCode is not null) then
    v_where2_1 := v_where2_1 || ' AND EXISTS (SELECT t1.staffid FROM  t_ucp_staffbasicinfo t1,t_ucp_orgainfo t2
                            where B.REPLYSTAFFNO=t1.staffid  and t1.orgaid=t2.orgaid and t2.orgacode LIKE (
                            select t2.orgacode||''%'' from t_ucp_orgainfo t2 where t2.orgaid=:v_deptCode))';
    v_deptCode := i_deptCode;
  else
    v_where2_1  := v_where2_1 || ' and ''1'' = :v_deptCode ';
    v_deptCode := '1';
  end if ;



  v_sql := v_sql1||v_where1||v_where1_1||v_sql2||v_where2||v_where2_1||'order by Sessionid,Serialno';


  OPEN o_cur FOR v_sql using v_startTime,v_endTime,
                             v_replyMethod,v_acceptNo,
                             v_sessionId,v_replyStaffNo,v_userGrade,v_requestContent,
                             v_satisfyFlag,v_replyEmail,
                             v_mediaType, v_belongCity,
                             v_serviceId,v_chatFlagYes,
                             v_chatFlagNo,v_deptCode,
                             v_startTime,v_endTime,
                             v_startTime,v_endTime,
                             v_startTime,v_endTime,
                             v_startTime,v_endTime,
                             v_replyMethod,v_acceptNo,
                             v_sessionId,v_replyStaffNo,v_userGrade,v_requestContent,
                             v_satisfyFlag,v_replyEmail,
                             v_mediaType, v_belongCity,
                             v_serviceId,v_chatFlagYes,
                             v_chatFlagNo,v_deptCode
                             ;



  --o_count := v_count;
    o_ret := 0;
  commit;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    o_ret := 1;
    OPEN o_cur FOR 'SELECT ''查询异常'' Serialno, ''查询异常'' Sessionid, sysdate STARTTIME,
     sysdate Endtime, '''' LOGINIP, '''' ACCEPTNO, '''' REPLYMETHOD, '''' REPLYSTAFFNO,
     '''' USERGRADE,'''' REPLYEMAIL,0 Replytype, '''' REPLYTEL,1 SATISFACTIONTFLAG,
     ''0'' STAFFHANGUP, 0 QCFLAG, ''查询异常'' QCSTAFFNO, ''查询异常'' ENDCAUSE, ''查询异常'',
     ''查询异常'' as chatcontent
      from dual ';
  --o_count := 1;
END p_c_magent_getwebchatrecord;
