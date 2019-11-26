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
           | 日志门面  （日志的抽象层）               | 日志实现
        	| ---------------------------------------- | ---------------------------------------- |
        	| JCL（Jakarta  Commons Logging）          | Log4j  JUL（java.util.logging）  Log4j2  Logback
        	| SLF4j（Simple  Logging Facade for Java） jboss-logging|
        	系统统一日志（slf4j）输出：
        		1、将系统中其他日志框架先排除出去
        		2、用中间包来替换原有的日志框架
        		3、我们导入slf4j其他的实现
        	日志级别：
        		由低到高   trace<debug<info<warn<error
        	springBoot修改默认日志配置：
        		1、指定级别：logging.level.XX包名=trace
        		2、logging.path=  #若不指定路径在当前项目下生成springboot.log日志
        		   logging.path=/spring/log #在当前磁盘的根路径下创建spring文件夹和里面的log文件夹；使用 spring.log 作为默认文件
        		3、logging.file=G:/springboot.log
        		输出格式：
        		4、logging.pattern.console=%d{yyyy-MM-dd} [%thread] %-5level %logger{50} - %msg%n #控制台
        		5、logging.pattern.file=%d{yyyy-MM-dd} [%thread] %-5level %logger{50} - %msg%n #指定文件中
        	指定具体的日志实现配置：类路径下（classpath:）放上每个日志框架自己的配置文件即可
        		如：logback.xml：直接就被日志框架识别了；
        			logback-spring.xml：日志框架就不直接加载日志的配置项，由SpringBoot解析日志配置，可以使用SpringBoot的高级Profile功能
        			xml文件：
        			<appender name="stdout" class="ch.qos.logback.core.ConsoleAppender">
        				<!--
        				日志输出格式：
        					%d表示日期时间，
        					%thread表示线程名，
        					%-5level：级别从左显示5个字符宽度
        					%logger{50} 表示logger名字最长50个字符，否则按照句点分割。
        					%msg：日志消息，
        					%n是换行符
        				-->
        				<layout class="ch.qos.logback.classic.PatternLayout">
        					<springProfile name="dev">
        						<pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} ----> [%thread] ---> %-5level %logger{50} - %msg%n</pattern>
        					</springProfile>
        					<springProfile name="!dev">
        						<pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} $$$$$$ [%thread] $$$$$$ %-5level %logger{50} - %msg%n</pattern>
        					</springProfile>
        				</layout>
        			</appender>
三、Web模块：
   静态资源映射：
	1、（以Jar包的方式引入静态资源）/webjars/**，都去 classpath:/META-INF/resources/webjars/找资源；如：localhost:8080/webjars/jquery/3.3.1/jquery.js
		引入如：
			<dependency>
				<groupId>org.webjars</groupId>
				<artifactId>jquery</artifactId>
				<version>3.3.1</version>
			</dependency>
	2、	/**，访问任何资源
		静态资源的文件夹：
		"classpath:/META-INF/resources/",
		"classpath:/resources/",
		"classpath:/static/",
		"classpath:/public/"
		"/"：当前项目的根路径
	3、	欢迎页：静态资源文件夹下的所有index.html页面；被"/**"映射；
	4、 所有的 **/favicon.ico 都是在静态资源文件下找
    模板引擎：JSP、Velocity、Freemarker、Thymeleaf，SpringBoot推荐的Thymeleaf；
	Thymeleaf使用：
	1、引入：POM.xml
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-thymeleaf</artifactId>
			<version>2.1.6</version>
		</dependency>
	<properties>
		<thymeleaf.version>3.0.9.RELEASE</thymeleaf.version>
		<!-- 布局功能的支持程序  thymeleaf3主程序  layout2以上版本 -->
		<!-- thymeleaf2   layout1-->
		<thymeleaf-layout-dialect.version>2.2.2</thymeleaf-layout-dialect.version>
   </properties>
	2、使用：把HTML页面放在classpath:/templates/，thymeleaf就能自动渲染；
    		页面引入：<html lang="en" xmlns:th="http://www.thymeleaf.org">
    		页面使用标签：
    			语法规则：
				包含：th:insert th:replace th:include
				遍历：th:each
				条件判断：th:if th:unless th:switch th:case
				申明变量：th:object th:with
				属性修改：th:attr th:attrprepend th:attrapend
				属性值修改: th:value th:src th:href
				标签体内容：th:text（转义） th:utext（不转义）
				申明片段：th:fragment
				移除：th:remove
    			表达式：
    				${...}：获取变量值，符合OGNL（Object Graphic Navigation Language(对象图导航语言)）标准；
    					1）、获取对象的属性、调用方法
    					2）、使用内置的基本对象：
    						#ctx : the context object.
    						#vars: the context variables.
    						#locale : the context locale.
    						#request : (only in Web Contexts) the HttpServletRequest object.
    						#response : (only in Web Contexts) the HttpServletResponse object.
    						#session : (only in Web Contexts) the HttpSession object.
    						#servletContext : (only in Web Contexts) the ServletContext object.
    					3）、内置的一些工具对象：
    					#execInfo : information about the template being processed.
    					#messages : methods for obtaining externalized messages inside variables expressions, in the same way as they would be obtained using #{}syntax.
    					#uris : methods for escaping parts of URLs/URIs
    					#conversions : methods for executing the configured conversion service (if any).
    					#dates : methods for java.util.Date objects: formatting, component extraction, etc.
    					#calendars : analogous to #dates , but for java.util.Calendar objects.
    					#numbers : methods for formatting numeric objects.
    					#strings : methods for String objects: contains, startsWith, prepending/appending, etc.
    					#objects : methods for objects in general.
    					#bools : methods for boolean evaluation.
    					#arrays : methods for arrays.
    					#lists : methods for lists.
    					#sets : methods for sets.
    					#maps : methods for maps.
    					#aggregates : methods for creating aggregates on arrays or collections.
    					#ids : methods for dealing with id attributes that might be repeated (for example, as a result of an iteration).
    						Selection Variable Expressions: *{...}：选择表达式：和${}在功能上是一样；补充：配合 th:object="${session.user}：
    					    <div th:object="${session.user}">
    						<p>Name: <span th:text="*{firstName}">Sebastian</span>.</p>
    						<p>Surname: <span th:text="*{lastName}">Pepper</span>.</p>
    						<p>Nationality: <span th:text="*{nationality}">Saturn</span>.</p>
    						</div>
    						Message Expressions: #{...}：获取国际化内容
    						Link URL Expressions: @{...}：定义URL；@{/order/process(execId=${execId},execType='FAST')}
    						Fragment Expressions: ~{...}：片段引用表达式;<div th:insert="~{commons :: main}">...</div>
    					Literals（字面量）
    						  Text literals: 'one text' , 'Another one!' ,…
    						  Number literals: 0 , 34 , 3.0 , 12.3 ,…
    						  Boolean literals: true , false
    						  Null literal: null
    						  Literal tokens: one , sometext , main ,…
    					Text operations:（文本操作）
    						String concatenation: +
    						Literal substitutions: |The name is ${name}|
    					Arithmetic operations:（数学运算）
    						Binary operators: + , - , * , / , %
    						Minus sign (unary operator): -
    					Boolean operations:（布尔运算）
    						Binary operators: and , or
    						Boolean negation (unary operator): ! , not
    					Comparisons and equality:（比较运算）
    						Comparators: > , < , >= , <= ( gt , lt , ge , le )
    						Equality operators: == , != ( eq , ne )
    					Conditional operators:条件运算（三元运算符）
    						If-then: (if) ? (then)
    						If-then-else: (if) ? (then) : (else)
    						Default: (value) ?: (defaultvalue)
    					Special tokens:
    						No-Operation: _
        禁用Thymeleaf缓存：spring.thymeleaf.cache=false
        Thymeleaf模板抽取：
					1、抽取公共片段
					<div th:fragment="copy">
						&copy; 2011 The Good Thymes Virtual Grocery
					</div>
					2、引入公共片段
					<div th:insert="~{footer :: copy}"></div> // ~{templatename::selector}：模板名::选择器;~{templatename::fragmentname}:模板名::片段名	
					3、默认效果：
					如果使用th:insert等属性进行引入，可以不用写~{}：行内写法可以加上：[[~{}]];[(~{})]；
					三种引入公共片段的th属性：
					th:insert：将公共片段整个插入到声明引入的元素中
					th:replace：将声明引入的元素替换为公共片段
					th:include：将被引入的片段的内容包含进这个标签中
					如：
					<footer th:fragment="copy">
						&copy; 2011 The Good Thymes Virtual Grocery
					</footer>
					引入方式
					<div th:insert="footer :: copy"></div>
					<div th:replace="footer :: copy"></div>
					<div th:include="footer :: copy"></div>
					效果
					<div>
						<footer>
						&copy; 2011 The Good Thymes Virtual Grocery
						</footer>
					</div>
					<footer>
						&copy; 2011 The Good Thymes Virtual Grocery
					</footer>
					<div>
						&copy; 2011 The Good Thymes Virtual Grocery
					</div>
    SpringMVC自动配置：
    	SpringBoot对SpringMVC的默认配置，WebMvcAutoConfiguration
    	做的主要几件事：
    			1、自动配置了ViewResolver（视图解析器）
    			2、支持静态资源文件夹路径,webjars
    			3、支持静态首页访问
    			4、支持favicon.ico系统图标
    			5、自动注册了Converte转换器Formatter格式化器
       扩展SpringMVC：
					Bean.XML 参考：
						 <mvc:view-controller path="/hello" view-name="success"/>
							<mvc:interceptors>
								<mvc:interceptor>
									<mvc:mapping path="/hello"/>
									<bean></bean>
								</mvc:interceptor>
							</mvc:interceptors>
					编写一个配置类（@Configuration），是WebMvcConfigurerAdapter类型；不能标注@EnableWebMvc（会全面接管），既保留了所有的自动配置，也能用自定义扩展的配置；
					如：@Configuration
						//@EnableWebMvc
						public class MyMvcConfig extends WebMvcConfigurerAdapter {
							@Override
							public void addViewControllers(ViewControllerRegistry registry) {
							   // super.addViewControllers(registry);
								registry.addViewController("/atguigu").setViewName("success");
							}
						}
	   全面接管SpringMVC：需要在自定义的配置类中添加@EnableWebMvc即可；
					原理：底层有@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)，WebMvcConfigurationSupport只是保留SpringMVC最基本的功能；
	国际化i18n：
       使用步骤：	1）、编写国际化配置文件messages_zh_CN.properties、messages_en_US.properties
					2）、使用ResourceBundleMessageSource管理国际化资源文件
					3）、在页面使用fmt:message取出国际化内容
		结论：根据浏览器语言设置的信息切换了国际化
		原理：国际化Locale（区域信息对象）；LocaleResolver（获取区域信息对象解析器）；
				@Bean
				@ConditionalOnMissingBean
				@ConditionalOnProperty(prefix = "spring.mvc", name = "locale")
				public LocaleResolver localeResolver() {
					if (this.mvcProperties
							.getLocaleResolver() == WebMvcProperties.LocaleResolver.FIXED) {
						return new FixedLocaleResolver(this.mvcProperties.getLocale());
					}
					//默认的就是根据请求头带来的区域信息获取Locale进行国际化
					AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
					localeResolver.setDefaultLocale(this.mvcProperties.getLocale());
					return localeResolver;
				}
		点击链接切换国际化: 自定义个类实现LocaleResolver重写resolveLocale方法（对请求参数进行处理）返回区域对象，并注入容器里
				参考：
				public class MyLocaleResolver implements LocaleResolver {
					@Override
					public Locale resolveLocale(HttpServletRequest request) {
						String l = request.getParameter("l");
						Locale locale = Locale.getDefault();
						if(!StringUtils.isEmpty(l)){
							String[] split = l.split("_");
							locale = new Locale(split[0],split[1]);
						}
						return locale;
					}
					@Override
					public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
					}
				}
				 @Bean
					public LocaleResolver localeResolver(){
						return new MyLocaleResolver();
					}
				}
	Rest风格:
	    URI：/资源名称/资源标识（主表Id），以HTTP请求方式（GET、POST、PUT、DELETE）区分对资源CRUD操作；
		注意要点：如果添加/修改页面（二合一版），页面创建一个input项，name="_method";值就是我们指定的请求方式，原理：SpringMVC中配置HiddenHttpMethodFilter;（SpringBoot自动配置）
	错误处理：
		效果：1、浏览器：返回一个默认的错误页面；2、其他客户端，默认响应一个json数据
		原理：ErrorMvcAutoConfiguration；错误处理的自动配置类
			一但系统出现4xx或者5xx之类的错误；
			1、ErrorPageCustomizer就会生效（定制错误的响应规则）；就会来到/error请求；
			2、就会来到BasicErrorController处理（针对浏览器与其他客户端分别处理）；
			3、浏览器：调用DefaultErrorViewResolver类，交给它处理（有模板引擎，按模板引擎处理；没有默认处理error/状态码.html）
			4、其他客户端：调用getErrorAttributes方法，返回封装的Json数据；
		定制处理处理：
			基本规则：1、有模板引擎：模板引擎文件夹里面的error文件夹下找状态码.HTML（支持精准匹配与模糊匹配如：5xx.html）
						包含信息：
							timestamp：时间戳
			​				status：状态码
			​				error：错误提示
			​				exception：异常对象
			​				message：异常消息
			​				errors：JSR303数据校验的错误
					  2、没有模板引擎：静态资源文件夹
					  3、默认：来到SpringBoot默认的错误提示页面
		定制错误的JSON返回数据（思路）：
			自定义异常处理&返回定制json数据
			转发到/error进行自适应响应效果处理
			将定制数据携带出去
	配置嵌入式Servlet容器：
	   结论：SpringBoot默认使用Tomcat作为嵌入式的Servlet容器；
	   定制：
		1、ServerProperties方式，在配置文件中配置
		   通用的Servlet容器设置，server.xxx，如：server.port=8081 server.context-path=/crud 
		   Tomcat的设置，server.tomcat.xxx
		   如：server.tomcat.uri-encoding=UTF-8
		2、EmbeddedServletContainerCustomizer方式，在java代码中配置
		如：
		@Bean  //注入到容器中
		public EmbeddedServletContainerCustomizer embeddedServletContainerCustomizer(){
			return new EmbeddedServletContainerCustomizer() {
				//定制嵌入式的Servlet容器相关的规则
				@Override
				public void customize(ConfigurableEmbeddedServletContainer container) {
					container.setPort(8083);
				}
			};
		}
    	注册Servlet三大组件：Servlet、Filter、Listener 替代在web.xml中的配置
    	自动的注册前端控制器：DispatcherServletAutoConfiguration
    	修改配置：server.servletPath修改默认拦截的请求路径
    	修改为其他的servlet容器：
		支持Tomcat Undertow Jetty
		如：
			<!-- 引入web模块 -->
			<dependency>
			   <groupId>org.springframework.boot</groupId>
			   <artifactId>spring-boot-starter-web</artifactId>
			   <exclusions>
				  <exclusion>
					 <artifactId>spring-boot-starter-tomcat</artifactId>
					 <groupId>org.springframework.boot</groupId>
				  </exclusion>
			   </exclusions>
			</dependency>
			<!--引入其他的Servlet容器-->
			<dependency>
			   <artifactId>spring-boot-starter-undertow</artifactId>
			   <groupId>org.springframework.boot</groupId>
			</dependency>
			各自区别：
				Tomcat 是Apache下的一款重量级的基于HTTP协议的服务器
				Undertow 基于NIO（非阻塞式输入输出，相对于BIO（Blocking I/O，阻塞IO））实现的高并发轻量级的服务器，支持JSP
				Jetty 基于NIO（非阻塞式输入输出，相对于BIO（Blocking I/O，阻塞IO））实现的高并发轻量级的服务器，支持长链接
				Netty是一款基于NIO（Nonblocking I/O，非阻塞IO）开发的网络通信框架，客户端服务器框架
			嵌入式Servlet容器自动配置原理：EmbeddedServletContainerAutoConfiguration
				步骤：
				1）、SpringBoot根据导入的依赖情况，给容器中添加相应的EmbeddedServletContainerFactory
				2）、容器中某个组件要创建对象就会惊动后置处理器；EmbeddedServletContainerCustomizerBeanPostProcessor；只要是嵌入式的Servlet容器工厂，后置处理器就工作；
				3）、后置处理器，从容器中获取所有的EmbeddedServletContainerCustomizer，调用定制器的定制方法
				启动原理（步骤）：
				springBoot应用启动运行run方法->refreshContext(context);SpringBoot创建并刷新IOC容器(如果是web应用创建AnnotationConfigEmbeddedWebApplicationContext，否则：AnnotationConfigApplicationContext)
				->refresh(context)刷新IOC容器->onRefresh()->webIoc容器会创建嵌入式的Servlet容器；createEmbeddedServletContainer()
				->获取嵌入式的Servlet容器工厂EmbeddedServletContainerFactory->后置处理器EmbeddedServletContainerCustomizerBeanPostProcessor工作->
				->定制器来先定制Servlet容器的相关配置->嵌入式的Servlet容器创建对象并启动Servlet容器
				结论：IOC容器启动创建嵌入式的Servlet容器并启动
			外置的Servlet容器：
				嵌入式Servlet容器将应用打成可执行的jar，优点：简单、便携；缺点：默认不支持JSP、优化定制比较复杂；
				外置的Servlet容器一般指外面安装Tomcat---应用war包的方式打包；
				使用步骤：
				1）、必须创建一个war项目；（利用idea创建好目录结构）
				2）、将嵌入式的Tomcat指定为provided；
				<dependency>
				   <groupId>org.springframework.boot</groupId>
				   <artifactId>spring-boot-starter-tomcat</artifactId>
				   <scope>provided</scope>
				</dependency>
				3）、必须编写一个SpringBootServletInitializer的子类，并调用configure方法
				public class ServletInitializer extends SpringBootServletInitializer {
				   @Override
				   protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
					   //传入SpringBoot应用的主程序
					  return application.sources(SpringBoot04WebJspApplication.class);
				   }
				}
				4）、启动服务器就可以使用；
				原理：
				jar包：执行SpringBoot主类的main方法，启动IOC容器，创建嵌入式的Servlet容器；
				war包：启动服务器，服务器启动SpringBoot应用[SpringBootServletInitializer]，启动IOC容器；
四、数据访问：
    连接JDBC:
	1、导入依赖：
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-jdbc</artifactId>
		</dependency>
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<scope>runtime</scope>
		</dependency>
	2、添加配置参数：
		spring:
		  datasource:
			username: root
			password: 123456
			url: jdbc:mysql://192.168.15.22:3306/jdbc
			driver-class-name: com.mysql.jdbc.Driver
			schema:
			- classpath:department.sql #指定位置
	3、申明使用
			相关结论：
				默认是用org.apache.tomcat.jdbc.pool.DataSource作为数据源，数据源的相关配置都在DataSourceProperties里面
				DataSourceInitializer：ApplicationListener 可以运行建表与运行数据插入（runSchemaScripts();运行建表语句；runDataScripts();运行插入数据的sql语句；）
				默认只需要将文件重命名为：schema-*.sql、data-*.sql 默认规则：schema.sql，schema-all.sql；
				可以使用
				schema:
					- classpath:department.sql #指定位置
				自动配置了JdbcTemplate操作数据库；
			整合：Druid数据源，参考：https://blog.csdn.net/weixin_41404773/article/details/82592719
				1、导入依赖：
					<dependency>
						<groupId>org.springframework.boot</groupId>
						<artifactId>spring-boot-starter-jdbc</artifactId>
					</dependency>
					<!--引入druid-->
					<!-- https://mvnrepository.com/artifact/com.alibaba/druid -->
					<dependency>
						<groupId>com.alibaba</groupId>
						<artifactId>druid</artifactId>
						<version>1.1.8</version>
					</dependency>
				2、添加配置参数：在aplication.yml或aplication.properties
					spring:
					  datasource:
						username: root
						password: 123456
						url: jdbc:mysql://localhost:3306/testwkn
						driver-class-name: com.mysql.jdbc.Driver
						type: com.alibaba.druid.pool.DruidDataSource
						initialSize: 5
						minIdle: 5
						maxActive: 20
						maxWait: 60000
						timeBetweenEvictionRunsMillis: 60000
						minEvictableIdleTimeMillis: 300000
						validationQuery: SELECT 1 FROM DUAL
						testWhileIdle: true
						testOnBorrow: false
						testOnReturn: false
						poolPreparedStatements: true
					#   配置监控统计拦截的filters，去掉后监控界面sql无法统计，'wall'用于防火墙
						filters: stat,wall,log4j
						maxPoolPreparedStatementPerConnectionSize: 20
						useGlobalDataSourceStat: true
						connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500
					#   schema:
					#     - classpath:department.sql
				3、	读取配置
					@Configuration
					public class DruidConfig {
						@ConfigurationProperties(prefix = "spring.datasource")
						@Bean
						public DataSource druid(){
						   return  new DruidDataSource();
						}
						//配置Druid的监控
						//1、配置一个管理后台的Servlet
						@Bean
						public ServletRegistrationBean statViewServlet(){
							ServletRegistrationBean bean = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");
							Map<String,String> initParams = new HashMap<>();
							initParams.put("loginUsername","admin");
							initParams.put("loginPassword","123456");
							initParams.put("allow","");//默认就是允许所有访问
							initParams.put("deny","192.168.15.21");
							bean.setInitParameters(initParams);
							return bean;
						}
						//2、配置一个web监控的filter
						@Bean
						public FilterRegistrationBean webStatFilter(){
							FilterRegistrationBean bean = new FilterRegistrationBean();
							bean.setFilter(new WebStatFilter());
							Map<String,String> initParams = new HashMap<>();
							initParams.put("exclusions","*.js,*.css,/druid/*");
							bean.setInitParameters(initParams);
							bean.setUrlPatterns(Arrays.asList("/*"));
							return  bean;
						}
					}
	整合Mybatis:
    	1、导入依赖：
    		<dependency>
    			<groupId>org.mybatis.spring.boot</groupId>
    			<artifactId>mybatis-spring-boot-starter</artifactId>
    			<version>1.3.1</version>
    		</dependency>
    	2、申明使用：
    		1、注解版-写好提供的接口，程序的入口添加@MapperScan
    		2、配置文件版
			mybatis:
			  config-location: classpath:mybatis/mybatis-config.xml #指定全局配置文件的位置
			  mapper-locations: classpath:mybatis/mapper/*.xml  #指定sql映射文件的位置
	整合Jpa（Java Persistence API，通过注解或者XML描述[对象-关系表]之间的映射关系，并将实体对象持久化到数据库中）:
		Jpa特点：ORM映射元数据：JPA支持XML和注解两种元数据的形式，元数据描述对象和表之间的映射关系，框架据此将实体对象持久化到数据库表中；如：@Entity、@Table、@Column、@Transient等注解
				 JPA 提供API：用来操作实体对象，执行CRUD操作，框架在后台替我们完成所有的事情，开发者从繁琐的JDBC和SQL代码中解脱出来；如：entityManager.merge(T t)；
				 JPQL查询语言：通过面向对象而非面向数据库的查询语言查询数据，避免程序的SQL语句紧密耦合；如：from Student s where s.name = ?
				 JPA仅仅是一种规范，也就是说JPA仅仅定义了一些接口，而接口是需要实现才能工作的。Hibernate就是实现了JPA接口的ORM框架。
		Spirng data jpa：是spring提供的一套简化JPA开发的框架，按照约定好的[方法命名规则]写dao层接口，就可以在不写接口实现的情况下，实现对数据库的访问和操作。同时提供了很多除了CRUD之外的功能，如分页、排序、复杂查询等等。Spring Data JPA 可以理解为 JPA 规范的再次封装抽象，底层还是使用了 Hibernate 的 JPA 技术实现。
					接口约定命名规则：如：findByNameAndPwd xxAndxx
					使用：
						1、导入依赖：
						<dependency>
							<groupId>org.springframework.boot/groupId>
							<artifactId>spring-boot-starter-data-jpa</artifactId>
						</dependency>
						2、添加配置：
						spring:
							jpa:
								hibernate:
							# 更新或者创建数据表结构
									ddl-auto: update
							#控制台显示SQL
								show-sql: true
								database: mysql
						3、使用：
						编写一个实体类（bean）和数据表进行映射，并且配置好映射关系；
						编写一个Dao接口来操作实体类对应的数据表（Repository）；
						如：
						//使用JPA注解配置映射关系
						@Entity //实体类（和数据表映射的类）
						@Table(name = "tbl_user") //@Table来指定和哪个数据表对应;如果省略默认表名就是user；
						public class User {
							@Id //主键
							@GeneratedValue(strategy = GenerationType.IDENTITY)//自增主键
							private Integer id;
							@Column(name = "last_name",length = 50) //这是和数据表对应的一个列
							private String lastName;
							@Column //省略默认列名就是属性名
							private String email;
						}
						public interface UserRepository extends JpaRepository<User,Integer> {
						}
	Springboot启动配置：
		构造过程（initialize(sources)）
			ApplicationContextInitializer，应用程序初始化器，做一些初始化的工作，	
			ApplicationListener，应用程序事件(ApplicationEvent)监听器，
			默认情况下，initialize方法从spring.factories文件中找出对应的key为ApplicationContextInitializer的类与ApplicationListener的类；
		SpringApplication执行
			SpringApplication构造完成之后调用run方法，启动SpringApplication，run方法执行的时候会做以下几件事
			构造Spring容器、刷新Spring容器、从Spring容器中找出ApplicationRunner和CommandLineRunner接口的实现类并排序后依次执行！
五、缓存：
    JSR107标准：
       Java Caching定义了5个核心接口，分别是CachingProvider, CacheManager, Cache, Entry和Expiry
		CachingProvider定义了创建、配置、获取、管理和控制多个CacheManager。
		CacheManager定义了创建、配置、获取、管理和控制多个唯一命名的Cache。
		Cache是一个类似Map的数据结构并临时存储以Key为索引的值。
		Entry是一个存储在Cache中的key-value对。Expiry 每一个存储在Cache中的条目有一个定义的有效期。
	使用：
    	<dependency>
    		<groupId>javax.cache</groupId>
    		<artifactId>cache-api</artifactId>
    	</dependency>
	Spring缓存抽象：
		简介：Spring从3.1开始定义了org.springframework.cache.Cache和org.springframework.cache.CacheManager接口来统一不同的缓存技术；并支持使用JCache（JSR-107）注解简化开发；
		特点：
		Cache接口为缓存的组件规范定义，包含缓存的各种操作集合；
		Cache接口下Spring提供了各种xxxCache的实现；如RedisCache，EhCacheCache , ConcurrentMapCache等；
		每次调用需要缓存功能的方法时，Spring会检查检查指定参数的指定的目标方法是否已经被调用过；如果有就直接从缓存中获取方法调用后的结果，如果没有就调用方法并缓存结果后返回给用户。下次调用直接从缓存中获取。
		使用Spring缓存抽象时我们需要关注以下两点；
		确定方法需要被缓存以及他们的缓存策略
		从缓存中读取之前缓存存储的数据
	    注解：
		@Cacheable - 主要针对方法配置，能够根据方法的请求参数对其结果进行缓存
		@CacheEvict - 清空缓存（删除）
		@CachePut - 保证方法被调用，又希望结果被缓存（更新）
		@EnableCaching	- 开启基于注解的缓存
		keyGenerator - 缓存数据时key生成策略
		serialize - 缓存数据时value序列化策略
	    