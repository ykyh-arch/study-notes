//MongoDB实现分组分片查询，Aggregate的使用
//源数据
db.items.insert( [
  {
   "quantity" : 2,
   "price" : 5.0,
   "pnumber" : "p003",
  },{
   "quantity" : 2,
   "price" : 8.0,
   "pnumber" : "p002"
  },{
   "quantity" : 1,
   "price" : 4.0,
   "pnumber" : "p002"
  },{
   "quantity" : 2,
   "price" : 4.0,
   "pnumber" : "p001"
  },{
   "quantity" : 4,
   "price" : 10.0,
   "pnumber" : "p003"
  },{
   "quantity" : 10,
   "price" : 20.0,
   "pnumber" : "p001"
  },{
   "quantity" : 10,
   "price" : 20.0,
   "pnumber" : "p003"
  },{
   "quantity" : 5,
   "price" : 10.0,
   "pnumber" : "p002"
  }
])     
//查询
db.items.find();
//$group语法:{ $group: { _id: <expression>, <field1>: { <accumulator1> : <expression1> }, ... } }
/*
 *_id 分组的key,expression分组的字段，如果_id为null 相当于SQL:select count(*) from table
 *field1 分组后展示的字段
 *accumulator1 分组管道函数，如：$sum\$avg\$min\$max\$push\$addToSet\$first\$last
 *expression1  分组显示数据相关
 *
 */
//查询总数,相当于SQL:select count(1) as count from items
db.items.count();
db.items.aggregate([{$group:{_id:null,count:{$sum:1}}}])
//统计数量，相当于SQL:select sum(quantity) as total  from  items
db.items.aggregate([{$group:{_id:null,total:{$sum:"$quantity"}}}]);
//按产品类型来进行分组，然后在统计卖出的数量是多少，相当于SQL：select sum(quantity) as total from  items  group by pnumber
db.items.aggregate([{$group:{_id:"$pnumber",total:{$sum:"$quantity"}}}])
//通过相同的产品类型来进行分组，然后查询相同产品类型卖出最多的订单详情，相当于SQL:select max(quantity) as quantity from  items  group by pnumber
db.items.aggregate([{$group:{_id:"$pnumber",max:{$max:"$quantity"}}}])
db.items.aggregate([{$group:{_id:"$pnumber",min:{$min:"$quantity"}}}])
//通过相同的产品类型来进行分组，统计各个产品数量，然后获取最大的数量，相当于SQL:select max(t.total) from (select sum(quantity) as total from  items  group by pnumber) t
db.items.aggregate([{$group:{_id:"$pnumber",total:{$sum:"$quantity"}}}])
db.items.aggregate([{$group:{_id:"$pnumber",total:{$sum:"$quantity"}}},{$group:{_id:null,max:{$max:"$total"}}}])
//通过相同的产品类型来进行分组，然后查询每个订单详情相同产品类型卖出的平均价格，相当于SQL:select avg(price) as price from  items  group by pnumber
db.items.aggregate([{$group:{_id:"$pnumber",price:{$avg:"$price"}}}])
//通过相同的产品类型来进行分组，然后查询每个相同产品卖出的数量放在数组里面,，注意值数组中的值不要超过16M
db.items.aggregate([{$group:{_id:"$pnumber",quantitys:{$push:"$quantity"}}}])
db.items.aggregate([{$group:{_id:"$pnumber",quantitys:{$push:{quantity:"$quantity",price:"$price"}}}}])
//表达式的值添加到一个数组中（无重复值），这个值不要超过16M
db.items.aggregate([{$group:{_id:"$pnumber",quantitys:{$addToSet:"$quantity"}}}])
//$first：返回每组第一个文档，如果有排序，按照排序，如果没有按照默认的存储的顺序的第一个文档。
//$last：返回每组最后一个文档，如果有排序，按照排序，如果没有按照默认的存储的顺序的最后个文档。
db.items.aggregate([{$group:{_id:"$pnumber",quantityFrist:{$first:"$quantity"}}}])
//$project显示或不显示字段，相当于SQL:select
db.items.aggregate([{$group:{_id:null,count:{$sum:1}}},{$project:{"_id":0,"count":1}}])
//通过滤订单中，想知道卖出的数量大于8的产品有哪些产品，相当于SQL:select sum(quantity) as total from  items  group by pnumber having total>8   
db.items.aggregate([{$group:{_id:"$pnumber",total:{$sum:"$quantity"}}},{$match:{total:{$gt:8}}}])
//$match如果是放在$group之前就是当做where来使用，我们只统计pnumber =p001 产品卖出了多少个  select sum(quantity) as total from  items where pnumber='p001'
db.items.aggregate([{$match:{"pnumber":"p001"}},{$group:{_id:null,total:{$sum:"$quantity"}}}])
//$skip、$limit使用顺序不同，结果也不同，注意：$limit、$skip、$sort、$match可以使用在阶段管道，如果使用在$group之前可以过滤掉一些数据，提高性能
db.items.aggregate([{ $skip: 2 },{ $limit: 4 },{ $sort: { quantity : -1 }}])
db.items.aggregate([{ $limit: 4 },{ $skip: 2 }])
//将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值
db.items.aggregate([{$group:{_id:"$pnumber",quantitys:{$push:"$quantity"}}}])
db.items.aggregate([{$group:{_id:"$pnumber",quantitys:{$push:"$quantity"}}},{$unwind:"$quantitys"}])
//$out必须为pipeline最后一个阶段管道，因为是将最后计算结果写入到指定的collection中
db.items.aggregate([{$group:{_id:"$pnumber",quantitys:{$push:"$quantity"}}},{$unwind:"$quantitys"},{$project:{"_id":0,"quantitys":1}},{$out:"result"}])
db.result.find()
//$redact 语法：{ $redact: <expression> }
/*$redact 跟$cond结合使用，并在$cond里面使用了if、then、else表达式，if-else缺一不可，$redact还有三个重要的参数：
     1）$$DESCEND：返回包含当前document级别的所有字段，并且会继续判字段包含内嵌文档，内嵌文档的字段也会去判断是否符合条件。
     2）$$PRUNE：返回不包含当前文档或者内嵌文档级别的所有字段，不会继续检测此级别的其他字段，即使这些字段的内嵌文档持有相同的访问级别。
     3）$$KEEP：返回包含当前文档或内嵌文档级别的所有字段，不再继续检测此级别的其他字段，即使这些字段的内嵌文档中持有不同的访问级别。
*/
//源数据，内嵌document结构的级别
db.redact.insert(
  {
  _id: 1,
  level: 1,
  status: "A",
  acct_id: "xyz123",
  cc: [{
    level: 1,
    type: "yy",
    num: 000000000000,
    exp_date: ISODate("2015-11-01T00:00:00.000Z"),
    billing_addr: {
      level: 5,
      addr1: "123 ABC Street",
      city: "Some City"
    }
  },{
    level: 3,
    type: "yy",
    num: 000000000000,
    exp_date: ISODate("2015-11-01T00:00:00.000Z"),
    billing_addr: {
      level: 1,
      addr1: "123 ABC Street",
      city: "Some City"
    }
}]
});
//查询所有文档
db.redact.find();
//分组 
db.redact.aggregate(
  [
    { $match: { status: "A" } },
    {
      $redact: {
        $cond: {
          if: { $eq: [ "$level", 1] },
          then: "$$DESCEND",
          else: "$$PRUNE"
        }
      }
    }
  ]
);
//查询结果包含以下内嵌文档数据
{
  "_id" : 1,
  "level" : 1,
  "status" : "A",
  "acct_id" : "xyz123",
  "cc" : [
           { "level" : 1,
             "type" : "yy",
             "num" : 0,
             "exp_date" : ISODate("2015-11-01T00:00:00Z")
           }
    ]
 }
//插入数据
db.redact.insert(
      {
      _id: 1,
      level: 1,
      status: "A",
      acct_id: "xyz123",
      cc: {
            level: 3,
            type: "yy",
            num: 000000000000,
            exp_date: ISODate("2015-11-01T00:00:00.000Z"),
            billing_addr: {
              level: 1,
              addr1: "123 ABC Street",
              city: "Some City"
            }
        }
     }
 );
db.redact.find();
 //分组查询
db.redact.aggregate(
  [
    { $match: { status: "A" } },
    {
      $redact: {
        $cond: {
          if: { $eq: [ "$level", 3] },
          then: "$$PRUNE",
          else: "$$DESCEND"
        }
      }
    }
  ]
);
//查询所有文档
db.redact.find();
db.redact.aggregate(
  [
    { $match: { status: "A" } },
    {
      $redact: {
        $cond: {
          if: { $eq: [ "$level", 1] },
          then: "$$KEEP",
          else: "$$PRUNE"
        }
      }
    }
  ]
);
//option操作explain:返回指定aggregate各个阶段管道的执行计划信息，操作返回一个游标，包含aggregate执行计划详细信息
db.items.aggregate([{$group:{_id:"$pnumber",total:{$sum:"$quantity"}}},{$group:{_id:null,max:{$max:"$total"}}}],{explain:true});
//游标
var cursor=db.items.aggregate([{$group:{_id:"$pnumber",total:{$sum:"$quantity"}}},{ $limit: 2 }],{cursor: { batchSize: 1 }});
cursor.hasNext()
cursor.next()
cursor.toArray()
cursor.forEach()
cursor.map()
cursor.objsLeftInBatch()
cursor.itcount()
cursor.pretty()
//插入订单信息
db.orders.insert([  
{  
        "onumber" : "001",   
        "date" : "2015-07-02",   
        "cname" : "zcy1",   
         "items" :[ {  
                   "ino" : "001",  
                  "quantity" :2,   
                  "price" : 4.0  
                 },{  
                   "ino" : "002",  
                  "quantity" : 4,   
                  "price" : 6.0  
                }  
                ]  
},{  
         "onumber" : "002",   
        "date" : "2015-07-02",   
        "cname" : "zcy2",   
         "items" :[ {  
                  "ino" : "003",  
                  "quantity" :1,   
                  "price" : 4.0  
                   },{  
                  "ino" : "002",  
                  "quantity" :6,   
                  "price" : 6.0  
                 }  
               ]  
},{  
         "onumber" : "003",   
        "date" : "2015-07-02",   
        "cname" : "zcy2",   
         "items" :[ {  
                  "ino" : "004",  
                  "quantity" :3,   
                  "price" : 4.0  
                   },{  
                  "ino" : "005",  
                  "quantity" :1,   
                  "price" : 6.0  
                 }  
               ]  
},{  
         "onumber" : "004",   
        "date" : "2015-07-02",   
        "cname" : "zcy2",   
         "items" :[ {  
                  "ino" : "001",  
                  "quantity" :3,   
                  "price" : 4.0  
                   },{  
                  "ino" : "003",  
                  "quantity" :1,   
                  "price" : 6.0  
                 }  
               ]  
}
]);
//查询订单
db.orders.find();
//需求，查询订单号为001,002,003中的订单详情各个产品卖出多少个，并且过滤掉数量小于1的产品
db.orders.aggregate([
 {$match:{"onumber":{$in:["001","002", "003"]}}},
 {$unwind:"$items"},
 {$group:{_id:"$items.ino",total:{$sum:"$items.quantity"}}},
 {$match:{total:{$gt:1}}}
]);
//清空集合
db.orders.remove({});
db.students.find();
//模糊查询
db.students.find({"user_name": {$regex: /尚/, $options:'i'}}); 
db.students.find({"user_name": {$regex:/尚.*/i}}); 
db.students.find({user_name:{$in:[/^孙尚香/i,/^胡歌/]}});
db.students.find({user_name:{$regex:/^孙尚香/i,$nin:['孙尚香II']}});
db.students.find({user_name:{$regex:/香/,$options:"si"}});























