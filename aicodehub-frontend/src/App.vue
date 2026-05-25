<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup>
// App.vue是根组件，只负责渲染当前路由对应的页面
// 所有页面布局都在各自的页面组件中处理
</script>

<style>
#app {
  min-height: 100vh;
  background-color: #f5f7fa;
}
</style>
