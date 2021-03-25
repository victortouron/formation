require('./tuto.webflow/css/tuto.webflow.css');
require('!!file-loader?name=[name].[ext]!./index.html')

var ReactDOM = require('react-dom')
var React = require('react')
var createReactClass = require('create-react-class')
var Qs = require('qs')
var Cookie = require('cookie')

var orders = [
  {remoteid: "000000189", custom: {customer: {full_name: "TOTO & CIE"}, billing_address: "Some where in the world"}, items: 2},
  {remoteid: "000000190", custom: {customer: {full_name: "Looney Toons"}, billing_address: "The Warner Bros Company"}, items: 3},
  {remoteid: "000000191", custom: {customer: {full_name: "Asterix & Obelix"}, billing_address: "Armorique"}, items: 29},
  {remoteid: "000000192", custom: {customer: {full_name: "Lucky Luke"}, billing_address: "A Cowboy doesn't have an address. Sorry"}, items: 0},
]

//To render this JSON in the table, we will have to map the list on a **`JSXZ`** render.
var Page = createReactClass({
  render(){
    var i = 0
    return <JSXZ in="orders" sel=".layout">
    <Z sel=".table-body">
    {
      orders.map( order => (<JSXZ in="orders" key={i++} sel=".table-line">
      <Z sel=".col-1">{order.remoteid}</Z>
      <Z sel=".col-2">{order.custom.customer.full_name}</Z>
      <Z sel=".col-3">{order.custom.billing_address}</Z>
      <Z sel=".col-4">{order.items}</Z>
      <Z sel=".col-5">Details</Z>
      <Z sel=".col-6">Pay</Z>
      </JSXZ>))
    }
    </Z>
    </JSXZ>
  }
})

var ErrorPage = createReactClass({
  render(){
    return <h1>{this.props.code} / {this.props.message}</h1>;
  }
})

var Layout = createReactClass({
  render(){
    return <JSXZ in="orders" sel=".layout">
    <Z sel=".layout-container">
    <this.props.Child {...this.props}/>
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

var Orders = createReactClass({
  render(){
    var i = 0
    return <JSXZ in="orders" sel=".orders-container">
    <Z sel=".table-body">
    {
      orders.map( order => (<JSXZ in="orders" key={i++} sel=".table-line">
      <Z sel=".col-1">{order.remoteid}</Z>
      <Z sel=".col-2">{order.custom.customer.full_name}</Z>
      <Z sel=".col-3">{order.custom.billing_address}</Z>
      <Z sel=".col-4">{order.items}</Z>
      <Z sel=".col-5">Details</Z>
      <Z sel=".col-6">Pay</Z>
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
      return r && {handlerPath: [Layout, Header, Orders],  order_id: r[1]}
    }
  }
}

function onPathChange() {
  var path = location.pathname
  var qs = Qs.parse(location.search.slice(1))
  var cookies = Cookie.parse(document.cookie)
  browserState = {
    ...browserState,
    path: path,
    qs: qs,
    cookie: cookies
  }
  var route, routeProps
  //We try to match the requested path to one our our routes
  for(var key in routes) {
    console.log(key)
    routeProps = routes[key].match(path, qs)
    if(routeProps){
      route = key
      break;
    }
  }
  browserState = {
    ...browserState,
    ...routeProps,
    route: route
  }
  //If we don't have a match, we render an Error component
  if(!route)
    return ReactDOM.render(<ErrorPage message={"Not Found"} code={404}/>, document.getElementById('root'))
  ReactDOM.render(<Child {...browserState}/>, document.getElementById('root'))
  // ReactDOM.render(<Page />, document.getElementById('root'));
}

window.addEventListener("popstate", ()=>{ onPathChange() })
onPathChange()
