<template>
  <div class="content">
    <v-text-field
      v-model="decimal"
      :rules="nameRules"
      label="decimal"
      required
    />
    <v-text-field
      v-model="tokenName"
      :rules="nameRules"
      label="tokenName"
      required
    />
    <v-text-field
      v-model="symbol"
      :rules="nameRules"
      label="symbol"
      required
    />
    <v-text-field
      v-model="totalSupply"
      :rules="nameRules"
      label="totalSupply"
      required
    />

    <v-btn>deploy</v-btn>
  </div>
</template>

<script>
export default {
  name: 'HomePage',
  data () {
    return {
      decimal: '',
      tokenName: '',
      symbol: '',
      totalSupply: 0
    }
  }
}
</script>

<style lang="scss" scoped>
h1 {
  font-weight: normal;
  color: $c-primary;
}
.content {
  max-width: 600px;
  margin: auto;
}
</style>
