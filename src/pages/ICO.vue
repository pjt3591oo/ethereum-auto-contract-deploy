<template>
  <div class="content">
    <v-text-field
      v-model="beneficiary"
      label="beneficiary"
      required
    />
    <v-text-field
      v-model="tokenAddress"
      label="tokenAddress"
      required
    />
    <v-text-field
      v-model="owner"
      label="owner"
      required
    />

    <v-btn>deploy</v-btn>
  </div>
</template>

<script>
export default {
  name: 'Ico',
  data () {
    return {
      beneficiary: '',
      tokenAddress: '',
      owner: ''
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
