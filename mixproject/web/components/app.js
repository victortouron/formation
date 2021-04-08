require('../tuto.webflow/css/tuto.webflow.css');
require('../tuto.webflow/css/modal.loader.css');
require('!!file-loader?name=[name].[ext]!../index.html')

var localhost = require('reaxt/config').localhost
var ReactDOM = require('react-dom')
var React = require('react')
var createReactClass = require('create-react-class')
var Qs = require('qs')
var Cookie = require('cookie')
var XMLHttpRequest = require("xhr2")
var When = require('when')
var page = 1

var HTTP = new (function(){
  this.get = (url)=>this.req('GET',url)
  this.delete = (url)=>this.req('DELETE',url)
  this.post = (url,data)=>this.req('POST',url,data)
  this.put = (url,data)=>this.req('PUT',url,data)

  this.req = (method,url,data)=> new Promise((resolve, reject) => {
    var req = new XMLHttpRequest()
    url = (typeof window !== 'undefined') ? url : localhost+url
    req.open(method, url)
    req.responseType = "text"
    req.setRequestHeader("accept","application/json,*/*;0.8")
    req.setRequestHeader("content-type","application/json")
    req.onload = ()=>{
      if(req.status >= 200 && req.status < 300){
        resolve(req.responseText && JSON.parse(req.responseText))
      }else{
        reject({http_code: req.status})
      }
    }
    req.onerror = (err)=>{
      reject({http_code: req.status})
    }
    req.send(data && JSON.stringify(data))
  })
})()

var remoteProps = {
  user: (props) => {
    return {
      url: "/api/me",
      prop: "user"
    }
  },
  orders: (props) => {
    /*if (!props.user)
    return*/
    var qs = {...props.qs}//, user_id: props.user.value.id}
    var query = Qs.stringify(qs)
    if (query != "")
      page = query.split('=')[1]
    return {
      url: "/api/orders" + (query == '' ? '' : '?' + query),
      prop: "orders"
    }
  },
  order: (props) => {
    return {
      url: "/api/order/" + props.order_id,
      prop: "order"
    }
}}

function addRemoteProps(props){
  return new Promise((resolve, reject)=>{
    //Here we could call `[].concat.apply` instead of `Array.prototype.concat.apply`
    //apply first parameter define the `this` of the concat function called
    //Ex [0,1,2].concat([3,4],[5,6])-> [0,1,2,3,4,5,6]
    // <=> Array.prototype.concat.apply([0,1,2],[[3,4],[5,6]])
    //Also `var list = [1,2,3]` <=> `var list = new Array(1,2,3)`
    var remoteProps = Array.prototype.concat.apply([],
      props.handlerPath
      .map((c)=> c.remoteProps) // -> [[remoteProps.user], [remoteProps.orders], null]
      .filter((p)=> p) // -> [[remoteProps.user], [remoteProps.orders]]
    )
    var remoteProps = remoteProps
    .map((spec_fun)=> spec_fun(props) ) // -> 1st call [{url: '/api/me', prop: 'user'}, undefined]
    // -> 2nd call [{url: '/api/me', prop: 'user'}, {url: '/api/orders?user_id=123', prop: 'orders'}]
    .filter((specs)=> specs) // get rid of undefined from remoteProps that don't match their dependencies
    .filter((specs)=> !props[specs.prop] ||  props[specs.prop].url != specs.url) // get rid of remoteProps already resolved with the url
    if(remoteProps.length == 0)
    return resolve(props)
    // check out https://github.com/cujojs/when/blob/master/docs/api.md#whenmap and https://github.com/cujojs/when/blob/master/docs/api.md#whenreduce
    // all remoteProps can be queried in parallel
    const promise_mapper = (spec) => {
      // we want to keep the url in the value resolved by the promise here. spec = {url: '/api/me', value: {name: 'Guillaume'}, prop: 'user'}
      return HTTP.get(spec.url).then((res) => { spec.value = res; return spec })
    }
    const reducer = (acc, spec) => {
      // spec = url: '/api/me', value: {name: 'Guillaume'}, prop: 'user'}
      acc[spec.prop] = {url: spec.url, value: spec.value}
      return acc
    }
    const promise_array = remoteProps.map(promise_mapper)
    return Promise.all(promise_array)
    .then(xs => xs.reduce(reducer, props), reject)
    .then((p) => {
      // recursively call remote props, because props computed from
      // previous queries can give the missing data/props necessary
      // to define another query
      return addRemoteProps(p).then(resolve, reject)
    }, reject)
  })
}

var ErrorPage = createReactClass({
  render(){
    return <h1>{this.props.code} / {this.props.message}</h1>;
  }
})

var cn = function(){
  var args = arguments, classes = {}
  for (var i in args) {
    var arg = args[i]
    if(!arg) continue
    if ('string' === typeof arg || 'number' === typeof arg) {
      arg.split(" ").filter((c)=> c!="").map((c)=>{
        classes[c] = true
      })
    } else if ('object' === typeof arg) {
      for (var key in arg) classes[key] = arg[key]
    }
  }
  return Object.keys(classes).map((k)=> classes[k] && k || '').join(' ')
}

var DeleteModal = React.createClass({
  render(){
    return <JSXZ in="modal" sel=".modal-content">
    <Z sel=".modal_title">{this.props.message}</Z>
    <Z sel=".yes_button" onClick={(e) => this.props.callback(true)}>Yes</Z>
    <Z sel=".no_button" onClick={(e) => window.location.reload()}>No</Z>
    </JSXZ>
  }
})

var Loader = createReactClass({
  render(){
    return <JSXZ in="loader" sel=".loader-content">
    </JSXZ>
  }
});

var Layout = createReactClass({
  getInitialState: function() {
    return {
      modal: null,
      loader: false
    };
  },
  modal(spec){
    this.setState({modal: {
      ...spec, callback: (res)=>{
        this.setState({modal: null},()=>{
          if(spec.callback) spec.callback(res)
        })
      }
    }})
  },
  loader(promise) {
    this.setState({loader: true});
    return promise.then(() => {
      this.setState({loader: false});
    })
  },
  render(){
    var props = {
      ...this.props, modal: this.modal, loader: this.loader
    }
    var modal_component = {
      'delete': (props) => <DeleteModal {...props}/>
    }[this.state.modal && this.state.modal.type];
    modal_component = modal_component && modal_component(this.state.modal)
    var loader_component = this.state.loader && (() => <Loader />)
    loader_component = loader_component && loader_component(this.state.loader)
      return <JSXZ in="orders" sel=".layout">
      <Z sel=".layout-container">
      <this.props.Child {...props}/>
      </Z>
      <Z sel=".modal-wrapper" className={cn(classNameZ, {'hidden': !modal_component})}>
      {modal_component}
      </Z>
      <Z sel=".loader-wrapper" className={cn(classNameZ, {'hidden': !loader_component})}>
      {loader_component}
      </Z>
      </JSXZ>
  }
})

var Header = createReactClass({
  render(){
      return <JSXZ in="orders" sel=".header">
      <Z sel=".header-container">
      <this.props.Child {...this.props}/>
      </Z>
      </JSXZ>
  }
})

function handleClick(){
  const intput_text = document.getElementById("search_text").value;
  console.log(intput_text);
  HTTP.get("/api/vtouron_orders_index?" + intput_text).then(res => {
    console.log(res);
  })
}

function nextpage(){
  page ++
  GoTo("orders", [], "page=" + page)
}

function previouspage(){
  if (page > 1)
    page --
  GoTo("orders", [], "page=" + page)
}

var Link = createReactClass({
  statics: {
    renderFunc: null, //render function to use (differently set depending if we are server sided or client sided)
    GoTo(route, params, query){// function used to change the path of our browser
      var path = routes[route].path(params)
      var qs = Qs.stringify(query)
      var url = path + (qs == '' ? '' : '?' + qs)
      history.pushState({},"",url)
      Link.onPathChange()
    },
    onPathChange(){ //Updated onPathChange
      var path = location.pathname
      var qs = Qs.parse(location.search.slice(1))
      var cookies = Cookie.parse(document.cookie)
      inferPropsChange(path, qs, cookies).then( //inferPropsChange download the new props if the url query changed as done previously
        ()=>{
          Link.renderFunc(<Child {...browserState}/>) //if we are on server side we render
        },({http_code})=>{
          Link.renderFunc(<ErrorPage message={"Not Found"} code={http_code}/>, http_code) //idem
        }
      )
    },
    LinkTo: (route,params,query)=> {
      var qs = Qs.stringify(query)
      return routes[route].path(params) +((qs=='') ? '' : ('?'+qs))
    }
  },
  onClick(ev) {
    ev.preventDefault();
    Link.GoTo(this.props.to,this.props.params,this.props.query);
  },
  render (){//render a <Link> this way transform link into href path which allows on browser without javascript to work perfectly on the website
    return (
      <a href={Link.LinkTo(this.props.to,this.props.params,this.props.query)} onClick={this.onClick}>
        {this.props.children}
      </a>
    )
  }
})

var Orders = createReactClass({
  statics: {
    remoteProps: [remoteProps.orders]
  },
  render(){
    var new_orders = this.props.orders.value.response.docs
    var i = 0
    function delete_order(id, props) {
      var data = {
        order: "nat_order" + id
      };
      props.modal({
        type: 'delete',
        title: 'Order deletion',
        message: `Are you sure you want to delete this ?`,
        callback: (value)=>{
          console.log(value),
          console.log(data),
          props.loader(HTTP.post("/api/delete", data).then(res => {
            window.location.reload();
          }));
        }
      })
    }
    return <JSXZ in="orders" sel=".orders-container">
    <Z sel=".submit-button-3" onClick={(e) => handleClick()}></Z>
    <Z sel=".table-body">
    {
      new_orders.map( order => (<JSXZ in="orders" key={i++} sel=".table-line">
      <Z sel=".col-1">{order.remoteid}</Z>
      <Z sel=".col-2">{order["custom.customer.full_name"]}</Z>
      <Z sel=".col-3">{order["custom.shipping_address.street"]}, {order["custom.shipping_address.postcode"]} {order["custom.shipping_address.city"]}</Z>
      <Z sel=".col-4">{order["custom.items.quantity_to_fetch"].length}</Z>
      <Z sel=".col-5" onClick={(e) => GoTo("order", order.remoteid, "")}></Z>
      <Z sel=".col-6" onClick={(e) => delete_order(order.remoteid, this.props)}></Z>
      </JSXZ>))
    }
    </Z>
    <Z sel=".previouspage" onClick={(e) => previouspage()}></Z>
    <Z sel=".currentpage">{page}</Z>
    <Z sel=".nextpage" onClick={(e) => nextpage()}></Z>

    </JSXZ>
  }
})

var Order = createReactClass({
  statics: {
    remoteProps: [remoteProps.order]
  },
  render(){
    var order = this.props.order.value.response.docs[0]
    var items = order["custom.items.product_title"]
    var i = -1
    return <JSXZ in="order" sel=".order-container">
    <Z sel=".name_val">{order["custom.customer.full_name"]}</Z>
    <Z sel=".add_val">{order["custom.shipping_address.street"]}, {order["custom.shipping_address.postcode"]} {order["custom.shipping_address.city"]}</Z>
    <Z sel=".comm_val">{order.remoteid}</Z>
    <Z sel=".table-body">
    {
      items.map( item => (<JSXZ in="order" key={i++} sel=".table-line">
      <Z sel=".col-1">{item}</Z>
      <Z sel=".col-2">{order["custom.items.quantity_to_fetch"][i]}</Z>
      <Z sel=".col-3">{order["custom.items.unit_price"][i]}</Z>
      <Z sel=".col-4">{order["custom.items.quantity_to_fetch"][i] * order["custom.items.unit_price"][i]}</Z>
      </JSXZ>))
    }
    </Z>
    </JSXZ>
  }
})

var Child = createReactClass({
  render(){
    var [ChildHandler,...rest] = this.props.handlerPath
    return <ChildHandler {...this.props} handlerPath={rest} />
  }
})

var browserState = {Child: Child}

var routes = {
  "orders": {
    path: (params) => {
      return "/";
    },
    match: (path, qs) => {
      return (path == "/") && {handlerPath: [Layout, Header, Orders]}
    }
  },
  "order": {
    path: (params) => {
      return "/order/" + params;
    },
    match: (path, qs) => {
      var r = new RegExp("/order/([^/]*)$").exec(path)
      return r && {handlerPath: [Layout, Header, Order],  order_id: r[1]}
    }
  }
}

// var GoTo = (route, params, query) => {
//   var qs = Qs.stringify(query)
//   var url = routes[route].path(params) + ((query=='') ? '' : ('?'+query))
//   history.pushState({}, "", url)
//   onPathChange()
// }

// function onPathChange() {
//   var path = location.pathname
//   var qs = Qs.parse(location.search.slice(1))
//   var cookies = Cookie.parse(document.cookie)
//   browserState = {
//     ...browserState,
//     path: path,
//     qs: qs,
//     cookie: cookies
//   }
//   var route, routeProps
//   //We try to match the requested path to one our our routes
//   for(var key in routes) {
//     routeProps = routes[key].match(path, qs)
//     if(routeProps){
//       route = key
//       break;
//     }
//   }
//   browserState = {
//     ...browserState,
//     ...routeProps,
//     route: route
//   }
//   addRemoteProps(browserState).then(
//     (props) => {
//       browserState = props
//       ReactDOM.render(<Child {...browserState}/>, document.getElementById('root'))
//     }, (res) => {
//       ReactDOM.render(<ErrorPage message={"Shit happened"} code={404}/>, document.getElementById('root'))
//     })
//   }
  //
  // window.addEventListener("popstate", ()=>{ onPathChange() })
  // onPathChange()

  var browserState = {}



function inferPropsChange(path,query,cookies){ // the second part of the onPathChange function have been moved here
  browserState = {
    ...browserState,
    path: path, qs: query,
    Link: Link,
    Child: Child
  }

  var route, routeProps
  for(var key in routes) {
    routeProps = routes[key].match(path, query)
    if(routeProps){
      route = key
      break
    }
  }

  if(!route){
    return new Promise( (res,reject) => reject({http_code: 404}))
  }
  browserState = {
    ...browserState,
    ...routeProps,
    route: route
  }

  return addRemoteProps(browserState).then(
    (props)=>{
      browserState = props
    })
}

  module.exports = {
  reaxt_server_render(params, render){
    inferPropsChange(params.path, params.query, params.cookies)
      .then(()=>{
        render(<Child {...browserState}/>)
      },(err)=>{
        render(<ErrorPage message={"Not Found :" + err.url } code={err.http_code}/>, err.http_code)
      })
  },
  reaxt_client_render(initialProps, render){
    browserState = initialProps
    Link.renderFunc = render
    window.addEventListener("popstate", ()=>{ Link.onPathChange() })
    Link.onPathChange()
  }
}
