<template>
  <div class="home-page">
    <h1>{{ msg }}</h1>

    <div class="hot-key">
      <div>
        <h2>
          <router-link to="/deploy">Token 배포하러 가기</router-link>
        </h2>
      </div>
      <div>
        <h2>
          <router-link to="/tokeninfo">Token 관리하러 가기</router-link>
        </h2>
      </div>
    </div>
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
a {
  text-decoration: none;
}

.hot-key {
  margin-top: 50px;
}
.hot-key a{
  margin-top: 20px;
  color: hotpink;
}
</style>
