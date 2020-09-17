import VueRouter from 'vue-router'

import HomeContainer from './components/tabbar/Home.vue'
import UserContainer from './components/tabbar/User.vue'
import LoginContainer from './components/user/Login.vue'
import RegisterContainer from './components/user/Register.vue'
import RecordContainer from './components/user/Record.vue'
import IncomeContainer from './components/user/Income.vue'
// import LoadmoreContainer from './components/user/Loadmore.vue'
import ForwardContainer from './components/user/Forward.vue'
import GameInfoContainer from './components/game/GameInfo.vue'
// 3. 创建路由对象
var router = new VueRouter({
  routes: [{
      path: '/',
      redirect: '/home'
    },
    {
      path: "/home",
      component: HomeContainer
    },
    {
      path: "/user",
      component: UserContainer
    },
    {
      path: "/user/record",
      component: RecordContainer
    },
    {
      path: "/user/income",
      component: IncomeContainer
    },
    
    {
      path: "/user/login",
      component: LoginContainer
    },
    {
      path: "/user/register",
      component: RegisterContainer
    },
    {
      path: "/user/forward",
      component: ForwardContainer
    },
    {
      path: "/game/gameinfo/:id",
      component: GameInfoContainer
    },

  ],
  linkActiveClass: 'mui-active'
})

// 把路由对象暴露出去
export default router