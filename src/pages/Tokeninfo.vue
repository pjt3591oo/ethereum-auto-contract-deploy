<template>
  <div class="content">
    <div class="token-info">
      <v-text-field
        v-model="tokenContractAddress"
        label="tokenContractAddress"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>배포된 토큰 주소</span>
        </v-tooltip>
      </v-text-field>

      <v-btn @click="getInfo()">getInfo</v-btn>

      <div class="title">
        <h2>토큰정보</h2>
      </div>

      <v-text-field
        v-model="decimal"
        label="decimal"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>최대 소수점 허용자릿수 (ethereum의 경우 decimal=18)</span>
        </v-tooltip>
      </v-text-field>
      <v-text-field
        v-model="tokenName"
        label="tokenName"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>배포하는 토큰이름</span>
        </v-tooltip>
      </v-text-field>

      <v-text-field
        v-model="symbol"
        label="symbol"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>토큰 상징이름 (예, 비트코인: BTC, 이더리움: ETH)</span>
        </v-tooltip>
      </v-text-field>

      <v-text-field
        v-model="totalSupply"
        label="totalSupply"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>토큰전체 발행량</span>
        </v-tooltip>
      </v-text-field>
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import tokenAbi from '../utils/abis/token'

export default {
  name: 'Tokeninfo',
  data () {
    return {
      tokenContractAddress: '0xf825da5d575cc635a1cbcc54d2b3edd9d882b6d1',
      decimal: '',
      tokenName: '',
      symbol: '',
      totalSupply: '',
      abi: tokenAbi()
    }
  },
  methods: {
    getInfo () {
      let web3 = new Web3(window.web3.currentProvider)
      web3.eth.defaultAccount = web3.eth.accounts[0]

      let CoursesContract = web3.eth.contract(this.abi)
      let Courses = CoursesContract.at(this.tokenContractAddress)
      let self = this

      Courses.name(function (error, tokenName) {
        console.log(error)
        self.tokenName = tokenName
      })
      Courses.decimals(function (error, decimal) {
        console.log(error)
        self.decimal = decimal
      })
      Courses.symbol(function (error, symbol) {
        console.log(error)
        self.symbol = symbol
      })
      Courses.totalSupply(function (error, totalSupply) {
        console.log(error)
        self.totalSupply = totalSupply
      })
    }
  }
}
</script>

<style scoped>
.content {
  max-width: 600px;
  margin: auto;
}
.deploy-info {
  width: 100%;
}
.title {
  text-align: left;
}
h2 {
  color: rgb(125, 125, 125);
}
</style>
