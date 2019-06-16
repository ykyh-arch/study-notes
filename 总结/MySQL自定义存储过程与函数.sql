-- ----------------------------------------------------------- MySQL存储过程、函数 -----------------------------------------

-- 创建存储过程 -- 
# 语法：
# CREATE PROCEDURE sp_name ([ proc_parameter ]) [ characteristics..] routine_body 
# 参数：sp_name 存储过程名称
#	proc_parameter 参数列表，形式：[IN|OUT|INOUT] param_name type
#	
#	characteristic: 
#    LANGUAGE SQL  -- SQL语言
#  | [NOT] DETERMINISTIC -- 存储过程执行的结果是否确定
#  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA } -- 程序包含、不包含、读、写SQL语句
#  | SQL SECURITY { DEFINER | INVOKER } -- 安全性  定义者 调用者
#  | COMMENT 'string' -- 注释
# routine_body: -- SQL代码的内容 用BEGIN...END来表示SQL代码的开始和结束
#   Valid SQL procedure statement or statements
#

DROP PROCEDURE IF EXISTS Proc; -- 删除

DELIMITER // -- 封装，更改默认MySQL语句结束符
CREATE PROCEDURE Proc() 
BEGIN
  SELECT * FROM `user`;
END//
DELIMITER ;

CALL Proc(); -- 执行存储过程

DELIMITER $$
CREATE PROCEDURE CountProc(OUT param1 INT)
BEGIN
   SELECT COUNT(*) INTO param1 FROM `user`;
END $$
DELIMITER ;

-- 存储函数 -- 
# 语法：
# CREATE FUNCTION func_name([func_parameter]) -- 函数名称
# RETURNS TYPE -- 函数返回数据的类型
# [characteristics...] routine_body -- 存储函数的特性
#

DELIMITER //

CREATE FUNCTION NameByT()
RETURNS CHAR(50)
RETURN (SELECT `name` FROM `user` WHERE id=2);
//
DELIMITER ;

SELECT nameByT();

-- 变量的使用（在子程序中声明并使用，作用范围是在BEGIN...END子程序中） -- 
-- 定义变量（存储过程中定义变量）
# 语法：DECLARE var_name[,varname]...date_type[DEFAULT VALUE];
DECLARE MYPARAM INT DEFAULT 100;
-- 赋值 
# 语法：SET var_name=expr[,var_name=expr]... ，此外，通过SELECT...INTO为一个或多个变量赋值
# 如：
DECLARE var1,var2,var3 INT;
SET var1=10,var2=20;
SET var3=var1+var2;

SELECT id,`name` INTO id ,`name` FROM `user` WHERE id=2;

-- 定义条件与处理程序 -- 
-- 定义条件
# DECLARE condition_name CONDITION FOR[condition_type]
# [condition_type]:
# SQLSTATE[VALUE] sqlstate_value |mysql_error_code

-- 方法一：使用sqlstate_value
DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000'

-- 方法二：使用mysql_error_code
DECLARE command_not_allowed CONDITION FOR SQLSTATE 1148

-- 处理程序

# DECLARE handler_type HANDLER FOR 
# condition_value[,...] sp_statement 
# handler_type: 
# CONTINUE | EXIT | UNDO 
# condition_value: 
# SQLSTATE [VALUE] sqlstate_value |
# condition_name | SQLWARNING 
# | NOT FOUND | SQLEXCEPTION | mysql_error_code
#


















