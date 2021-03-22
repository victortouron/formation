require('!!file-loader?name=[name].[ext]!./tuto.webflow/orders.html')
require('./tuto.webflow/css/tuto.webflow.css');

var ReactDOM = require('react-dom')
var React = require('react')
var createReactClass = require('create-react-class')

var orders = [
  {remoteid: "000000189", custom: {customer: {full_name: "TOTO & CIE"}, billing_address: "Some where in the world"}, items: 2},
  {remoteid: "000000190", custom: {customer: {full_name: "Looney Toons"}, billing_address: "The Warner Bros Company"}, items: 3},
  {remoteid: "000000191", custom: {customer: {full_name: "Asterix & Obelix"}, billing_address: "Armorique"}, items: 29},
  {remoteid: "000000192", custom: {customer: {full_name: "Lucky Luke"}, billing_address: "A Cowboy doesn't have an address. Sorry"}, items: 0},
]

//To render this JSON in the table, we will have to map the list on a **`JSXZ`** render.
var Page = createReactClass({
  render(){
    // return <JSXZ in="orders" sel=".table-line">
    // <Z sel=".col-1">1</Z>
    // <Z sel=".col-2">toto</Z>
    // <Z sel=".col-3">allé du slip</Z>
    // <Z sel=".col-4">42</Z>
    // <Z sel=".col-5">logo</Z>
    // <Z sel=".col-6">logo</Z>
    // </JSXZ>
     orders.map( order => (
      <JSXZ in="orders" sel=".table-line">
      <Z sel=".col-1">{order.remoteid}</Z>
      <Z sel=".col-2">{order.customer.full_name}</Z>
      <Z sel=".col-3">{order.customer.billing_address}</Z>
      <Z sel=".col-4">{order.items}</Z>
      <Z sel=".col-5">logo</Z>
      <Z sel=".col-6">logo</Z>
      </JSXZ>))
    }
  })

ReactDOM.render(
  <Page/>,
  document.getElementById('table-body')
)
