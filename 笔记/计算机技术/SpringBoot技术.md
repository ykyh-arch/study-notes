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
    