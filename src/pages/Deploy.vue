<template>
  <div class="content">
    <div class="deploy-info">
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

      <v-btn @click="deploy()">deploy</v-btn>
      <v-btn @click="test()">test</v-btn>
    </div>

    <hr>

    <v-layout row wrap>
      <div class="code-title">
        <h2>token code</h2>
        <h2 class="copy" @click="codeCopy()">(복사)</h2>
      </div>
      <v-flex xs12>
        <v-textarea
          v-model="tokenCode"
          :disabled="true"
          outline
          rows="45"
          name="input-7-4"
        />
      </v-flex>

      <div class="code-title">
        <h2>Application Binary Interface</h2>
        <h2 class="copy" @click="abiCopy()">(복사)</h2>
      </div>
      <v-flex xs12 class="abi-section">
        <vue-json-pretty
          :data="abi"
          :show-length="true"
          class="abi"
        />
      </v-flex>
      <div class="code-title">
        <h2>Byte Code</h2>
        <h2 class="copy" @click="bytecodeCopy()">(복사)</h2>
      </div>
      <v-flex xs12>
        <v-textarea
          v-model="byteCode"
          :disabled="true"
          outline
          name="input-7-4"
        />
      </v-flex>
    </v-layout>

    <v-content class="app">
      <div class="text-xs-center">
        <v-dialog
          v-model="contractDialogNoti"
          width="500"
        >
          <v-card>
            <v-card-title
              v-show="dialogStatus === 'Waring'"
              primary-title
              class="headline red lighten-2"
            >
              {{ dialogStatus }}
            </v-card-title>
            <v-card-title
              v-show="dialogStatus === 'Success'"
              primary-title
              class="headline green lighten-2"
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
                @click="test()"
              >
                I Confirm
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
      <router-view/>
    </v-content>
  </div>
</template>

<script>
import Web3 from 'web3'
import VueJsonPretty from 'vue-json-pretty'
import TokenCode from '../utils/contracts/token'

export default {
  name: 'Deploy',
  components: {
    VueJsonPretty
  },
  data () {
    return {
      contractDialogNoti: false,
      browsersolc: '',
      dialogMsg: '',
      decimal: 18,
      tokenName: 'ParkJeongTae',
      symbol: 'pjt',
      totalSupply: 10000000,
      tokenCode: '',
      abi: '',
      byteCode: ' ',
      dialogStatus: '',
      dialogClass: ''
    }
  },
  watch: {
    decimal: function (d) {
      this.makeCode()
    },
    tokenName: function (n) {
      this.makeCode()
    },
    symbol: function (s) {
      this.makeCode()
    }
  },
  created () {
    this.makeCode()
    console.log(window.BrowserSolc)
    window.BrowserSolc.loadVersion('soljson-v0.4.24+commit.e67f0147.js', (compiler) => {
      this.browsersolc = compiler
      this.contractDialogNoti = true
      this.dialogMsg = 'solidity compiler 로드완료'
      this.dialogStatus = 'Success'
    })
  },
  methods: {
    async compile () {
      if (!this.browsersolc) {
        this.contractDialogNoti = true
        this.dialogMsg = '아직 solidity compiler가 로드되지 않았습니다. 로드될때까지 잠시만 기다려 주세요.'
        this.dialogStatus = 'Waring'

        window.BrowserSolc.loadVersion('soljson-v0.4.24+commit.e67f0147.js', (compiler) => {
          this.browsersolc = compiler
          this.contractDialogNoti = true
          this.dialogMsg = 'solidity compiler 로드완료'
          this.dialogStatus = 'Success'
        })
        return
      }

      let source = ''

      try {
        source = this.browsersolc.compile(this.tokenCode.replace(/\n/g, '').replace(/\t/g, ''))
      } catch (err) {
        console.log(`Token Compile 중 문제발생 \n ${err}`)
        this.contractDialogNoti = true
        this.dialogMsg = `Token Compile 중 문제발생 \n ${err}`
        this.dialogStatus = 'Waring'
      }
      let bytecode = source.contracts[':ERC20Token'].bytecode
      let abi = source.contracts[':ERC20Token'].interface
      this.byteCode = bytecode
      this.abi = JSON.parse(abi)
    },
    async deploy () {
      let paramMsg = this.isParamsBlack()
      if (paramMsg) {
        this.contractDialogNoti = true
        this.dialogMsg = `${paramMsg}`
        this.dialogStatus = 'Waring'
        return 0
      }
      let web3 = new Web3(window.web3.currentProvider)

      console.log(web3.eth.accounts)

      if (!web3.eth.accounts.length) {
        this.contractDialogNoti = true
        this.dialogMsg = 'metamask 로그인이 되어있지 않습니다.\n 만약 로그인이 되어있다면 다시 접속해주세요.'
        this.dialogStatus = 'Waring'
        return 0
      }

      this.makeCode()
      await this.compile()

      const Contract = web3.eth.contract(this.abi)

      const pasPrice = 21
      const GWei = 9

      Contract.new(this.totalSupply, {
        data: `0x${this.byteCode}`,
        arguments: [this.totalSupply],
        from: web3.eth.accounts[0],
        gasPrice: pasPrice * (10 ** GWei)
      }, (err, ca) => {
        console.log(ca)
        if (err) {
          console.log(`Token 발행중 문제발생 \n ${err}`)
          this.contractDialogNoti = true
          this.dialogMsg = `Token 발행중 문제발생 \n ${err}`
          this.dialogStatus = 'Waring'
        }
        if (ca.address) {
          this.contractDialogNoti = true
          this.dialogMsg = `Token 발행이 완료되었습니다.\n Token Address는 ${ca.address} 입니다.`
          this.dialogStatus = 'Success'
          window.open(`https://ropsten.etherscan.io/token/${ca.address}`, '_blank')
        }
      })
    },
    test () {
      console.log(this.browsersolc)
      // let web3 = new Web3(window.web3.currentProvider)
      // window.open('https://ropsten.etherscan.io/token/0x2bc48a9cd3ced66450a74c0cc03bacaabc98d5ad', '_blank')
    },
    isParamsBlack () {
      let msg = ''
      if (!this.decimal) {
        msg = 'decimal이 비었습니다'
      }
      if (!this.tokenName) {
        msg = 'tokenName이 비었습니다'
      }
      if (!this.symbol) {
        msg = 'symbol이 비었습니다'
      }
      if (!this.totalSupply) {
        msg = 'totalSupply이 비었습니다'
      }

      return msg
    },
    codeCopy () {
      this.$copyText(this.tokenCode)
      this.contractDialogNoti = true
      this.dialogMsg = `token code 복사가 완료되었습니다.`
      this.dialogStatus = 'Success'
    },
    abiCopy () {
      this.$copyText(JSON.stringify(this.abi))
      this.contractDialogNoti = true
      this.dialogMsg = `Application Binary Interface 복사가 완료되었습니다.`
      this.dialogStatus = 'Success'
    },
    bytecodeCopy () {
      this.$copyText(this.byteCode)
      this.contractDialogNoti = true
      this.dialogMsg = `bytecode 복사가 완료되었습니다.`
      this.dialogStatus = 'Success'
    },
    makeCode () {
      this.tokenCode = TokenCode({ decimal: this.decimal, tokenName: this.tokenName, symbol: this.symbol })
    }
  }
}
</script>

<style lang="scss" scoped>
.app {
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  display: block;
  margin: 50px;
}
h1 {
  font-weight: normal;
  color: $c-primary;
}
h2 {
  color: rgb(125, 125, 125);
  font-weight: bold;
}
.code-title {
  text-align: left;
  width: 100%;
}
.code-title h2{
  width: auto;
  display: inline-block;
}
.code-title h2.copy {
  cursor: pointer;
}
hr {
  opacity: 0;
  margin: 20px 0 20px 0;
}
.content {
  max-width: 600px;
  margin: auto;
}
.deploy-info {
  width: 100%;
}
.abi-section{
  background-color: #1c1c1c;
  border: 2px solid hsla(0,0%,100%,.7);
  margin-bottom: 20px;
}
.abi {
  background-color: #fff;
  width: 100%;
  text-align: left;
}
</style>
