-- ----------------------------------- MySQL 中常用的函数（总结）-------------------------------------------------

-- 字符串函数
SELECT CONCAT_WS('-','1st','2nd','3rd'),CONCAT_WS('-','1st',NULL,'3rd'); -- 字符串拼接；
SELECT INSERT('warWalf',2,2,'BB'); -- 替换
SELECT LPAD('hello',4,'??'),RPAD('hello',10,'??'); -- 填充
SELECT TRIM(' book ') `trim`; -- 去除两端空格
SELECT TRIM('xy' FROM 'xyxboxyokxxyxy');
SELECT REPEAT('str',3); -- 重复
SELECT STRCMP('txt','txt2') ,STRCMP('txt2','txt'),STRCMP('txt','txt'); -- 返回-1 或 1 或 0
SELECT LOCATE('ball','football'),POSITION('ball' IN 'football') ,INSTR('football','ball'); -- 查找位置
SELECT ELT(3,'1st','2nd','3rd'),ELT(3,'net','os'); -- 查找字符串
SELECT FIELD('hi','hihi','hey','hi','bas') AS coll1,
FIELD('hi','hihi','lo','hilo','foo') AS col2; -- 查找
SELECT FIND_IN_SET('hi','hihi,hey,hi,bas'); 
SELECT MAKE_SET(1,'a','b','c') AS col1,
MAKE_SET(1|4,'hello','nice','world') AS col2; -- 二进制返回的字符串；

-- 数值函数
SELECT TRUNCATE(1.32,1); -- 截取小数后一位
SELECT MOD(31,8);
SELECT ROUND(1.36,1);
SELECT HEX('this is a test str'); -- 十六进制表示； 

DELIMITER $$
SELECT *  ,CHAR_LENGTH(NAME) c FROM testchar $$ -- 对于char型的字符串会去除左右的空格
SELECT *  ,LENGTH(NAME) varc FROM testvarchar $$
END $$
DELIMITER ;

-- 日期时间函数
SELECT NOW(),CURDATE(),CURRENT_DATE(),CURRENT_TIMESTAMP(),LOCALTIME(),SYSDATE(); -- 2017-08-07 14:14:49 2017-08-07 2017-08-07 2017-08-07 14:14:49 2017-08-07 14:14:49 2017-08-07 14:14:49
SELECT UTC_DATE(),UTC_TIME();
SELECT MONTHNAME('2013-8-2')；-- 获取月份；August
SELECT QUARTER('11-04-01'); -- 返回季度 1~4
SELECT MINUTE('11-02-03 10:10:06'); -- 分钟
SELECT SECOND('10:23:10'); -- 秒数
SELECT DAYNAME('2013-2-3'); -- 返回星期 Sunday
SELECT EXTRACT(YEAR FROM '2013-2-3'); -- 返回年数 2013
SELECT TIME_TO_SEC('23:22:00'); -- 转换为秒数；转换公式为：小时*3600+分钟*60+秒  84120
SELECT SEC_TO_TIME('84120'); -- 转换为时间； 23:22:00

-- *日期与时间的比较* -- 
SELECT DATE_ADD('2013-2-3',INTERVAL 1 MONTH); -- 增加日期：2013-03-03 
SELECT ADDDATE('2013-2-3',INTERVAL 1 WEEK); 
SELECT DATE_SUB('2013-2-3',INTERVAL 1 WEEK); -- 减少日期：2013-01-27
SELECT SUBDATE('2013-2-3',INTERVAL 1 WEEK); 
SELECT ADDTIME('2013-2-3 01:05:06','10:50:20'); -- 增加时间：2013-02-03 11:55:26
SELECT SUBTIME('2013-2-3 01:05:06','10:50:20'); -- 减少时间：2013-02-02 14:14:46
SELECT DATEDIFF('2008-12-30','2007-12-29') AS DiffDate；-- 时间差,返回天数；
SELECT LAST_DAY('2003-02-05');  -- 每月最后一天：2003-02-28
SELECT DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s');-- 格式化日期 2017-08-07 10:20:11
-- SELECT TIME_FORMAT('100:00:00', '%H %k %h %I %l'); -- 格式化时间 '%H %k %h %I %l' 表示小时
 SELECT DATE_FORMAT(NOW(),GET_FORMAT(TIMESTAMP,'ISO')); -- 格式化日期 2017-08-07 10:36:35 
 
# 表结构
# CREATE TABLE `testuser` (
# `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
# `name` varchar(30) DEFAULT NULL COMMENT '姓名',
# `gender` char(5) DEFAULT NULL COMMENT '性别',
# `address` varchar(30) DEFAULT NULL COMMENT '籍贯',
# `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '录入时间',
# PRIMARY KEY (`id`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8

 -- 查询当天、昨天、近一周、当月、上个月、下个月。。。 数据
SELECT * FROM testuser WHERE TO_DAYS(create_time) = TO_DAYS(NOW()); -- 当天数据
SELECT * FROM testuser WHERE testuser.create_time LIKE CONCAT('%',DATE_FORMAT(NOW(),'%Y-%m-%d'),'%'); -- 当天数据
SELECT * FROM testuser WHERE TO_DAYS(NOW()) - TO_DAYS(create_time) = 1; -- 昨天数据
SELECT * FROM testuser WHERE create_time > DATE_SUB(NOW(), INTERVAL 7 DAY) AND create_time <= NOW(); -- 近7天
SELECT * FROM testuser WHERE create_time > DATE_SUB(NOW(), INTERVAL 30 DAY) AND create_time <= NOW(); -- 近30天
SELECT * FROM testuser WHERE WEEKOFYEAR(create_time) = WEEKOFYEAR(NOW()); -- 当前这周数据(不包括上周日)
SELECT * FROM testuser WHERE YEARWEEK(DATE_FORMAT(create_time,'%Y-%m-%d')) = YEARWEEK(NOW()); -- 当前这周数据(包括上周日)
SELECT * FROM testuser WHERE YEARWEEK(DATE_FORMAT(create_time,'%Y-%m-%d')) = YEARWEEK(NOW())-1; -- 上一周数据
SELECT * FROM testuser WHERE WEEKOFYEAR(create_time) = WEEKOFYEAR(NOW())-1; -- 上一周数据
SELECT * FROM testuser WHERE DATE_FORMAT(create_time, '%Y%m') = DATE_FORMAT(CURDATE(), '%Y%m'); -- 本月数据
SELECT * FROM testuser WHERE PERIOD_DIFF( DATE_FORMAT(NOW(),'%Y%m'),DATE_FORMAT(create_time,'%Y%m')) =1; -- 上月数据
SELECT * FROM testuser WHERE QUARTER(create_time)= QUARTER(NOW()); -- 本季度的数据
SELECT * FROM testuser WHERE QUARTER(create_time)= QUARTER(DATE_SUB(NOW(),INTERVAL 1 QUARTER)); -- 上季度的数据
SELECT * FROM testuser WHERE QUARTER(create_time)= QUARTER(DATE_ADD(NOW(),INTERVAL 1 QUARTER)); -- 下季度的数据
SELECT * FROM testuser WHERE YEAR(create_time)=YEAR(NOW()); -- 今年的数据
SELECT * FROM testuser WHERE YEAR(create_time)=YEAR(DATE_SUB(NOW(),INTERVAL 1 YEAR)); -- 去年的数据
SELECT * FROM testuser WHERE create_time BETWEEN DATE_SUB(NOW(),INTERVAL 3 MONTH) AND NOW(); -- 距现在3个月的数据

-- 条件判断函数
SELECT IF(3>2,2,3); -- 返回2

-- IFNULL函数
SELECT IFNULL(1,2),IFNULL(NULL,10); -- 假如V1不为NULL，则IFNULL(V1,V2)的返回值为v1；否则其返回值为v2

# CASE函数

# 语法 一：
#	SELECT 
#	    表字段名,
#	CASE
#	    WHEN （Bollean值）条件1 THEN 结果表达式1
#	    WHEN （Bollean值）条件2 THEN 结果表达式2
#	    ELSE 结果表达式3 END  
#	FROM 表名
#

# 语法 二：
#	SELECT 
#	    表字段名1,
#	CASE 表字段名2
#	    WHEN 值1 THEN 结果表达式1
#	    WHEN 值2 THEN 结果表达式2
#	    ELSE 结果表达式3  END 
#	FROM 表名
#

-- MySQL系统信息函数

SELECT VERSION(),CONNECTION_ID(); -- 返回MySQL 的版本、链接数（ID）
SHOW PROCESSLIST; -- 查看线程，只显示100个
SHOW FULL PROCESSLIST; -- 包括所有
SELECT DATABASE(),SCHEMA(); -- 当前数据库

SELECT USER(),CURRENT_USER(),SYSTEM_USER(),SESSION_USER();-- 用户名
SELECT CHARSET('abc') ,CHARSET(CONVERT('abc' USING latin1)),CHARSET(VERSION()); -- 字符集
SELECT COLLATION(_latin2 'abc'),COLLATION(CONVERT('abc' USING utf8)); -- 字符集排列方式 latin2_general_ci utf8_general_ci

 -- 加密函数
 SELECT PASSWORD('NEWPWD'); -- *067906D546600BF74D1435B72BDD12D45421DD17
 SELECT MD5('123'); -- (32位十六进制数字组成) 202cb962ac59075b964b07152d234b70
 
 SELECT ENCODE('uetec','123'); -- '123'密码 'uetec'加密字符串	 ��WJ 加密后乱码
#	|
#	|
#	|
#      解密
SELECT DECODE(ENCODE('uetec','123'),'123'); -- uetec
-- 格式化函数,数字格式化,进行四舍五入
SELECT FORMAT(12332.123465,4); -- 12,332.1235
-- 进制转换
SELECT CONV('a',16,2); -- 1010 将十六进制的a转换为二进制表示的数值
-- IP地址与数字相互转换的函数，优化存储空间
SELECT INET_ATON('192.168.1.200'); -- 3232235976
SELECT INET_NTOA('3232235976'); -- 192.168.1.200
-- 加锁、解锁
#select GET_LOCK('keySock',1000) from testchar;
#insert into testchar(id,`name`) value(null,'suo1');
#SELECT release_LOCK('keySock') FROM testchar;

#SELECT GET_LOCK('keySock',1000) FROM testchar;
#INSERT INTO testchar(id,`name`) VALUE(NULL,'suo2');
#SELECT RELEASE_LOCK('keySock') FROM testchar;
#SELECT IS_FREE_LOCK('keySock') FROM testchar;
#SELECT IS_USED_LOCK('keySock') FROM testchar;
#INSERT INTO testchar(id,`name`) VALUE(3,'suo3');

#SELECT BENCHMARK(500000,PASSWORD('uetec'));

-- 改变字符集函数
SELECT  CHARSET('string'),CHARSET(CONVERT('string' USING latin1)); -- 字符集
-- 数据类型的转换
SELECT  CAST(100 AS CHAR(2)),CONVERT('2013-8-9 12:12:12',TIME);

#SHOW VARIABLES LIKE 'character_set_%';  -- 查看当前MySQL使用的字符集






























