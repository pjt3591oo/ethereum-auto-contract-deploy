import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import Vuetify from 'vuetify'
import VueClipboard from 'vue-clipboard2'
import 'vuetify/dist/vuetify.min.css'

VueClipboard.config.autoSetContainer = true // add this line
Vue.use(VueClipboard)
Vue.use(Vuetify, {
  iconfont: 'mdi'
})

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
