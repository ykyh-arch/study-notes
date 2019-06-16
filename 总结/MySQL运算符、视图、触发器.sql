-- ----------------------------------------------------------- MySQL运算符、视图、触发器 -----------------------------------------

-- 安全等于运算符，规则均为NULL时，其返回值为1，否则返回0
SELECT NULL <=>1;  
SELECT 1<=>0; 
SELECT NULL <=>NULL; -- 1
-- LEAST()运算符，返回最小值
SELECT LEAST(2,0),LEAST('a','b','c'),LEAST(10,NULL); -- 0 a null
-- GREATEST()运算符，返回最大值
SELECT GREATEST(2,0),GREATEST('a','b','c'),GREATEST(10,NULL); -- 2 c null
-- REGEXP 运算符（正则表达式）
# 规则
# '^'匹配以该字符后面的字符开头的字符串
# '$'匹配以该字符后面的字符结尾的字符串
# '.'匹配任何一个单字符
# '[...]'匹配在方括号内的任何字符。例如，“[abc]" 匹配a、b或c。字符的范围可以使用一个'-'，“[a-z]”匹配任何字母，而“[0-9]”匹配任何数字	
# '*' 匹配零个或多个在他前面的字符。例如，“x*”匹配任何数量的'*'字符，“[0-9]*”匹配任何数量的数字，而“.*”匹配任何数量的任何字符
# '+' 匹配至少一个在他前面的字符。
# '|' 匹配指定字符串，匹配多个字符串，多个字符串之间使用分隔符“|”隔开
# '[]' 字符集合，只匹配其中任何一个字符
# '[^字符集合]' “[^字符集合]”匹配不在指定集合中的任何字符，如： '[^a-e1-2]'表示开头不在a-e  1-2字母的记录
# '{n,}'或'{n,m}' “字符串{n,}”，表示前面的字符至少匹配n次；“字符串{n,m}”表示匹配前面的字符串不少于n次，不多于m次

-- 逻辑运算符
-- 逻辑与：AND 或&&; 逻辑或 OR或||
SELECT * FROM testuser WHERE gender ='女' AND `name` LIKE '%赵%';
SELECT * FROM testuser WHERE gender ='女' && `name` LIKE '%赵%';

SELECT * FROM testuser WHERE gender ='女' OR `name` LIKE '%赵%';
SELECT * FROM testuser WHERE gender ='女' || `name` LIKE '%赵%';

-- 异或XOR运算符 规则：当任意一个操作数为NULL时，返回值为NULL;对于非NULL的操作数，如果两个操作数都是非0值或者都是0值，则返回结果为0，反之为1，XOR等同于a AND (NOT b))或者NOT a AND (b)
SELECT 1 XOR 1, 0 XOR 0,1 XOR 0,1 XOR NULL,1 XOR 1 XOR 1;

-- MySQL 支持转义字符 
# 单引号：\'
# 双引号：\''
# 反斜杠：\\
# 回车符：\r
# 换行符：\n
# 制表符：\tab
# 退格符：\b
# 如 ：INSERT INTO testvar(`name`) value('\'');

-- 视图（虚表）  -- 
# 语法 ：
# CREATE [OR REPLACE] [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]     -- 创建、替换、选择算法  
# VIEW view_name [(column_list)] -- 视图名、列名
# AS select_statement -- 查询语句
# [WITH [CASCADED | LOCAL] CHECK OPTION] -- 控制权限
#
-- 建表、插入数据
CREATE TABLE student (stuno INT ,stuname NVARCHAR(60));
CREATE TABLE stuinfo (stuno INT ,class NVARCHAR(60),city NVARCHAR(60));
INSERT INTO student VALUES(1,'wanglin'),(2,'gaoli'),(3,'zhanghai');
INSERT INTO stuinfo VALUES(1,'wuban','henan'),(2,'liuban','hebei'),(3,'qiban','shandong');
-- 创建视图
CREATE VIEW stu_class(id,NAME,class) AS SELECT student.`stuno`,student.`stuname`,stuinfo.`class`
FROM student,stuinfo WHERE student.`stuno`=stuinfo.`stuno`;
-- SELECT * FROM stu_class;
-- 查看视图 方法：DESCRIBE、SHOW TABLE STATUS LIKE、SHOW CREATE VIEW
DESCRIBE stu_class; -- 或 DESC stu_class;
SHOW TABLE STATUS LIKE 'stu_class'; -- comment项为view表示视图
-- SHOW TABLE STATUS LIKE 'stuinfo'; -- 基表
SHOW CREATE VIEW stu_class;
SELECT * FROM `information_schema`.`VIEWS`; -- 查看MySQL数据库中所有视图的详细信息

-- 修改视图
# 语法：
# ALTER OR REPLACE [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
# VIEW view_name [(column_list)]
# AS select_statement
# [WITH [CASCADED | LOCAL] CHECK OPTION]
#

DELIMITER $$

CREATE OR REPLACE VIEW `stu_class` AS 
SELECT
  `student`.`stuno`   AS `id`
FROM (`student` JOIN `stuinfo`)
WHERE (`student`.`stuno` = `stuinfo`.`stuno`)$$

DELIMITER ;

-- 查看
DESC stu_class;
SELECT * FROM stu_class;
-- 修改视图
ALTER VIEW stu_class AS SELECT stuno FROM student;
SELECT * FROM stu_class;

-- 更新视图（通过视图更新的时候都是转到基表进行更新，如果对视图增加或者删除记录，实际上是对基表增加或删除记录）
-- 修改
ALTER VIEW stu_class AS SELECT stuno,stuname FROM student;
-- 修改视图
UPDATE stu_class SET stuname='xiaofang' WHERE stuno=2; -- SELECT * FROM student; -- 原表的数据也改变
INSERT INTO stu_class VALUES(6,'haojie');
DELETE FROM stu_class WHERE stuno=1;

-- 删除视图 -- 
# 语法 ：
# DROP VIEW [IF EXISTS]
# view_name [, view_name] ...
# [RESTRICT | CASCADE]
#

DROP VIEW IF EXISTS stu_class; 
-- SHOW CREATE VIEW stu_class; -- Table 'trigger_test.stu_class' doesn't exist

-- 触发器 --
# 语法：
# CREATE TRIGGER trigger_name trigger_time trigger_event  
# ON tbl_name FOR EACH ROW trigger_stmt
# 参数解释 ：trigger_name 触发器名称; trigger_time 触发时间，值有：BEFORE或AFTER; trigger_event 激发事件，值有：INSERT UPDATE DELETE 
#	     tbl_name 表名 trigger_stmt 触发程序激活时执行的语句，是BEGIN ... END复合语句结构。
#

-- 单执行触发器
#CREATE TABLE account(acct_num INT ,amount DECIMAL(10,2));
#CREATE TRIGGER ins_sum BEFORE INSERT ON account
#FOR EACH ROW SET @SUM=@SUM+new.amount;

#DECLARE @num INT
#SET @num=0
#INSERT INTO account VALUES(1,1.00),(2,2.00)
#SELECT @num
#select * from account;

-- 多执行触发器
-- 建表
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `account` VARCHAR(255) DEFAULT NULL COMMENT '用户账号',
  `name` VARCHAR(255) DEFAULT NULL COMMENT '用户姓名',
  `address` VARCHAR(255) DEFAULT NULL COMMENT '用户地址',
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user_history`;
CREATE TABLE `user_history` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `operatetype` VARCHAR(200) NOT NULL COMMENT '操作的类型',
  `operatetime` DATETIME NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- 创建触发器
DROP TRIGGER IF EXISTS `tri_insert_user`;
DELIMITER ;;
CREATE TRIGGER `tri_insert_user` AFTER INSERT ON `user` FOR EACH ROW BEGIN -- 新增
    INSERT INTO user_history(user_id, operatetype, operatetime) VALUES (new.id, 'add a user', NOW());
END
;;
DELIMITER ;

DROP TRIGGER IF EXISTS `tri_update_user`;
DELIMITER $$
CREATE TRIGGER `tri_update_user` AFTER UPDATE ON `user` FOR EACH ROW BEGIN -- 修改
    INSERT INTO user_history(user_id,operatetype, operatetime) VALUES (new.id, 'update a user', NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS `tri_delete_user`;
DELIMITER |
CREATE TRIGGER `tri_delete_user` AFTER DELETE ON `user` FOR EACH ROW BEGIN -- 删除
    INSERT INTO user_history(user_id, operatetype, operatetime) VALUES (old.id, 'delete a user', NOW());
END
|
DELIMITER ;

-- 向user表中插入数据
INSERT INTO `user`(account, `name`, address) VALUES ('zhangsan.@sina.cn', 'zhangsan', '合肥');
INSERT INTO `user`(account, `name`, address) VALUES ('lisi.@sina.cn', 'lisi', '蚌埠');
INSERT INTO `user`(account, `name`, address) VALUES ('wangwu.@sina.cn', 'wangwu', '芜湖'),('zhaoliu.@sina.cn', 'zhaoliu', '安庆');
-- 向user表中修改数据
UPDATE `user` SET `name` = 'qianqi', account = 'qianqi.@sina.cn', address='铜陵' WHERE `name`='zhaoliu';
-- 向user表中删除数据
DELETE FROM `user` WHERE `name` = 'wangwu';

-- 查看触发器
SHOW TRIGGERS;
SELECT * FROM `information_schema`.`TRIGGERS` WHERE `TRIGGER_NAME`='ins_sum'; -- 查看指定触发器
-- 删除触发器（基表删除后，触发器不复存在）
# 语法：DROP TRIGGER [schema_name.]trigger_name
DROP TRIGGER `trigger_test`.`ins_sum`;































