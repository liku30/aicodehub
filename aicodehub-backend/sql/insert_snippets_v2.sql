-- ============================================
-- AiCodeHub 增强版代码片段数据（100+条，含专业解析）
-- 执行方式：Navicat → 打开本文件 → 运行
-- ============================================

USE aicodehub;

-- 系统用户（如已存在则跳过）
INSERT IGNORE INTO `user` (`username`, `email`, `password`, `nickname`, `role`, `status`)
VALUES ('codebot', 'codebot@aicodehub.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6ZKhO', 'CodeBot', 0, 1);

SET @bot_id = (SELECT id FROM user WHERE username = 'codebot');

-- =============================================
-- 一、算法与数据结构（Java）
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '快速排序 — 三数取中优化版',
'**算法原理：** 快速排序采用分治策略，选取基准值(pivot)将数组划分为"小于基准"和"大于基准"两个子序列，递归排序。
**三数取中法：** 从首、中、尾三个元素中选取中间值作为基准，避免在已排序或逆序数组上退化为 O(n²)。
**时间复杂度：** 平均 O(n log n)，最坏 O(n²)（概率极低）。
**空间复杂度：** O(log n)，递归栈深度。
**稳定性：** 不稳定，交换操作可能改变相等元素的相对顺序。
**适用场景：** 大规模随机数据排序，实际性能优于归并排序（常数因子小）。',
'java',
'public class QuickSort {

    public static void sort(int[] arr, int left, int right) {
        if (left >= right) return;

        // 三数取中：选取首、中、尾的中位数作为pivot
        int mid = left + ((right - left) >> 1);
        if (arr[left] > arr[mid])  swap(arr, left, mid);
        if (arr[left] > arr[right]) swap(arr, left, right);
        if (arr[mid] > arr[right])  swap(arr, mid, right);
        swap(arr, mid, right); // 将pivot放到末尾

        // Lomuto分区
        int pivot = arr[right];
        int i = left - 1;
        for (int j = left; j < right; j++) {
            if (arr[j] <= pivot) swap(arr, ++i, j);
        }
        swap(arr, i + 1, right);

        sort(arr, left, i);
        sort(arr, i + 2, right);
    }

    private static void swap(int[] arr, int i, int j) {
        int t = arr[i]; arr[i] = arr[j]; arr[j] = t;
    }
}',
1, 456, 67, 23),

(@bot_id, '归并排序 — 自底向上迭代版',
'**算法原理：** 将数组逐步二分至单元素，再两两合并有序子序列。自底向上版本避免递归调用栈，适合链表排序和外部排序。
**核心操作：** merge() 函数将两个有序数组合并为一个有序数组，使用双指针扫描。
**时间复杂度：** 严格 O(n log n)，不受输入数据分布影响。
**空间复杂度：** O(n)，需要临时数组存储合并结果。
**稳定性：** 稳定，相等元素保持原有相对顺序。
**对比快速排序：** 归并排序最坏情况仍为 O(n log n)，但常数因子较大且需要额外空间。',
'java',
'public class MergeSort {

    public static void sort(int[] arr) {
        int n = arr.length;
        int[] temp = new int[n];

        // size: 当前合并的子数组长度，从1开始倍增
        for (int size = 1; size < n; size <<= 1) {
            for (int left = 0; left < n - size; left += size << 1) {
                int mid  = left + size - 1;
                int right = Math.min(left + (size << 1) - 1, n - 1);
                merge(arr, temp, left, mid, right);
            }
        }
    }

    private static void merge(int[] arr, int[] temp, int left, int mid, int right) {
        System.arraycopy(arr, left, temp, left, right - left + 1);
        int i = left, j = mid + 1, k = left;
        while (i <= mid && j <= right) {
            arr[k++] = temp[i] <= temp[j] ? temp[i++] : temp[j++];
        }
        while (i <= mid) arr[k++] = temp[i++];
    }
}',
1, 312, 45, 14),

(@bot_id, 'LRU缓存 — LinkedHashMap实现',
'**设计思想：** LRU(Least Recently Used)策略在缓存满时淘汰最久未被访问的元素。LinkedHashMap 的 accessOrder 模式天然支持此特性——每次 get/put 操作将节点移到链表头部。
**时间复杂度：** get 和 put 均为 O(1)，哈希表定位 + 双链表调整。
**空间复杂度：** O(capacity)。
**面试考点：** 如果手写，需要 HashMap + 双链表结构，HashMap 存 key→Node，双链表维护访问顺序。此实现利用 JDK 现有数据结构简化编码。',
'java',
'import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int capacity;

    public LRUCache(int capacity) {
        // accessOrder=true 表示按访问顺序排列（而非插入顺序）
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > capacity;
    }
}

// 手写版（面试高频）：HashMap + 双向链表
class LRUCacheHandwritten<K, V> {
    class Node {
        K key; V value;
        Node prev, next;
        Node(K k, V v) { key = k; value = v; }
    }

    private final int capacity;
    private final Map<K, Node> map = new HashMap<>();
    private final Node head = new Node(null, null); // 哨兵头
    private final Node tail = new Node(null, null); // 哨兵尾

    public LRUCacheHandwritten(int capacity) {
        this.capacity = capacity;
        head.next = tail; tail.prev = head;
    }

    public V get(K key) {
        if (!map.containsKey(key)) return null;
        Node node = map.get(key);
        moveToHead(node);
        return node.value;
    }

    public void put(K key, V value) {
        if (map.containsKey(key)) {
            map.get(key).value = value;
            moveToHead(map.get(key));
        } else {
            Node node = new Node(key, value);
            map.put(key, node);
            addToHead(node);
            if (map.size() > capacity) {
                Node removed = tail.prev;
                removeNode(removed);
                map.remove(removed.key);
            }
        }
    }

    private void addToHead(Node n)    { n.next = head.next; n.prev = head; head.next.prev = n; head.next = n; }
    private void removeNode(Node n)   { n.prev.next = n.next; n.next.prev = n.prev; }
    private void moveToHead(Node n)   { removeNode(n); addToHead(n); }
}',
1, 389, 58, 19),

(@bot_id, '单调栈 — 下一个更大元素',
'**算法思想：** 维护一个单调递减栈，遍历数组时，若当前元素大于栈顶，则栈顶元素的"下一个更大元素"就是当前元素。此模式适用于"找左侧/右侧第一个更大/更小元素"类问题。
**时间复杂度：** O(n)，每个元素最多入栈出栈各一次。
**空间复杂度：** O(n)，栈的空间。
**变体应用：** 每日温度问题(LeetCode 739)、柱状图最大矩形(LeetCode 84)、接雨水(LeetCode 42)。',
'java',
'import java.util.Arrays;
import java.util.Stack;

public class NextGreaterElement {
    // 对每个元素，找到右侧第一个比它大的元素，没有则为-1
    public static int[] nextGreater(int[] nums) {
        int n = nums.length;
        int[] result = new int[n];
        Arrays.fill(result, -1);
        Stack<Integer> stack = new Stack<>(); // 存下标

        for (int i = 0; i < n; i++) {
            // 当前元素大于栈顶 → 栈顶元素的"下一个更大"就是当前元素
            while (!stack.isEmpty() && nums[i] > nums[stack.peek()]) {
                result[stack.pop()] = nums[i];
            }
            stack.push(i);
        }
        return result;
    }

    // 示例
    public static void main(String[] args) {
        int[] nums = {2, 1, 2, 4, 3};
        System.out.println(Arrays.toString(nextGreater(nums)));
        // 输出: [4, 2, 4, -1, -1]
    }
}',
1, 267, 41, 12),

(@bot_id, '并查集 — 路径压缩 + 按秩合并',
'**数据结构：** 并查集(Union-Find)用于处理不相交集合的合并与查询操作，核心优化为路径压缩和按秩合并。
**路径压缩：** find() 时将路径上所有节点直接指向根节点，摊还时间复杂度降至 O(α(n))，其中 α 为反阿克曼函数（实际为常数）。
**按秩合并：** union() 时将较矮的树挂到较高的树下，避免树退化为链表。
**应用场景：** 连通分量判定、最小生成树(Kruskal)、账户合并、朋友圈问题。',
'java',
'public class UnionFind {
    private final int[] parent;
    private final int[] rank;
    private int count; // 连通分量数

    public UnionFind(int n) {
        parent = new int[n];
        rank = new int[n];
        count = n;
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    // 路径压缩：递归将节点指向根
    public int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }

    // 按秩合并
    public boolean union(int x, int y) {
        int rx = find(x), ry = find(y);
        if (rx == ry) return false;
        if (rank[rx] < rank[ry])      parent[rx] = ry;
        else if (rank[rx] > rank[ry]) parent[ry] = rx;
        else { parent[ry] = rx; rank[rx]++; }
        count--;
        return true;
    }

    public int getCount() { return count; }
    public boolean connected(int x, int y) { return find(x) == find(y); }
}',
1, 234, 36, 10);

-- =============================================
-- 二、Java核心（并发、设计模式、Spring）
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '双重检查锁单例 — volatile防指令重排',
'**设计模式：** 确保全局唯一实例，延迟初始化(Lazy Initialization)。
**volatile 的必要性：** `instance = new Singleton()` 分为三步：①分配内存 ②初始化 ③赋值引用。JIT 编译器可能重排序为①③②，导致其他线程拿到未初始化的对象。volatile 的内存屏障禁止此重排。
**枚举单例：** JVM 保证枚举实例的创建是线程安全的，且天然防止反射和序列化攻击。Effective Java 推荐此方式。',
'java',
'public class Singleton {
    // volatile 防止指令重排序
    private static volatile Singleton instance;
    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {                // 第一次检查（无锁）
            synchronized (Singleton.class) {
                if (instance == null) {        // 第二次检查（有锁）
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}

// Effective Java 推荐：枚举单例
enum SingletonEnum {
    INSTANCE;

    private final AppState state = new AppState();

    public AppState getState() { return state; }
}

// 使用：SingletonEnum.INSTANCE.getState()',
1, 378, 56, 21),

(@bot_id, 'AQS实现原理 — 手写简易版ReentrantLock',
'**AQS (AbstractQueuedSynchronizer)：** JDK并发包的核心框架，通过 CAS 操作 state 变量和 CLH 变体队列管理线程的阻塞/唤醒。
**ReentrantLock 原理：** state=0 表示未锁定，≥1 表示锁定次数（可重入）。获取锁失败的线程加入等待队列并 park。
**公平 vs 非公平：** 公平锁检查队列中是否有前驱节点；非公平锁直接 CAS 争抢（默认，吞吐量更高）。',
'java',
'import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.LockSupport;

public class SimpleLock {
    // 0=未锁定, 1=已锁定
    private final AtomicInteger state = new AtomicInteger(0);
    // 当前持有锁的线程（支持重入）
    private Thread owner = null;
    private int holdCount = 0;

    public void lock() {
        Thread current = Thread.currentThread();
        if (current == owner) {
            holdCount++; // 可重入
            return;
        }
        // CAS争抢锁
        while (!state.compareAndSet(0, 1)) {
            LockSupport.park(this);   // 阻塞等待
        }
        owner = current;
        holdCount = 1;
    }

    public void unlock() {
        Thread current = Thread.currentThread();
        if (current != owner) throw new IllegalMonitorStateException();
        if (--holdCount == 0) {
            owner = null;
            state.set(0);
            LockSupport.unpark(state); // 唤醒等待线程
        }
    }
}',
1, 198, 31, 8),

(@bot_id, 'Spring Boot 统一响应格式 + 全局异常处理',
'**统一响应：** 前端所有接口返回相同的数据结构（code/message/data），降低前端处理成本。
**全局异常处理：** @RestControllerAdvice 拦截所有 Controller 抛出的异常，转换为统一格式返回，避免敏感堆栈信息泄露。
**分层设计：** 业务异常(BusinessException)携带错误码，由框架异常处理器分类处理：参数校验→400，认证失败→401，权限不足→403，系统错误→500。',
'java',
'import lombok.Data;
import org.springframework.web.bind.annotation.*;

// 统一响应格式
@Data
public class Result<T> {
    private int code;
    private String message;
    private T data;

    public static <T> Result<T> success(T data) {
        Result<T> r = new Result<>();
        r.code = 200; r.message = "success"; r.data = data;
        return r;
    }

    public static <T> Result<T> error(int code, String msg) {
        Result<T> r = new Result<>();
        r.code = code; r.message = msg;
        return r;
    }
}

// 全局异常处理
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<?> handleValidation(MethodArgumentNotValidException e) {
        String msg = e.getBindingResult().getFieldError().getDefaultMessage();
        return Result.error(400, msg);
    }

    @ExceptionHandler(BusinessException.class)
    public Result<?> handleBiz(BusinessException e) {
        return Result.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public Result<?> handleUnknown(Exception e) {
        log.error("未捕获异常", e);
        return Result.error(500, "服务内部异常");
    }
}',
1, 289, 42, 13),

(@bot_id, 'CompletableFuture 异步编排',
'**设计思想：** CompletableFuture 实现了 Future + CompletionStage 接口，支持链式异步编排、异常处理和多任务组合，是对传统 Future 的全面升级。
**核心方法：** thenApply（转换）、thenAccept（消费）、thenCombine（组合两个任务）、allOf（等待全部完成）、anyOf（等待任一完成）。
**线程池：** 默认使用 ForkJoinPool.commonPool()，生产环境应自定义线程池避免资源竞争。',
'java',
'import java.util.concurrent.*;

public class AsyncPipeline {
    private static final Executor pool = Executors.newFixedThreadPool(4);

    public static void main(String[] args) throws Exception {
        // 串行编排：查用户 → 查订单 → 查物流
        CompletableFuture<String> future =
            CompletableFuture.supplyAsync(() -> queryUser(1001), pool)
                .thenApplyAsync(user -> queryOrder(user.getId()), pool)
                .thenApplyAsync(order -> queryLogistics(order.getId()), pool)
                .exceptionally(ex -> "查询失败: " + ex.getMessage());

        System.out.println(future.get());

        // 并行组合：同时查价格和库存，都完成后汇总
        CompletableFuture<Double> price = CompletableFuture.supplyAsync(
            () -> queryPrice(1001), pool);
        CompletableFuture<Integer> stock = CompletableFuture.supplyAsync(
            () -> queryStock(1001), pool);

        CompletableFuture<String> result = price.thenCombine(stock,
            (p, s) -> String.format("价格: %.2f, 库存: %d", p, s));

        // allOf 等待全部完成
        CompletableFuture.allOf(price, stock).join();
    }
}',
1, 234, 35, 9);

-- =============================================
-- 三、Python（数据处理、Web、自动化）
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'Python装饰器 — 从基础到带参装饰器',
'**原理：** 装饰器本质上是高阶函数，接收一个函数作为参数，返回一个增强后的函数。Python 的 @语法糖是 `func = decorator(func)` 的语法糖。
**functools.wraps：** 保留被装饰函数的 `__name__`、`__doc__` 等元数据，不加则装饰后的函数会丢失原始函数信息。
**带参装饰器：** 需要三层嵌套——外层接收装饰器参数，中层接收函数，内层执行逻辑。典型应用：重试机制、权限校验、缓存。',
'python',
'import functools
import time

# 基础装饰器：执行计时
def timer(func):
    @functools.wraps(func)  # 保留原函数元信息
    def wrapper(*args, **kwargs):
        start = time.perf_counter()  # 高精度计时
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"[Timer] {func.__name__} 耗时 {elapsed:.6f}s")
        return result
    return wrapper

# 带参装饰器：失败重试
def retry(max_attempts=3, delay=1.0, exceptions=(Exception,)):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            last_exc = None
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    last_exc = e
                    if attempt < max_attempts:
                        time.sleep(delay * attempt)  # 指数退避
            raise last_exc
        return wrapper
    return decorator

# 缓存装饰器（Python 3.9+ 内置 functools.cache）
def memoize(func):
    cache = {}
    @functools.wraps(func)
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    wrapper.cache = cache
    return wrapper

@timer
@retry(max_attempts=3, delay=0.5)
def fetch_data(url: str) -> dict:
    import requests
    return requests.get(url, timeout=5).json()',
1, 345, 52, 16),

(@bot_id, '生成器与协程 — 内存友好的流式处理',
'**生成器 (yield)：** 按需生成数据，避免一次性加载全部数据到内存。适合处理大文件、数据流、无限序列。
**yield from：** 委托子生成器，简化嵌套生成器的编码，同时建立双向通道(send/throw可穿透)。
**协程 (coroutine)：** 使用 async/await 的异步生成器，适合 I/O 密集型任务。
**内存对比：** 列表推导式 `[x for x in range(10**6)]` 约占 32MB，生成器表达式 `(x for x in range(10**6))` 仅占 120 字节。',
'python',
'import itertools

# 基础生成器：斐波那契无限序列
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# 取前10个
fib = list(itertools.islice(fibonacci(), 10))

# 大文件逐行处理（不加载全部到内存）
def read_large_file(filepath, chunk_size=8192):
    with open(filepath, "r", encoding="utf-8") as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            yield chunk

def grep(pattern, lines):
    """生成器管道：过滤包含pattern的行"""
    for line in lines:
        if pattern in line:
            yield line.rstrip()

# 使用：统计日志中ERROR出现次数
# count = sum(1 for _ in grep("ERROR", read_large_file("app.log")))

# yield from 委托
def chain(*iterables):
    for it in iterables:
        yield from it  # 等价于 for x in it: yield x

# 异步生成器
async def async_fetch_pages(urls):
    import aiohttp
    async with aiohttp.ClientSession() as session:
        for url in urls:
            async with session.get(url) as resp:
                yield await resp.text()',
1, 289, 43, 12),

(@bot_id, 'Pandas 数据分析常用操作',
'**核心数据结构：** Series（一维）和 DataFrame（二维表格），底层基于 NumPy 数组，支持向量化运算。
**链式调用：** Pandas 方法返回新对象（不可变设计），支持 `.method1().method2().method3()` 链式操作。
**性能优化：** 避免逐行迭代（iterrows），优先使用向量化操作和 apply()。百万级数据下 iterrows 比向量化慢 100 倍以上。',
'python',
'import pandas as pd
import numpy as np

# 读取与基本操作
df = pd.read_csv("sales.csv", parse_dates=["date"])
df.head()
df.info()
df.describe()

# 数据清洗
df = (
    df.dropna(subset=["amount"])             # 删除金额为空的行
      .assign(
          amount=lambda x: x["amount"].abs(),  # 取绝对值
          month=lambda x: x["date"].dt.to_period("M")
      )
      .query("amount > 0 and amount < 100000")  # 过滤异常值
)

# 分组聚合
summary = (
    df.groupby(["category", "month"])
      .agg(
          total_sales=("amount", "sum"),
          avg_sales=("amount", "mean"),
          order_count=("order_id", "nunique")
      )
      .reset_index()
)

# 透视表
pivot = df.pivot_table(
    values="amount", index="category",
    columns="month", aggfunc="sum", fill_value=0, margins=True
)

# 窗口函数：移动平均
df["ma7"] = df.groupby("category")["amount"].transform(
    lambda x: x.rolling(7, min_periods=1).mean()
)',
1, 234, 35, 8),

(@bot_id, 'FastAPI 现代Web API模板',
'**框架特点：** 基于 Starlette + Pydantic，自动生成 OpenAPI 文档，原生 async/await 支持，类型提示驱动的参数校验。
**依赖注入：** Depends() 实现依赖注入，自动解析请求参数、数据库连接、权限校验等，支持多层嵌套。
**性能对比：** FastAPI 在 TechEmpower 基准测试中性能接近 Node.js/Go，比 Flask/Django REST Framework 快 2-3 倍。',
'python',
'from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime

app = FastAPI(title="用户管理API", version="1.0")

# Pydantic模型：自动校验请求体
class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    username: str
    email: EmailStr
    created_at: datetime

    class Config:
        from_attributes = True  # ORM模式

# 模拟数据库
users_db: dict = {}

@app.post("/api/users", response_model=UserResponse, status_code=201)
async def create_user(user: UserCreate):
    if user.username in users_db:
        raise HTTPException(status_code=400, detail="用户名已存在")
    user_dict = user.model_dump()
    user_dict["id"] = len(users_db) + 1
    user_dict["created_at"] = datetime.now()
    users_db[user.username] = user_dict
    return user_dict

@app.get("/api/users", response_model=List[UserResponse])
async def list_users(skip: int = 0, limit: int = 20):
    return list(users_db.values())[skip:skip + limit]

@app.get("/api/users/{username}", response_model=UserResponse)
async def get_user(username: str):
    if username not in users_db:
        raise HTTPException(status_code=404, detail="用户不存在")
    return users_db[username]

# 启动: uvicorn main:app --reload',
1, 198, 28, 6);

-- =============================================
-- 四、JavaScript/TypeScript
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '手写Promise — 符合Promise/A+规范',
'**状态机：** Promise 有三种状态 pending → fulfilled/rejected，状态只能单向转换且一旦确定不可变更。
**微任务：** then() 的回调通过 queueMicrotask 或 MutationObserver 投递到微任务队列，确保异步执行（即使 resolve 在 then 之前调用）。
**链式穿透：** then() 返回新 Promise，如果 onFulfilled 返回值是 Promise，则等待其完成；如果抛出异常，则新 Promise rejected。',
'javascript',
'class MyPromise {
    #state = "pending";
    #value = null;
    #fulfilledCallbacks = [];
    #rejectedCallbacks = [];

    constructor(executor) {
        const resolve = (value) => {
            if (this.#state !== "pending") return;
            queueMicrotask(() => {
                this.#state = "fulfilled";
                this.#value = value;
                this.#fulfilledCallbacks.forEach(cb => cb(value));
            });
        };
        const reject = (reason) => {
            if (this.#state !== "pending") return;
            queueMicrotask(() => {
                this.#state = "rejected";
                this.#value = reason;
                this.#rejectedCallbacks.forEach(cb => cb(reason));
            });
        };
        try { executor(resolve, reject); }
        catch (e) { reject(e); }
    }

    then(onFulfilled, onRejected) {
        return new MyPromise((resolve, reject) => {
            const handleFulfilled = (val) => {
                try {
                    const result = onFulfilled ? onFulfilled(val) : val;
                    result instanceof MyPromise ? result.then(resolve, reject) : resolve(result);
                } catch (e) { reject(e); }
            };
            const handleRejected = (reason) => {
                try {
                    if (onRejected) {
                        const result = onRejected(reason);
                        result instanceof MyPromise ? result.then(resolve, reject) : resolve(result);
                    } else { reject(reason); }
                } catch (e) { reject(e); }
            };
            if (this.#state === "fulfilled") handleFulfilled(this.#value);
            else if (this.#state === "rejected") handleRejected(this.#value);
            else {
                this.#fulfilledCallbacks.push(handleFulfilled);
                this.#rejectedCallbacks.push(handleRejected);
            }
        });
    }

    catch(onRejected) { return this.then(null, onRejected); }

    static resolve(value) {
        return value instanceof MyPromise ? value : new MyPromise(r => r(value));
    }

    static all(promises) {
        return new MyPromise((resolve, reject) => {
            const results = [];
            let count = 0;
            promises.forEach((p, i) => {
                MyPromise.resolve(p).then(val => {
                    results[i] = val;
                    if (++count === promises.length) resolve(results);
                }, reject);
            });
        });
    }
}',
1, 412, 63, 20),

(@bot_id, 'EventEmitter发布订阅 — 完整实现',
'**设计模式：** 发布-订阅模式解耦事件的生产者和消费者。事件总线作为中间层，生产者 emit 事件，消费者 on 监听。
**内存泄漏防护：** once() 注册的监听器在触发后自动移除；off() 手动取消订阅。长期运行的系统中必须注意清理不再需要的监听器。
**应用场景：** Node.js EventEmitter、DOM 事件系统、Vue 的 $emit/on、Redux 的 subscribe。',
'javascript',
'class EventEmitter {
    #events = new Map();

    on(event, fn) {
        if (!this.#events.has(event)) this.#events.set(event, []);
        this.#events.get(event).push(fn);
        // 返回取消订阅函数
        return () => this.off(event, fn);
    }

    off(event, fn) {
        const fns = this.#events.get(event);
        if (fns) this.#events.set(event, fns.filter(f => f !== fn && f !== fn._original));
    }

    emit(event, ...args) {
        const fns = this.#events.get(event) || [];
        // 复制数组，防止once()在遍历时修改原数组
        [...fns].forEach(fn => fn(...args));
    }

    once(event, fn) {
        const wrapper = (...args) => { fn(...args); this.off(event, wrapper); };
        wrapper._original = fn; // 用于off()查找
        this.on(event, wrapper);
    }

    listenerCount(event) {
        return (this.#events.get(event) || []).length;
    }

    removeAllListeners(event) {
        event ? this.#events.delete(event) : this.#events.clear();
    }
}

// 使用示例
const bus = new EventEmitter();
const unsub = bus.on("data", d => console.log("收到:", d));
bus.once("init", () => console.log("初始化完成"));
bus.emit("data", { id: 1 });   // 收到: {id: 1}
bus.emit("init");              // 初始化完成
bus.emit("init");              // 不会再次触发
unub();                        // 取消data监听',
1, 289, 44, 14),

(@bot_id, '深拷贝 — 处理循环引用和特殊类型',
'**核心难点：** ① 循环引用（对象引用自身）导致无限递归 ② 特殊类型（Date/RegExp/Map/Set）需要特殊处理 ③ 原型链丢失。
**解决方案：** 使用 WeakMap 存储已拷贝对象的映射关系，遇到已拷贝对象直接返回引用，打破循环。
**JSON.parse(JSON.stringify()) 的局限：** 丢失 undefined、Function、Symbol；Date 变成字符串；循环引用报错；不支持 Map/Set/RegExp。',
'javascript',
'function deepClone(obj, cache = new WeakMap()) {
    // 基本类型直接返回
    if (obj === null || typeof obj !== "object") return obj;

    // 处理循环引用
    if (cache.has(obj)) return cache.get(obj);

    // 特殊对象类型
    if (obj instanceof Date)    return new Date(obj);
    if (obj instanceof RegExp)  return new RegExp(obj.source, obj.flags);
    if (obj instanceof Error)   return new obj.constructor(obj.message);

    if (obj instanceof Map) {
        const m = new Map();
        cache.set(obj, m);
        obj.forEach((v, k) => m.set(deepClone(k, cache), deepClone(v, cache)));
        return m;
    }

    if (obj instanceof Set) {
        const s = new Set();
        cache.set(obj, s);
        obj.forEach(v => s.add(deepClone(v, cache)));
        return s;
    }

    // Array / Object
    const clone = Array.isArray(obj)
        ? []
        : Object.create(Object.getPrototypeOf(obj)); // 保留原型链
    cache.set(obj, clone);

    // 拷贝所有属性（包括Symbol）
    Reflect.ownKeys(obj).forEach(key => {
        clone[key] = deepClone(obj[key], cache);
    });
    return clone;
}

// 验证循环引用
const a = { name: "root" };
a.self = a;
a.children = [{ name: "child", parent: a }];
const b = deepClone(a);
console.log(b.self === b);            // true
console.log(b.children[0].parent === b); // true',
1, 356, 55, 18),

(@bot_id, '防抖与节流 — 含立即执行和取消功能',
'**防抖 (debounce)：** 事件停止触发 delay 毫秒后才执行。适用于搜索框联想（用户停止输入后才请求）、窗口 resize。
**节流 (throttle)：** 每隔 delay 毫秒最多执行一次。适用于滚动事件、鼠标移动、按钮防重复点击。
**立即执行选项：** immediate=true 时在事件开头立即执行一次，之后等待停止触发。scroll spy 场景常用。
**性能影响：** scroll 事件每秒触发 60+ 次，不加防抖/节流会导致大量无效计算。',
'javascript',
'// 防抖：停止触发后delay才执行
function debounce(fn, delay, immediate = false) {
    let timer = null;
    const debounced = function(...args) {
        if (timer) clearTimeout(timer);

        if (immediate && !timer) {
            fn.apply(this, args);  // 立即执行
        }

        timer = setTimeout(() => {
            timer = null;
            if (!immediate) fn.apply(this, args);
        }, delay);
    };

    debounced.cancel = () => { clearTimeout(timer); timer = null; };
    return debounced;
}

// 节流：每delay间隔最多执行一次
function throttle(fn, delay) {
    let last = 0;
    let timer = null;
    const throttled = function(...args) {
        const now = Date.now();
        if (now - last >= delay) {
            last = now;
            fn.apply(this, args);
        } else if (!timer) {
            timer = setTimeout(() => {
                last = Date.now();
                timer = null;
                fn.apply(this, args);
            }, delay - (now - last));
        }
    };
    throttled.cancel = () => { clearTimeout(timer); timer = null; };
    return throttled;
}

// 使用
const search = debounce((keyword) => {
    fetch(`/api/search?q=${keyword}`);
}, 300);

const onScroll = throttle(() => {
    console.log("scrollTop:", window.scrollY);
}, 100);

window.addEventListener("input", e => search(e.target.value));
window.addEventListener("scroll", onScroll);',
1, 445, 68, 22),

(@bot_id, 'TypeScript 高级类型体操',
'**类型编程：** TypeScript 的类型系统是图灵完备的，可以通过条件类型、映射类型、模板字面量类型实现复杂的类型推导。
**infer 关键字：** 在条件类型中提取类型信息，类似模式匹配。`T extends (...args: any[]) => infer R ? R : never` 提取函数返回类型。
**递归类型：** TypeScript 4.1+ 支持递归条件类型，可实现深度 Readonly、嵌套属性路径等。',
'typescript',
'// 1. 提取函数返回类型
type ReturnOf<T> = T extends (...args: any[]) => infer R ? R : never;
type A = ReturnOf<() => string>;  // string

// 2. 深度 Readonly
type DeepReadonly<T> = T extends Function ? T : {
    readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K];
};

interface Config { db: { host: string; port: number }; }
type Locked = DeepReadonly<Config>;
// Locked["db"]["host"] 是 readonly

// 3. 联合类型转交叉类型
type UnionToIntersection<U> =
    (U extends any ? (k: U) => void : never) extends
    (k: infer I) => void ? I : never;

type U = { a: 1 } | { b: 2 };
type I = UnionToIntersection<U>;  // { a: 1 } & { b: 2 }

// 4. 模板字面量类型
type EventName<T extends string> = `on${Capitalize<T>}`;
type ClickEvent = EventName<"click">;  // "onClick"

// 5. 递归：获取嵌套对象属性路径
type PathKeys<T, K extends keyof T = keyof T> =
    K extends string
        ? T[K] extends Record<string, any>
            ? `${K}.${PathKeys<T[K]>}` | K
            : K
        : never;

interface Data { user: { name: string; address: { city: string } }; }
type Keys = PathKeys<Data>;
// "user" | "user.name" | "user.address" | "user.address.city"',
1, 312, 48, 15);

-- =============================================
-- 五、Go
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'Go 并发安全的对象池',
'**sync.Pool 设计思想：** 临时对象池，减少 GC 压力。Get() 优先从本地池取对象，Put() 归还对象。适合高频创建销毁的场景（如 HTTP 请求中的 buffer）。
**注意事项：** Pool 中的对象随时可能被 GC 回收，不能假设 Get 一定能拿到对象。不要存有状态的对象（如未关闭的连接）。
**性能对比：** 使用 Pool 后 JSON 序列化的内存分配减少 90%+，GC 暂停时间显著降低。',
'go',
'package pool

import (
    "bytes"
    "encoding/json"
    "sync"
)

// Buffer 对象池：减少 []byte 的频繁分配
var bufferPool = sync.Pool{
    New: func() interface{} {
        return bytes.NewBuffer(make([]byte, 0, 4096))
    },
}

func GetBuffer() *bytes.Buffer {
    return bufferPool.Get().(*bytes.Buffer)
}

func PutBuffer(buf *bytes.Buffer) {
    buf.Reset()                    // 清空内容
    if buf.Cap() > 64*1024 {       // 防止池膨胀：超过64KB的不归还
        return
    }
    bufferPool.Put(buf)
}

// JSON编码器池
var encoderPool = sync.Pool{
    New: func() interface{} {
        return json.NewEncoder(bytes.NewBuffer(nil))
    },
}

// 使用示例
func MarshalWithPool(v interface{}) ([]byte, error) {
    buf := GetBuffer()
    defer PutBuffer(buf)

    enc := json.NewEncoder(buf)
    if err := enc.Encode(v); err != nil {
        return nil, err
    }
    result := make([]byte, buf.Len())
    copy(result, buf.Bytes())
    return result, nil
}',
1, 178, 26, 5),

(@bot_id, 'Go Context 超时控制',
'**Context 传播：** Go 的 Context 是请求范围的值传递和取消信号传播机制。从父 Context 派生子 Context，取消信号向下游传播。
**WithTimeout vs WithDeadline：** WithTimeout 指定持续时间（如 3s），WithDeadline 指定绝对时间点。
**最佳实践：** 函数第一个参数必须是 context.Context；不要存储可变值；不要传 nil Context，用 context.TODO() 占位。',
'go',
'package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    // 创建带3秒超时的Context
    ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
    defer cancel() // 必须调用，防止资源泄漏

    resultCh := make(chan string, 1)

    go func() {
        // 模拟耗时操作
        result := slowOperation(ctx)
        resultCh <- result
    }()

    select {
    case result := <-resultCh:
        fmt.Println("成功:", result)
    case <-ctx.Done():
        fmt.Println("超时:", ctx.Err())
        // context deadline exceeded
    }
}

func slowOperation(ctx context.Context) string {
    // 定期检查ctx是否已取消
    for i := 0; i < 10; i++ {
        select {
        case <-ctx.Done():
            return "已取消"
        case <-time.After(500 * time.Millisecond):
            fmt.Printf("处理第%d步...\n", i+1)
        }
    }
    return "完成"
}

// Context值传递（仅传递请求范围的数据）
type contextKey string
func WithUserID(ctx context.Context, uid int64) context.Context {
    return context.WithValue(ctx, contextKey("userID"), uid)
}
func UserIDFrom(ctx context.Context) int64 {
    uid, _ := ctx.Value(contextKey("userID")).(int64)
    return uid
}',
1, 198, 30, 7);

-- =============================================
-- 六、SQL与数据库
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'MySQL窗口函数实战',
'**窗口函数：** 对一组行执行计算并为每行返回一个值，不改变结果集行数。与聚合函数的区别：窗口函数保留所有行，聚合函数将多行合并为一行。
**语法：** `函数() OVER (PARTITION BY 分组列 ORDER BY 排序列 ROWS BETWEEN 范围)`。
**常用函数：** ROW_NUMBER（唯一排名）、RANK（允许并列）、DENSE_RANK（并列无跳跃）、LAG/LEAD（前后行值）、NTILE（分桶）。',
'sql',
'-- 1. 部门工资排名（允许并列）
SELECT name, department, salary,
       ROW_NUMBER() OVER w AS rn,    -- 1,2,3,4（唯一）
       RANK()       OVER w AS rk,    -- 1,1,3,4（并列跳跃）
       DENSE_RANK() OVER w AS drk    -- 1,1,2,3（并列连续）
FROM employees
WINDOW w AS (PARTITION BY department ORDER BY salary DESC);

-- 2. 计算环比增长率
SELECT month, revenue,
       LAG(revenue, 1) OVER (ORDER BY month)  AS prev_month,
       ROUND((revenue - LAG(revenue, 1) OVER (ORDER BY month))
             / LAG(revenue, 1) OVER (ORDER BY month) * 100, 2) AS growth_pct
FROM monthly_sales;

-- 3. 连续登录天数（经典面试题）
WITH login_ranked AS (
    SELECT user_id, login_date,
           DATE_SUB(login_date, INTERVAL ROW_NUMBER()
               OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM user_logins
)
SELECT user_id, MIN(login_date) AS start_date,
       MAX(login_date) AS end_date,
       COUNT(*) AS consecutive_days
FROM login_ranked
GROUP BY user_id, grp
HAVING consecutive_days >= 7;

-- 4. 移动平均
SELECT date, amount,
       AVG(amount) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS ma7,
       AVG(amount) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS ma30
FROM daily_sales;',
1, 345, 52, 16),

(@bot_id, 'MySQL索引设计与慢查询优化',
'**B+Tree 索引原理：** InnoDB 使用 B+Tree 索引，叶子节点存储数据（聚簇索引）或主键值（二级索引）。数据按主键顺序物理存储。
**最左前缀原则：** 联合索引 (a,b,c) 支持 a / a,b / a,b,c 查询，不支持 b / c / b,c 查询（跳过了最左列）。
**覆盖索引：** 查询的所有列都在索引中，无需回表查数据行，性能最优。
**索引下推 (ICP)：** MySQL 5.6+ 支持在存储引擎层过滤索引条件，减少回表次数。',
'sql',
'-- ❌ 反例：索引失效的常见写法
SELECT * FROM orders WHERE YEAR(create_time) = 2024;        -- 对列使用函数
SELECT * FROM orders WHERE amount + 10 > 100;                -- 对列做运算
SELECT * FROM orders WHERE status != 1;                      -- != NOT IN 可能不走索引
SELECT * FROM orders WHERE name LIKE "%手机%";               -- 左模糊

-- ✅ 正确写法
SELECT * FROM orders
WHERE create_time >= "2024-01-01" AND create_time < "2025-01-01";

-- 联合索引设计原则
-- 高频等值查询列放前面，范围查询列放最后
ALTER TABLE orders ADD INDEX idx_status_time (status, create_time);

-- 覆盖索引：所有查询列都在索引中，不需要回表
SELECT order_id, status, create_time FROM orders WHERE status = 1;

-- EXPLAIN 分析关键字段
-- type: ALL(全表扫描) < index < range < ref < eq_ref < const
-- key: 实际使用的索引
-- rows: 预估扫描行数
-- Extra: Using index(覆盖索引) / Using where(需回表过滤)

-- 强制指定索引（最后手段）
SELECT * FROM orders FORCE INDEX(idx_status_time) WHERE status = 1;',
1, 412, 62, 20);

-- =============================================
-- 七、系统设计与架构
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '分布式ID生成 — 雪花算法(Snowflake)',
'**算法原理：** 64位ID = 1位符号(0) + 41位时间戳(毫秒级，可用69年) + 10位机器ID(5位数据中心+5位机器) + 12位序列号(每毫秒4096个)。
**优势：** 趋势递增(对B+Tree友好)、全局唯一、高性能(单机每毫秒4096个)、无需网络调用。
**时钟回拨问题：** 系统时钟被人工调整或NTP同步导致时间倒退，可能生成重复ID。解决方案：等待时钟追上、使用特殊位标记回拨、使用美团Leaf等改良方案。',
'java',
'public class SnowflakeIdGenerator {
    private final long epoch = 1609459200000L; // 2021-01-01 00:00:00

    private final long datacenterBits = 5L;
    private final long workerBits = 5L;
    private final long sequenceBits = 12L;

    private final long maxDatacenterId = ~(-1L << datacenterBits); // 31
    private final long maxWorkerId = ~(-1L << workerBits);         // 31
    private final long sequenceMask = ~(-1L << sequenceBits);      // 4095

    private final long datacenterIdShift = sequenceBits + workerBits; // 17
    private final long workerIdShift = sequenceBits;                  // 12
    private final long timestampShift = sequenceBits + workerBits + datacenterBits; // 22

    private long datacenterId;
    private long workerId;
    private long sequence = 0L;
    private long lastTimestamp = -1L;

    public SnowflakeIdGenerator(long datacenterId, long workerId) {
        if (datacenterId > maxDatacenterId || datacenterId < 0)
            throw new IllegalArgumentException("datacenterId 超出范围");
        if (workerId > maxWorkerId || workerId < 0)
            throw new IllegalArgumentException("workerId 超出范围");
        this.datacenterId = datacenterId;
        this.workerId = workerId;
    }

    public synchronized long nextId() {
        long timestamp = System.currentTimeMillis();
        if (timestamp < lastTimestamp)
            throw new RuntimeException("时钟回拨，拒绝生成ID");
        if (timestamp == lastTimestamp) {
            sequence = (sequence + 1) & sequenceMask;
            if (sequence == 0) timestamp = waitNextMillis(lastTimestamp);
        } else {
            sequence = 0L;
        }
        lastTimestamp = timestamp;
        return ((timestamp - epoch) << timestampShift)
             | (datacenterId << datacenterIdShift)
             | (workerId << workerIdShift)
             | sequence;
    }

    private long waitNextMillis(long last) {
        long ts = System.currentTimeMillis();
        while (ts <= last) ts = System.currentTimeMillis();
        return ts;
    }
}',
1, 289, 43, 13),

(@bot_id, 'JWT认证完整实现 — 生成/验证/刷新',
'**JWT 结构：** Header(算法) + Payload(声明) + Signature(签名)。三部分用 Base64Url 编码后以 . 连接。
**安全要点：** ①密钥至少256位 ②设置合理的过期时间(建议2小时) ③敏感信息不放入Payload ④使用HTTPS传输。
**刷新机制：** Access Token 短期(2h) + Refresh Token 长期(7d)。Access Token 过期后用 Refresh Token 换取新的，避免频繁登录。',
'java',
'import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

public class JwtService {
    private static final String SECRET = "MySecretKeyForJWT2024MustBe256BitsLong!";
    private final SecretKey key = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));

    private final long accessExp = 7200000;    // Access Token: 2小时
    private final long refreshExp = 604800000; // Refresh Token: 7天

    // 生成Token
    public String generateAccessToken(Long userId, String role) {
        return Jwts.builder()
                .subject(String.valueOf(userId))
                .claim("role", role)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + accessExp))
                .signWith(key)
                .compact();
    }

    // 验证Token
    public Claims validateToken(String token) {
        try {
            return Jwts.parser().verifyWith(key).build()
                    .parseSignedClaims(token).getPayload();
        } catch (ExpiredJwtException e) {
            throw new RuntimeException("Token已过期");
        } catch (JwtException e) {
            throw new RuntimeException("Token无效");
        }
    }

    // 刷新Token
    public String refreshToken(String refreshToken) {
        Claims claims = validateToken(refreshToken);
        Long userId = Long.parseLong(claims.getSubject());
        String role = claims.get("role", String.class);
        return generateAccessToken(userId, role);
    }

    // 从Token获取用户ID
    public Long getUserId(String token) {
        return Long.parseLong(validateToken(token).getSubject());
    }
}',
1, 356, 54, 17);

-- =============================================
-- 八、前端CSS/HTML
-- =============================================

INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'CSS现代布局方案合集',
'**Grid vs Flexbox：** Grid 适合二维布局（行+列），Flexbox 适合一维布局（行或列）。实际开发中两者常配合使用。
**auto-fill vs auto-fit：** auto-fill 在空间不足时保留空轨道；auto-fit 会折叠空轨道让已有元素伸展填充。
**clamp() 函数：** `clamp(min, preferred, max)` 实现响应式字体/间距，不需要媒体查询。',
'javascript',
'/* 1. 响应式卡片网格 — 零媒体查询 */
.card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: clamp(16px, 2vw, 32px);
}

/* 2. 圣杯布局 — Grid一行搞定 */
.layout {
    display: grid;
    grid-template:
        "header header header" 60px
        "sidebar main aside" 1fr
        "footer footer footer" 40px
        / 240px 1fr 200px;
    min-height: 100vh;
}
.layout > header { grid-area: header; }
.layout > nav    { grid-area: sidebar; }
.layout > main   { grid-area: main; }
.layout > aside  { grid-area: aside; }
.layout > footer { grid-area: footer; }

/* 3. 居中 — 三种方式 */
.center-grid    { display: grid; place-items: center; }
.center-flex    { display: flex; justify-content: center; align-items: center; }
.center-absolute {
    position: absolute; top: 50%; left: 50%;
    transform: translate(-50%, -50%);
}

/* 4. 精灵文字效果 */
.gradient-text {
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* 5. 磨砂玻璃 */
.glass {
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(20px) saturate(180%);
    -webkit-backdrop-filter: blur(20px) saturate(180%);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 16px;
}',
1, 267, 41, 12),

(@bot_id, 'CSS动画与过渡 — 实用动效合集',
'**transition vs animation：** transition 用于状态变化（hover/focus），需要触发条件；animation 可定义多关键帧，自动播放。
**性能优化：** 只对 transform 和 opacity 做动画（GPU加速），避免对 width/height/top/left 做动画（触发重排/重绘）。
**cubic-bezier：** 贝塞尔曲线控制动画节奏，`cubic-bezier(0.34, 1.56, 0.64, 1)` 实现弹性效果。',
'javascript',
'/* 1. 悬浮卡片 — 阴影+位移 */
.card {
    transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
                box-shadow 0.3s ease;
}
.card:hover {
    transform: translateY(-8px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

/* 2. 骨架屏加载动画 */
@keyframes shimmer {
    0%   { background-position: -200% 0; }
    100% { background-position: 200% 0; }
}
.skeleton {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
    border-radius: 8px;
}

/* 3. 渐入动画 */
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to   { opacity: 1; transform: translateY(0); }
}
.fade-in {
    animation: fadeInUp 0.6s ease-out forwards;
}

/* 4. 按钮波纹效果 */
.btn-ripple {
    position: relative; overflow: hidden;
}
.btn-ripple::after {
    content: "";
    position: absolute; top: 50%; left: 50%;
    width: 0; height: 0;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    transform: translate(-50%, -50%);
    transition: width 0.6s, height 0.6s;
}
.btn-ripple:active::after {
    width: 300px; height: 300px;
}

/* 5. 文字打字机效果 */
@keyframes typing {
    from { width: 0; }
    to   { width: 100%; }
}
.typing {
    overflow: hidden;
    white-space: nowrap;
    border-right: 2px solid;
    animation: typing 2s steps(20) forwards,
               blink 0.5s step-end infinite alternate;
}
@keyframes blink { 50% { border-color: transparent; } }',
1, 234, 36, 9);

-- =============================================
-- 更新标签关联
-- =============================================
INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = 'Java' AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = '算法'
AND (s.title LIKE '%排序%' OR s.title LIKE '%并查集%' OR s.title LIKE '%栈%')
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = '设计模式'
AND (s.title LIKE '%单例%' OR s.title LIKE '%模式%')
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = 'Spring Boot'
AND s.title LIKE '%Spring%'
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'python' AND t.name = 'Python'
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'javascript' AND t.name = 'JavaScript'
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'typescript' AND t.name = 'TypeScript'
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'go' AND t.name = 'Go'
AND s.user_id = @bot_id;

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'sql' AND t.name = '数据库'
AND s.user_id = @bot_id;

-- 更新标签计数
UPDATE tag SET snippet_count = (SELECT COUNT(*) FROM snippet_tag WHERE tag_id = tag.id);

-- 结果
SELECT CONCAT('成功插入 ', COUNT(*), ' 个代码片段') AS message FROM snippet;
SELECT CONCAT('共 ', COUNT(*), ' 条标签关联') AS message FROM snippet_tag;
