webpackJsonp([1],{"5OHe":function(e,t){},"8No1":function(e,t){},Cjpx:function(e,t){},FLRd:function(e,t){},NHnr:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var i=n("MVMM"),a={render:function(){var e=this.$createElement,t=this._self._c||e;return t("div",{attrs:{id:"app"}},[t("router-view",{key:this.$route.fullPath})],1)},staticRenderFns:[]};var s=n("Z0/y")({name:"App"},a,!1,function(e){n("SDzh")},null,null).exports,o=n("zO6J"),r={name:"HelloWorld",data:function(){return{msg:"Welcome to Your Vue.js App"}},methods:{funcMerge:function(){for(var e in arguments)arguments[e]&&arguments[e].call(null)},t2:function(){console.log("t2")},t1:function(){console.log("t1")},test:function(){this.funcMerge(this.t1,this.t2)}}},l={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"hello"},[n("h1",[e._v(e._s(e.msg))]),e._v(" "),n("h2",[e._v("Essential Links")]),e._v(" "),n("button",{on:{click:e.test}},[e._v("测试")])])},staticRenderFns:[]};n("Z0/y")(r,l,!1,function(e){n("TCnL")},"data-v-4e9e094c",null).exports;var c=n("wSez"),u=n.n(c),d={name:"Selection",data:function(){return{chapters:[],text:"",STATES:{UNLOCK:1,LOCK:2,DONE:3},OPEN_STATES:{UNOPEN:0,OPEN:1}}},created:function(){console.log(this.$router),this.requestChapter()},methods:{requestChapter:function(e){this.text="白雪公主的童话作者是",this.chapters=[{id:3,st:"白雪公主短文四",state:3,aud:"test.mp3",owner:"龙哥",ownerId:"",open:1},{id:2,st:"白雪公主短文二",state:2,owner:"龙哥",ownerId:"1",open:1},{id:1,st:"白雪公主短文一",state:1,open:1},{id:3,st:"白雪公主短文四",state:1,aud:"",owner:"龙哥",ownerId:"",open:0}]},enterChapter:function(e){var t=this,n=e.state;if(e.open){var i=this.STATES;switch(n){case i.UNLOCK:c.MessageBox.confirm("确定领取？","领取章节").then(function(e){t.requestUnlockChapter(function(e){})});break;case i.LOCK:c.MessageBox.alert(sprintf("章节已经被%s同学领取<br>10分钟后再来看看吧",e.owner));break;case i.DONE:}}else Object(c.Toast)({message:"章节还没打开，请先完成之前章节",position:"bottom",duration:1e3})},requestUnlockChapter:function(e){},back:function(){},playAudio:function(e){if(e.aud){e.aud;Object(c.Toast)({message:"播放音频",position:"bottom",duration:1e3})}}}},p={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",[n("div",{staticClass:"desc-box"},[e._v(e._s(e.text))]),e._v(" "),e._m(0),e._v(" "),n("ul",e._l(e.chapters,function(t,i){return n("li",{on:{click:function(n){e.enterChapter(t)}}},[t.state==e.STATES.UNLOCK?[t.open==e.OPEN_STATES.OPEN?[n("div",{staticClass:"unlock open"},[n("p",[e._v("等待领取")]),e._v(" "),n("p",[e._v("第"+e._s(i+1)+"节")])])]:e._e(),e._v(" "),t.open==e.OPEN_STATES.UNOPEN?[n("div",{staticClass:"unlock unopen"},[n("p",[e._v("未开启")]),e._v(" "),n("p",[e._v("第"+e._s(i+1)+"节")])])]:e._e()]:t.state==e.STATES.LOCK?[n("div",{staticClass:"lock"},[n("p",[e._v("已领取")]),e._v(" "),n("p",[e._v("第"+e._s(i+1)+"节")]),e._v(" "),n("p",[e._v(e._s(t.owner))])])]:t.state==e.STATES.DONE?[n("div",{staticClass:"done"},[n("p",[e._v("已完成")]),e._v(" "),n("p",[e._v("第"+e._s(i+1)+"节")]),e._v(" "),n("p",[e._v(e._s(t.owner))]),e._v(" "),t.aud?n("p",{on:{click:function(n){e.playAudio(t)}}},[e._v("播放")]):e._e()])]:e._e()],2)}))])},staticRenderFns:[function(){var e=this.$createElement,t=this._self._c||e;return t("div",{},[t("b",[this._v("开启共读之旅")])])}]};var h=n("Z0/y")(d,p,!1,function(e){n("THJF")},"data-v-2b70e046",null).exports,v={render:function(){var e=this,t=e.$createElement;return(e._self._c||t)("div",{staticClass:"player",class:{play:e.current==e.STATES.PLAY,stop:e.current==e.STATES.STOP,pause:e.current==e.STATES.PAUSE,loading:e.current==e.STATES.LOADING,loaded:e.current==e.STATES.LOADED},on:{click:e.click}})},staticRenderFns:[]};var f=n("Z0/y")({name:"PlayerButton",data:function(){return{STATES:{PLAY:1,STOP:2,PAUSE:3,LOADING:4,LOADED:5},current:null,path:"static/test.mp3",duration:0,EVENTS:{STATE_CHANGE:"stateChange",DURATION_LOAD:"durationLoad",TIME_CHANGE:"timeChange"}}},created:function(){this.current=this.STATES.STOP},methods:{click:function(){var e=this;this.current==this.STATES.STOP?(this.current=this.STATES.LOADING,this.$audio.play({src:[this.path],onplay:function(){e.current=e.STATES.PLAY},onload:function(){e.duration=e.$audio.duration(),e.$emit(e.EVENTS.DURATION_LOAD,e.duration.toFixed()),e.current=e.STATES.LOADED},onend:function(){e.current=e.STATES.STOP},onpause:function(){e.current=e.STATES.PAUSE},onplaying:function(t){e.$emit(e.EVENTS.TIME_CHANGE,t)}})):this.current==this.STATES.PLAY?this.$audio.pause():this.current==this.STATES.PAUSE&&this.$audio.resume()},stop:function(){this.current==this.STATES.PLAY&&this.$audio.pause()}}},v,!1,function(e){n("8No1")},"data-v-7838bf90",null).exports,T={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"progress-bar"},[n("div",[e._v(e._s(e.current))]),e._v(" "),n("div",{style:{width:e.progressWidth+"vw"}},[n("mt-progress",{attrs:{value:e.trackWidth},nativeOn:{click:function(t){return e.progressClick(t)}}})],1),e._v(" "),n("div",[e._v(e._s(e.total))])])},staticRenderFns:[]};var _=n("Z0/y")({name:"ProgressBar",created:function(){},data:function(){return{EVENTS:{PROGRESS_CLICK:"progressClick"},width:300}},props:["total","current"],methods:{progressClick:function(e){var t=this.progressWidth/100*e.view.innerWidth,n=e.offsetX;this.val=n/t*this.total,this.$emit(this.EVENTS.PROGRESS_CLICK,this.val.toFixed())}},computed:{progressWidth:function(){return this.width/750*100},trackWidth:function(){return this.total?this.current/this.total*100:0}}},T,!1,function(e){n("ryCT")},"data-v-523e4c82",null).exports,m={name:"PlayerPanel",components:{PlayerButton:f,ProgressBar:_},props:["enableBack"],data:function(){return{EVENTS:{OPEN_CATELOG:"openCatelog",BACK:"back"},audio:null,total:0,duration:0}},methods:{openCatelog:function(){this.$emit(this.EVENTS.OPEN_CATELOG)},back:function(){this.$emit(this.EVENTS.BACK)},progressClick:function(e){this.$audio.seek(e)},durationLoad:function(e){this.total=e},timeChange:function(e){this.duration=e}}},E={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"player-tab"},[n("div",{staticClass:"catelog-button",on:{click:e.openCatelog}},[e._v("目录")]),e._v(" "),n("progress-bar",{staticClass:"progress-bar",attrs:{total:e.total,current:e.duration},on:{progressClick:e.progressClick}}),e._v(" "),n("player-button",{staticClass:"player-button",on:{durationLoad:e.durationLoad,timeChange:e.timeChange}}),e._v(" "),e.enableBack?n("div",{on:{click:e.back}},[e._v("返回")]):e._e()],1)},staticRenderFns:[]};var S=n("Z0/y")(m,E,!1,function(e){n("oTjg")},"data-v-06249012",null).exports,b={name:"RecorderButton",created:function(){this.current=this.STATES.STOP},data:function(){return{STATES:{RECORD:1,STOP:2},EVENTS:{CHANGE:"changeEvent"},current:null,filePath:null}},methods:{click:function(){this.current==this.STATES.STOP?this.filePath=this.record():this.stop(),this.$emit(this.EVENTS.CHANGE,this.current)},record:function(){var e=this;this.$bridge.call("record",{},function(t){e.current=e.STATES.RECORD,Object(c.Toast)("start record")})},stop:function(){var e=this;this.$bridge.call("stopRecord",{},function(t){e.current=e.STATES.STOP,e.filePath=sprintf("file://%s",t)})},testAudio:function(){Object(c.Toast)(this.filePath);try{this.$audio.play({src:[this.filePath]})}catch(e){Object(c.Toast)(e)}}}},g={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",[n("div",{staticClass:"recorder",class:{record:e.current==e.STATES.RECORD,stop:e.current==e.STATES.STOP},on:{click:e.click}}),e._v(" "),n("button",{on:{click:e.testAudio}},[e._v("测试试听")])])},staticRenderFns:[]};var C={name:"RecorderPanel",data:function(){return{EVENTS:{GOTO_REPLAY:"gotoReplay",UPLOAD:"upload"},replayVisiable:!1,uploadVisiable:!1}},methods:{gotoReplay:function(){this.$emit(this.EVENTS.GOTO_REPLAY)},upload:function(){c.MessageBox.confirm("确认上传音频？","确认上传").then(function(e){Object(c.Toast)({message:"上传成功",position:"bottom",duration:1e3})}),this.$emit(this.EVENTS.UPLOAD)},recordClick:function(){},stateChange:function(e){this.replayVisiable=!0,this.uploadVisiable=!0}},components:{RecordButton:n("Z0/y")(b,g,!1,function(e){n("lUAV")},"data-v-2f81d65e",null).exports}},P={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"recorder-tab"},[n("div",{directives:[{name:"show",rawName:"v-show",value:e.replayVisiable,expression:"replayVisiable"}],staticClass:"goto-replay-button",on:{click:e.gotoReplay}},[e._v("试听")]),e._v(" "),n("record-button",{staticClass:"record-button",on:{changeEvent:e.stateChange}}),e._v(" "),n("div",{directives:[{name:"show",rawName:"v-show",value:e.uploadVisiable,expression:"uploadVisiable"}],staticClass:"upload-button",on:{click:e.upload}},[e._v("上传")])],1)},staticRenderFns:[]};var A={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"catelog-panel"},[n("div",{staticClass:"title"},[e._v("\n        顺序播放(共五节)\n        "),n("span",{staticClass:"close",on:{click:e.close}},[e._v("X")])]),e._v(" "),n("ul",{directives:[{name:"infinite-scroll",rawName:"v-infinite-scroll",value:e.loadMore,expression:"loadMore"}],attrs:{"infinite-scroll-disabled":"loading","infinite-scroll-distance":"10"}},e._l(e.catelog,function(t,i){return n("li",{on:{click:function(n){e.selectItem(t)}}},[n("span",[e._v(e._s(t.title))]),e._v(" "),n("span",[e._v(e._s(t.img))]),e._v(" "),n("span",[e._v(e._s(t.owner))]),e._v(" "),n("span",[e._v(e._s(t.time))])])}))])},staticRenderFns:[]};var y={name:"Reading",data:function(){return{ANS_TYPES:{AUD:1},QUES_TYPES:{TXT:1},catelog:null,chapter:null,visible:{catelogVisible:!1,recorderPanelVisible:!1,playerPanelVisible:!1},enable:{recorderPanelEnable:!0,playerPanelEnable:!0},own:1,complete:0,overTime:0}},beforeRouteUpdate:function(e,t,n){this.$audio.pause(),n()},beforeRouteLeave:function(e,t,n){this.$audio.pause(),n()},created:function(){this.$route.params.id;switch(this.chapter=this.getChapter(),this.catelog=this.getCatelog(),sprintf("%s%s%s",this.own,this.complete,this.overTime)){case"100":this.enable.recorderPanelEnable=!0,this.showPanel("recorderPanelVisible");break;case"110":this.enable.recorderPanelEnable=!0,this.showPanel("playerPanelVisible");break;default:this.enable.recorderPanelEnable=!1,this.showPanel("playerPanelVisible")}},methods:{getChapter:function(){return{id:1,text:"白雪公主在国王和王后的宠爱之下，逐渐长大了，终于成了一个人见人爱的美少女。白雪公主非常善良、有爱心、她经常和动物一起玩耍。森林的动物，像小鹿、小兔子、松鼠、小鸟都喜欢白雪公主，因为白雪公主会给它们吃食物，还会讲故事给它们听。个性善良犹如天使般的白雪公主，过着幸福快乐的生活。　　可是，好景不长，白雪公主的母亲生病去世了。　　国王为了白雪公主就迎娶了一位新王后，可是，这位新王后却是个精通法术的女巫。她虽然很美丽，但是个性很骄傲、暴躁。尤其她最恨别人比她美丽",align:"left",aud:"",maxTime:"",owner:"小李",quesType:1,ansType:1,state:1}},getCatelog:function(){return[{id:1,title:"第一节",owner:"小菜",time:"10:00",img:""},{id:2,title:"第二节",owner:"小吧",time:"10:00",img:""},{id:3,title:"第三节",owner:"小酒",time:"10:00",img:""}]},gotoReplay:function(){this.showPanel("playerPanelVisible")},openCatelog:function(){this.showPanel("catelogVisible")},closeCatelog:function(){this.showPanel("playerPanelVisible")},backtoRecorder:function(){this.showPanel("recorderPanelVisible")},showPanel:function(e){for(var t in this.visible)this.visible[t]=!1;this.visible[e]=!0},selectItem:function(e){this.$router.push({name:"Reading",params:{id:e.id}})}},computed:{},components:{PlayerButton:f,ProgressBar:_,PlayerPanel:S,RecorderPanel:n("Z0/y")(C,P,!1,function(e){n("mY/O")},"data-v-77ab0917",null).exports,CatelogPanel:n("Z0/y")({name:"CatelogPanel",data:function(){return{EVENTS:{CLOSE:"close",SELECT_ITEM:"selectItem"}}},props:["catelog"],methods:{close:function(){this.$emit(this.EVENTS.CLOSE)},loadMore:function(){},selectItem:function(e){this.$emit(this.EVENTS.SELECT_ITEM,e)}}},A,!1,function(e){n("FLRd")},"data-v-6fed41bf",null).exports}},O={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"reading-panel"},[n("div",{on:{click:function(t){e.showPanel("recorderPanelVisible")}}},[e._v("朗读活动页")]),e._v(" "),e.chapter?[e.chapter.quesType==e.QUES_TYPES.TXT?[n("div",{staticClass:"text"},[e._v(e._s(e.chapter.text))])]:e._e(),e._v(" "),e.chapter.ansType==e.ANS_TYPES.AUD?[n("recorder-panel",{directives:[{name:"show",rawName:"v-show",value:e.visible.recorderPanelVisible,expression:"visible.recorderPanelVisible"}],on:{gotoReplay:e.gotoReplay}}),e._v(" "),n("player-panel",{directives:[{name:"show",rawName:"v-show",value:e.visible.playerPanelVisible,expression:"visible.playerPanelVisible"}],attrs:{enableBack:e.enable.recorderPanelEnable},on:{openCatelog:e.openCatelog,back:e.backtoRecorder}})]:e._e(),e._v(" "),n("catelog-panel",{directives:[{name:"show",rawName:"v-show",value:e.visible.catelogVisible,expression:"visible.catelogVisible"}],attrs:{catelog:e.catelog},on:{close:e.closeCatelog,selectItem:e.selectItem}})]:e._e()],2)},staticRenderFns:[]};var k=n("Z0/y")(y,O,!1,function(e){n("Cjpx")},"data-v-186c94b0",null).exports,w=this,N={name:"Activity",data:function(){return{activities:null}},created:function(){this.activities=[{id:1,name:"阅读活动二",startTime:"13:00",endTime:"16:00"},{id:2,name:"阅读活动三",startTime:"13:00",endTime:"16:00"}]},methods:{selectActivity:function(){w.$router.push({name:"Selection",params:{id:item.id}})}}},R={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("ul",e._l(e.activities,function(t,i){return n("li",{on:{click:function(n){e.selectActivity(t)}}},[n("span",[e._v(e._s(t.name))]),e._v(" "),n("span",[e._v(e._s(t.startTime)+" - "+e._s(t.endTime))])])}))},staticRenderFns:[]};var V=n("Z0/y")(N,R,!1,function(e){n("hk/I")},"data-v-6a72e600",null).exports;i.default.use(o.a);var L=new o.a({routes:[{path:"/",name:"Reading",component:k},{path:"/Activity",name:"Activity",component:V},{path:"/Selection",name:"Selection",component:h},{path:"/Reading/:id",name:"Reading",component:k}]}),$=(n("5OHe"),n("HMzc")),x=(n("m7aY"),n("aA9S")),D=n.n(x),I={install:function(e,t){e.prototype.$audio=function(){var e=n("pgsL"),t=(e.Howler,e.Howl),i=null,a=null,s=0,o={volumn:.5,html5:!1},r=null;function l(e){var t=i.seek()||0;e.call(null,t.toFixed()),i.playing()&&requestAnimationFrame(l.bind(null,e))}return{play:function(){return i&&i.stop(),i=function(e){r=D()({},o,e,{onplay:function(){var e=arguments;return function(){for(var t in e)e[t]&&e[t].call(null)}}(e.onplay,function(){e.onplaying&&n.playing()&&requestAnimationFrame(l.bind(null,e.onplaying))})});var n=new t(r);return n}.apply(null,arguments),a=i.play()},pause:function(){i&&(i.pause(a),s=i.seek(a))},stop:function(){i&&i.stop()},resume:function(){i&&(i.play(a),i.seek(s,a))},duration:function(){if(i)return i.duration(a)},seek:function(e){i&&i.seek(e)}}}()}},U=n("TS2E");i.default.use($),i.default.use(u.a),i.default.config.productionTip=!1,i.default.use(I),i.default.use(U.a),new i.default({el:"#app",router:L,components:{App:s},template:"<App/>"})},SDzh:function(e,t){},TCnL:function(e,t){},THJF:function(e,t){},"hk/I":function(e,t){},lUAV:function(e,t){},m7aY:function(e,t){},"mY/O":function(e,t){},oTjg:function(e,t){},ryCT:function(e,t){}},["NHnr"]);
//# sourceMappingURL=app.c34061eca59d1352b98d.js.map