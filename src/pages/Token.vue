<template>
  <div class="content" @click="c()">

    <div class="deploy-info">
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
          outline
          rows="45"
          name="input-7-4"
          disabled="'true'"
        />
      </v-flex>

      <div class="code-title">
        <h2>Application Binary Interface</h2>
        <h2 class="copy" @click="abiCopy()">(복사)</h2>
      </div>
      <v-flex xs12 class="abi-section">
        <vue-json-pretty
          :data="abi"
          :show-length="'true'"
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
          outline
          name="input-7-4"
          disabled="'true'"
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
              v-show="dialogStatus === 'Warring'"
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
  name: 'HomePage',
  components: {
    VueJsonPretty
  },
  data () {
    return {
      contractDialogNoti: false,
      dialogMsg: '',
      decimal: 18,
      tokenName: 'ParkJeongTae',
      symbol: 'pjt',
      totalSupply: 10000000,
      tokenCode: '',
      abi: '',
      byteCode: '',
      dialogStatus: '',
      dialogClass: ''
    }
  },
  watch: {
    decimal: function (d) {
      this.makeOnlineCode()
    },
    tokenName: function (n) {
      this.makeOnlineCode()
    },
    symbol: function (s) {
      this.makeOnlineCode()
    }
  },
  created () {
    this.makeOnlineCode()
  },
  methods: {
    async compile () {
      let bs = () => {
        return new Promise((resolve, reject) => {
          window.BrowserSolc.loadVersion('soljson-v0.4.24+commit.e67f0147.js', (compiler) => {
            resolve(compiler)
          })
        })
      }
      if (!this.solc) {
        this.solc = await bs()
      }
      let source = ''
      try {
        source = this.solc.compile(this.tokenCode.replace(/\n/g, '').replace(/\t/g, ''), 1)
      } catch (err) {
      }
      let bytecode = source.contracts[':ERC20Token'].bytecode
      let abi = source.contracts[':ERC20Token'].interface
      this.byteCode = bytecode
      this.abi = JSON.parse(abi)
    },
    async deploy () {
      let web3 = new Web3(window.web3.currentProvider)

      console.log(web3.eth.accounts)

      if (!web3.eth.accounts.length) {
        this.contractDialogNoti = true
        this.dialogMsg = 'metamask 로그인이 되어있지 않습니다.'
        this.dialogStatus = 'Warring'
        return 0
      }

      this.makeOnlineCode()
      await this.compile()

      let Contract = web3.eth.contract(this.abi)

      Contract.new(this.totalSupply, {
        data: `0x${this.byteCode}`,
        arguments: [this.totalSupply],
        from: web3.eth.accounts[0],
        gasPrice: 21 * (10 ** 9)
      }, (err, ca) => {
        if (err) {
          this.contractDialogNoti = true
          this.dialogMsg = `Token 발행중 문제발생 \n ${err}`
          this.dialogStatus = 'Warring'
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
      this.$copyText('ttttt')
      // let web3 = new Web3(window.web3.currentProvider)
      // window.open('https://ropsten.etherscan.io/token/0x2bc48a9cd3ced66450a74c0cc03bacaabc98d5ad', '_blank')
    },
    codeCopy () {
      this.$copyText(this.tokenCode)
      this.contractDialogNoti = true
      this.dialogMsg = `token code 복사가 완료되었습니다.`
      this.dialogStatus = 'Success'
    },
    abiCopy () {
      this.$copyText(this.abi)
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
    makeOnlineCode () {
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
  color: rgb(0, 255, 64);
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
