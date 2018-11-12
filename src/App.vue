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
      <v-select v-bind:items="networks" v-model="network" />
    </v-toolbar>

    <v-content class="app">
      <router-view/>
    </v-content>

    <v-navigation-drawer
      :mini-variant="mini"
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
export default {
  name: 'App',
  created: () => {

  },
  data () {
    return {
      drawer: false,
      networks: [
        'https://mainnet.infura.io',
        'https://ropsten.infura.i'
      ],
      network: ''
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
