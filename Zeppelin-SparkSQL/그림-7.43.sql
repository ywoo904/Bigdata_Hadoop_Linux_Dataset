val dsSmartCar_1= new StringIndexer().setInputCol("car_model").setOutputCol("car_model_n").fit(dsSmartCar).transfrom(dsSmartCar)
val dsSmartCar_2= new StringIndexer().setInputCol("engine").setOutputCol("engine_n").fit(dsSmartCar_1).transfrom(dsSmartCar_1)
val dsSmartCar_3= new StringIndexer().setInputCol("break").setOutputCol("break_n").fit(dsSmartCar_2).transfrom(dsSmartCar_2)
val dsSmartCar_4= new StringIndexer().setInputCol("status").setOutputCol("label").fit(dsSmartCar_3).transfrom(dsSmartCar_3)
val dsSmartCar_5= dsSmartCar_4.drop("car_model").drop("engine").drop("break").drop("status") 

dsSmartCar_5.show() 

////////////////////////

val url="hdfs://server01.hadoop.com:8020"
val dPath="/user/hive/warehouse/managed_smartcar_drive_info/biz_date=20200429/*"
val driveData=sc.textFile(url + dPath)
case class DriveInfo(car_num: String,        sex: String,           age: String,            
                     marriage: String,       region: String,        job: String,           
                     car_capacity: String,   car_year: String,      car_model: String,
                     speed_pedal: String,    break_pedal: String,   steer_angle: String, 
                     direct_light: String,   speed: String,         area_num: String,       
                     date: String)

val drive = driveData.map(sd=>sd.split(",")).map(
                sd=>DriveInfo(sd(0).toString, sd(1).toString, sd(2).toString, sd(3).toString,
                              sd(4).toString, sd(5).toString, sd(6).toString, sd(7).toString,
                              sd(8).toString, sd(9).toString, sd(10).toString,sd(11).toString,
                              sd(12).toString,sd(13).toString,sd(14).toString,sd(15).toString
        )
)

drive.toDF().registerTempTable("DriveInfo")

//////////////////////////////////////

%spark.sql
select T1.area_num,T1.avg_speed 
from (select area_num, avg(speed) as avg_speed 
      from DriveInfo 
      group by area_num 
      ) T1
order by T1.avg_speed desc 


///////////////////////