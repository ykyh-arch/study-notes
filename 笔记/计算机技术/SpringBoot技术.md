# SpringBoot技术
一、基本概念：
	特点：开箱即用，自动配置
	配置文件：YAML 的基本使用-支持文档块
	配置文件值的注入：
	方式一：@ConfigurationProperties
		格式：
		javaBean
		@Component
		@ConfigurationProperties(prefix = "person")
		//@Validated
		public class Person {
			//@Value("${person.last-name}")
			private String lastName;
			//@Value("#{11*2}")
			private Integer age;
			private Boolean boss;
			private Date birth;
			private Map<String,Object> maps;
			private List<Object> lists;
			private Dog dog;
		}
		配置文件：
		person:
			lastName: hello
			age: 18
			boss: false
			birth: 2017/12/12
			maps: {k1: v1,k2: 12}
			lists:
			  - lisi
			  - zhaoliu
			dog:
			  name: 小狗
			  age: 12
		方式二：@Value
		区别：
			|            	| @ConfigurationProperties    | @Value 	      |
 			| 功能         	| 批量注入配置文件中的属性           一个个指定
			| 松散绑定（松散语法）| 支持                        不支持
			| SpEL       	| 不支持                          支持
			| JSR303数据校验| 支持                            不支持
			| 复杂类型封装   | 支持                           不支持
    加载配置文件：@PropertySource
		格式：
			@PropertySource(value = {"classpath:person.properties"})
			@Component
			@ConfigurationProperties(prefix = "person")
			public class Person {
				private Integer age;
				private Boolean boss;
			}
	读取配置文件：@ImportResource
	    格式：
		    java文件
			@ImportResource(locations = {"classpath:beans.xml"})
		    xml文件
    		<?xml version="1.0" encoding="UTF-8"?>
    		<beans xmlns="http://www.springframework.org/schema/beans"
    			   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    			   xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    			<bean id="helloService" class="com.atguigu.springboot.service.HelloService"></bean>
    		</beans>
    添加配置文件：
		推荐使用全注解的方式
		1、配置类@Configuration------>Spring配置文件
		2、使用@Bean给容器中添加组件
		```java
		@Configuration
		public class MyAppConfig {
			//将方法的返回值添加到容器中；容器中这个组件默认的id就是方法名
			@Bean
			public HelloService helloService(){
				System.out.println("配置类@Bean给容器中添加组件了...");
				return new HelloService();
			}
		}
    配置文件占位符:
    	如：*.properties 配置文件中
    		person.last-name=张三${random.uuid}
    		person.dog.name=${person.hello:hello}_dog
    配置文件Profile:
			激活指定profile的方式：
			1、配置文件中指定  spring.profiles.active=dev	
			2、命令行方式 java -jar **-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev；
			3、虚拟机参数 -Dspring.profiles.active=dev
			配置文件加载位置：
				springboot启动会扫描以下位置的application.properties或者application.yml文件作为Spring boot的默认配置文件
				–file:./config/
				–file:./
				–classpath:/config/
				–classpath:/    #优先级由高到底，高优先级的配置会覆盖低优先级的配置；SpringBoot会从这四个位置全部加载主配置文件；互补配置；				
				java -jar **-0.0.1-SNAPSHOT.jar --spring.config.location=G:/application.properties #用户指定加载位置：
			外部配置加载顺序：
				SpringBoot也可以从以下位置加载配置； 优先级从高到低；高优先级的配置覆盖低优先级的配置，所有的配置会形成互补配置
				1.命令行参数
					java -jar **-02-0.0.1-SNAPSHOT.jar --server.port=8087  --server.context-path=/abc #多个配置用空格分开；--配置项=值
				2.来自java:comp/env的JNDI属性
				3.Java系统属性（System.getProperties()）
				4.操作系统环境变量
				5.RandomValuePropertySource配置的random.*属性值
				6.由jar包外向jar包内进行寻找，优先加载带profile
					jar包外部的application-{profile}.properties或application.yml(带spring.profile)配置文件
					jar包内部的application-{profile}.properties或application.yml(带spring.profile)配置文件
				10.@Configuration注解类上的@PropertySource
				11.通过SpringApplication.setDefaultProperties指定的默认属性
			自动配置原理：
				xxxxAutoConfigurartion：自动配置类；
				xxxxProperties:封装配置文件中相关属性；
			检测自动配置类是否生效：debug=true
二、日志框架：
	默认：springBoot底层也是使用slf4j+logback的方式进行日志记录；
	