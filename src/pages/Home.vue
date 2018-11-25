<template>
  <div class="home-page">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
export default {
  name: 'HomePage',
  data () {
    return {
      msg: 'Token Management System'
    }
  }
}
</script>

<style lang="scss" scoped>
h1 {
  font-weight: normal;
  color: $c-primary;
}
</style>
