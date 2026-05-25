-- ============================================
-- AiCodeHub 全面代码片段（按模块分类）
-- 覆盖：面试高频、初学者必学、日常开发常用
-- ============================================

USE aicodehub;
SET @bot_id = (SELECT id FROM user WHERE username = 'codebot');

-- =============================================
-- 模块一：算法 — 排序（面试必考）
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '冒泡排序',
'**原理：** 相邻元素两两比较，每轮将最大元素"冒泡"到末尾。双重循环，外层控制轮数，内层执行比较交换。
**时间复杂度：** 最好 O(n)（已有序，加优化标志），平均/最坏 O(n²)。
**空间复杂度：** O(1)，原地排序。
**稳定性：** 稳定，相等元素不交换。
**适用场景：** 教学演示、小规模数据、几乎有序的数据（优化版）。',
'java',
'public class BubbleSort {
    public static void sort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            boolean swapped = false; // 优化：若本轮无交换则已有序
            for (int j = 0; j < n - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                    swapped = true;
                }
            }
            if (!swapped) break;
        }
    }
}',
1, 520, 78, 25),

(@bot_id, '选择排序',
'**原理：** 每轮从未排序部分选出最小元素，放到已排序部分末尾。与冒泡排序的区别：选择排序每轮只交换一次。
**时间复杂度：** O(n²)，无论数据是否有序。
**空间复杂度：** O(1)。
**稳定性：** 不稳定，交换操作可能改变相等元素的相对位置。
**适用场景：** 数据量小、对交换次数敏感的场景（每次交换代价高时）。',
'java',
'public class SelectionSort {
    public static void sort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIdx]) minIdx = j;
            }
            if (minIdx != i) {
                int temp = arr[i];
                arr[i] = arr[minIdx];
                arr[minIdx] = temp;
            }
        }
    }
}',
1, 345, 52, 16),

(@bot_id, '插入排序',
'**原理：** 将数组分为已排序和未排序两部分，逐个将未排序元素插入到已排序部分的正确位置。
**时间复杂度：** 最好 O(n)（已有序），平均/最坏 O(n²)。
**空间复杂度：** O(1)。
**稳定性：** 稳定。
**适用场景：** 小规模数据（n<50）、几乎有序的数据、作为高级排序的子过程（TimSort 对小分区使用插入排序）。',
'java',
'public class InsertionSort {
    public static void sort(int[] arr) {
        for (int i = 1; i < arr.length; i++) {
            int key = arr[i];
            int j = i - 1;
            // 将大于key的元素后移
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }
}',
1, 312, 45, 14),

(@bot_id, '堆排序',
'**原理：** 利用最大堆的性质（父节点>=子节点），先建堆使根节点为最大值，再将根节点与末尾交换并缩小堆。
**时间复杂度：** O(n log n)，建堆 O(n)，每次调整 O(log n)。
**空间复杂度：** O(1)，原地排序。
**稳定性：** 不稳定。
**优势：** 始终 O(n log n)，不受数据分布影响；适合 Top-K 问题。',
'java',
'public class HeapSort {
    public static void sort(int[] arr) {
        int n = arr.length;
        // 建最大堆（从最后一个非叶子节点开始）
        for (int i = n / 2 - 1; i >= 0; i--) {
            heapify(arr, n, i);
        }
        // 逐个取出堆顶（最大值），放到末尾
        for (int i = n - 1; i > 0; i--) {
            int temp = arr[0]; arr[0] = arr[i]; arr[i] = temp;
            heapify(arr, i, 0);
        }
    }

    private static void heapify(int[] arr, int n, int i) {
        int largest = i, left = 2 * i + 1, right = 2 * i + 2;
        if (left < n && arr[left] > arr[largest]) largest = left;
        if (right < n && arr[right] > arr[largest]) largest = right;
        if (largest != i) {
            int temp = arr[i]; arr[i] = arr[largest]; arr[largest] = temp;
            heapify(arr, n, largest);
        }
    }
}',
1, 289, 42, 13),

(@bot_id, '计数排序 — 非比较排序',
'**原理：** 统计每个元素出现的次数，按次数重建有序数组。适用于值域范围有限的整数数组。
**时间复杂度：** O(n + k)，k为值域范围。
**空间复杂度：** O(k)。
**局限性：** 仅适用于整数且值域范围小的场景（如成绩排序、年龄排序）。',
'java',
'public class CountingSort {
    public static void sort(int[] arr) {
        int max = arr[0], min = arr[0];
        for (int x : arr) { max = Math.max(max, x); min = Math.min(min, x); }

        int[] count = new int[max - min + 1];
        for (int x : arr) count[x - min]++;

        int idx = 0;
        for (int i = 0; i < count.length; i++) {
            while (count[i]-- > 0) arr[idx++] = i + min;
        }
    }
}',
1, 234, 36, 10);

-- =============================================
-- 模块二：算法 — 查找与递归（面试高频）
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '二分查找及变体',
'**原理：** 在有序数组中，每次取中间元素与目标比较，将搜索范围缩小一半。
**变体：** ①查找第一个等于目标的位置 ②查找最后一个等于目标的位置 ③查找第一个大于目标的位置。
**时间复杂度：** O(log n)。
**面试陷阱：** mid = left + (right - left) / 2 防溢出；循环条件和边界更新是易错点。',
'java',
'public class BinarySearch {
    // 基础版：返回目标值下标，不存在返回-1
    public static int search(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + ((right - left) >> 1);
            if (arr[mid] == target) return mid;
            else if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }

    // 查找第一个等于target的位置（面试高频）
    public static int firstEqual(int[] arr, int target) {
        int left = 0, right = arr.length - 1, result = -1;
        while (left <= right) {
            int mid = left + ((right - left) >> 1);
            if (arr[mid] == target) { result = mid; right = mid - 1; }
            else if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return result;
    }

    // 查找第一个大于target的位置
    public static int firstGreater(int[] arr, int target) {
        int left = 0, right = arr.length;
        while (left < right) {
            int mid = left + ((right - left) >> 1);
            if (arr[mid] <= target) left = mid + 1;
            else right = mid;
        }
        return left < arr.length ? left : -1;
    }
}',
1, 456, 68, 22),

(@bot_id, '递归经典问题合集',
'**递归三要素：** ①函数定义 ②终止条件 ③递推关系。
**优化：** 递归 → 记忆化 → 动态规划，是同一思想的三种实现方式。
**常见陷阱：** 栈溢出（递归深度过大）、重复计算（加记忆化）。',
'java',
'public class Recursion {

    // 1. 斐波那契数列（记忆化优化）
    private static Map<Integer, Long> memo = new HashMap<>();
    public static long fibonacci(int n) {
        if (n <= 1) return n;
        if (memo.containsKey(n)) return memo.get(n);
        long result = fibonacci(n - 1) + fibonacci(n - 2);
        memo.put(n, result);
        return result;
    }

    // 2. 汉诺塔
    public static void hanoi(int n, char from, char to, char aux) {
        if (n == 1) { System.out.println(from + " -> " + to); return; }
        hanoi(n - 1, from, aux, to);
        System.out.println(from + " -> " + to);
        hanoi(n - 1, aux, to, from);
    }

    // 3. 全排列
    public static List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> result = new ArrayList<>();
        backtrack(nums, new boolean[nums.length], new ArrayList<>(), result);
        return result;
    }
    private static void backtrack(int[] nums, boolean[] used, List<Integer> path, List<List<Integer>> result) {
        if (path.size() == nums.length) { result.add(new ArrayList<>(path)); return; }
        for (int i = 0; i < nums.length; i++) {
            if (used[i]) continue;
            used[i] = true; path.add(nums[i]);
            backtrack(nums, used, path, result);
            path.remove(path.size() - 1); used[i] = false;
        }
    }

    // 4. 二叉树的最大深度
    public static int maxDepth(TreeNode root) {
        if (root == null) return 0;
        return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
    }
}',
1, 378, 56, 18);

-- =============================================
-- 模块三：数据结构 — 链表（面试必考）
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '链表核心操作合集',
'**链表 vs 数组：** 链表插入删除 O(1)（已知位置），查找 O(n)；数组查找 O(1)，插入删除 O(n)。
**虚拟头节点：** 使用 dummy 节点统一头节点和其他节点的处理逻辑，避免空指针。
**快慢指针：** 快指针走两步、慢指针走一步，可求中点、判环、找倒数第K个节点。',
'java',
'public class LinkedListOps {

    static class ListNode { int val; ListNode next; ListNode(int v) { val = v; } }

    // 1. 反转链表（LeetCode 206）
    public static ListNode reverse(ListNode head) {
        ListNode prev = null, curr = head;
        while (curr != null) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }

    // 2. 合并两个有序链表（LeetCode 21）
    public static ListNode merge(ListNode l1, ListNode l2) {
        ListNode dummy = new ListNode(0), curr = dummy;
        while (l1 != null && l2 != null) {
            if (l1.val <= l2.val) { curr.next = l1; l1 = l1.next; }
            else { curr.next = l2; l2 = l2.next; }
            curr = curr.next;
        }
        curr.next = l1 != null ? l1 : l2;
        return dummy.next;
    }

    // 3. 快慢指针找中点
    public static ListNode findMiddle(ListNode head) {
        ListNode slow = head, fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }
        return slow;
    }

    // 4. 判断链表是否有环（LeetCode 141）
    public static boolean hasCycle(ListNode head) {
        ListNode slow = head, fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if (slow == fast) return true;
        }
        return false;
    }

    // 5. 删除倒数第N个节点（LeetCode 19）
    public static ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode dummy = new ListNode(0); dummy.next = head;
        ListNode fast = dummy, slow = dummy;
        for (int i = 0; i <= n; i++) fast = fast.next;
        while (fast != null) { fast = fast.next; slow = slow.next; }
        slow.next = slow.next.next;
        return dummy.next;
    }

    // 6. 判断回文链表（LeetCode 234）
    public static boolean isPalindrome(ListNode head) {
        ListNode mid = findMiddle(head);
        ListNode reversed = reverse(mid);
        while (reversed != null) {
            if (head.val != reversed.val) return false;
            head = head.next; reversed = reversed.next;
        }
        return true;
    }
}',
1, 512, 76, 24);

-- =============================================
-- 模块四：数据结构 — 栈和队列
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '栈的经典应用',
'**栈的特性：** 后进先出(LIFO)。适合处理"最近/上一个"类问题。
**单调栈：** 栈内元素保持单调递增/递减，可在 O(n) 内找到每个元素的下一个更大/更小元素。
**双栈实现队列：** 一个栈负责入队，一个栈负责出队，出栈为空时将入栈元素全部倒入。',
'java',
'import java.util.*;

public class StackApplications {

    // 1. 有效的括号（LeetCode 20）
    public static boolean isValid(String s) {
        Deque<Character> stack = new ArrayDeque<>();
        Map<Character, Character> map = Map.of(')', '(', '}', '{', ']', '[');
        for (char c : s.toCharArray()) {
            if (!map.containsKey(c)) stack.push(c);
            else if (stack.isEmpty() || stack.pop() != map.get(c)) return false;
        }
        return stack.isEmpty();
    }

    // 2. 最小栈（LeetCode 155）：O(1)获取最小值
    static class MinStack {
        Deque<Integer> stack = new ArrayDeque<>();
        Deque<Integer> minStack = new ArrayDeque<>();
        public void push(int val) {
            stack.push(val);
            minStack.push(minStack.isEmpty() ? val : Math.min(val, minStack.peek()));
        }
        public void pop() { stack.pop(); minStack.pop(); }
        public int top() { return stack.peek(); }
        public int getMin() { return minStack.peek(); }
    }

    // 3. 用两个栈实现队列（LeetCode 232）
    static class MyQueue {
        Deque<Integer> in = new ArrayDeque<>(), out = new ArrayDeque<>();
        public void push(int x) { in.push(x); }
        public int pop() { if (out.isEmpty()) while (!in.isEmpty()) out.push(in.pop()); return out.pop(); }
        public int peek() { if (out.isEmpty()) while (!in.isEmpty()) out.push(in.pop()); return out.peek(); }
        public boolean empty() { return in.isEmpty() && out.isEmpty(); }
    }

    // 4. 柱状图中最大矩形（LeetCode 84）
    public static int largestRectangleArea(int[] heights) {
        Deque<Integer> stack = new ArrayDeque<>();
        int max = 0, n = heights.length;
        for (int i = 0; i <= n; i++) {
            int h = (i == n) ? 0 : heights[i];
            while (!stack.isEmpty() && h < heights[stack.peek()]) {
                int height = heights[stack.pop()];
                int width = stack.isEmpty() ? i : i - stack.peek() - 1;
                max = Math.max(max, height * width);
            }
            stack.push(i);
        }
        return max;
    }
}',
1, 345, 52, 16);

-- =============================================
-- 模块五：动态规划（面试重中之重）
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '动态规划入门 — 五大经典问题',
'**DP三要素：** ①状态定义（dp[i]代表什么）②状态转移方程（dp[i]如何从前面推出）③初始条件和边界。
**解题步骤：** 暴力递归 → 记忆化 → 自底向上DP → 空间优化。
**常见模型：** 线性DP、背包DP、区间DP、树形DP、状态压缩DP。',
'java',
'public class DynamicProgramming {

    // 1. 爬楼梯（LeetCode 70）：每次爬1或2阶，到n阶有多少种
    public static int climbStairs(int n) {
        if (n <= 2) return n;
        int a = 1, b = 2;
        for (int i = 3; i <= n; i++) { int c = a + b; a = b; b = c; }
        return b;
    }

    // 2. 最长递增子序列 LIS（LeetCode 300）
    public static int lengthOfLIS(int[] nums) {
        int[] dp = new int[nums.length];
        Arrays.fill(dp, 1);
        int max = 1;
        for (int i = 1; i < nums.length; i++) {
            for (int j = 0; j < i; j++) {
                if (nums[j] < nums[i]) dp[i] = Math.max(dp[i], dp[j] + 1);
            }
            max = Math.max(max, dp[i]);
        }
        return max;
    }

    // 3. 0-1背包问题
    public static int knapsack(int[] weights, int[] values, int capacity) {
        int n = weights.length;
        int[] dp = new int[capacity + 1];
        for (int i = 0; i < n; i++) {
            for (int w = capacity; w >= weights[i]; w--) {
                dp[w] = Math.max(dp[w], dp[w - weights[i]] + values[i]);
            }
        }
        return dp[capacity];
    }

    // 4. 最长公共子序列 LCS（LeetCode 1143）
    public static int longestCommonSubsequence(String s1, String s2) {
        int m = s1.length(), n = s2.length();
        int[] dp = new int[n + 1];
        for (int i = 1; i <= m; i++) {
            int prev = 0;
            for (int j = 1; j <= n; j++) {
                int temp = dp[j];
                dp[j] = s1.charAt(i-1) == s2.charAt(j-1) ? prev + 1 : Math.max(dp[j], dp[j-1]);
                prev = temp;
            }
        }
        return dp[n];
    }

    // 5. 零钱兑换（LeetCode 322）
    public static int coinChange(int[] coins, int amount) {
        int[] dp = new int[amount + 1];
        Arrays.fill(dp, amount + 1);
        dp[0] = 0;
        for (int i = 1; i <= amount; i++) {
            for (int coin : coins) {
                if (coin <= i) dp[i] = Math.min(dp[i], dp[i - coin] + 1);
            }
        }
        return dp[amount] > amount ? -1 : dp[amount];
    }
}',
1, 567, 85, 28),

(@bot_id, '股票买卖系列（LeetCode 121/122/123/188/309/714）',
'**系列特征：** 同一道题的不同变体——限制交易次数、含冷冻期、含手续费。
**状态机DP：** 用"持有/未持有" × "交易次数"定义状态，状态转移清晰。
**核心思想：** 每天的决策只有"买"或"卖"或"持有"，用状态记录当前最优。',
'java',
'public class StockDP {

    // 1. 只能买卖一次（121）
    public static int maxProfit1(int[] prices) {
        int minPrice = Integer.MAX_VALUE, maxProfit = 0;
        for (int p : prices) {
            minPrice = Math.min(minPrice, p);
            maxProfit = Math.max(maxProfit, p - minPrice);
        }
        return maxProfit;
    }

    // 2. 不限次数（122）
    public static int maxProfit2(int[] prices) {
        int profit = 0;
        for (int i = 1; i < prices.length; i++) {
            if (prices[i] > prices[i-1]) profit += prices[i] - prices[i-1];
        }
        return profit;
    }

    // 3. 最多两次交易（123）
    public static int maxProfit3(int[] prices) {
        int buy1 = Integer.MIN_VALUE, sell1 = 0;
        int buy2 = Integer.MIN_VALUE, sell2 = 0;
        for (int p : prices) {
            buy1 = Math.max(buy1, -p);
            sell1 = Math.max(sell1, buy1 + p);
            buy2 = Math.max(buy2, sell1 - p);
            sell2 = Math.max(sell2, buy2 + p);
        }
        return sell2;
    }

    // 4. 含冷冻期1天（309）
    public static int maxProfit4(int[] prices) {
        int n = prices.length;
        if (n <= 1) return 0;
        int hold = -prices[0], sold = 0, rest = 0;
        for (int i = 1; i < n; i++) {
            int prevSold = sold;
            sold = hold + prices[i];
            hold = Math.max(hold, rest - prices[i]);
            rest = Math.max(rest, prevSold);
        }
        return Math.max(sold, rest);
    }
}',
1, 412, 63, 20);

-- =============================================
-- 模块六：Java并发编程（面试高频）
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'volatile与原子类',
'**volatile：** 保证可见性（一个线程修改对其他线程立即可见）和禁止指令重排序，但不保证原子性。
**Atomic类：** 基于CAS（Compare-And-Swap）实现无锁线程安全操作。CAS是CPU原语，比较内存值与预期值，相同则更新。
**ABA问题：** 值从A变为B又变回A，CAS认为没变。解决方案：AtomicStampedReference加版本号。',
'java',
'import java.util.concurrent.atomic.*;

public class VolatileAndAtomic {

    // volatile 保证可见性
    private volatile boolean running = true;
    public void stop() { running = false; } // 其他线程立即可见

    // AtomicInteger 线程安全计数器
    private AtomicInteger count = new AtomicInteger(0);
    public void increment() { count.incrementAndGet(); } // CAS自旋

    // LongAdder（Java 8+）：高并发下比AtomicLong快
    private LongAdder longAdder = new LongAdder();
    public void add(long x) { longAdder.add(x); }
    public long sum() { return longAdder.sum(); }

    // AtomicReference：原子更新引用
    private AtomicReference<String> ref = new AtomicReference<>("A");
    public boolean casUpdate(String expect, String update) {
        return ref.compareAndSet(expect, update);
    }

    // ABA问题演示
    public static void abaDemo() {
        AtomicStampedReference<Integer> ref = new AtomicStampedReference<>(100, 0);
        int[] stamp = {0};
        ref.get(stamp); // stamp[0] = 0
        ref.compareAndSet(100, 200, 0, 1); // stamp变为1
        ref.compareAndSet(200, 100, 1, 2); // stamp变为2
        // 此时值虽然变回100，但stamp已变为2，可检测到变化
    }
}',
1, 356, 54, 17),

(@bot_id, 'CountDownLatch / CyclicBarrier / Semaphore',
'**CountDownLatch：** 一个或多个线程等待其他线程完成操作。计数器只能减不能加，一次性使用。
**CyclicBarrier：** 一组线程互相等待，都到达屏障后同时继续。可重复使用。
**Semaphore：** 控制同时访问特定资源的线程数，用于限流。底层基于AQS。',
'java',
'import java.util.concurrent.*;

public class SyncTools {

    // CountDownLatch：主线程等待所有子线程完成
    public static void countDownLatchDemo() throws Exception {
        int threads = 5;
        CountDownLatch latch = new CountDownLatch(threads);
        for (int i = 0; i < threads; i++) {
            new Thread(() -> {
                try { Thread.sleep((long)(Math.random() * 1000)); }
                catch (InterruptedException e) { Thread.currentThread().interrupt(); }
                System.out.println(Thread.currentThread().getName() + " 完成");
                latch.countDown();
            }).start();
        }
        latch.await(); // 主线程等待所有子线程完成
        System.out.println("全部完成");
    }

    // CyclicBarrier：所有线程到达屏障后同时继续
    public static void cyclicBarrierDemo() throws Exception {
        int parties = 3;
        CyclicBarrier barrier = new CyclicBarrier(parties,
            () -> System.out.println("所有线程已到达，开始执行"));
        for (int i = 0; i < parties; i++) {
            new Thread(() -> {
                System.out.println(Thread.currentThread().getName() + " 到达屏障");
                try { barrier.await(); } catch (Exception e) { e.printStackTrace(); }
                System.out.println(Thread.currentThread().getName() + " 继续执行");
            }).start();
        }
    }

    // Semaphore：限制并发数（如数据库连接池）
    public static void semaphoreDemo() throws Exception {
        Semaphore sem = new Semaphore(3); // 最多3个线程同时执行
        for (int i = 0; i < 10; i++) {
            new Thread(() -> {
                try {
                    sem.acquire();
                    System.out.println(Thread.currentThread().getName() + " 获取许可");
                    Thread.sleep(1000);
                } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
                finally { sem.release(); }
            }).start();
        }
    }
}',
1, 289, 43, 13);

-- =============================================
-- 模块七：Python 实用工具（日常开发）
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '文件与目录操作',
'**pathlib（Python 3.4+）：** 面向对象的文件路径操作，替代 os.path。
**shutil：** 高级文件操作（复制、移动、压缩）。
**最佳实践：** 使用 `with` 语句管理文件资源；pathlib 替代字符串拼接路径。',
'python',
'from pathlib import Path
import shutil
import json
import csv

# 1. 路径操作（pathlib推荐）
root = Path(".")
data_dir = root / "data" / "2024"
data_dir.mkdir(parents=True, exist_ok=True)

# 遍历文件
for py_file in root.rglob("*.py"):
    print(py_file.name, py_file.stat().st_size)

# 2. 文件读写
text = Path("input.txt").read_text(encoding="utf-8")
Path("output.txt").write_text(text.upper(), encoding="utf-8")

# JSON读写
data = {"users": [{"name": "张三", "age": 25}]}
Path("data.json").write_text(json.dumps(data, ensure_ascii=False, indent=2))

# CSV读写
with open("data.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["name", "age"])
    writer.writeheader()
    writer.writerow({"name": "张三", "age": 25})

# 3. 文件复制/移动/压缩
shutil.copy2("src.txt", "dst.txt")        # 复制（保留元数据）
shutil.move("old.txt", "new_dir/old.txt")  # 移动
shutil.make_archive("backup", "zip", "data")  # 压缩

# 4. 临时文件
import tempfile
with tempfile.NamedTemporaryFile(mode="w", suffix=".txt", delete=False) as f:
    f.write("临时数据")
    print(f.name)',
1, 345, 52, 16),

(@bot_id, '日志与配置管理',
'**logging：** Python 标准库日志模块，支持多处理器、格式化、级别过滤。
**configparser / tomllib：** 配置文件读取。
**最佳实践：** 生产环境用 JSON 格式日志；日志级别 DEBUG < INFO < WARNING < ERROR < CRITICAL。',
'python',
'import logging
import logging.config
import json
from datetime import datetime

# 1. 基础日志配置
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.FileHandler("app.log", encoding="utf-8"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)
logger.info("应用启动")
logger.warning("磁盘空间不足")
logger.error("数据库连接失败", exc_info=True)

# 2. JSON格式日志（适合ELK收集）
class JsonFormatter(logging.Formatter):
    def format(self, record):
        return json.dumps({
            "time": datetime.now().isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "file": f"{record.filename}:{record.lineno}"
        }, ensure_ascii=False)

handler = logging.FileHandler("app.json.log", encoding="utf-8")
handler.setFormatter(JsonFormatter())
logger.addHandler(handler)

# 3. 配置文件（YAML格式）
# pip install pyyaml
import yaml
config = yaml.safe_load(Path("config.yml").read_text())
db_host = config["database"]["host"]
db_port = config["database"].get("port", 3306)

# 4. 环境变量管理
import os
DB_URL = os.getenv("DATABASE_URL", "sqlite:///default.db")
DEBUG = os.getenv("DEBUG", "false").lower() == "true"',
1, 234, 35, 9);

-- =============================================
-- 模块八：JavaScript 前端核心
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, '闭包与this绑定',
'**闭包：** 函数可以访问其定义时的词法作用域，即使在外层函数执行完毕后。常见用途：数据私有化、柯里化、回调。
**this指向：** 默认绑定（全局）、隐式绑定（对象方法）、显式绑定（call/apply/bind）、new绑定。优先级：new > 显式 > 隐式 > 默认。
**箭头函数：** 没有自己的this，继承外层作用域的this。',
'javascript',
'// 1. 闭包实现数据私有化
function createCounter() {
    let count = 0; // 私有变量
    return {
        increment: () => ++count,
        decrement: () => --count,
        getCount: () => count
    };
}
const counter = createCounter();
console.log(counter.increment()); // 1
console.log(counter.getCount()); // 1

// 2. 闭包实现柯里化
function curry(fn) {
    return function curried(...args) {
        if (args.length >= fn.length) return fn(...args);
        return (...moreArgs) => curried(...args, ...moreArgs);
    };
}
const add = curry((a, b, c) => a + b + c);
console.log(add(1)(2)(3)); // 6
console.log(add(1, 2)(3)); // 6

// 3. 手写bind
Function.prototype.myBind = function(ctx, ...args) {
    const fn = this;
    return function(...moreArgs) {
        return fn.apply(ctx, [...args, ...moreArgs]);
    };
};

// 4. this指向经典面试题
const obj = {
    name: "obj",
    sayName: function() { console.log(this.name); },
    sayNameArrow: () => { console.log(this.name); } // this指向外层（window）
};
obj.sayName();       // "obj"
obj.sayNameArrow();  // undefined（window.name）

const say = obj.sayName;
say(); // undefined（丢失了obj绑定）',
1, 456, 68, 22),

(@bot_id, '手写call/apply/bind/new',
'**面试必考：** 手写 JavaScript 核心方法，考察对 this、原型链、闭包的理解。
**call vs apply：** call 接收参数列表，apply 接收参数数组。
**new的过程：** ①创建新对象 ②原型链连接 ③执行构造函数（this指向新对象）④返回新对象。',
'javascript',
'// 手写call
Function.prototype.myCall = function(ctx, ...args) {
    ctx = ctx ?? globalThis;
    const fn = Symbol("fn"); // 防止属性名冲突
    ctx[fn] = this;
    const result = ctx[fn](...args);
    delete ctx[fn];
    return result;
};

// 手写apply
Function.prototype.myApply = function(ctx, args = []) {
    ctx = ctx ?? globalThis;
    const fn = Symbol("fn");
    ctx[fn] = this;
    const result = ctx[fn](...args);
    delete ctx[fn];
    return result;
};

// 手写bind
Function.prototype.myBind = function(ctx, ...boundArgs) {
    const fn = this;
    return function(...callArgs) {
        return fn.apply(
            this instanceof fn ? this : ctx, // new时this指向实例
            [...boundArgs, ...callArgs]
        );
    };
};

// 手写new
function myNew(constructor, ...args) {
    const obj = Object.create(constructor.prototype); // ①②
    const result = constructor.apply(obj, args);      // ③
    return result instanceof Object ? result : obj;    // ④
}

// 测试
function Person(name) { this.name = name; }
Person.prototype.greet = function() { return `Hi, ${this.name}`; };
const p = myNew(Person, "张三");
console.log(p.greet()); // Hi, 张三',
1, 389, 58, 19);

-- =============================================
-- 模块九：Go 并发与网络
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'Go goroutine 与 channel 模式',
'**goroutine：** Go 的轻量级协程，初始栈仅 2KB，可动态扩展。创建成本远低于线程（MB级栈）。
**channel：** goroutine 之间的通信管道。遵循"不要通过共享内存来通信，而要通过通信来共享内存"。
**select：** 多路复用，同时监听多个 channel，配合 default 实现非阻塞操作。',
'go',
'package main

import (
    "fmt"
    "sync"
    "time"
)

func main() {
    // 1. 基础goroutine + WaitGroup
    var wg sync.WaitGroup
    for i := 0; i < 5; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            fmt.Printf("goroutine %d 执行中\n", id)
        }(i)
    }
    wg.Wait()

    // 2. channel 生产者消费者
    ch := make(chan int, 10)
    go func() { // 生产者
        for i := 0; i < 100; i++ { ch <- i }
        close(ch)
    }()
    for val := range ch { // 消费者
        fmt.Println(val)
    }

    // 3. select 多路复用
    ch1 := make(chan string)
    ch2 := make(chan string)
    go func() { time.Sleep(1 * time.Second); ch1 <- "one" }()
    go func() { time.Sleep(2 * time.Second); ch2 <- "two" }()
    for i := 0; i < 2; i++ {
        select {
        case msg := <-ch1: fmt.Println(msg)
        case msg := <-ch2: fmt.Println(msg)
        case <-time.After(3 * time.Second):
            fmt.Println("超时")
        }
    }

    // 4. worker pool 模式
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    for w := 0; w < 3; w++ {
        go func(id int) {
            for job := range jobs {
                results <- job * 2
            }
        }(w)
    }
    for i := 0; i < 10; i++ { jobs <- i }
    close(jobs)
    for i := 0; i < 10; i++ { fmt.Println(<-results) }
}',
1, 267, 41, 12);

-- =============================================
-- 模块十：SQL 进阶查询
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'SQL子查询与CTE实战',
'**子查询：** 嵌套在其他查询中的 SELECT 语句。相关子查询每行执行一次，性能较差。
**CTE (WITH)：** 公用表表达式，提高可读性，支持递归查询。MySQL 8.0+ 支持。
**性能建议：** 优先用 JOIN 替代子查询；CTE 在复杂查询中可读性更好。',
'sql',
'-- 1. 子查询：查找每个部门工资最高的员工
SELECT e.name, e.department, e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(salary) FROM employees WHERE department = e.department
);

-- 2. CTE：计算每月累计销售额
WITH monthly_sales AS (
    SELECT DATE_FORMAT(order_date, "%Y-%m") AS month,
           SUM(amount) AS total
    FROM orders
    GROUP BY month
)
SELECT month, total,
       SUM(total) OVER (ORDER BY month) AS cumulative
FROM monthly_sales;

-- 3. 递归CTE：组织架构树
WITH RECURSIVE org AS (
    -- 锚点：顶层领导
    SELECT id, name, manager_id, 0 AS level,
           CAST(name AS CHAR(500)) AS path
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    -- 递归：下属员工
    SELECT e.id, e.name, e.manager_id, o.level + 1,
           CONCAT(o.path, " > ", e.name)
    FROM employees e JOIN org o ON e.manager_id = o.id
    WHERE o.level < 10 -- 防止无限递归
)
SELECT REPEAT("  ", level) || name AS tree, path
FROM org ORDER BY path;

-- 4. EXISTS优化：查询有订单的客户
-- ❌ 子查询（慢）：SELECT * FROM customers WHERE id IN (SELECT customer_id FROM orders)
-- ✅ EXISTS（快）：
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);

-- 5. CASE WHEN 行转列
SELECT product_name,
       SUM(CASE WHEN quarter = "Q1" THEN amount ELSE 0 END) AS Q1,
       SUM(CASE WHEN quarter = "Q2" THEN amount ELSE 0 END) AS Q2,
       SUM(CASE WHEN quarter = "Q3" THEN amount ELSE 0 END) AS Q3,
       SUM(CASE WHEN quarter = "Q4" THEN amount ELSE 0 END) AS Q4
FROM sales
GROUP BY product_name;',
1, 389, 58, 18);

-- =============================================
-- 模块十一：Shell / Linux 运维
-- =============================================
INSERT INTO `snippet` (`user_id`, `title`, `description`, `language`, `code_content`, `visibility`, `view_count`, `like_count`, `comment_count`) VALUES

(@bot_id, 'Shell脚本自动化',
'**用途：** 日志分析、批量部署、定时任务、监控告警。
**关键语法：** 变量 `$VAR`、条件 `[[ ]]`、循环 `for/while`、管道 `|`、重定向 `>/>>`。
**最佳实践：** 脚本开头加 `set -euo pipefail`；用 `"$VAR"` 防止空值和空格问题。',
'shell',
'#!/bin/bash
set -euo pipefail  # 严格模式：出错即停、未定义变量报错、管道失败报错

# ========== 1. 日志分析 ==========
# 统计最近1小时的ERROR数量
ERROR_COUNT=$(awk -v start="$(date -d "1 hour ago" +%Y-%m-%dT%H:%M)" \
    "\$0 >= start && /ERROR/" /var/log/app.log | wc -l)
echo "最近1小时错误数: $ERROR_COUNT"

# 提取Top10慢查询
grep "slow query" /var/log/mysql/slow.log \
    | awk "{print \$NF}" | sort | uniq -c | sort -rn | head -10

# ========== 2. 批量操作 ==========
# 批量修改配置文件
for host in web{1..5}.example.com; do
    ssh "$host" "sudo sed -i \\"s/old-value/new-value/g\\" /etc/app/config.yml" &
done
wait  # 等待所有SSH完成
echo "所有服务器配置已更新"

# ========== 3. 监控脚本 ==========
check_disk() {
    local usage=$(df / | awk "NR==2 {print \$5}" | tr -d "%")
    if [ "$usage" -gt 80 ]; then
        echo "ALERT: 磁盘使用率 ${usage}%"
        # 可以发送邮件或钉钉通知
    fi
}
check_disk

# ========== 4. 定时任务 ==========
# crontab -e 添加：
# 0 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
# */5 * * * * /opt/scripts/monitor.sh
# 0 3 * * 0 find /tmp -mtime +7 -delete',
1, 234, 35, 9);

-- =============================================
-- 更新标签关联
-- =============================================
INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = 'Java' AND s.user_id = @bot_id
AND s.id NOT IN (SELECT snippet_id FROM snippet_tag);

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = '算法'
AND (s.title LIKE '%排序%' OR s.title LIKE '%查找%' OR s.title LIKE '%递归%' OR s.title LIKE '%动态%' OR s.title LIKE '%股票%')
AND s.user_id = @bot_id AND s.id NOT IN (SELECT snippet_id FROM snippet_tag WHERE tag_id = t.id);

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'java' AND t.name = '数据结构'
AND (s.title LIKE '%链表%' OR s.title LIKE '%栈%' OR s.title LIKE '%队列%')
AND s.user_id = @bot_id AND s.id NOT IN (SELECT snippet_id FROM snippet_tag WHERE tag_id = t.id);

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'python' AND t.name = 'Python'
AND s.user_id = @bot_id AND s.id NOT IN (SELECT snippet_id FROM snippet_tag WHERE tag_id = t.id);

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'javascript' AND t.name = 'JavaScript'
AND s.user_id = @bot_id AND s.id NOT IN (SELECT snippet_id FROM snippet_tag WHERE tag_id = t.id);

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'go' AND t.name = 'Go'
AND s.user_id = @bot_id AND s.id NOT IN (SELECT snippet_id FROM snippet_tag WHERE tag_id = t.id);

INSERT IGNORE INTO `snippet_tag` (`snippet_id`, `tag_id`)
SELECT s.id, t.id FROM snippet s, tag t
WHERE s.language = 'sql' AND t.name = '数据库'
AND s.user_id = @bot_id AND s.id NOT IN (SELECT snippet_id FROM snippet_tag WHERE tag_id = t.id);

-- 更新标签计数
UPDATE tag SET snippet_count = (SELECT COUNT(*) FROM snippet_tag WHERE tag_id = tag.id);

-- 结果统计
SELECT language, COUNT(*) AS count FROM snippet WHERE user_id = @bot_id GROUP BY language ORDER BY count DESC;
SELECT CONCAT('总计 ', COUNT(*), ' 个代码片段') AS result FROM snippet;
