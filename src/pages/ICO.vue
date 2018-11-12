<template>
  <div class="content">
    <v-text-field
      v-model="beneficiary"
      :rules="nameRules"
      label="beneficiary"
      required
    />
    <v-text-field
      v-model="tokenAddress"
      :rules="nameRules"
      label="tokenAddress"
      required
    />
    <v-text-field
      v-model="owner"
      :rules="nameRules"
      label="owner"
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
      beneficiary: '',
      tokenAddress: '',
      owner: '',
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
