# SpringCloud
* 微服务：强调的是服务的大小，它关注的是某一个点，是具体解决某一个问题/提供落地对应服务的一个服务应用；最早提出：马丁福勒；微服务化的核心是将传统的一站式应用，根据业务拆分成一个一个的服务，彻底地去耦合,每一个微服务提供单个业务功能的服务，一个服务做一件事，从技术角度看就是一种小而独立的处理过程，类似进程概念，能够自行单独启动或销毁，拥有自己独立的数据库。
* 微服务架构：架构模式，微服务之间互相协调、互相配合，每个服务运行在其独立的进程中，服务与服务间采用轻量级的通信机制互相协作（通常是基于HTTP协议的RESTful API），包括一些环境，有机构成的整体。
    + 优点：内聚小，松耦合，拥有独立的进程，开发简单；
			   易于与第三方集成，如：与持续自动化构建部署（Jenkins, Hudson）；
			   微服务只是业务逻辑的代码，不会和HTML,CSS 或其他界面组件混合（前后端分离思想）。
	+ 缺点：开发人员要处理分布式系统的复杂性；
			多服务运维难度，随着服务的增加，运维的压力也在增大；
			系统部署依赖；
			服务间通信成本、数据一致性、系统集成测试、性能监控……
* 微服务技术栈：
    |  微服务条目	   | 落地技术	    |   备注	  |
    | --- | --- | --- |
    |  服务开发   | Springboot、Spring、SpringMVC    |     |
    |  服务配置与管理   | Netflix公司的Archaius、阿里Diamond等    |     |
    |  服务注册与发现   | Eureka、Consul、Zookeeper、AliBabaNacos等    |     |
    |  服务调用   | Rest、RPC、gRPC    |     |
    |  服务熔断器   | Hystrix、Envoy等    |     |
    |  负载均衡   | Ribbon、Feign Nginx等    |     |
    |  服务接口调用(客户端调用服务的简化工具)   | Feign等    |     |
    |  消息队列   | Kafka、RabbitMQ、ActiveMQ等    |     |
    |  服务配置中心管理   | SpringCloudConfig、Chef等    |     |
    |  服务路由（API网关）   | Zuul、Spring Cloud Gateway等    |     |
    |  服务监控   | Zabbix、Nagios、Metrics、Spectator等    |     |
    |  全链路追踪   | Zipkin，Brave、Dapper、Sleuth等    |     |
    |  服务部署   | Docker、OpenStack、Kubernetes等    |     |
    |  数据流操作开发包   | SpringCloud Stream（封装与Redis,Rabbit、Kafka等发送接收消息）    |     |
    |  事件消息总线   | Spring Cloud Bus    |     |
    |  ......   |     |     |
* SpringCloud入门介绍：
    + 含义：SpringCloud=分布式微服务架构下的一站式解决方案，是各个微服务架构落地技术的集合体，俗称微服务全家桶。
    + 与springboot的比较：SpringBoot可以离开SpringCloud独立使用开发项目，但是SpringCloud离不开SpringBoot，属于依赖的关系。SpringBoot专注于快速、方便的开发单个微服务个体，SpringCloud关注全局的服务治理框架。
    + 与Dubbo的比较：
        + 最大区别：SpringCloud抛弃了Dubbo的RPC通信，采用的是基于HTTP的REST方式。REST相比RPC更为灵活，服务提供方和调用方的依赖只依靠一纸契约，这在强调快速演化的微服务环境下，显得更加合适。
        + 品牌机与组装机的区别：Spring Cloud的功能比DUBBO更加强大，涵盖面更广，而且作为Spring的拳头项目，它也能够与Spring Framework、Spring Boot、Spring Data、Spring Batch等其他Spring项目完美融合，这些对于微服务而言是至关重要的。使用Dubbo构建的微服务架构就像组装电脑，各环节我们的选择自由度很高；而Spring Cloud就像品牌机，在Spring Source的整合下，做了大量的兼容性测试，保证了机器拥有更高的稳定性。
        + 社区支持与更新力度：最为重要的是，DUBBO停止了5年左右的更新，虽然2017.7重启了(刘军)。对于技术发展的新需求，需要由开发者自行拓展升级（比如当当网弄出了DubboX），这对于很多想要采用微服务架构的中小软件组织，显然是不太合适的，中小公司没有这么强大的技术能力去修改Dubbo源码+周边的一整套解决方案，并不是每一个公司都有阿里的大牛+真实的线上生产环境测试过。
    + 简单服务调用：
    RestTemplate + API 使用方式：RestTemplate提供了多种便捷访问远程Http服务的方法，是一种简单便捷的访问restful服务模板类，是Spring提供的用于访问Rest服务的客户端模板工具集；
    使用步骤：
    1，注入Bean；
        ```java
        @Configuration
    	public class ConfigBean{
        	@Bean
        	public RestTemplate getRestTemplate(){
        	return new RestTemplate();
    		}
    	}
        ```
        2，声明使用：
        ```java
        @Autowired
    	private RestTemplate restTemplate;
    	//方法中
    	restTemplate.postForObject(REST_URL_PREFIX+"/dept/add", dept, Boolean.class); //参数：REST请求地址、请求参数、HTTP响应转换被转换成的对象类型
        ```
* 服务注册与发现：
  **Eureka(C/S)**
  + 简介：Netflix公司的子模块，是一个基于REST的服务，用于定位服务，以实现云端中间层服务发现和故障转移。Netflix在设计Eureka时遵守的就是AP原则（**CAP原则：CAP原则又称CAP定理，指的是在一个分布式系统中，Consistency（一致性）、 Availability（可用性）、Partition tolerance（分区容错性），三者不可兼得**）；
  + 功能：
  1、Eureka Server 提供服务注册和发现；
  2、Service Provider服务提供方将自身服务注册到Eureka，从而使服务消费方能够找到；
  3、Service Consumer服务消费方从Eureka获取注册服务列表，从而能够消费服务；
  + 使用注册中心:
    服务端
    1,引用模块：POM.XML
    ```xml
    <dependency>
		<groupId>org.springframework.cloud<groupId>
		<artifactId>spring-cloud-starter-eureka-server<artifactId>
	</dependency>
	```
	2,配置参数：application.properties或YML文件的配置
	```properties
      eureka.instance.hostname=localhost
      #不要向注册中心注册自己
      eureka.client.register-with-eureka=false
      #禁止检索服务
      eureka.client.fetch-registry=false
      eureka.client.service-url.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka
	```
	3,申明使用：程序main入口，添加@EnableEurekaServer注解，来开启服务注册中心；
	客户端：
	1,引用模块：POM.XML
	```xml
	<dependency>
    	<groupId>org.springframework.cloud</groupId>
    	<artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
	```
	2,配置参数：application.properties或YML文件的配置
	```yml
	#设置服务名
	spring:
	  application:
		name: 服务名
	eureka:
		  client: #客户端注册进eureka服务列表内
			service-url:
			  defaultZone: http://localhost:7001/eureka
			  instance:
				instance-id: 服务实例名 #设置后可以隐藏主机名
			  prefer-ip-address: true #访问路径可以显示IP地址
			  #点击链接显示
			  info:
				  app.name: 服务程序名
				  company.name: 公司名
				  build.artifactId: $project.artifactId$
				  build.version: $project.version$
	```
	3,申明使用：主类上添加@EnableEurekaClient注解以实现Eureka中的DiscoveryClient实现，可以使用@EnableDiscoveryClient代替；
  + 使用服务发现：
    申明使用，主启动类添加@EnableDiscoveryClient；使用时注入以下代码：
	 ```java
	 @Autowired
	 private DiscoveryClient client //注：DiscoveryClient是spring clould对治理体系的一个抽象
	 ```
  + 自我保护机制：某时刻某一个微服务不可用了，eureka不会立刻清理，依旧会对该微服务的信息进行保存!
  + 集群处理：
    ```yml
     #服务端
     eureka:
    	instance:
    		hostname: eureka1.com #eureka服务端的实例名称
    	client:
    		register-with-eureka: false #false表示不向注册中心注册自己。
    		fetch-registry: false #false表示自己端就是注册中心，职责就是维护服务实例，并不需要去检索服务
    	service-url:
    	#单机 defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/  #设置与Eureka Server交互的地址查询服务和注册服务都需要依赖这个地址（单机）。
    	defaultZone: http://eureka1.com:7002/eureka/,http://eureka3.com:7003/eureka/
    ```
  + 与Dubbo的Zookeeper的比较：
    著名的CAP理论指出，一个分布式系统不可能同时满足C(一致性)、A(可用性)和P(分区容错性)。由于分区容错性P在是分布式系统中必须要保证的，因此我们只能在A和C之间进行权衡。因此,Zookeeper保证的是CP,Eureka则是AP。因此，Eureka可以很好的应对因网络故障导致部分节点失去联系的情况，而不会像zookeeper那样使整个注册服务瘫痪。
  **Consul**
  + 简介：Spring Cloud Consul是分布式的、高可用、横向扩展(AP原则)，它包含多个组件，但是作为一个整体，在微服务架构中为我们的基础设施提供服务发现和服务配置的工具。它包含了下面几个特性：
	    1、服务发现（service discovery）
	    2、健康检查（health checking）
	    3、Key/Value存储（一个用来存储动态配置的系统）
	    4、多数据中心（multi-datacenter）
  + 使用-客户端：
    1,引用模块：POM.XML
    ```xml
    <dependency>
	  <groupId>org.springframework.cloud</groupId>
	  <artifactId>spring-cloud-starter-consul-discovery</artifactId>
	</dependency>
    ```
	2,配置参数：application.properties或YML文件的配置
	```properties
	spring.cloud.consul.host=localhost #域名
	spring.cloud.consul.port=8500 #端口
	```
	3,申明使用：程序main入口，添加@EnableDiscoveryClient注解，开启服务治理；注意：consul不需要创建类似eureka-server的服务端吗？由于Consul自身提供了服务端，所以我们不需要像之前实现Eureka的时候创建服务注册中心，直接通过下载consul的服务端程序就可以使用。启动consul服务：$consul agent -dev；
  **Nocas**
  参考Spring Cloud Alibaba 技术站的Nocas相关内容，详情参考：https://blog.csdn.net/qq_38765404/article/details/89521124；
* 负载均衡：
    + Ribbon（结合Eureka使用）
        + 简介：基于Netflix实现的一套客户端负载均衡的工具，主要功能是提供客户端的软件负载均衡算法。
		 + 负载均衡：将用户的请求基于某种规则平摊的分配到多个服务上，从而达到系统的HA，常见的负载均衡有软件Nginx，LVS，Haproxy，硬件F5等；
		 + 分类：集中式LB-即在服务的消费方和提供方之间使用独立的LB设施(可以是硬件，如F5, 也可以是软件，如nginx), 由该设施负责把访问请求通过某种策略转发至服务的消费方；
				 进程内LB-将LB逻辑集成到消费方，消费方从服务注册中心获知有哪些地址可用，然后自己再从这些地址中选择出一个合适的服务器。Ribbon就属于进程内LB。
	+ 申明使用：
	    1,引用模块：POM.XML
	    ```xml
	    <dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-ribbon</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka</artifactId>
		</dependency>
	    ```
		2,配置参数：application.properties或YML文件的配置
		```yml
		#eureka配置
		server:
			port: 80
			eureka:
				client:
				register-with-eureka: false
				service-url:
				defaultZone: http://eureka1.com:7001/eureka/,http://eureka2.com:7002/eureka/,http://eureka3.com:7003/eureka/
		```
		3,申明使用：1、程序main入口，添加@EnableDiscoveryClient注解，开启服务治理；2、在配置文件ConfigBean中添加@LoadBalanced注解即可；结论：Ribbon和Eureka整合后服务消费方可以直接调用服务而不用再关心地址和端口号。
		4,策略IRule：简单轮询负载均衡RoundRobinRule，区别于RetryRule，随机负载均衡，加权响应时间负载均衡 ，区域感知轮询负载均衡；
		5,自定义Ribbon：主启动类添加@RibbonClient注解，格式：@RibbonClient(name="MICROSERVICECLOUD",configuration=MySelfRule.class)，注意：这个自定义配置类不能放在@ComponentScan所扫描的当前包下以及子包下，否则我们自定义的这个配置类就会被所有的Ribbon客户端所共享，也就是说我们达不到特殊化定制的目的了。在配置文件ConfigBean中添加@LoadBalanced注解。
	+ Feign（声明式服务调用，WebService客户端）：
	    + 含义：它的使用方法是定义一个接口，然后在上面添加注解，同时也支持JAX-RS（Java API for RESTful Web Services）标准的注解。
	    + 特性：
	       可插拔式的注解支持，包括Feign注解和JAX-RS注解；
			支持可插拔的HTTP编码器和解码器；
			支持Hystrix和它的Fallback；
			支持Ribbon的负载均衡；
			支持HTTP请求和响应的压缩。
		+ 使用：
		1,引用模块：POM.XML
		```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-feign</artifactId>
		</dependency>
    	<dependency>
    		<groupId>org.springframework.cloud</groupId>
    		<artifactId>spring-cloud-starter-eureka</artifactId>
    		<version>1.3.5.RELEASE</version>
    	</dependency>
		```
		2,配置参数：application.properties或YML文件的配置
		```yml
		server:
			port: 80
			eureka:
				client:
				register-with-eureka: false
				service-url:
				defaultZone: http://eureka1.com:7001/eureka/,http://eureka2.com:7002/eureka/,http://eureka3.com:7003/eureka/
		```
		3,申明使用：
	    a.程序main入口，添加@EnableDiscoveryClient注解，开启服务治理；同时添加@EnableFeignClients来开启feign；
        b.定义接口：
       ```java
       /*格式：value=“服务名称”,configuration = xxx.class 这个类配置Hystrix的一些精确属性*/
       @FeignClient(value = "serviceName",fallback = FeignFallBack.class)
	    public interface FeignService {
			@RequestMapping(value = "/ml", method= RequestMethod.GET)
			String method1(@RequestParam("name") String name);
		}
		@Component
		public class FeignFallBack implements FeignService{
		　　//实现的方法是服务调用的降级方法
			@Override
			public String method1() {
				return "error";
			}
		}
       ```
* 服务熔断器（断路器）：
  **Hystrix**
  + 概念来源：服务雪崩：
	服务扇出：多个微服务之间调用的时候，假设微服务A调用微服务B和微服务C，微服务B和微服务C又调用其它的微服务，这就是所谓的“扇出”效应。
	解决方案：熔断模式（容错处理机制）、隔离模式（容错处理机制）、限流模式（预防模式）。
  +	简介：Hystrix是一个用于处理分布式系统的延迟和容错的开源库，在分布式系统（SOA面向服务架构）里，许多依赖不可避免的会调用失败，比如超时、异常等，Hystrix能够保证在一个依赖出问题的情况下，不会导致整体服务失败，避免级联故障，以提高分布式系统的弹性。“断路器”本身是一种开关装置，当某个服务单元发生故障之后，通过断路器的故障监控（类似熔断保险丝），向调用方返回一个符合预期的、可处理的备选响应（FallBack），而不是长时间的等待或者抛出调用方无法处理的异常，这样就保证了服务调用方的线程不会被长时间、不必要地占用，从而避免了故障在分布式系统中的蔓延，乃至雪崩。
  + 服务熔断
    概念：当扇出链路的某个微服务不可用或者响应时间太长时，会进行服务的降级，进而熔断该节点微服务的调用，快速返回"错误"的响应信息。SpringCloud框架里熔断机制通过Hystrix实现。Hystrix会监控微服务间调用的状况，当失败的调用到一定阈值，缺省是5秒内20次调用失败就会启动熔断机制。熔断机制的注解是@HystrixCommand。
    使用方式：
    1,引用模块：POM.XML
    ```xml
     <dependency>
		<groupId>org.springframework.cloud</groupId>
		<artifactId>spring-cloud-starter-hystrix</artifactId>
	</dependency>
    ```
	2,配置参数：application.properties或YML文件的配置
	```yml
	server:
		port: 80
		eureka:
			client:
			register-with-eureka: false
			service-url:
			defaultZone: http://eureka1.com:7001/eureka/,http://eureka2.com:7002/eureka/,http://eureka3.com:7003/eureka/
	```
	3,申明使用：
	a、程序main入口，添加@EnableCircuitBreaker注解，开启熔断支持；
	b、在控制层申明使用
	```java
	//格式示例：fallbackMethod 快速应急的处理方法，进行服务降级处理；
	@RequestMapping(value="/dept/get/{id}",method=RequestMethod.GET)
	@HystrixCommand(fallbackMethod = "processHystrix_Get")
	public Dept get(@PathVariable("id") Long id){
	    Dept dept =  this.service.get(id);
		if(null == dept){
		throw new RuntimeException("该ID："+id+"没有没有对应的信息");
	    }
		return dept;
	}
	public Dept processHystrix_Get(@PathVariable("id") Long id){
		return new Dept().setDeptno(id)
			   .setDname("该ID："+id+"没有没有对应的信息,null--@HystrixCommand")
			   .setDb_source("no this database in MySQL");
	}
	```
	+ 服务降级Fallback
	  概念：整体资源快不够了，忍痛将某些服务先关掉，待渡过难关，再开启回来。服务降级处理是在客户端实现完成的，与服务端没有关系。
	  申明使用（与Feign结合使用）：
	  ```java
	  @FeignClient(value = "MICROSERVICECLOUD",fallbackFactory=DeptClientServiceFallbackFactory.class)
	  public interface DeptClientService{
			@RequestMapping(value = "/dept/get/{id}",method = RequestMethod.GET)
			public Dept get(@PathVariable("id") long id);
      }
	  @Component
	  public class DeptClientServiceFallbackFactory implements FallbackFactory{
			@Override
			public Dept get(@PathVariable("id") long id){
				...
			}
	  }
	  ```
	  注意：在application.properties或YML文件的配置添加一行配置
	  ```yml
      feign:
    		hystrix:
    			enabled: true //开启
	  ```
   + 服务监控HystrixDashboard
     概念：Hystrix还提供了准实时的监控（Hystrix Dashboard），Spring Cloud也提供了Hystrix Dashboard的整合，对监控内容转化成可视化界面。
     使用方式：
     1,引用模块：POM.XML
      ```xml
       <dependency>
    		<groupId>org.springframework.cloud</groupId>
    		<artifactId>spring-cloud-starter-hystrix</artifactId>
    	</dependency>
    	<dependency>
    		<groupId>org.springframework.cloud</groupId>
    		<artifactId>spring-boot-starter-actuator</artifactId>
    	</dependency>
    	<dependency>
    		<groupId>org.springframework.cloud</groupId>
    		<artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
    	</dependency>
     ```
	2,配置参数：application.properties或YML文件的配置
	```yml
      server:
			port: 9901
	```
	3,申明使用：1、程序main入口，添加@EnableHystrixDashboard注解，开启熔断监控的支持；
* 路由网关:
    
