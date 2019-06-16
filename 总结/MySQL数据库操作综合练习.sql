############################################# MySQL 查询语句综合练习 ##################################################

-- 数据库设计
-- 老师信息实体
CREATE TABLE teacherinfo
(
	-- 老师编号
	teacherid INT AUTO_INCREMENT PRIMARY KEY,
	-- 老师姓名
	teachername VARCHAR(10) NOT NULL,
	-- 老师性别
	teachergender ENUM('男', '女') NOT NULL,
	-- 老师年龄
	teacherage INT NOT NULL
);
-- 学生信息实体
CREATE TABLE studentinfo
(
	-- 学生编号
	studentid INT AUTO_INCREMENT PRIMARY KEY,
	-- 学生姓名
	studentname VARCHAR(10) NOT NULL,
	-- 学生性别
	studentgender ENUM('男', '女') NOT NULL,
	-- 学生年龄
	studentage INT NOT NULL
);
-- 课程信息实体
CREATE TABLE courseinfo
(
	-- 课程编号
	courseid INT AUTO_INCREMENT PRIMARY KEY,
	-- 课程名称
	coursename VARCHAR(10) NOT NULL,
	-- 老师编号
	teacherid INT NOT NULL
);
-- 得分实体信息
CREATE TABLE scoreinfo
(
	-- 成绩编号
	scoreid INT AUTO_INCREMENT PRIMARY KEY,
	-- 学生编号
	studentid INT NOT NULL,
	-- 课程编号
	courseid INT NOT NULL,
	-- 成绩分数
	score DECIMAL(4, 1)
);
-- 插入测试数据
INSERT INTO courseinfo VALUES(NULL, '语文', 1), (NULL, '数学', 2), (NULL, '英语', 1);
INSERT INTO teacherinfo VALUES(NULL, '张老师', '男', 60),(NULL, '王老师', '女', 30), (NULL, '李老师', '男', 40);
INSERT INTO studentinfo VALUES(NULL, '刘备', '男', 35),(NULL, '关羽', '男', 30),(NULL, '张飞', '男', 25),
(NULL, '貂蝉', '女', 15), (NULL, '吕布', '男', 33),(NULL, '甄姬', '女', 22);

INSERT INTO scoreinfo VALUES(NULL, 1, 1, 60), (NULL, 1, 2, 90),(NULL, 1, 3, 80),(NULL, 1, 4, 70),(NULL, 1, 5, 40),
(NULL, 2, 1, 70), (NULL, 2, 2, 50),(NULL, 2, 3, 70),(NULL, 2, 4, 30),(NULL, 2, 5, 90),
(NULL, 3, 1, 55), (NULL, 3, 2, 65),(NULL, 3, 3, 75),
(NULL, 4, 1, 87),(NULL, 4, 2, 63),(NULL, 4, 4, 28);
-- 查表信息
SELECT * FROM studentinfo;
SELECT * FROM courseinfo;
SELECT * FROM teacherinfo;
SELECT * FROM scoreinfo;
#########################################################  SQL查询 #######################################################

-- 1、查询姓张的老师的数量
SELECT COUNT(*) AS 张姓数量 FROM teacherinfo WHERE teacherinfo.`teachername` LIKE '张%'; -- '张_' ：表示张X,_只占一个字符
-- 2、查询每门功课选修的学生数量
SELECT c.`coursename` AS 课程名称,temp.stu_num AS 学生数量 FROM courseinfo AS c
JOIN 
(SELECT COUNT(scoreinfo.`studentid`) AS stu_num, scoreinfo.`courseid` AS courseid FROM scoreinfo 
GROUP BY  scoreinfo.`courseid`) AS temp
ON c.`courseid` = temp.courseid;

SELECT 
  c.`coursename` AS 课程名称,
  (SELECT 
    COUNT(scoreinfo.`studentid`) 
  FROM
    scoreinfo 
  WHERE scoreinfo.`courseid` = c.`courseid` 
  GROUP BY scoreinfo.`courseid`) AS 学生数量 
FROM
  courseinfo AS c ;

-- 3、查询个人平均成绩高于60分的学生编号、学生姓名 和 个人平均成绩（如果得到的人数超过2人，显示第二条记录和第三条记录）
SELECT st.`studentid` AS 学生编号,st.`studentname` AS 学生姓名,
temp.avgscore AS 平均分
FROM 
(SELECT AVG(scoreinfo.`score`) AS avgscore, scoreinfo.`studentid` AS studentid FROM scoreinfo GROUP BY scoreinfo.`studentid` HAVING AVG(scoreinfo.`score`) > 60) AS temp JOIN
studentinfo AS st ON st.`studentid` = temp.`studentid`
LIMIT 1,2;

-- 4、查询男生的人数 和 女生的人数
SELECT stu.`studentgender` AS 性别, COUNT(studentgender) AS 人数 FROM studentinfo stu GROUP BY stu.`studentgender`; 
 
 -- 5、查询同名同姓的学生人数
SELECT * FROM studentinfo;
INSERT INTO studentinfo VALUES(NULL, '甄姬', '女', 38);
SELECT stu.`studentname` AS 姓名,COUNT(stu.`studentname`) AS 人数 FROM studentinfo stu GROUP BY stu.`studentname` HAVING COUNT(stu.`studentname`) > 1;

-- 6、查询每门功课的平均成绩，结果按每门功课平均成绩升序排列，成绩相同时，按课程编号倒序排列
SELECT c.`coursename` AS 课程名称,temp.avgscore AS 平均成绩
FROM(
SELECT sc.`courseid` AS courseid,AVG(sc.`score`) AS avgscore FROM scoreinfo AS sc
GROUP BY sc.`courseid` 
) AS temp
JOIN courseinfo AS c ON temp.`courseid` = c.`courseid`  ORDER BY temp.avgscore ASC,c.`courseid` DESC;

-- 7、查询课程名称为数学，且数学成绩低于60分的学生姓名和分数
SELECT stu.`studentname` AS 学生姓名,sc.`score` AS 分数 FROM studentinfo stu 
INNER JOIN scoreinfo sc ON sc.`studentid` = stu.`studentid` JOIN courseinfo c ON c.`courseid` = sc.`courseid` AND c.`coursename` ='数学' WHERE sc.`score` < 60;

-- 8、查询所有学生的选课信息（显示为：学生编号、学生姓名、课程名称）

SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,c.`coursename` AS 课程名称
FROM studentinfo stu 
LEFT JOIN scoreinfo sc ON stu.`studentid` = sc.`studentid` 
LEFT JOIN courseinfo c ON c.`courseid` = sc.`courseid`;

-- 9、查询任何一门课程成绩在60分以上的学生姓名、课程名称及成绩
SELECT stu.`studentname` AS 学生姓名,c.`coursename` AS 课程名称,sc.`score` AS 成绩 FROM studentinfo stu JOIN scoreinfo sc  ON stu.`studentid` = sc.`studentid` JOIN courseinfo c ON c.`courseid` = sc.`courseid`
WHERE sc.`score` >60;

-- 10、查询至少选修了两门课程的学生信息
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 学生年龄,stu.`studentgender` 学生性别 FROM studentinfo stu JOIN scoreinfo sc ON sc.`studentid` = stu.`studentid`
GROUP BY sc.`studentid` HAVING COUNT(sc.`courseid`) >=2;

-- 子查询实现（明日实现）：
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 学生年龄,stu.`studentgender` 学生性别 
FROM
studentinfo stu INNER JOIN(
SELECT sc.`studentid` AS studentid FROM scoreinfo sc GROUP BY sc.`studentid` HAVING COUNT(sc.`courseid`) >=2
) AS temp 
ON temp.`studentid` = stu.`studentid`;

-- 独立子查询
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 学生年龄,stu.`studentgender` 学生性别 
FROM studentinfo stu WHERE stu.`studentid` IN (SELECT sc.`studentid` FROM scoreinfo sc GROUP BY sc.`studentid` HAVING COUNT(sc.`courseid`) >=2);

-- 11、查询全部学生都选修了的课程编号以及课程名称（基于无脏数据，不存在垃圾数据）
SELECT c.`courseid` AS 课程编号,c.`coursename` AS 课程名称 FROM courseinfo  c WHERE c.`courseid` IN( SELECT sc.`scoreid` FROM scoreinfo sc GROUP BY sc.`scoreid` HAVING 
COUNT(sc.`studentid`) = (SELECT COUNT(stu.`studentid`) FROM studentinfo stu));

SELECT c.`courseid` AS 课程编号,c.`coursename` AS 课程名称 FROM courseinfo c JOIN scoreinfo sc ON sc.`courseid` = c.`courseid` GROUP BY sc.`scoreid` HAVING 
COUNT(sc.`studentid`) = (SELECT COUNT(stu.`studentid`) FROM studentinfo stu);

-- 12、查询个人的英语成绩比数学成绩高的学生信息
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 学生年龄,stu.`studentgender` AS 性别 FROM studentinfo stu WHERE 
stu.`studentid` IN (
 SELECT temp1.`studentid` FROM (SELECT sc1.`studentid` AS studentid,sc1.`score` AS score FROM courseinfo c1 JOIN scoreinfo sc1 ON sc1.`courseid` = c1.`courseid` WHERE c1.`coursename` ='英语'
 ) AS temp1
 INNER JOIN (SELECT sc2.`studentid` AS studentid,sc2.`score` AS score FROM courseinfo c2 JOIN scoreinfo sc2 ON sc2.`courseid` = c2.`courseid` WHERE c2.`coursename` ='数学') AS temp2
 ON temp1.`studentid` = temp2.`studentid` AND temp1.`score` > temp2.`score`
);

-- 13、查询所有学生的编号、姓名、选课数量、总成绩
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,COUNT(sc.`courseid`) AS 选课数量,SUM(sc.`score`) AS 总成绩 FROM studentinfo stu LEFT JOIN scoreinfo sc ON sc.`studentid` = stu.`studentid`
GROUP BY stu.`studentid`,stu.`studentname`;

-- 14、查询没有选修过张老师课程的学生信息
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 年龄,stu.`studentgender` AS 学生性别 FROM studentinfo stu
WHERE stu.`studentid` NOT IN (SELECT sc.`studentid` FROM scoreinfo sc INNER JOIN courseinfo c ON sc.`courseid` = c.`courseid` INNER JOIN teacherinfo t ON t.`teacherid` = c.`teacherid` 
WHERE t.`teachername` ='张老师');

-- 15、查询学过语文也学过数学的学生信息
-- 方式一：
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 年龄,stu.`studentgender` AS 学生性别 FROM studentinfo stu 
WHERE stu.`studentid` IN (
SELECT temp1.`studentid` FROM ( SELECT sc1.`studentid` FROM scoreinfo sc1 INNER  JOIN courseinfo c1 ON c1.`courseid` = sc1.`courseid` AND c1.`coursename` = '语文' 
) AS temp1
INNER JOIN (SELECT sc2.`studentid` FROM scoreinfo sc2 INNER  JOIN courseinfo c2 ON c2.`courseid` = sc2.`courseid` AND c2.`coursename` = '数学' )AS temp2
ON temp1.`studentid` = temp2.`studentid`
);

-- 方式二：
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 年龄,stu.`studentgender` AS 学生性别 FROM studentinfo stu 
INNER JOIN scoreinfo sc1 ON sc1.`studentid` = stu.`studentid` AND sc1.`courseid` = (SELECT c1.`courseid` FROM courseinfo c1 WHERE c1.`coursename` ='语文')
INNER JOIN scoreinfo sc2 ON sc2.`studentid` = stu.`studentid` AND sc2.`courseid` = (SELECT c2.`courseid` FROM courseinfo c2 WHERE c2.`coursename` ='数学');

-- 16、查询个人成绩中每门功课都不及格的学生信息
-- 包括没有分数的学生，部分及格，部分不及格
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 年龄,stu.`studentgender` AS 学生性别 FROM studentinfo stu 
WHERE stu.`studentid` NOT IN (
 SELECT sc.`studentid` FROM scoreinfo sc WHERE sc.`score` >=60
);

-- 不包括没有分数的学生
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 年龄,stu.`studentgender` AS 学生性别 FROM studentinfo stu 
WHERE stu.`studentid` IN (
SELECT sc.`studentid` FROM scoreinfo sc GROUP BY sc.`studentid` HAVING MAX(sc.`score`) <60
);

-- 17、查询每门功课的分数段人数，显示为：课程编号、课程名称、选课人数、[优秀90~100]、[良好80~90]、[一般70~80]、[及格60~70]、[不及格0~60]
SELECT c.`courseid` AS 课程编号,c.`coursename` AS 课程名称,
COUNT(sc.`studentid`) AS 选课人数,
SUM(CASE WHEN sc.`score` >90 && sc.`score` <=100 THEN 1 ELSE 0 END) AS `[优秀90~100]`,
SUM(CASE WHEN sc.`score` >80 && sc.`score` <=90 THEN 1 ELSE 0 END) AS `[良好80~90]`,
SUM(CASE WHEN sc.`score` >70 && sc.`score` <=80 THEN 1 ELSE 0 END) AS `[一般70~80]`,
SUM(CASE WHEN sc.`score` >60 && sc.`score` <=70 THEN 1 ELSE 0 END) AS `[及格60~70]`,
SUM(CASE WHEN sc.`score` >=0 && sc.`score` <=60 THEN 1 ELSE 0 END) AS `[不及格0~60]`
FROM scoreinfo sc INNER JOIN courseinfo c ON sc.`courseid` = c.`courseid`
GROUP BY sc.`courseid`;

-- 18、查询没有选修全部课程的学生信息
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名,stu.`studentage` AS 学生年龄,stu.`studentgender` AS 学生性别 FROM studentinfo stu WHERE stu.`studentid` IN(
SELECT sc.`studentid` FROM scoreinfo sc GROUP BY sc.`studentid` HAVING COUNT(sc.`courseid`)<(SELECT COUNT(*) FROM courseinfo)); 

-- 19、查询和刘备（学生编号1）至少一起选修了一门课程的学生编号和学生姓名
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名 FROM studentinfo stu WHERE stu.`studentid` IN (
SELECT sc.`studentid` FROM scoreinfo sc WHERE sc.`courseid` IN (SELECT sc1.`courseid` FROM scoreinfo sc1 INNER JOIN studentinfo stu1 ON stu1.`studentid` = sc1.`studentid` WHERE sc1.`studentid` = 1 AND stu1.`studentname`='刘备'));

-- 20、查询和张飞（学生编号3）选修的课程完全相同的学生编号和学生姓名
SELECT stu.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名 FROM studentinfo stu WHERE stu.`studentid` IN (
 SELECT sc1.`studentid` FROM scoreinfo sc1 INNER JOIN scoreinfo sc2 ON sc1.`courseid` = sc2.`courseid` AND sc2.`studentid` = 3 AND sc1.`studentid` <> sc2.`studentid`
 GROUP BY sc1.`studentid`,sc2.`studentid` HAVING COUNT(sc1.`courseid`) = (SELECT COUNT(*) FROM scoreinfo WHERE scoreinfo.`studentid` =3)
);

-- 21、按个人平均成绩降序排列显示学生的语文、数学、英语三门功课的成绩（选修了几门计算几门的平均分，未选修的课程显示未选）
SELECT sc.`studentid` AS 学生编号,stu.`studentname` AS 学生姓名, AVG(sc.`score`) AS 平均成绩,
IFNULL((SELECT sc1.`score` FROM scoreinfo sc1 WHERE sc1.`studentid` = sc.`studentid` AND sc1.`courseid` =(SELECT courseid FROM courseinfo WHERE courseinfo.`coursename` ='语文')),'未选')AS `语文成绩`,
IFNULL((SELECT sc2.`score` FROM scoreinfo sc2 WHERE sc2.`studentid` = sc.`studentid` AND sc2.`courseid` =(SELECT courseid FROM courseinfo WHERE courseinfo.`coursename` ='数学')),'未选')AS `数学成绩`,
IFNULL((SELECT sc3.`score` FROM scoreinfo sc3 WHERE sc3.`studentid` = sc.`studentid` AND sc3.`courseid` =(SELECT courseid FROM courseinfo WHERE courseinfo.`coursename` ='英语')),'未选')AS `英语成绩`
FROM 
scoreinfo sc INNER JOIN studentinfo stu ON sc.`studentid` = stu.`studentid` 
GROUP BY sc.`studentid` 
ORDER BY AVG(sc.`score`) DESC;

-- 22、查询每门功课的最高分和最低分，显示为：课程编号、课程名称、最高分、最低分
SELECT sc.`courseid` AS 课程编号,c.`coursename` AS 课程名称,MAX(sc.`score`) AS 最高分,MIN(sc.`score`) AS 最低分 FROM scoreinfo sc
INNER JOIN courseinfo c ON c.`courseid` = sc.`courseid`
GROUP BY sc.`courseid`;

-- 23、查询只选修了一门功课的学生的学号和姓名
SELECT stu.`studentid` AS 学号, stu.`studentname` AS 学生姓名 FROM studentinfo stu
WHERE stu.`studentid` IN (
     SELECT sc.`studentid` FROM scoreinfo sc GROUP BY sc.`studentid` HAVING COUNT(sc.`courseid`) = 1
);

-- 内联：
SELECT stu.`studentid` AS 学号, stu.`studentname` AS 学生姓名 FROM studentinfo stu INNER JOIN scoreinfo sc ON sc.`studentid` = stu.`studentid` GROUP BY stu.`studentid` HAVING COUNT(sc.`courseid`) = 1;

-- 24、查询学过张老师教的全部课程的学生的学号和姓名
SELECT stu.`studentid` AS 学号,stu.`studentname` AS 姓名 FROM studentinfo stu WHERE stu.`studentid` IN (
   SELECT sc.`studentid` FROM scoreinfo sc JOIN courseinfo c ON c.`courseid` = sc.`courseid` INNER JOIN teacherinfo t1 ON t1.`teacherid` = c.`teacherid` AND t1.`teachername` ='张老师' GROUP BY sc.`studentid` HAVING COUNT(sc.`courseid`) =(
   SELECT COUNT(c.`courseid`) FROM teacherinfo t INNER JOIN courseinfo c ON c.`teacherid` = t.`teacherid` WHERE t.`teachername` ='张老师')
);

-- 内联：
SELECT stu.`studentid` AS 学号,stu.`studentname` AS 姓名 FROM studentinfo stu 
INNER JOIN scoreinfo sc ON sc.`studentid` = stu.`studentid`
JOIN courseinfo c ON c.`courseid` = sc.`courseid` 
JOIN teacherinfo t ON t.`teacherid` = c.`teacherid` AND t.`teachername` = '张老师'
GROUP BY stu.`studentid`
HAVING COUNT(sc.`courseid`) = (
      SELECT COUNT(c1.`courseid`) FROM teacherinfo t1 INNER JOIN courseinfo c1 ON c1.`teacherid` = t1.`teacherid` WHERE t1.`teachername` ='张老师'
);

-- 25、学生信息表中被人删除了若干条记录，现在需要查询出第4行至第6行的记录来使用（考虑多种实现）
SELECT * FROM studentinfo stu LIMIT 3,3;
SELECT * FROM studentinfo WHERE studentid >=4 && studentid <= 6; # 数据没有被删除时
SELECT * FROM studentinfo WHERE studentid BETWEEN 4 AND 6;
# 数据删除时 
SELECT * FROM(SELECT * FROM(SELECT * FROM studentinfo LIMIT 0,6)AS temp1 ORDER BY temp1.`studentid` DESC LIMIT 0,3) AS temp2 ORDER BY temp2.`studentid` ASC;

SELECT * FROM(SELECT * FROM(SELECT * FROM(SELECT * FROM studentinfo LIMIT 0, 6) AS temp1 ORDER BY temp1.`studentid` DESC) AS temp2 LIMIT 0, 3) AS temp3 ORDER BY temp3.`studentid` ASC ;

