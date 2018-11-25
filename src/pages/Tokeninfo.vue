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
        v-model="userToken"
        label="보유중인 토큰"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>해당 유저가 보유중인 토큰</span>
        </v-tooltip>
      </v-text-field>
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

      <div class="title">
        <h2>토큰전송</h2>
      </div>

      <v-text-field
        v-model="transferTo"
        label="transferTo"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>토큰 받는 계정주소</span>
        </v-tooltip>
      </v-text-field>
      <v-text-field
        v-model="transferValue"
        label="transferValue"
        required
      >
        <v-tooltip slot="append" bottom>
          <v-icon slot="activator" color="#b3d4fc">help</v-icon>
          <span>토큰전송량</span>
        </v-tooltip>
      </v-text-field>
      <v-btn @click="transfer()">transfer</v-btn>
      <v-btn @click="test()">test</v-btn>
    </div>
    <v-content class="app">
      <div class="text-xs-center">
        <v-dialog
          v-model="contractDialogNoti"
          width="500"
        >
          <v-card>
            <v-card-title
              primary-title
              class="headline red"
            >
              {{ dialogStatus }}
            </v-card-title>

            <v-card-text>
              {{ dialogMsg }}
            </v-card-text>
            <v-divider/>
            <v-card-actions>
              <v-spacer/>
              <v-btn
                color="primary"
                flat
                @click="confirm()"
              >
                I Confirm
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
      <!-- <router-view/> -->
    </v-content>
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
      userToken: '', // 해당 유저가 보유중인 토큰
      decimal: '',
      tokenName: '',
      symbol: '',
      totalSupply: '',
      abi: tokenAbi(),
      transferValue: 0, // 토큰 전송량
      transferTo: '0x', // 토큰 받는 계정주소
      dialogStatus: '',
      dialogMsg: '',
      contractDialogNoti: false
    }
  },
  methods: {
    getInfo () {
      if (this.tokenContractAddress.length !== 42) {
        this.dialogStatus = 'Error'
        this.contractDialogNoti = true
        this.dialogMsg = '토큰 컨트랙트 주소 확인필요'
        return 0
      }
      let web3 = new Web3(window.web3.currentProvider)
      web3.eth.defaultAccount = web3.eth.accounts[0]

      let CoursesContract = web3.eth.contract(this.abi)
      let Courses = CoursesContract.at(this.tokenContractAddress)
      let self = this
      Courses.name(function (_, tokenName) {
        self.tokenName = tokenName
      })
      Courses.decimals(function (_, decimal) {
        self.decimal = decimal
        const calcDecimal = 10 ** decimal
        Courses.balanceOf(web3.eth.defaultAccount, function (_, userToken) {
          self.userToken = userToken / calcDecimal
        })
        Courses.totalSupply(function (_, totalSupply) {
          self.totalSupply = totalSupply / calcDecimal
        })
      })
      Courses.symbol(function (error, symbol) {
        console.log(error)
        self.symbol = symbol
      })
    },
    transfer () {
      console.log(this.transferTo.length)
      if (this.transferTo.length !== 42) {
        this.dialogStatus = 'Error'
        this.contractDialogNoti = true
        this.dialogMsg = '토큰 받는 계정정보 확인필요'
        return 0
      }
      if (!this.transferValue) {
        this.dialogStatus = 'Error'
        this.contractDialogNoti = true
        this.dialogMsg = '토큰전송량 확인필요'
        return 0
      }
      let web3 = new Web3(window.web3.currentProvider)
      web3.eth.defaultAccount = web3.eth.accounts[0]

      let CoursesContract = web3.eth.contract(this.abi)
      let Courses = CoursesContract.at(this.tokenContractAddress)

      let self = this
      console.log(this.transferTo)
      console.log(this.transferValue)

      Courses.decimals(function (_, decimal) {
        console.log(decimal)
        Courses.transfer(self.transferTo, self.transferValue * (10 ** decimal), function (err, data) {
          console.log(err)
          console.log(data)
        })
      })
    },
    confirm () {
      this.contractDialogNoti = false
    },
    test () {
      let web3 = new Web3(window.web3.currentProvider)
      web3.eth.getCode(this.tokenContractAddress, function (_, data) {
        console.log(data)
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
  margin: 20px 0 20px 0;
}
h2 {
  color: rgb(125, 125, 125);
}
</style>
