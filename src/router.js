import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/pages/Home'
import Token from '@/pages/Token'
import Ico from '@/pages/Ico'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/token',
      name: 'Token',
      component: Token
    },
    {
      path: '/ico',
      name: 'Ico',
      component: Ico
    }
  ]
})
