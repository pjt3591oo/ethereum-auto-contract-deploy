<template>
  <div class="content">

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
    </div>

    <v-layout row wrap>
      <v-flex xs12>
        <v-textarea
          v-model="tokenCode"
          outline
          name="input-7-4"
          label="tokenCode"
        />
      </v-flex>
      <v-flex xs12>
        <v-textarea
          v-model="abi"
          outline
          name="input-7-4"
          label="Application Binary Interface"
        />
      </v-flex>
      <v-flex xs12>
        <v-textarea
          v-model="byteCode"
          outline
          name="input-7-4"
          label="byteCode"
        />
      </v-flex>
    </v-layout>

  </div>
</template>

<script>
export default {
  name: 'HomePage',
  data () {
    return {
      decimal: 1,
      tokenName: '1',
      symbol: '2',
      totalSupply: 123,
      tokenCode: '',
      abi: '',
      byteCode: ''
    }
  },
  created () {
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
        source = this.solc.compile(this.tokenCode, 1)
      } catch (err) {
        console.log(err)
      }
      let bytecode = source.contracts[':ERC20TokenComplete'].bytecode
      let abi = source.contracts[':ERC20TokenComplete'].interface
      this.byteCode = bytecode
      this.abi = abi
    },
    async deploy () {
      this.makeCode()
      await this.compile()

      console.log(this.byteCode)
      console.log(this.abi)
    },
    makeCode () {
      this.tokenCode = `pragma solidity ^0.4.24; contract ERC20TokenComplete {string public constant name ="${this.tokenName}";string public constant symbol = "${parseInt(this.symbol)}";uint8 public constant decimals = ${parseInt(this.decimal)};uint256 public totalSupply = ${this.totalSupply};mapping(address => uint256) public balanceOf;event Transfer(address indexed from, address indexed to, uint256 value);event Burn(address indexed from, uint256 value);address owner;modifier onlyOwner() {require(msg.sender == owner);_;}constructor (uint256 _totalSupply) public {owner = msg.sender;totalSupply = _totalSupply * 10 ** uint256(${parseInt(this.decimal)});balanceOf[msg.sender] = totalSupply;emit Transfer(address(this), msg.sender, totalSupply);assert(true);}function transfer(address to, uint amount) public returns(bool) {require(balanceOf[msg.sender] >= amount);balanceOf[msg.sender] -= amount;balanceOf[to] += amount;emit Transfer(msg.sender, to, amount);}function burn(uint amount) onlyOwner public {require(totalSupply >= amount);balanceOf[msg.sender] -= amount;totalSupply -= amount;emit Burn(msg.sender, amount);}function addPublish(uint amount) onlyOwner public{totalSupply += amount * 10 ** uint(${parseInt(this.decimal)});balanceOf[msg.sender] += amount * 10 ** uint(${parseInt(this.decimal)});}}`
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
.deploy-info {
  width: 100%;
}
.abi {
  background-color: #fff;
  margin-top: 50px;
  width: 100%;
}
</style>
