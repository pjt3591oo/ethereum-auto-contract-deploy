import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/pages/Home'
import Deploy from '@/pages/Deploy'
import Tokeninfo from '@/pages/Tokeninfo'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/deploy',
      name: 'Deploy',
      component: Deploy
    },
    {
      path: '/tokeninfo',
      name: 'Tokeninfo',
      component: Tokeninfo
    }
  ]
})
