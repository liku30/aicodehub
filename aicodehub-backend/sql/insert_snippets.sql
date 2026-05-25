-- ============================================
-- AiCodeHub 经典代码片段数据
-- 执行方式：在 Navicat 中打开本文件并执行
-- ============================================

USE aicodehub;

-- 创建系统用户（代码片段的作者）
INSERT INTO `user` (`username`, `email`, `password`, `nickname`, `role`, `status`) VALUES
('codebot', 'codebot@aicodehub.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6ZKhO', '代码机器人', 0, 1);
-- 密码是 123456 的BCrypt加密

SET @bot_id = LAST_INSERT_ID();

-- ========== Java ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '快速排序算法', '经典快速排序，含三数取中优化', 'java',
'public class QuickSort {
    public static void quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int pivotIndex = medianOfThree(arr, left, right);
            swap(arr, pivotIndex, right);
            int pivot = partition(arr, left, right);
            quickSort(arr, left, pivot - 1);
            quickSort(arr, pivot + 1, right);
        }
    }

    private static int partition(int[] arr, int left, int right) {
        int pivot = arr[right];
        int i = left - 1;
        for (int j = left; j < right; j++) {
            if (arr[j] <= pivot) {
                i++;
                swap(arr, i, j);
            }
        }
        swap(arr, i + 1, right);
        return i + 1;
    }

    private static int medianOfThree(int[] arr, int left, int right) {
        int mid = left + (right - left) / 2;
        if (arr[left] > arr[mid]) swap(arr, left, mid);
        if (arr[left] > arr[right]) swap(arr, left, right);
        if (arr[mid] > arr[right]) swap(arr, mid, right);
        return mid;
    }

    private static void swap(int[] arr, int i, int j) {
        int temp = arr[i]; arr[i] = arr[j]; arr[j] = temp;
    }
}', 1, 328, 45, 12),

(@bot_id, '归并排序算法', '自顶向下的归并排序实现', 'java',
'public class MergeSort {
    public static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);
            merge(arr, left, mid, right);
        }
    }

    private static void merge(int[] arr, int left, int mid, int right) {
        int[] temp = new int[right - left + 1];
        int i = left, j = mid + 1, k = 0;
        while (i <= mid && j <= right) {
            temp[k++] = arr[i] <= arr[j] ? arr[i++] : arr[j++];
        }
        while (i <= mid) temp[k++] = arr[i++];
        while (j <= right) temp[k++] = arr[j++];
        System.arraycopy(temp, 0, arr, left, temp.length);
    }
}', 1, 215, 32, 8),

(@bot_id, '二叉树的层序遍历', 'BFS实现二叉树层序遍历，返回每层节点', 'java',
'import java.util.*;

public class BinaryTreeLevelOrder {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<>();
        if (root == null) return result;
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            int size = queue.size();
            List<Integer> level = new ArrayList<>();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                level.add(node.val);
                if (node.left != null) queue.offer(node.left);
                if (node.right != null) queue.offer(node.right);
            }
            result.add(level);
        }
        return result;
    }
}', 1, 189, 28, 6),

(@bot_id, 'LRU缓存实现', '基于LinkedHashMap的LRU缓存，面试高频题', 'java',
'import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int capacity;

    public LRUCache(int capacity) {
        super(capacity, 0.75f, true); // accessOrder=true
        this.capacity = capacity;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > capacity;
    }

    public static void main(String[] args) {
        LRUCache<Integer, String> cache = new LRUCache<>(3);
        cache.put(1, "A"); cache.put(2, "B"); cache.put(3, "C");
        cache.get(1);       // 访问1，1移到最前
        cache.put(4, "D");  // 容量满了，淘汰最久未使用的2
        System.out.println(cache); // {3=C, 1=A, 4=D}
    }
}', 1, 256, 41, 15),

(@bot_id, '单例模式 - 双重检查锁', '线程安全的单例模式，面试必考', 'java',
'public class Singleton {
    private static volatile Singleton instance;

    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}

// 更优雅的方式：枚举单例（推荐）
enum SingletonEnum {
    INSTANCE;
    public void doSomething() {
        System.out.println("Enum singleton");
    }
}', 1, 312, 52, 18),

(@bot_id, '生产者消费者模式', '使用BlockingQueue实现经典的生产者消费者', 'java',
'import java.util.concurrent.*;

public class ProducerConsumer {
    private static final BlockingQueue<String> queue = new ArrayBlockingQueue<>(10);

    public static void main(String[] args) {
        // 生产者
        new Thread(() -> {
            try {
                for (int i = 0; i < 20; i++) {
                    String item = "产品-" + i;
                    queue.put(item);
                    System.out.println("生产: " + item);
                    Thread.sleep(100);
                }
            } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        }).start();

        // 消费者
        new Thread(() -> {
            try {
                while (true) {
                    String item = queue.take();
                    System.out.println("消费: " + item);
                    Thread.sleep(300);
                }
            } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        }).start();
    }
}', 1, 178, 25, 5),

(@bot_id, '手写线程池', '简化版线程池实现，理解线程池核心原理', 'java',
'import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

public class SimpleThreadPool {
    private final int coreSize;
    private final BlockingQueue<Runnable> taskQueue;
    private final AtomicInteger running = new AtomicInteger(0);

    public SimpleThreadPool(int coreSize, int queueSize) {
        this.coreSize = coreSize;
        this.taskQueue = new ArrayBlockingQueue<>(queueSize);
    }

    public void submit(Runnable task) {
        if (running.get() < coreSize) {
            running.incrementAndGet();
            new Thread(() -> {
                while (true) {
                    Runnable t = taskQueue.poll();
                    if (t != null) t.run();
                    else {
                        try { Thread.sleep(50); } catch (InterruptedException e) { break; }
                    }
                }
            }).start();
        }
        taskQueue.offer(task);
    }
}', 1, 145, 22, 3),

(@bot_id, 'Spring Boot 全局异常处理', '统一异常处理，返回标准JSON格式', 'java',
'import org.springframework.web.bind.annotation.*;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<?> handleValidation(MethodArgumentNotValidException e) {
        String msg = e.getBindingResult().getFieldError()
                      .getDefaultMessage();
        return Result.error(400, msg);
    }

    @ExceptionHandler(BusinessException.class)
    public Result<?> handleBusiness(BusinessException e) {
        return Result.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception e) {
        log.error("系统异常", e);
        return Result.error(500, "系统内部错误");
    }
}', 1, 198, 35, 9),

(@bot_id, 'JWT工具类', 'JWT生成和验证工具，Spring Boot项目常用', 'java',
'import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

public class JwtUtil {
    private static final String SECRET = "YourSecretKeyMustBeAtLeast256BitsLong!";
    private static final long EXPIRATION = 86400000; // 24小时

    public static String generateToken(Long userId, String username) {
        return Jwts.builder()
                .subject(username)
                .claim("userId", userId)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + EXPIRATION))
                .signWith(Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8)))
                .compact();
    }

    public static Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8)))
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}', 1, 267, 48, 14),

(@bot_id, 'HashMap底层原理', '手写简化版HashMap，理解数组+链表结构', 'java',
'public class SimpleHashMap<K, V> {
    private static final int DEFAULT_CAPACITY = 16;
    private Node<K, V>[] buckets;
    private int size;

    static class Node<K, V> {
        K key; V value;
        Node<K, V> next;
        Node(K key, V value) { this.key = key; this.value = value; }
    }

    @SuppressWarnings("unchecked")
    public SimpleHashMap() {
        buckets = new Node[DEFAULT_CAPACITY];
    }

    public void put(K key, V value) {
        int index = Math.abs(key.hashCode()) % buckets.length;
        Node<K, V> node = buckets[index];
        while (node != null) {
            if (node.key.equals(key)) { node.value = value; return; }
            node = node.next;
        }
        Node<K, V> newNode = new Node<>(key, value);
        newNode.next = buckets[index];
        buckets[index] = newNode;
        size++;
    }

    public V get(K key) {
        int index = Math.abs(key.hashCode()) % buckets.length;
        Node<K, V> node = buckets[index];
        while (node != null) {
            if (node.key.equals(key)) return node.value;
            node = node.next;
        }
        return null;
    }
}', 1, 234, 38, 11);

-- ========== Python ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '装饰器模式', 'Python装饰器完整示例，包含带参数的装饰器', 'python',
'import functools
import time

# 基础装饰器：计时
def timer(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__} 耗时: {time.time() - start:.4f}s")
        return result
    return wrapper

# 带参数的装饰器：重试
def retry(max_attempts=3, delay=1):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise e
                    time.sleep(delay)
        return wrapper
    return decorator

@timer
@retry(max_attempts=3)
def fetch_data(url):
    import requests
    return requests.get(url).json()', 1, 289, 42, 13),

(@bot_id, '列表推导式大全', 'Python列表推导式的各种用法', 'python',
'# 基础列表推导式
squares = [x**2 for x in range(10)]

# 带条件过滤
evens = [x for x in range(20) if x % 2 == 0]

# 嵌套推导式（扁平化二维列表）
matrix = [[1,2,3], [4,5,6], [7,8,9]]
flat = [x for row in matrix for x in row]

# 字典推导式
word = "hello world"
char_count = {c: word.count(c) for c in set(word)}

# 集合推导式
unique_lengths = {len(w) for w in ["apple", "banana", "cat"]}

# 生成器表达式（节省内存）
total = sum(x**2 for x in range(1000000))

# 条件推导式
labels = ["偶数" if x % 2 == 0 else "奇数" for x in range(5)]
# 结果: [偶数, 奇数, 偶数, 奇数, 偶数]', 1, 345, 56, 16),

(@bot_id, '协程与异步编程', 'Python asyncio 异步编程完整示例', 'python',
'import asyncio
import aiohttp

# 异步获取单个URL
async def fetch_url(session, url):
    async with session.get(url) as response:
        return await response.text()

# 并发获取多个URL
async def fetch_all(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        return results

# 异步生成器
async def async_range(start, stop):
    for i in range(start, stop):
        await asyncio.sleep(0.1)
        yield i

# 使用示例
async def main():
    urls = [
        "https://httpbin.org/delay/1",
        "https://httpbin.org/delay/2",
        "https://httpbin.org/delay/3",
    ]
    results = await fetch_all(urls)
    print(f"获取了 {len(results)} 个页面")

asyncio.run(main())', 1, 198, 30, 7),

(@bot_id, '数据类与类型注解', 'Python dataclass 和类型注解最佳实践', 'python',
'from dataclasses import dataclass, field
from typing import Optional, List
from datetime import datetime

@dataclass
class User:
    id: int
    username: str
    email: str
    nickname: Optional[str] = None
    created_at: datetime = field(default_factory=datetime.now)
    tags: List[str] = field(default_factory=list)

    @property
    def display_name(self) -> str:
        return self.nickname or self.username

    def __post_init__(self):
        self.email = self.email.lower()

# 使用
user = User(
    id=1,
    username="zhangsan",
    email="ZHANGSAN@Example.COM"
)
print(user.display_name)  # zhangsan
print(user.email)         # zhangsan@example.com

# dataclass也支持比较和序列化
user2 = User(id=2, username="lisi", email="lisi@example.com")
print(user == user2)  # False', 1, 167, 24, 4),

(@bot_id, '快速排序 - Python实现', '简洁的Python快速排序', 'python',
'def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)

# 使用
print(quick_sort([3, 6, 8, 10, 1, 2, 1]))
# 输出: [1, 1, 2, 3, 6, 8, 10]', 1, 412, 63, 20),

(@bot_id, 'Flask RESTful API模板', 'Flask基础RESTful API，含JWT认证', 'python',
'from flask import Flask, jsonify, request
from functools import wraps
import jwt, datetime

app = Flask(__name__)
app.config["SECRET_KEY"] = "your-secret-key"

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get("Authorization", "").replace("Bearer ", "")
        try:
            data = jwt.decode(token, app.config["SECRET_KEY"], algorithms=["HS256"])
        except:
            return jsonify({"message": "Token无效"}), 401
        return f(*args, **kwargs)
    return decorated

@app.route("/api/login", methods=["POST"])
def login():
    data = request.json
    token = jwt.encode(
        {"user": data["username"], "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=24)},
        app.config["SECRET_KEY"], algorithm="HS256"
    )
    return jsonify({"token": token})

@app.route("/api/users", methods=["GET"])
@token_required
def get_users():
    return jsonify([{"id": 1, "name": "张三"}])', 1, 178, 28, 5),

(@bot_id, '正则表达式常用模式', 'Python正则表达式速查表', 'python',
'import re

text = "联系邮箱: test@example.com, 电话: 13812345678, IP: 192.168.1.1"

# 邮箱匹配
emails = re.findall(r"[\\w.+-]+@[\\w-]+\\.[\\w.]+", text)

# 手机号匹配
phones = re.findall(r"1[3-9]\\d{9}", text)

# IP地址匹配
ips = re.findall(r"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", text)

# 替换敏感信息
masked = re.sub(r"(1[3-9]\\d{9})", lambda m: m.group()[:3] + "****" + m.group()[-4:], text)

# 分组提取
url_pattern = r"(https?)://([\\w.]+)(/.*)?"
match = re.match(url_pattern, "https://www.google.com/search?q=python")
if match:
    protocol, domain, path = match.groups()
    print(f"协议: {protocol}, 域名: {domain}, 路径: {path}")', 1, 223, 35, 8),

(@bot_id, 'Python生成器模式', '生成器、yield from、协程的使用', 'python',
'import itertools

# 基础生成器
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# 取前10个斐波那契数
fib = fibonacci()
first_10 = [next(fib) for _ in range(10)]

# yield from 委托生成器
def chain(*iterables):
    for it in iterables:
        yield from it

result = list(chain([1,2], [3,4], [5,6]))
# [1, 2, 3, 4, 5, 6]

# 生成器实现管道模式
def read_lines(filename):
    with open(filename) as f:
        for line in f:
            yield line.strip()

def grep(pattern, lines):
    for line in lines:
        if pattern in line:
            yield line

# 使用: grep("error", read_lines("app.log"))', 1, 156, 21, 3),

(@bot_id, 'Django模型最佳实践', 'Django ORM常用查询和模型设计', 'python',
'from django.db import models
from django.utils import timezone

class Article(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    author = models.ForeignKey("auth.User", on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    views = models.PositiveIntegerField(default=0)
    is_published = models.BooleanField(default=False)

    class Meta:
        ordering = ["-created_at"]
        indexes = [
            models.Index(fields=["-created_at"]),
            models.Index(fields=["author", "is_published"]),
        ]

    def __str__(self):
        return self.title

# 常用查询
# 最近7天发布的文章
Article.objects.filter(
    created_at__gte=timezone.now() - timezone.timedelta(days=7),
    is_published=True
).select_related("author").prefetch_related("tags")[:10]

# 聚合统计
from django.db.models import Count, Avg
stats = Article.objects.aggregate(
    total=Count("id"),
    avg_views=Avg("views")
)', 1, 145, 19, 4);

-- ========== JavaScript ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '防抖与节流', '手写debounce和throttle，面试高频题', 'javascript',
'// 防抖：最后一次触发后等delay才执行
function debounce(fn, delay) {
    let timer = null;
    return function(...args) {
        clearTimeout(timer);
        timer = setTimeout(() => fn.apply(this, args), delay);
    };
}

// 节流：每delay间隔最多执行一次
function throttle(fn, delay) {
    let last = 0;
    return function(...args) {
        const now = Date.now();
        if (now - last >= delay) {
            last = now;
            fn.apply(this, args);
        }
    };
}

// 使用
window.addEventListener("resize", debounce(() => {
    console.log("防抖：停止resize后执行");
}, 300));

window.addEventListener("scroll", throttle(() => {
    console.log("节流：每100ms最多执行一次");
}, 100));', 1, 456, 72, 22),

(@bot_id, '深拷贝实现', '完整深拷贝，支持循环引用和特殊类型', 'javascript',
'function deepClone(obj, map = new WeakMap()) {
    if (obj === null || typeof obj !== "object") return obj;
    if (map.has(obj)) return map.get(obj); // 处理循环引用

    // 处理特殊类型
    if (obj instanceof Date) return new Date(obj);
    if (obj instanceof RegExp) return new RegExp(obj);
    if (obj instanceof Map) {
        const m = new Map();
        map.set(obj, m);
        obj.forEach((v, k) => m.set(deepClone(k, map), deepClone(v, map)));
        return m;
    }
    if (obj instanceof Set) {
        const s = new Set();
        map.set(obj, s);
        obj.forEach(v => s.add(deepClone(v, map)));
        return s;
    }

    // 处理数组和对象
    const clone = Array.isArray(obj) ? [] : {};
    map.set(obj, clone);
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            clone[key] = deepClone(obj[key], map);
        }
    }
    return clone;
}

// 测试循环引用
const a = { name: "a" };
a.self = a;
const b = deepClone(a);
console.log(b.self === b); // true', 1, 334, 55, 17),

(@bot_id, 'Promise手写实现', '简化版Promise，理解Promise核心原理', 'javascript',
'class MyPromise {
    constructor(executor) {
        this.state = "pending";
        this.value = null;
        this.callbacks = [];

        const resolve = (value) => {
            if (this.state !== "pending") return;
            this.state = "fulfilled";
            this.value = value;
            this.callbacks.forEach(cb => cb.onFulfilled(value));
        };

        const reject = (reason) => {
            if (this.state !== "pending") return;
            this.state = "rejected";
            this.value = reason;
            this.callbacks.forEach(cb => cb.onRejected(reason));
        };

        try { executor(resolve, reject); }
        catch (e) { reject(e); }
    }

    then(onFulfilled, onRejected) {
        return new MyPromise((resolve, reject) => {
            const handle = () => {
                try {
                    const result = onFulfilled ? onFulfilled(this.value) : this.value;
                    resolve(result);
                } catch (e) { reject(e); }
            };
            if (this.state === "fulfilled") handle();
            else this.callbacks.push({ onFulfilled: handle });
        });
    }
}', 1, 278, 44, 12),

(@bot_id, '数组扁平化', '多种方式实现数组扁平化', 'javascript',
'const arr = [1, [2, [3, [4, [5]]]]];

// 方法1：递归
function flatten1(arr) {
    return arr.reduce((acc, val) =>
        acc.concat(Array.isArray(val) ? flatten1(val) : val), []);
}

// 方法2：扩展运算符
function flatten2(arr) {
    while (arr.some(Array.isArray)) {
        arr = [].concat(...arr);
    }
    return arr;
}

// 方法3：Array.flat (ES2019)
const result = arr.flat(Infinity);

// 方法4：JSON + 正则（黑魔法，仅限数字）
function flattenJSON(arr) {
    return JSON.parse("[" + JSON.stringify(arr).replace(/\\[|\\]/g, "") + "]");
}

console.log(flatten1(arr)); // [1, 2, 3, 4, 5]
console.log(flatten2(arr)); // [1, 2, 3, 4, 5]
console.log(result);        // [1, 2, 3, 4, 5]', 1, 367, 58, 19),

(@bot_id, 'EventEmitter事件总线', '手写发布订阅模式，前端常用', 'javascript',
'class EventEmitter {
    constructor() {
        this.events = {};
    }

    on(event, callback) {
        if (!this.events[event]) this.events[event] = [];
        this.events[event].push(callback);
        return () => this.off(event, callback); // 返回取消订阅函数
    }

    off(event, callback) {
        if (!this.events[event]) return;
        this.events[event] = this.events[event].filter(cb => cb !== callback);
    }

    emit(event, ...args) {
        if (!this.events[event]) return;
        this.events[event].forEach(cb => cb(...args));
    }

    once(event, callback) {
        const wrapper = (...args) => {
            callback(...args);
            this.off(event, wrapper);
        };
        this.on(event, wrapper);
    }
}

// 使用
const bus = new EventEmitter();
const unsub = bus.on("msg", data => console.log("收到:", data));
bus.emit("msg", "Hello");  // 收到: Hello
bus.once("login", user => console.log("欢迎:", user));
bus.emit("login", "张三"); // 欢迎: 张三
bus.emit("login", "李四"); // 不会触发', 1, 234, 38, 9),

(@bot_id, '防XSS和CSRF工具', '前端安全防护常用函数', 'javascript',
'// XSS防护：转义HTML
function escapeHtml(str) {
    const map = {
        "&": "&amp;", "<": "&lt;", ">": "&gt;",
        "\"": "&quot;", "'": "&#x27;", "/": "&#x2F;"
    };
    return str.replace(/[&<>"\''/]/g, c => map[c]);
}

// CSRF防护：生成token
function generateCsrfToken() {
    const arr = new Uint8Array(32);
    crypto.getRandomValues(arr);
    return Array.from(arr, b => b.toString(16).padStart(2, "0")).join("");
}

// 安全的innerHTML替代
function safeSetHTML(element, html) {
    const sanitized = html
        .replace(/<script\\b[^<]*(?:(?!<\\/script>)<[^<]*)*<\\/script>/gi, "")
        .replace(/on\\w+="[^"]*"/gi, "")
        .replace(/javascript:/gi, "");
    element.innerHTML = sanitized;
}

// URL参数安全编码
function safeEncode(param) {
    return encodeURIComponent(String(param))
        .replace(/</g, "%3C").replace(/>/g, "%3E");', 1, 145, 20, 3),

(@bot_id, 'Vue 3 组合式API模板', 'Vue 3 Composition API 常用模式', 'javascript',
'import { ref, computed, watch, onMounted } from "vue";

export default {
    setup() {
        // 响应式数据
        const count = ref(0);
        const list = ref([]);
        const loading = ref(false);

        // 计算属性
        const double = computed(() => count.value * 2);
        const total = computed(() =>
            list.value.reduce((sum, item) => sum + item.price, 0)
        );

        // 方法
        const increment = () => count.value++;
        async function fetchData() {
            loading.value = true;
            try {
                const res = await fetch("/api/items");
                list.value = await res.json();
            } finally {
                loading.value = false;
            }
        }

        // 侦听器
        watch(count, (newVal, oldVal) => {
            console.log(`count: ${oldVal} -> ${newVal}`);
        });

        // 生命周期
        onMounted(() => { fetchData(); });

        return { count, list, loading, double, total, increment, fetchData };
    }
};', 1, 189, 28, 6),

(@bot_id, 'CSS Grid布局模板', '常用CSS Grid布局方案', 'javascript',
'/* 响应式卡片网格 - 自动填充 */
.card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
    padding: 20px;
}

/* 圣杯布局 */
.holy-grail {
    display: grid;
    grid-template-areas:
        "header header header"
        "nav    main   aside"
        "footer footer footer";
    grid-template-columns: 200px 1fr 200px;
    grid-template-rows: auto 1fr auto;
    min-height: 100vh;
}
.holy-grail header { grid-area: header; }
.holy-grail nav    { grid-area: nav; }
.holy-grail main   { grid-area: main; }
.holy-grail aside  { grid-area: aside; }
.holy-grail footer { grid-area: footer; }

/* 两栏等高布局 */
.two-column {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 16px;
}', 1, 178, 25, 4);

-- ========== Go ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'Go并发安全的连接池', '基于channel的高性能连接池', 'go',
'package pool

import (
    "errors"
    "net"
    "sync"
    "time"
)

type Pool struct {
    mu       sync.Mutex
    conns    chan net.Conn
    factory  func() (net.Conn, error)
    maxOpen  int
    numOpen  int
}

func New(factory func() (net.Conn, error), maxOpen int) *Pool {
    return &Pool{
        conns:   make(chan net.Conn, maxOpen),
        factory: factory,
        maxOpen: maxOpen,
    }
}

func (p *Pool) Get() (net.Conn, error) {
    select {
    case conn := <-p.conns:
        return conn, nil
    default:
        p.mu.Lock()
        if p.numOpen < p.maxOpen {
            p.numOpen++
            p.mu.Unlock()
            return p.factory()
        }
        p.mu.Unlock()
        return nil, errors.New("pool exhausted")
    }
}

func (p *Pool) Put(conn net.Conn) {
    select {
    case p.conns <- conn:
    default:
        conn.Close()
        p.mu.Lock()
        p.numOpen--
        p.mu.Unlock()
    }
}', 1, 156, 22, 3),

(@bot_id, 'Go HTTP服务器模板', 'Gin框架RESTful API基础模板', 'go',
'package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
)

type User struct {
    ID       int    `json:"id"`
    Username string `json:"username" binding:"required"`
    Email    string `json:"email" binding:"required,email"`
}

var users = []User{
    {ID: 1, Username: "zhangsan", Email: "zhang@example.com"},
}

func main() {
    r := gin.Default()

    api := r.Group("/api")
    {
        api.GET("/users", func(c *gin.Context) {
            c.JSON(http.StatusOK, gin.H{"data": users})
        })
        api.POST("/users", func(c *gin.Context) {
            var user User
            if err := c.ShouldBindJSON(&user); err != nil {
                c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
                return
            }
            user.ID = len(users) + 1
            users = append(users, user)
            c.JSON(http.StatusCreated, gin.H{"data": user})
        })
    }

    r.Run(":8080")
}', 1, 134, 18, 2);

-- ========== TypeScript ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'TypeScript泛型工具类型', '常用工具类型和自定义泛型', 'typescript',
'// 常用内置工具类型
type Readonly2<T> = { readonly [K in keyof T]: T[K] };
type Partial2<T> = { [K in keyof T]?: T[K] };
type Pick2<T, K extends keyof T> = { [P in K]: T[P] };

// 自定义：深度只读
type DeepReadonly<T> = {
    readonly [K in keyof T]: T[K] extends object
        ? T[K] extends Function ? T[K] : DeepReadonly<T[K]>
        : T[K];
};

// 自定义：提取函数返回类型
type ReturnOf<T> = T extends (...args: any[]) => infer R ? R : never;

// 自定义：条件类型
type IsString<T> = T extends string ? "yes" : "no";
type A = IsString<string>;  // "yes"
type B = IsString<number>;  // "no"

// 使用示例
interface Config {
    db: { host: string; port: number };
    api: { key: string; secret: string };
}

type ReadonlyConfig = DeepReadonly<Config>;
// config.db.host = "xxx" // 编译报错！', 1, 167, 24, 5),

(@bot_id, 'Pinia状态管理最佳实践', 'Vue 3 + Pinia 完整Store示例', 'typescript',
'import { defineStore } from "pinia";
import { ref, computed } from "vue";

export const useAuthStore = defineStore("auth", () => {
    const token = ref(localStorage.getItem("token") || "");
    const user = ref(null);
    const isLoggedIn = computed(() => !!token.value);

    async function login(credentials) {
        const res = await fetch("/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(credentials),
        });
        const data = await res.json();
        token.value = data.token;
        localStorage.setItem("token", data.token);
        return data;
    }

    function logout() {
        token.value = "";
        user.value = null;
        localStorage.removeItem("token");
    }

    return { token, user, isLoggedIn, login, logout };
});', 1, 145, 20, 3);

-- ========== C++ ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'C++智能指针用法', 'shared_ptr, unique_ptr, weak_ptr 使用指南', 'c++',
'#include <memory>
#include <iostream>
#include <vector>

class Resource {
public:
    Resource(const std::string& name) : name_(name) {
        std::cout << "创建: " << name_ << std::endl;
    }
    ~Resource() {
        std::cout << "销毁: " << name_ << std::endl;
    }
    void use() { std::cout << "使用: " << name_ << std::endl; }
private:
    std::string name_;
};

int main() {
    // unique_ptr: 独占所有权
    auto p1 = std::make_unique<Resource>("独占资源");
    p1->use();
    // auto p2 = p1; // 编译错误！不能复制

    // shared_ptr: 共享所有权（引用计数）
    std::shared_ptr<Resource> sp1 = std::make_shared<Resource>("共享资源");
    {
        auto sp2 = sp1; // 引用计数+1
        sp2->use();
    } // sp2析构，引用计数-1，不销毁
    sp1->use();

    // weak_ptr: 弱引用，不增加引用计数
    std::weak_ptr<Resource> wp = sp1;
    if (auto locked = wp.lock()) {
        locked->use();
    }

    return 0;
}', 1, 156, 22, 4);

-- ========== SQL ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'MySQL常用查询技巧', '分组统计、子查询、窗口函数等', 'sql',
'-- 分组统计每种商品的销量和总额
SELECT product_name,
       COUNT(*) AS sale_count,
       SUM(amount) AS total_amount,
       AVG(amount) AS avg_amount
FROM orders
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY product_name
HAVING total_amount > 1000
ORDER BY total_amount DESC
LIMIT 10;

-- 窗口函数：按部门排名工资
SELECT name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
       SUM(salary) OVER (PARTITION BY department) AS dept_total
FROM employees;

-- 递归查询：获取组织架构树
WITH RECURSIVE org_tree AS (
    SELECT id, name, manager_id, 1 AS level
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, t.level + 1
    FROM employees e JOIN org_tree t ON e.manager_id = t.id
)
SELECT * FROM org_tree ORDER BY level, name;

-- 优化：批量更新用 CASE WHEN
UPDATE products
SET price = CASE
    WHEN category = "电子" THEN price * 0.9
    WHEN category = "服装" THEN price * 0.8
    ELSE price
END
WHERE category IN ("电子", "服装");', 1, 234, 35, 9),

(@bot_id, 'MySQL索引优化指南', '索引设计原则和常见慢查询优化', 'sql',
'-- ❌ 错误：对索引列使用函数（索引失效）
SELECT * FROM users WHERE YEAR(created_at) = 2024;

-- ✅ 正确：范围查询（走索引）
SELECT * FROM users
WHERE created_at >= "2024-01-01" AND created_at < "2025-01-01";

-- ❌ 错误：LIKE左模糊（索引失效）
SELECT * FROM products WHERE name LIKE "%手机%";

-- ✅ 正确：使用全文索引
ALTER TABLE products ADD FULLTEXT INDEX ft_name(name);
SELECT * FROM products WHERE MATCH(name) AGAINST("手机");

-- ❌ 错误：OR条件不同列（索引失效）
SELECT * FROM users WHERE name = "张三" OR age = 25;

-- ✅ 正确：UNION替代OR
SELECT * FROM users WHERE name = "张三"
UNION
SELECT * FROM users WHERE age = 25;

-- 联合索引最左前缀原则
-- 索引: (a, b, c)
-- WHERE a=1 AND b=2 AND c=3  ✅ 走索引
-- WHERE a=1 AND b=2          ✅ 走索引
-- WHERE a=1                   ✅ 走索引
-- WHERE b=2                   ❌ 不走索引
-- WHERE a=1 AND c=3           ⚠️ 只走a的部分', 1, 312, 48, 15);

-- ========== Shell ==========
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'Linux常用运维命令', '日常运维必备Shell命令集合', 'shell',
'#!/bin/bash

# ========== 系统监控 ==========
# 查看CPU和内存使用
top -bn1 | head -20
free -h
df -h

# 查看端口占用
netstat -tlnp | grep :8080
lsof -i :8080

# ========== 日志分析 ==========
# 实时查看日志
tail -f /var/log/app.log

# 统计ERROR出现次数
grep -c "ERROR" /var/log/app.log

# 查找最近修改的大文件
find /var/log -type f -size +100M -mtime -7 -exec ls -lh {} \\;

# ========== 批量操作 ==========
# 批量替换文件内容
find . -name "*.conf" -exec sed -i "s/old-server/new-server/g" {} \\;

# 批量重命名文件
for f in *.jpeg; do mv "$f" "${f%.jpeg}.jpg"; done

# 并行压缩
ls *.log | xargs -P 4 -I {} gzip {}

# ========== 定时任务 ==========
# 每天凌晨3点清理30天前的日志
# crontab -e
# 0 3 * * * find /var/log -name "*.log.*" -mtime +30 -delete', 1, 189, 28, 7);

-- ========== 更新标签关联 ==========
-- 给代码片段关联标签
INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = 'Java';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = '算法' AND s.title LIKE '%排序%';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = '设计模式' AND s.title LIKE '%模式%';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = 'Spring Boot' AND s.title LIKE '%Spring%';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'python' AND t.name = 'Python';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'javascript' AND t.name = 'JavaScript';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'typescript' AND t.name = 'TypeScript';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'go' AND t.name = 'Go';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'c++' AND t.name = 'C++';

INSERT INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'sql' AND t.name = '数据库';

-- 更新标签计数
UPDATE tag SET snippet_count = (SELECT COUNT(*) FROM snippet_tag WHERE tag_id = tag.id);

-- 完成！
SELECT CONCAT('成功插入 ', COUNT(*), ' 个代码片段') AS message FROM snippet;
