#!/usr/bin/env python3
"""批量生成代码片段SQL文件"""
import datetime

snippets = []

def add(title, desc, lang, code, views=0, likes=0):
    code_escaped = code.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n")
    desc_escaped = desc.replace("'", "\\'")
    snippets.append((title, desc_escaped, lang, code_escaped, views, likes))

# ========== Java ==========
add('单例模式-双重检查锁', '线程安全的单例实现', 'Java',
'class Singleton {\n    private static volatile Singleton instance;\n    private Singleton() {}\n    public static Singleton getInstance() {\n        if (instance == null) {\n            synchronized (Singleton.class) {\n                if (instance == null) instance = new Singleton();\n            }\n        }\n        return instance;\n    }\n}')

add('冒泡排序', '经典冒泡排序，带提前退出优化', 'Java',
'static void bubbleSort(int[] arr) {\n    int n = arr.length;\n    for (int i = 0; i < n-1; i++) {\n        boolean swapped = false;\n        for (int j = 0; j < n-i-1; j++) {\n            if (arr[j] > arr[j+1]) {\n                int t = arr[j]; arr[j] = arr[j+1]; arr[j+1] = t;\n                swapped = true;\n            }\n        }\n        if (!swapped) break;\n    }\n}')

add('选择排序', '每次选择最小元素放到已排序末尾', 'Java',
'static void selectionSort(int[] arr) {\n    for (int i = 0; i < arr.length-1; i++) {\n        int minIdx = i;\n        for (int j = i+1; j < arr.length; j++)\n            if (arr[j] < arr[minIdx]) minIdx = j;\n        int t = arr[i]; arr[i] = arr[minIdx]; arr[minIdx] = t;\n    }\n}')

add('插入排序', '将元素插入到已排序序列的正确位置', 'Java',
'static void insertionSort(int[] arr) {\n    for (int i = 1; i < arr.length; i++) {\n        int key = arr[i], j = i-1;\n        while (j >= 0 && arr[j] > key) {\n            arr[j+1] = arr[j]; j--;\n        }\n        arr[j+1] = key;\n    }\n}')

add('归并排序', '分治思想的归并排序，O(n log n)', 'Java',
'static void mergeSort(int[] arr, int l, int r) {\n    if (l >= r) return;\n    int m = l + (r-l)/2;\n    mergeSort(arr, l, m);\n    mergeSort(arr, m+1, r);\n    int[] tmp = new int[r-l+1];\n    int i=l, j=m+1, k=0;\n    while (i<=m && j<=r) tmp[k++] = arr[i]<=arr[j] ? arr[i++] : arr[j++];\n    while (i<=m) tmp[k++] = arr[i++];\n    while (j<=r) tmp[k++] = arr[j++];\n    System.arraycopy(tmp, 0, arr, l, tmp.length);\n}')

add('二分查找', '有序数组的二分查找，O(log n)', 'Java',
'static int binarySearch(int[] arr, int target) {\n    int l=0, r=arr.length-1;\n    while (l<=r) {\n        int m = l+(r-l)/2;\n        if (arr[m]==target) return m;\n        else if (arr[m]<target) l=m+1;\n        else r=m-1;\n    }\n    return -1;\n}')

add('链表反转-迭代', '迭代方式反转单链表', 'Java',
'ListNode reverseList(ListNode head) {\n    ListNode prev=null, curr=head;\n    while (curr!=null) {\n        ListNode next=curr.next;\n        curr.next=prev;\n        prev=curr; curr=next;\n    }\n    return prev;\n}')

add('链表反转-递归', '递归方式反转单链表', 'Java',
'ListNode reverseList(ListNode head) {\n    if (head==null||head.next==null) return head;\n    ListNode newHead = reverseList(head.next);\n    head.next.next = head;\n    head.next = null;\n    return newHead;\n}')

add('LRU缓存', '基于LinkedHashMap的LRU缓存实现', 'Java',
'class LRUCache<K,V> extends LinkedHashMap<K,V> {\n    private final int cap;\n    LRUCache(int cap) { super(cap, 0.75f, true); this.cap=cap; }\n    protected boolean removeEldestEntry(Map.Entry<K,V> e) {\n        return size()>cap;\n    }\n}')

add('生产者消费者', 'BlockingQueue实现的生产者消费者模式', 'Java',
'BlockingQueue<String> q = new ArrayBlockingQueue<>(10);\nnew Thread(()->{ try{ while(true){ q.put(produce()); } }catch(InterruptedException e){} }).start();\nnew Thread(()->{ try{ while(true){ consume(q.take()); } }catch(InterruptedException e){} }).start();')

add('观察者模式', '事件总线实现观察者模式', 'Java',
'class EventBus {\n    Map<String,List<Consumer<Object>>> map = new ConcurrentHashMap<>();\n    void on(String e, Consumer<Object> l) {\n        map.computeIfAbsent(e, k->new CopyOnWriteArrayList<>()).add(l);\n    }\n    void emit(String e, Object d) {\n        map.getOrDefault(e, List.of()).forEach(l->l.accept(d));\n    }\n}')

add('策略模式', '用策略模式替代if-else分支', 'Java',
'interface Strategy { int calculate(int a, int b); }\nMap<String, Strategy> strategies = Map.of(\n    "add", (a,b)->a+b,\n    "sub", (a,b)->a-b,\n    "mul", (a,b)->a*b\n);\nint result = strategies.get("add").calculate(3, 5);')

add('工厂模式', '简单工厂创建不同类型的对象', 'Java',
'interface Shape { void draw(); }\nclass Circle implements Shape { public void draw() { System.out.println("Circle"); } }\nclass Rectangle implements Shape { public void draw() { System.out.println("Rectangle"); } }\nclass ShapeFactory {\n    static Shape create(String type) {\n        return switch(type) {\n            case "circle" -> new Circle();\n            case "rect" -> new Rectangle();\n            default -> throw new IllegalArgumentException();\n        };\n    }\n}')

add('建造者模式', '链式调用构建复杂对象', 'Java',
'class User {\n    private String name, email;\n    private int age;\n    static Builder builder() { return new Builder(); }\n    static class Builder {\n        private User u = new User();\n        Builder name(String n) { u.name=n; return this; }\n        Builder email(String e) { u.email=e; return this; }\n        Builder age(int a) { u.age=a; return this; }\n        User build() { return u; }\n    }\n}\nUser u = User.builder().name("Tom").email("t@x.com").age(25).build();')

add('CompletableFuture异步编排', '多任务并行执行后汇总结果', 'Java',
'CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> fetchUser());\nCompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> fetchOrder());\nCompletableFuture<String> f3 = CompletableFuture.supplyAsync(() -> fetchProduct());\nString result = CompletableFuture.allOf(f1,f2,f3)\n    .thenApply(v -> f1.join()+","+f2.join()+","+f3.join())\n    .get(5, TimeUnit.SECONDS);')

add('Stream API常用操作', '集合的过滤、映射、分组、排序', 'Java',
'List<User> users = getUsers();\n// 过滤+映射\nList<String> names = users.stream()\n    .filter(u -> u.getAge() > 18)\n    .map(User::getName)\n    .collect(Collectors.toList());\n// 分组\nMap<Integer, List<User>> byAge = users.stream()\n    .collect(Collectors.groupingBy(User::getAge));\n// 排序\nusers.sort(Comparator.comparing(User::getAge).reversed());')

add('线程池创建', '推荐的线程池创建方式', 'Java',
'ExecutorService pool = new ThreadPoolExecutor(\n    4, 8, 60L, TimeUnit.SECONDS,\n    new LinkedBlockingQueue<>(1000),\n    new ThreadFactoryBuilder().setNameFormat("worker-%d").build(),\n    new ThreadPoolExecutor.CallerRunsPolicy()\n);')

add('定时任务', 'ScheduledExecutorService定时执行', 'Java',
'ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(2);\n// 延迟3秒后执行\nscheduler.schedule(() -> System.out.println("delayed"), 3, TimeUnit.SECONDS);\n// 每5秒执行一次\nscheduler.scheduleAtFixedRate(() -> System.out.println("periodic"), 0, 5, TimeUnit.SECONDS);')

add('字符串工具类', '常用的字符串操作方法', 'Java',
'class Str {\n    static boolean empty(String s) { return s==null||s.isEmpty(); }\n    static boolean blank(String s) { return s==null||s.trim().isEmpty(); }\n    static String cap(String s) { return empty(s)?s:Character.toUpperCase(s.charAt(0))+s.substring(1); }\n    static String reverse(String s) { return empty(s)?s:new StringBuilder(s).reverse().toString(); }\n    static String repeat(String s, int n) { return s.repeat(n); }\n}')

add('文件读写工具', '读取和写入文件内容', 'Java',
'static String readFile(String path) throws IOException {\n    return Files.readString(Path.of(path));\n}\nstatic void writeFile(String path, String content) throws IOException {\n    Files.writeString(Path.of(path), content);\n}\nstatic List<String> readLines(String path) throws IOException {\n    return Files.readAllLines(Path.of(path));\n}')

add('JWT Token工具', '生成和解析JWT Token', 'Java',
'String token = Jwts.builder()\n    .setSubject(username)\n    .claim("userId", userId)\n    .setExpiration(new Date(System.currentTimeMillis()+86400000))\n    .signWith(key, SignatureAlgorithm.HS256)\n    .compact();\nClaims claims = Jwts.parserBuilder().setSigningKey(key).build()\n    .parseClaimsJws(token).getBody();')

add('Spring Boot REST Controller', '标准的RESTful接口写法', 'Java',
'@RestController@RequestMapping("/api/user")\nclass UserController {\n    @Autowired UserService service;\n    @GetMapping("/{id}") Result<User> get(@PathVariable Long id) {\n        return Result.success(service.getById(id));\n    }\n    @PostMapping Result<Void> create(@RequestBody @Valid UserDTO dto) {\n        service.save(dto); return Result.success();\n    }\n    @PutMapping("/{id}") Result<Void> update(@PathVariable Long id, @RequestBody UserDTO dto) {\n        service.update(id, dto); return Result.success();\n    }\n}')

add('MyBatis-Plus分页查询', '配置分页插件并使用分页查询', 'Java',
'@Bean\npublic MybatisPlusInterceptor paginationInterceptor() {\n    MybatisPlusInterceptor i = new MybatisPlusInterceptor();\n    i.addInnerInterceptor(new PaginationInnerInterceptor());\n    return i;\n}\n// 使用\nPage<User> page = new Page<>(1, 10);\nQueryWrapper<User> wrapper = new QueryWrapper<>();\nwrapper.like("name", keyword).orderByDesc("created_at");\nPage<User> result = userMapper.selectPage(page, wrapper);')

add('全局异常处理', '统一异常处理返回格式', 'Java',
'@RestControllerAdvice\nclass GlobalExceptionHandler {\n    @ExceptionHandler(BusinessException.class)\n    Result<?> handleBiz(BusinessException e) {\n        return Result.error(e.getCode(), e.getMessage());\n    }\n    @ExceptionHandler(MethodArgumentNotValidException.class)\n    Result<?> handleValid(MethodArgumentNotValidException e) {\n        String msg = e.getBindingResult().getAllErrors().get(0).getDefaultMessage();\n        return Result.error(400, msg);\n    }\n    @ExceptionHandler(Exception.class)\n    Result<?> handleOther(Exception e) {\n        return Result.error("系统内部错误");\n    }\n}')

add('Redis缓存工具', '使用RedisTemplate进行缓存操作', 'Java',
'@Autowired RedisTemplate<String, Object> redis;\nvoid set(String key, Object val, long ttl) {\n    redis.opsForValue().set(key, val, ttl, TimeUnit.SECONDS);\n}\n<T> T get(String key, Class<T> clazz) {\n    Object val = redis.opsForValue().get(key);\n    return val != null ? clazz.cast(val) : null;\n}\nvoid delete(String key) {\n    redis.delete(key);\n}')

add('参数校验DTO', '使用Jakarta Validation进行参数校验', 'Java',
'class UserDTO {\n    @NotBlank(message = "用户名不能为空")\n    @Size(min=2, max=20, message = "用户名2-20字符")\n    private String username;\n    @NotBlank(message = "邮箱不能为空")\n    @Email(message = "邮箱格式不正确")\n    private String email;\n    @NotNull(message = "年龄不能为空")\n    @Min(value=1, message = "年龄必须大于0")\n    private Integer age;\n}')

add('AOP日志切面', '记录接口调用日志的AOP切面', 'Java',
'@Aspect@Component\nclass LogAspect {\n    @Around("@annotation(log)")\n    Object around(ProceedingJoinPoint p, Log log) throws Throwable {\n        long start = System.currentTimeMillis();\n        Object result = p.proceed();\n        long cost = System.currentTimeMillis() - start;\n        System.out.println(p.getSignature()+" cost:"+cost+"ms");\n        return result;\n    }\n}')

add('CSV导出工具', '将List数据导出为CSV格式', 'Java',
'static <T> void exportCsv(List<T> data, String[] headers, Function<T, String[]> mapper, OutputStream os) throws IOException {\n    PrintWriter w = new PrintWriter(new OutputStreamWriter(os, StandardCharsets.UTF_8));\n    w.println(String.join(",", headers));\n    for (T item : data) w.println(String.join(",", mapper.apply(item)));\n    w.flush();\n}')

add('HTTP客户端工具', '使用Java 11 HttpClient发送请求', 'Java',
'static String get(String url) throws Exception {\n    HttpClient client = HttpClient.newHttpClient();\n    HttpRequest req = HttpRequest.newBuilder(URI.create(url))\n        .header("Accept","application/json").build();\n    return client.send(req, BodyHandlers.ofString()).body();\n}\nstatic String post(String url, String json) throws Exception {\n    HttpClient client = HttpClient.newHttpClient();\n    HttpRequest req = HttpRequest.newBuilder(URI.create(url))\n        .POST(BodyPublishers.ofString(json))\n        .header("Content-Type","application/json").build();\n    return client.send(req, BodyHandlers.ofString()).body();\n}')

add('树形结构构建', '从平铺列表构建树形结构', 'Java',
'List<TreeNode> buildTree(List<TreeNode> nodes) {\n    Map<Long, TreeNode> map = nodes.stream()\n        .collect(Collectors.toMap(TreeNode::getId, n -> n));\n    List<TreeNode> roots = new ArrayList<>();\n    for (TreeNode node : nodes) {\n        if (node.getParentId() == null) roots.add(node);\n        else map.get(node.getParentId()).getChildren().add(node);\n    }\n    return roots;\n}')

add('敏感信息脱敏', '手机号、身份证、邮箱脱敏处理', 'Java',
'class Desensitize {\n    static String phone(String p) { return p.replaceAll("(\\d{3})\\d{4}(\\d{4})","$1****$2"); }\n    static String idCard(String id) { return id.replaceAll("(\\d{4})\\d{10}(\\w{4})","$1**********$2"); }\n    static String email(String e) { return e.replaceAll("(\\w)\\w*@(\\w)","$1***@$2"); }\n    static String name(String n) { return n.charAt(0)+"*".repeat(n.length()-1); }\n}')

add('分布式ID生成-雪花算法', 'Twitter雪花算法生成唯一ID', 'Java',
'class Snowflake {\n    private final long epoch = 1609459200000L;\n    private long seq = 0, lastTime = 0;\n    private final long machineId;\n    Snowflake(long machineId) { this.machineId = machineId; }\n    synchronized long nextId() {\n        long time = System.currentTimeMillis() - epoch;\n        if (time == lastTime) seq = (seq+1) & 4095;\n        else { seq = 0; lastTime = time; }\n        return (time << 22) | (machineId << 12) | seq;\n    }\n}')

add('枚举实现状态机', '使用枚举实现简单的状态流转', 'Java',
'enum OrderStatus {\n    CREATED { public OrderStatus next() { return PAID; } },\n    PAID { public OrderStatus next() { return SHIPPED; } },\n    SHIPPED { public OrderStatus next() { return COMPLETED; } },\n    COMPLETED { public OrderStatus next() { return this; } };\n    public abstract OrderStatus next();\n}\nOrderStatus status = OrderStatus.CREATED;\nstatus = status.next(); // PAID')

add('图片验证码生成', '生成随机图片验证码', 'Java',
'static BufferedImage createCaptcha(String code, int w, int h) {\n    BufferedImage img = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);\n    Graphics2D g = img.createGraphics();\n    g.setColor(Color.WHITE); g.fillRect(0,0,w,h);\n    g.setFont(new Font("Arial", Font.BOLD, 36));\n    Random r = new Random();\n    for (int i=0; i<code.length(); i++) {\n        g.setColor(new Color(r.nextInt(200), r.nextInt(200), r.nextInt(200)));\n        g.drawString(String.valueOf(code.charAt(i)), 10+i*30, 35+r.nextInt(10));\n    }\n    g.dispose(); return img;\n}')

add('限流器-令牌桶', '简单的令牌桶限流实现', 'Java',
'class RateLimiter {\n    private final int maxTokens;\n    private int tokens;\n    private long lastRefill;\n    RateLimiter(int max, int refillPerSec) {\n        this.maxTokens = max; this.tokens = max;\n        this.lastRefill = System.currentTimeMillis();\n    }\n    synchronized boolean tryAcquire() {\n        long now = System.currentTimeMillis();\n        tokens = Math.min(maxTokens, tokens + (int)((now-lastRefill)/1000));\n        lastRefill = now;\n        if (tokens > 0) { tokens--; return true; }\n        return false;\n    }\n}')

add('WebSocket配置', 'Spring Boot WebSocket配置类', 'Java',
'@Configuration@EnableWebSocket\nclass WebSocketConfig implements WebSocketConfigurer {\n    @Override\n    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {\n        registry.addHandler(new ChatHandler(), "/ws/chat")\n            .setAllowedOrigins("*");\n    }\n}\nclass ChatHandler extends TextWebSocketHandler {\n    private final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();\n    public void afterConnectionEstablished(WebSocketSession s) { sessions.add(s); }\n    protected void handleTextMessage(WebSocketSession s, TextMessage m) {\n        sessions.forEach(ss -> { try { ss.sendMessage(m); } catch(Exception e){} });\n    }\n}')

add('验证码倒计时', '发送验证码后的60秒倒计时', 'Java',
'Map<String, Long> codeExpire = new ConcurrentHashMap<>();\nvoid sendCode(String phone) {\n    if (codeExpire.containsKey(phone) && System.currentTimeMillis() < codeExpire.get(phone)) {\n        long left = (codeExpire.get(phone) - System.currentTimeMillis()) / 1000;\n        throw new RuntimeException(left + "秒后再试");\n    }\n    String code = String.valueOf(new Random().nextInt(900000) + 100000);\n    codeExpire.put(phone, System.currentTimeMillis() + 60000);\n    smsService.send(phone, code);\n}')

add('深拷贝工具', '使用序列化实现对象深拷贝', 'Java',
'@SuppressWarnings("unchecked")\nstatic <T extends Serializable> T deepCopy(T obj) {\n    ByteArrayOutputStream bos = new ByteArrayOutputStream();\n    ObjectOutputStream oos = new ObjectOutputStream(bos);\n    oos.writeObject(obj);\n    ObjectInputStream ois = new ObjectInputStream(\n        new ByteArrayInputStream(bos.toByteArray()));\n    return (T) ois.readObject();\n}')

# ========== Python ==========
add('列表推导式', 'Python列表推导式的各种用法', 'Python',
'squares = [x**2 for x in range(10)]\nevens = [x for x in range(20) if x % 2 == 0]\nmatrix = [[i*j for j in range(5)] for i in range(5)]\nflat = [x for row in matrix for x in row]\nd = {x: x**2 for x in range(5)}')

add('装饰器-计时器', '计算函数执行时间的装饰器', 'Python',
'import time, functools\n\ndef timer(func):\n    @functools.wraps(func)\n    def wrapper(*args, **kwargs):\n        start = time.perf_counter()\n        result = func(*args, **kwargs)\n        elapsed = time.perf_counter() - start\n        print(f"{func.__name__} took {elapsed:.4f}s")\n        return result\n    return wrapper')

add('装饰器-缓存', '带过期时间的缓存装饰器', 'Python',
'import time, functools\n\ndef cache(ttl=300):\n    def decorator(func):\n        cache_data = {}\n        @functools.wraps(func)\n        def wrapper(*args):\n            if args in cache_data:\n                result, ts = cache_data[args]\n                if time.time() - ts < ttl: return result\n            result = func(*args)\n            cache_data[args] = (result, time.time())\n            return result\n        return wrapper\n    return decorator')

add('装饰器-重试', '失败自动重试的装饰器', 'Python',
'import time, functools\n\ndef retry(max_attempts=3, delay=1, exceptions=(Exception,)):\n    def decorator(func):\n        @functools.wraps(func)\n        def wrapper(*args, **kwargs):\n            for attempt in range(max_attempts):\n                try: return func(*args, **kwargs)\n                except exceptions as e:\n                    if attempt == max_attempts - 1: raise\n                    time.sleep(delay * 2**attempt)\n        return wrapper\n    return decorator')

add('装饰器-权限检查', 'Flask路由权限检查装饰器', 'Python',
'from functools import wraps\nfrom flask import session, redirect, url_for\n\ndef login_required(f):\n    @wraps(f)\n    def decorated(*args, **kwargs):\n        if not session.get("user_id"):\n            return redirect(url_for("login"))\n        return f(*args, **kwargs)\n    return decorated')

add('生成器-fibonacci', '使用生成器实现斐波那契数列', 'Python',
'def fibonacci():\n    a, b = 0, 1\n    while True:\n        yield a\n        a, b = b, a + b\n\n# 取前10个\nfib = fibonacci()\nfirst_10 = [next(fib) for _ in range(10)]')

add('上下文管理器', '自定义上下文管理器管理资源', 'Python',
'from contextlib import contextmanager\n\n@contextmanager\ndef timer(label):\n    import time\n    start = time.perf_counter()\n    yield\n    elapsed = time.perf_counter() - start\n    print(f"{label}: {elapsed:.4f}s")\n\nwith timer("sort"):\n    sorted(range(1000000), reverse=True)')

add('多线程并发执行', '使用ThreadPoolExecutor并发执行任务', 'Python',
'from concurrent.futures import ThreadPoolExecutor, as_completed\n\ndef fetch(url):\n    import urllib.request\n    return urllib.request.urlopen(url).read()\n\nurls = ["https://example.com"] * 5\nwith ThreadPoolExecutor(max_workers=5) as executor:\n    futures = {executor.submit(fetch, url): url for url in urls}\n    for future in as_completed(futures):\n        print(len(future.result()))')

add('CSV读写', '读取和写入CSV文件', 'Python',
'import csv\n\n# 写入\nwith open("data.csv", "w", newline="", encoding="utf-8") as f:\n    writer = csv.writer(f)\n    writer.writerow(["name", "age", "city"])\n    writer.writerows([["Tom", 25, "Beijing"], ["Jerry", 30, "Shanghai"]])\n\n# 读取\nwith open("data.csv", encoding="utf-8") as f:\n    reader = csv.DictReader(f)\n    for row in reader:\n        print(row["name"], row["age"])')

add('JSON处理', 'JSON序列化和反序列化', 'Python',
'import json\n\n# 序列化\ndata = {"name": "Tom", "scores": [90, 85, 92]}\njson_str = json.dumps(data, ensure_ascii=False, indent=2)\n\n# 反序列化\nparsed = json.loads(json_str)\n\n# 读写文件\nwith open("data.json", "w", encoding="utf-8") as f:\n    json.dump(data, f, ensure_ascii=False, indent=2)\n\nwith open("data.json", encoding="utf-8") as f:\n    data = json.load(f)')

add('正则表达式常用操作', '正则匹配、替换、分组', 'Python',
'import re\n\n# 匹配手机号\nphone_pattern = r"1[3-9]\\d{9}"\nphones = re.findall(phone_pattern, text)\n\n# 替换敏感信息\ntext = re.sub(r"(\\d{3})\\d{4}(\\d{4})", r"1****2", "13812345678")\n\n# 分组提取\nmatch = re.match(r"(\\w+)@(\\w+)", "user@example.com")\nif match:\n    user, domain = match.groups()')

add('类和继承', 'Python面向对象编程示例', 'Python',
'class Animal:\n    def __init__(self, name):\n        self.name = name\n    def speak(self):\n        raise NotImplementedError\n\nclass Dog(Animal):\n    def speak(self):\n        return f"{self.name} says Woof!"\n\nclass Cat(Animal):\n    def speak(self):\n        return f"{self.name} says Meow!"\n\nanimals = [Dog("Buddy"), Cat("Kitty")]\nfor a in animals:\n    print(a.speak())')

add('数据类dataclass', '使用dataclass简化类定义', 'Python',
'from dataclasses import dataclass, field\nfrom typing import List\n\n@dataclass\nclass User:\n    name: str\n    age: int\n    email: str = ""\n    tags: List[str] = field(default_factory=list)\n    \n    @property\n    def is_adult(self):\n        return self.age >= 18\n\nuser = User("Tom", 25, tags=["admin"])\nprint(user)')

add('二叉树遍历', '前序、中序、后序、层序遍历', 'Python',
'class TreeNode:\n    def __init__(self, val, left=None, right=None):\n        self.val, self.left, self.right = val, left, right\n\ndef preorder(root):\n    return [root.val] + preorder(root.left) + preorder(root.right) if root else []\n\ndef inorder(root):\n    return inorder(root.left) + [root.val] + inorder(root.right) if root else []\n\ndef level_order(root):\n    if not root: return []\n    queue, result = [root], []\n    while queue:\n        node = queue.pop(0)\n        result.append(node.val)\n        if node.left: queue.append(node.left)\n        if node.right: queue.append(node.right)\n    return result')

add('图的BFS和DFS', '图的广度优先和深度优先搜索', 'Python',
'from collections import deque\n\ndef bfs(graph, start):\n    visited, queue = set(), deque([start])\n    while queue:\n        node = queue.popleft()\n        if node not in visited:\n            visited.add(node)\n            queue.extend(graph[node] - visited)\n    return visited\n\ndef dfs(graph, start, visited=None):\n    if visited is None: visited = set()\n    visited.add(start)\n    for next_node in graph[start] - visited:\n        dfs(graph, next_node, visited)\n    return visited')

add('动态规划-爬楼梯', '每次可以爬1或2个台阶，有多少种方法', 'Python',
'def climb_stairs(n):\n    if n <= 2: return n\n    a, b = 1, 2\n    for _ in range(3, n+1):\n        a, b = b, a + b\n    return b\n\n# 测试\nprint(climb_stairs(10))  # 89')

add('动态规划-01背包', '经典的01背包问题', 'Python',
'def knapsack(weights, values, capacity):\n    n = len(weights)\n    dp = [0] * (capacity + 1)\n    for i in range(n):\n        for w in range(capacity, weights[i]-1, -1):\n            dp[w] = max(dp[w], dp[w-weights[i]] + values[i])\n    return dp[capacity]\n\nprint(knapsack([2,3,4,5], [3,4,5,6], 8))  # 10')

add('Flask路由示例', 'Flask基本路由和请求处理', 'Python',
'from flask import Flask, request, jsonify\napp = Flask(__name__)\n\n@app.route("/api/users", methods=["GET"])\ndef list_users():\n    return jsonify({"users": get_all_users()})\n\n@app.route("/api/users", methods=["POST"])\ndef create_user():\n    data = request.get_json()\n    user = User(name=data["name"], email=data["email"])\n    db.session.add(user)\n    db.session.commit()\n    return jsonify({"id": user.id}), 201')

add('FastAPI路由示例', 'FastAPI基本路由和参数校验', 'Python',
'from fastapi import FastAPI, HTTPException\nfrom pydantic import BaseModel\n\napp = FastAPI()\n\nclass UserCreate(BaseModel):\n    name: str\n    email: str\n    age: int = 0\n\n@app.get("/api/users/{user_id}")\nasync def get_user(user_id: int):\n    user = await User.get(user_id)\n    if not user: raise HTTPException(404)\n    return user\n\n@app.post("/api/users")\nasync def create_user(user: UserCreate):\n    return await User.create(**user.dict())')

add('SQLAlchemy ORM', 'SQLAlchemy模型定义和查询', 'Python',
'from sqlalchemy import Column, Integer, String, DateTime, create_engine\nfrom sqlalchemy.orm import declarative_base, sessionmaker\n\nBase = declarative_base()\n\nclass User(Base):\n    __tablename__ = "users"\n    id = Column(Integer, primary_key=True)\n    name = Column(String(50), nullable=False)\n    email = Column(String(100), unique=True)\n\nengine = create_engine("sqlite:///app.db")\nBase.metadata.create_all(engine)\nSession = sessionmaker(bind=engine)\nsession = Session()\nuser = session.query(User).filter_by(name="Tom").first()')

add('Pandas数据处理', 'Pandas常用数据操作', 'Python',
'import pandas as pd\n\n# 读取CSV\ndf = pd.read_csv("data.csv")\n\n# 筛选\ndf_filtered = df[df["age"] > 25]\n\n# 分组统计\ndf.groupby("city")["salary"].mean()\n\n# 新增列\ndf["salary_k"] = df["salary"] / 1000\n\n# 排序\ndf.sort_values("salary", ascending=False).head(10)\n\n# 导出\ndf.to_excel("output.xlsx", index=False)')

add('NumPy数组操作', 'NumPy常用数组操作', 'Python',
'import numpy as np\n\narr = np.array([1, 2, 3, 4, 5])\nmatrix = np.array([[1,2],[3,4]])\n\n# 数组操作\nprint(arr.mean(), arr.std(), arr.max())\nprint(arr.reshape(5, 1))\nprint(np.dot(matrix, matrix))\n\n# 随机数\nrand = np.random.randn(1000)\nprint(rand.mean(), rand.std())')

add('异步编程asyncio', 'Python异步IO示例', 'Python',
'import asyncio, aiohttp\n\nasync def fetch(session, url):\n    async with session.get(url) as resp:\n        return await resp.text()\n\nasync def main():\n    async with aiohttp.ClientSession() as session:\n        urls = ["https://example.com"] * 10\n        tasks = [fetch(session, url) for url in urls]\n        results = await asyncio.gather(*tasks)\n        print(len(results))\n\nasyncio.run(main())')

add('排序算法合集', 'Python实现多种排序算法', 'Python',
'def bubble_sort(arr):\n    for i in range(len(arr)-1):\n        for j in range(len(arr)-i-1):\n            if arr[j] > arr[j+1]: arr[j], arr[j+1] = arr[j+1], arr[j]\n    return arr\n\ndef quick_sort(arr):\n    if len(arr) <= 1: return arr\n    pivot = arr[len(arr)//2]\n    return quick_sort([x for x in arr if x < pivot]) + [x for x in arr if x == pivot] + quick_sort([x for x in arr if x > pivot])\n\ndef merge_sort(arr):\n    if len(arr) <= 1: return arr\n    mid = len(arr)//2\n    left, right = merge_sort(arr[:mid]), merge_sort(arr[mid:])\n    result = []\n    while left and right:\n        result.append(left.pop(0) if left[0] <= right[0] else right.pop(0))\n    return result + left + right')

# ========== JavaScript ==========
add('防抖函数', '限制函数在指定时间间隔内只执行一次', 'JavaScript',
'function debounce(fn, delay = 300) {\n    let timer = null;\n    return function(...args) {\n        clearTimeout(timer);\n        timer = setTimeout(() => fn.apply(this, args), delay);\n    }\n}\n\n// 使用\nconst search = debounce((keyword) => {\n    console.log("search:", keyword);\n}, 500);')

add('节流函数', '限制函数在指定时间内最多执行一次', 'JavaScript',
'function throttle(fn, interval = 300) {\n    let last = 0;\n    return function(...args) {\n        const now = Date.now();\n        if (now - last >= interval) {\n            last = now;\n            fn.apply(this, args);\n        }\n    }\n}\n\n// 使用\nwindow.addEventListener("scroll", throttle(() => {\n    console.log("scroll");\n}, 200));')

add('深拷贝', '实现对象深拷贝的多种方式', 'JavaScript',
'// 方式1: JSON (不支持函数/循环引用)\nconst clone1 = JSON.parse(JSON.stringify(obj));\n\n// 方式2: 递归实现\nfunction deepClone(obj, map = new WeakMap()) {\n    if (obj === null || typeof obj !== "object") return obj;\n    if (map.has(obj)) return map.get(obj);\n    const clone = Array.isArray(obj) ? [] : {};\n    map.set(obj, clone);\n    for (const key in obj) {\n        clone[key] = deepClone(obj[key], map);\n    }\n    return clone;\n}')

add('Promise.all并发控制', '限制并发数的Promise.all', 'JavaScript',
'async function asyncPool(poolLimit, array, iteratorFn) {\n    const ret = [];\n    const executing = new Set();\n    for (const item of array) {\n        const p = Promise.resolve().then(() => iteratorFn(item));\n        ret.push(p);\n        executing.add(p);\n        const clean = () => executing.delete(p);\n        p.then(clean, clean);\n        if (executing.size >= poolLimit) {\n            await Promise.race(executing);\n        }\n    }\n    return Promise.all(ret);\n}\n\nawait asyncPool(3, urls, url => fetch(url));')

add('发布订阅模式', '简单的事件发布订阅实现', 'JavaScript',
'class EventEmitter {\n    constructor() { this.events = {}; }\n    on(event, fn) {\n        (this.events[event] = this.events[event] || []).push(fn);\n        return this;\n    }\n    emit(event, ...args) {\n        (this.events[event] || []).forEach(fn => fn(...args));\n        return this;\n    }\n    off(event, fn) {\n        this.events[event] = (this.events[event] || []).filter(f => f !== fn);\n        return this;\n    }\n}')

add('数组高阶函数', 'map/filter/reduce/find常用操作', 'JavaScript',
'const users = [{name:"Tom",age:25},{name:"Jerry",age:18},{name:"Bob",age:30}];\n\n// map: 提取名字\nconst names = users.map(u => u.name);\n\n// filter: 过滤成年人\nconst adults = users.filter(u => u.age >= 20);\n\n// reduce: 计算年龄总和\nconst totalAge = users.reduce((sum, u) => sum + u.age, 0);\n\n// find: 查找第一个\nconst tom = users.find(u => u.name === "Tom");\n\n// some/every\nconst hasAdult = users.some(u => u.age >= 18);\nconst allAdult = users.every(u => u.age >= 18);')

add('async/await错误处理', '异步函数的错误处理模式', 'JavaScript',
'async function safeFetch(url) {\n    try {\n        const res = await fetch(url);\n        if (!res.ok) throw new Error(`HTTP ${res.status}`);\n        return await res.json();\n    } catch (err) {\n        console.error("Fetch failed:", err.message);\n        return null;\n    }\n}\n\n// 并发请求\nconst [users, posts] = await Promise.all([\n    safeFetch("/api/users"),\n    safeFetch("/api/posts")\n]);')

add('图片懒加载', 'IntersectionObserver实现图片懒加载', 'JavaScript',
'function lazyLoad(selector = "img[data-src]") {\n    const observer = new IntersectionObserver((entries) => {\n        entries.forEach(entry => {\n            if (entry.isIntersecting) {\n                const img = entry.target;\n                img.src = img.dataset.src;\n                img.removeAttribute("data-src");\n                observer.unobserve(img);\n            }\n        });\n    });\n    document.querySelectorAll(selector).forEach(img => observer.observe(img));\n}\n\nlazyLoad();')

add('LocalStorage封装', '带过期时间的LocalStorage操作', 'JavaScript',
'const storage = {\n    set(key, value, ttl = 86400) {\n        const item = { value, expire: Date.now() + ttl * 1000 };\n        localStorage.setItem(key, JSON.stringify(item));\n    },\n    get(key) {\n        const item = JSON.parse(localStorage.getItem(key));\n        if (!item) return null;\n        if (Date.now() > item.expire) {\n            localStorage.removeItem(key);\n            return null;\n        }\n        return item.value;\n    },\n    remove(key) { localStorage.removeItem(key); }\n};')

add('URL参数解析', '解析和构建URL查询参数', 'JavaScript',
'function parseQuery(url) {\n    const params = {};\n    new URL(url).searchParams.forEach((v, k) => {\n        params[k] = v;\n    });\n    return params;\n}\n\nfunction buildQuery(base, params) {\n    const url = new URL(base);\n    Object.entries(params).forEach(([k, v]) => {\n        if (v !== undefined && v !== null) url.searchParams.set(k, v);\n    });\n    return url.toString();\n}')

add('两数之和', '经典算法题：找出数组中两数之和等于目标值的下标', 'JavaScript',
'function twoSum(nums, target) {\n    const map = new Map();\n    for (let i = 0; i < nums.length; i++) {\n        const complement = target - nums[i];\n        if (map.has(complement)) {\n            return [map.get(complement), i];\n        }\n        map.set(nums[i], i);\n    }\n    return [];\n}\n\nconsole.log(twoSum([2,7,11,15], 9)); // [0, 1]')

add('有效括号', '判断括号字符串是否有效', 'JavaScript',
'function isValid(s) {\n    const stack = [];\n    const map = { ")":"(", "]":"[", "}":"{" };\n    for (const c of s) {\n        if ("([{".includes(c)) {\n            stack.push(c);\n        } else {\n            if (stack.pop() !== map[c]) return false;\n        }\n    }\n    return stack.length === 0;\n}\n\nconsole.log(isValid("({[]})")); // true')

add('最大子数组和', '动态规划求最大连续子数组和', 'JavaScript',
'function maxSubArray(nums) {\n    let maxSum = nums[0], currentSum = nums[0];\n    for (let i = 1; i < nums.length; i++) {\n        currentSum = Math.max(nums[i], currentSum + nums[i]);\n        maxSum = Math.max(maxSum, currentSum);\n    }\n    return maxSum;\n}\n\nconsole.log(maxSubArray([-2,1,-3,4,-1,2,1,-5,4])); // 6')

add('Promise封装AJAX', '用Promise封装XMLHttpRequest', 'JavaScript',
'function ajax(method, url, data = null) {\n    return new Promise((resolve, reject) => {\n        const xhr = new XMLHttpRequest();\n        xhr.open(method, url, true);\n        xhr.setRequestHeader("Content-Type", "application/json");\n        xhr.onload = () => {\n            if (xhr.status >= 200 && xhr.status < 300) {\n                resolve(JSON.parse(xhr.responseText));\n            } else {\n                reject(new Error(xhr.statusText));\n            }\n        };\n        xhr.onerror = () => reject(new Error("Network Error"));\n        xhr.send(data ? JSON.stringify(data) : null);\n    });\n}')

add('数组扁平化', '多维数组展平的多种方式', 'JavaScript',
'const arr = [1, [2, [3, [4]], 5]];\n\n// 方法1: flat\narr.flat(Infinity);\n\n// 方法2: 递归\nfunction flatten(arr) {\n    return arr.reduce((acc, item) =>\n        acc.concat(Array.isArray(item) ? flatten(item) : item), []);\n}\n\n// 方法3: 迭代\nfunction flatten2(arr) {\n    const stack = [...arr];\n    const result = [];\n    while (stack.length) {\n        const item = stack.pop();\n        Array.isArray(item) ? stack.push(...item) : result.unshift(item);\n    }\n    return result;\n}')

add('柯里化函数', '将多参数函数转换为链式单参数函数', 'JavaScript',
'function curry(fn) {\n    return function curried(...args) {\n        if (args.length >= fn.length) {\n            return fn.apply(this, args);\n        }\n        return (...more) => curried(...args, ...more);\n    }\n}\n\nconst add = curry((a, b, c) => a + b + c);\nconsole.log(add(1)(2)(3)); // 6\nconsole.log(add(1, 2)(3)); // 6')

# ========== SQL ==========
add('分页查询', 'MySQL分页查询，带条件筛选', 'SQL',
'SELECT * FROM user\nWHERE status = 1 AND is_deleted = 0\nORDER BY created_at DESC\nLIMIT 10 OFFSET 0;\n\n-- 计算总页数\nSELECT CEIL(COUNT(*) / 10.0) AS total_pages\nFROM user WHERE status = 1;')

add('多表联查', 'LEFT JOIN关联查询代码片段及作者信息', 'SQL',
'SELECT s.id, s.title, s.language, s.view_count,\n       u.username AS author_name, u.avatar AS author_avatar,\n       COUNT(c.id) AS comment_count\nFROM snippet s\nLEFT JOIN user u ON s.author_id = u.id\nLEFT JOIN comment c ON c.snippet_id = s.id AND c.is_deleted = 0\nWHERE s.visibility = 1 AND s.is_deleted = 0\nGROUP BY s.id\nORDER BY s.view_count DESC\nLIMIT 20;')

add('窗口函数-排名', '使用ROW_NUMBER/RANK/DENSE_RANK', 'SQL',
'-- 每种语言按浏览量排名\nSELECT title, language, view_count,\n    ROW_NUMBER() OVER(PARTITION BY language ORDER BY view_count DESC) AS rn,\n    RANK() OVER(PARTITION BY language ORDER BY view_count DESC) AS rnk,\n    DENSE_RANK() OVER(PARTITION BY language ORDER BY view_count DESC) AS drnk\nFROM snippet\nWHERE is_deleted = 0;')

add('窗口函数-累计求和', '累计统计和移动平均', 'SQL',
'-- 按日期累计注册用户数\nSELECT DATE(created_at) AS date,\n    COUNT(*) AS daily_count,\n    SUM(COUNT(*)) OVER(ORDER BY DATE(created_at)) AS cumulative\nFROM user\nWHERE is_deleted = 0\nGROUP BY DATE(created_at)\nORDER BY date;')

add('递归查询-树形结构', '使用CTE递归查询父子关系', 'SQL',
'WITH RECURSIVE tree AS (\n    SELECT id, name, parent_id, 0 AS depth,\n           CAST(name AS CHAR(500)) AS path\n    FROM category WHERE parent_id IS NULL\n    UNION ALL\n    SELECT c.id, c.name, c.parent_id, t.depth+1,\n           CONCAT(t.path, " > ", c.name)\n    FROM category c JOIN tree t ON c.parent_id = t.id\n)\nSELECT * FROM tree ORDER BY path;')

add('数据去重', '删除重复数据保留最新一条', 'SQL',
'-- 查找重复的邮箱\nSELECT email, COUNT(*) AS cnt\nFROM user WHERE is_deleted = 0\nGROUP BY email HAVING cnt > 1;\n\n-- 删除重复数据保留ID最大的\nDELETE FROM user WHERE id NOT IN (\n    SELECT * FROM (\n        SELECT MAX(id) FROM user GROUP BY email\n    ) AS tmp\n);')

add('索引优化', '常用索引创建和优化建议', 'SQL',
'-- 单列索引\nCREATE INDEX idx_user_email ON user(email);\n\n-- 复合索引（遵循最左前缀原则）\nCREATE INDEX idx_snippet_lang_vis ON snippet(language, visibility);\n\n-- 唯一索引\nCREATE UNIQUE INDEX uk_user_username ON user(username);\n\n-- 查看索引使用情况\nEXPLAIN SELECT * FROM snippet WHERE language = "Java" AND visibility = 1;')

add('存储过程', '批量更新浏览量的存储过程', 'SQL',
'DELIMITER //\nCREATE PROCEDURE update_view_count(IN snippet_id BIGINT)\nBEGIN\n    DECLARE EXIT HANDLER FOR SQLEXCEPTION\n    BEGIN ROLLBACK; END;\n    START TRANSACTION;\n    UPDATE snippet SET view_count = view_count + 1,\n        updated_at = NOW() WHERE id = snippet_id;\n    COMMIT;\nEND //\nDELIMITER ;\n\n-- 调用\nCALL update_view_count(1);')

add('触发器', '自动更新updated_at字段的触发器', 'SQL',
'DELIMITER //\nCREATE TRIGGER before_snippet_update\nBEFORE UPDATE ON snippet\nFOR EACH ROW\nBEGIN\n    SET NEW.updated_at = NOW();\nEND //\nDELIMITER ;')

add('视图', '创建常用查询的视图', 'SQL',
'CREATE VIEW v_snippet_detail AS\nSELECT s.*, u.username, u.avatar,\n    (SELECT COUNT(*) FROM comment c\n     WHERE c.snippet_id = s.id AND c.is_deleted = 0) AS comment_count,\n    (SELECT COUNT(*) FROM favorite f\n     WHERE f.snippet_id = s.id) AS favorite_count\nFROM snippet s\nLEFT JOIN user u ON s.author_id = u.id\nWHERE s.is_deleted = 0;\n\n-- 使用视图\nSELECT * FROM v_snippet_detail WHERE language = "Java";')

add('事务控制', '银行转账示例的事务处理', 'SQL',
'START TRANSACTION;\n\nUPDATE account SET balance = balance - 100\nWHERE user_id = 1 AND balance >= 100;\n\nIF ROW_COUNT() = 0 THEN\n    ROLLBACK;\n    SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "余额不足";\nEND IF;\n\nUPDATE account SET balance = balance + 100\nWHERE user_id = 2;\n\nCOMMIT;')

add('JSON字段操作', 'MySQL JSON字段的查询和操作', 'SQL',
'-- 创建含JSON字段的表\nCREATE TABLE settings (\n    user_id BIGINT PRIMARY KEY,\n    config JSON\n);\n\n-- 插入JSON数据\nINSERT INTO settings VALUES (1, \'{"theme":"dark","lang":"zh"}\');\n\n-- 查询JSON字段\nSELECT config->>"$.theme" AS theme FROM settings WHERE user_id = 1;\n\n-- 更新JSON字段\nUPDATE settings SET config = JSON_SET(config, "$.fontSize", 14) WHERE user_id = 1;')

add('慢查询分析', '查找和优化慢查询', 'SQL',
'-- 开启慢查询日志\nSET GLOBAL slow_query_log = ON;\nSET GLOBAL long_query_time = 2;\n\n-- 查看当前运行的查询\nSELECT id, user, host, db, command, time, state, info\nFROM information_schema.processlist\nWHERE command != "Sleep" ORDER BY time DESC;\n\n-- 分析表\nANALYZE TABLE snippet;\n-- 优化表\nOPTIMIZE TABLE snippet;')

add('批量插入优化', '高效批量插入大量数据', 'SQL',
'-- 方法1: 多值INSERT（推荐）\nINSERT INTO snippet (title, language, code_content, author_id, visibility)\nVALUES\n    ("title1", "Java", "code1", 1, 1),\n    ("title2", "Python", "code2", 1, 1),\n    ("title3", "JavaScript", "code3", 1, 1);\n\n-- 方法2: LOAD DATA（大批量最快）\nLOAD DATA INFILE "/tmp/data.csv"\nINTO TABLE snippet\nFIELDS TERMINATED BY "," ENCLOSED BY \'"\'\nLINES TERMINATED BY "\\n"\nIGNORE 1 ROWS;')

# ========== Shell ==========
add('批量重命名文件', '批量修改目录下文件扩展名', 'Shell',
'#!/bin/bash\n# 将当前目录下所有 .txt 改为 .md\nfor file in *.txt; do\n    mv "$file" "${file%.txt}.md"\ndone\n\n# 递归重命名\nfind . -name "*.txt" -exec bash -c \'mv "$0" "${0%.txt}.md"\' {} \\;')

add('日志分析脚本', '分析Nginx访问日志统计PV和IP', 'Shell',
'#!/bin/bash\nLOG="/var/log/nginx/access.log"\n\necho "=== 日访问量 ==="\nawk \'{print $4}\' $LOG | cut -d: -f1 | sort | uniq -c | sort -rn\n\necho "=== Top 10 IP ==="\nawk \'{print $1}\' $LOG | sort | uniq -c | sort -rn | head -10\n\necho "=== Top 10 URL ==="\nawk \'{print $7}\' $LOG | sort | uniq -c | sort -rn | head -10')

add('自动备份脚本', 'MySQL数据库自动备份并清理旧文件', 'Shell',
'#!/bin/bash\nBACKUP_DIR="/data/backup/mysql"\nDATE=$(date +%Y%m%d_%H%M%S)\nDB_NAME="aicodehub"\n\n# 备份\ndocker exec aicodehub-mysql mysqldump -uroot -p123456 $DB_NAME \\\n    | gzip > "$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"\n\n# 保留最近30天的备份\nfind $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete\n\necho "Backup completed: ${DB_NAME}_${DATE}.sql.gz"')

add('服务器监控脚本', '监控CPU、内存、磁盘使用率', 'Shell',
'#!/bin/bash\necho "=== 系统监控 $(date) ==="\n\necho "-- CPU --"\ntop -bn1 | head -5\n\necho "-- 内存 --"\nfree -h\n\necho "-- 磁盘 --"\ndf -h | grep -E "^/dev"\n\necho "-- Docker --"\ndocker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"')

add('Docker批量操作', 'Docker容器和镜像批量管理', 'Shell',
'#!/bin/bash\n# 清理无用的Docker资源\ndocker system prune -af --volumes\n\n# 批量停止所有容器\ndocker stop $(docker ps -q)\n\n# 批量删除已停止的容器\ndocker container prune -f\n\n# 查看所有容器资源占用\ndocker stats --no-stream\n\n# 导出容器为镜像\ndocker commit container_name backup:latest\ndocker save backup:latest | gzip > backup.tar.gz')

add('Git批量操作', 'Git常用批量操作脚本', 'Shell',
'#!/bin/bash\n# 批量拉取所有子模块更新\ngit submodule update --init --recursive\n\n# 清理本地已删除的远程分支\ngit fetch --prune\n\n# 撤销所有未提交的修改\ngit checkout -- .\ngit clean -fd\n\n# 统计代码行数\ngit ls-files | xargs wc -l | tail -1\n\n# 查看最近10次提交\ngit log --oneline -10')

add('系统信息收集', '收集系统完整信息', 'Shell',
'#!/bin/bash\necho "=== 系统信息 ==="\necho "主机名: $(hostname)"\necho "系统: $(uname -a)"\necho "启动时间: $(uptime -s)"\necho "用户: $(whoami)"\n\necho "=== 硬件信息 ==="\necho "CPU: $(lscpu | grep "Model name" | cut -d: -f2 | xargs)"\necho "内存: $(free -h | awk \'/Mem/{print $2}\')"\necho "磁盘: $(df -h / | awk \'NR==2{print $2}\')"\n\necho "=== 网络信息 ==="\ncurl -s ifconfig.me\necho ""')

add('端口扫描检测', '检测指定端口是否开放', 'Shell',
'#!/bin/bash\nHOST=$1\nPORTS="22 80 443 3306 6379 8080"\n\nfor port in $PORTS; do\n    (echo > /dev/tcp/$HOST/$port) 2>/dev/null \\\n        && echo "Port $port: OPEN" \\\n        || echo "Port $port: CLOSED"\ndone')

add('进程守护脚本', '监控进程并在挂掉时自动重启', 'Shell',
'#!/bin/bash\nPROC_NAME="java"\nCHECK_INTERVAL=30\n\nwhile true; do\n    if ! pgrep -x "$PROC_NAME" > /dev/null; then\n        echo "[$(date)] $PROC_NAME not running, restarting..."\n        cd /app && java -jar app.jar &\n    fi\n    sleep $CHECK_INTERVAL\ndone')

# ========== Go ==========
add('HTTP服务', 'Go标准库创建HTTP服务器', 'Go',
'package main\n\nimport (\n    "encoding/json"\n    "net/http"\n)\n\nfunc main() {\n    http.HandleFunc("/api/hello", func(w http.ResponseWriter, r *http.Request) {\n        json.NewEncoder(w).Encode(map[string]string{\n            "message": "Hello, World!",\n        })\n    })\n    http.ListenAndServe(":8080", nil)\n}')

add('Goroutine和Channel', 'Go并发编程基础示例', 'Go',
'package main\n\nimport "fmt"\n\nfunc main() {\n    ch := make(chan int, 10)\n    \n    // 生产者\n    go func() {\n        for i := 0; i < 10; i++ {\n            ch <- i\n        }\n        close(ch)\n    }()\n    \n    // 消费者\n    for v := range ch {\n        fmt.Println(v)\n    }\n}')

add('JSON编解码', 'Go的JSON序列化和反序列化', 'Go',
'package main\n\nimport (\n    "encoding/json"\n    "fmt"\n)\n\ntype User struct {\n    Name  string `json:"name"`\n    Email string `json:"email"`\n    Age   int    `json:"age,omitempty"`\n}\n\nfunc main() {\n    u := User{Name: "Tom", Email: "tom@example.com"}\n    data, _ := json.MarshalIndent(u, "", "  ")\n    fmt.Println(string(data))\n    \n    var u2 User\n    json.Unmarshal(data, &u2)\n}')

add('WaitGroup并发', '使用WaitGroup等待多个Goroutine完成', 'Go',
'package main\n\nimport (\n    "fmt"\n    "sync"\n)\n\nfunc main() {\n    var wg sync.WaitGroup\n    urls := []string{"url1", "url2", "url3"}\n    \n    for _, url := range urls {\n        wg.Add(1)\n        go func(u string) {\n            defer wg.Done()\n            fmt.Println("fetching:", u)\n        }(url)\n    }\n    wg.Wait()\n    fmt.Println("all done")\n}')

add('错误处理', 'Go的错误处理最佳实践', 'Go',
'package main\n\nimport (\n    "errors"\n    "fmt"\n)\n\ntype AppError struct {\n    Code    int\n    Message string\n}\n\nfunc (e *AppError) Error() string {\n    return fmt.Sprintf("code: %d, msg: %s", e.Code, e.Message)\n}\n\nfunc divide(a, b float64) (float64, error) {\n    if b == 0 {\n        return 0, &AppError{Code: 400, Message: "division by zero"}\n    }\n    return a / b, nil\n}')

# ========== TypeScript ==========
add('泛型函数', 'TypeScript泛型函数和约束', 'TypeScript',
'function identity<T>(arg: T): T {\n    return arg;\n}\n\nfunction getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {\n    return obj[key];\n}\n\nfunction merge<T extends object, U extends object>(a: T, b: U): T & U {\n    return { ...a, ...b };\n}\n\nconst result = merge({ name: "Tom" }, { age: 25 });')

add('类型守卫', '使用类型守卫缩小类型范围', 'TypeScript',
'type Fish = { swim: () => void };\ntype Bird = { fly: () => void };\n\nfunction isFish(pet: Fish | Bird): pet is Fish {\n    return (pet as Fish).swim !== undefined;\n}\n\nfunction move(pet: Fish | Bird) {\n    if (isFish(pet)) {\n        pet.swim();\n    } else {\n        pet.fly();\n    }\n}')

add('装饰器', 'TypeScript类装饰器和方法装饰器', 'TypeScript',
'function log(target: any, key: string, desc: PropertyDescriptor) {\n    const original = desc.value;\n    desc.value = function(...args: any[]) {\n        console.log(`Calling ${key} with`, args);\n        const result = original.apply(this, args);\n        console.log(`Result:`, result);\n        return result;\n    };\n}\n\nclass Calculator {\n    @log\n    add(a: number, b: number): number {\n        return a + b;\n    }\n}')

add('工具类型', 'TypeScript内置工具类型使用示例', 'TypeScript',
'interface User {\n    id: number;\n    name: string;\n    email: string;\n    age: number;\n}\n\n// Partial: 所有属性可选\ntype UpdateUser = Partial<User>;\n\n// Pick: 选取部分属性\ntype UserBasic = Pick<User, "id" | "name">;\n\n// Omit: 排除部分属性\ntype CreateUser = Omit<User, "id">;\n\n// Record: 键值对类型\ntype UserMap = Record<string, User>;\n\n// Required: 所有属性必填\ntype RequiredUser = Required<User>;')

# ========== C++ ==========
add('STL vector', 'C++ vector常用操作', 'C++',
'#include <vector>\n#include <algorithm>\nusing namespace std;\n\nvector<int> v = {3, 1, 4, 1, 5};\nv.push_back(9);\nv.pop_back();\n\nsort(v.begin(), v.end());\nauto it = find(v.begin(), v.end(), 4);\n\n// 遍历\nfor (int x : v) cout << x << " ";\n\n// 删除偶数\nv.erase(remove_if(v.begin(), v.end(),\n    [](int x){ return x%2==0; }), v.end());')

add('智能指针', 'C++11智能指针使用', 'C++',
'#include <memory>\nusing namespace std;\n\n// unique_ptr: 独占所有权\nauto p1 = make_unique<int>(42);\n\n// shared_ptr: 共享所有权\nauto p2 = make_shared<vector<int>>(10, 0);\nauto p3 = p2; // 引用计数+1\n\n// 自定义删除器\nauto file = unique_ptr<FILE, decltype(&fclose)>(\n    fopen("test.txt", "r"), fclose);\n\n// 工厂模式返回unique_ptr\nunique_ptr<Shape> createShape(string type) {\n    if (type == "circle") return make_unique<Circle>();\n    return make_unique<Rectangle>();\n}')

add('模板函数', 'C++函数模板和类模板', 'C++',
'template<typename T>\nT maximum(T a, T b) {\n    return a > b ? a : b;\n}\n\ntemplate<typename T>\nclass Stack {\n    vector<T> data;\npublic:\n    void push(T val) { data.push_back(val); }\n    T pop() {\n        T val = data.back(); data.pop_back(); return val;\n    }\n    bool empty() const { return data.empty(); }\n};\n\nStack<int> s; s.push(1); s.push(2);')

# 生成SQL文件
now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
with open('D:/wangzhan/wangzhan/sql/insert_snippets_massive.sql', 'w', encoding='utf-8') as f:
    f.write(f'-- ============================================\n')
    f.write(f'-- 批量代码片段数据 - 共 {len(snippets)} 条\n')
    f.write(f'-- 生成时间: {now}\n')
    f.write(f'-- ============================================\n\n')
    f.write('INSERT INTO snippet (title, description, language, code_content, author_id, visibility, view_count, like_count, created_at, updated_at) VALUES\n')

    for i, (title, desc, lang, code, views, likes) in enumerate(snippets):
        sep = ',' if i < len(snippets) - 1 else ';'
        f.write(f"('{title}', '{desc}', '{lang}', '{code}', 1, 1, {views}, {likes}, NOW(), NOW()){sep}\n")

print(f'生成完成！共 {len(snippets)} 条代码片段')
