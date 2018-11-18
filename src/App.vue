<template>
  <v-app dark>
    <v-toolbar class="hsla">
      <v-toolbar-title>
        <router-link to="/">AutoDeploy</router-link>
      </v-toolbar-title>
      <v-toolbar-items clipped-left>
        <v-btn dark>
          <router-link to="/token">tokenDeploy</router-link>
        </v-btn>
        <v-btn dark>
          <router-link to="/ico">icoDeploy</router-link>
        </v-btn>
      </v-toolbar-items>
      <v-spacer />
      <div>
        <h4>Network: <v-icon :color="isNetworkConnected">check_circle_outline</v-icon> </h4>
        <h4>Login: <v-icon :color="islogined">check_circle_outline</v-icon> </h4>
      </div>
    </v-toolbar>

    <v-content class="app">
      <div class="text-xs-center">
        <v-dialog
          v-model="dialog"
          width="500"
        >
          <v-card>
            <v-card-title
              class="headline red lighten-2"
              primary-title
            >
              Waring!!
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
                @click="networkCheck()"
              >
                I Confirm
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
      <router-view/>
    </v-content>

    <v-navigation-drawer
      v-model="drawer"
      temporary
      dark
      absolute
    >
      <v-toolbar flat class="transparent">
        <v-list class="pa-0">
          <v-list-tile avatar>
            <v-list-tile-avatar>
              <img src="https://randomuser.me/api/portraits/men/85.jpg">
            </v-list-tile-avatar>
            <v-list-tile-content>
              <v-list-tile-title>John Leider</v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
      </v-toolbar>
      <v-list class="pt-0" dense>
        <v-divider />
        <v-list-tile>
          <v-list-tile-action>
            <v-icon />
          </v-list-tile-action>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
  </v-app>
</template>

<script>
import Web3 from 'web3'

export default {
  name: 'App',
  data () {
    return {
      drawer: false,
      dialog: false,
      dialogMsg: '',
      isNetworkConnected: 'red',
      islogined: 'red',
      web3: ''
    }
  },
  created () {
    this.networkCheck()
  },
  methods: {
    networkCheck () {
      if (typeof window.web3 === 'undefined') {
        this.dialog = true
        this.isNetworkConnected = 'red'
        this.dialogMsg = 'You need to connecting metamask! Metamask 설치 후 다시접속하세요.'
      } else {
        this.dialog = false
        this.isNetworkConnected = 'green'
        this.web3 = new Web3(window.web3.currentProvider)
        this.loginCheck()
      }
    },
    loginCheck () {
      if (!this.web3.eth.accounts.length) {
        this.dialog = true
        this.islogined = 'red'
        this.dialogMsg = 'You need to login metamask! Metamask 로그인 후 다시접속하세요.'
      } else {
        this.dialog = false
        this.islogined = 'green'
      }
    }
  }
}
</script>

<style lang="scss" src="./styles/app.scss"></style>

<style scoped>
.app {
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  display: block;
  margin: 50px;
}
.deploy{
  display: block;
}

a{
  color: white;
  text-decoration: none;
}
</style>
