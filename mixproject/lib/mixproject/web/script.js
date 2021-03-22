// JSX

var click = document.getElementById('click');
click.onclick = () => {
  const text = 'Hey I was created from JSX!';
  const element = <div>{text}</div>;
  ReactDOM.render(
    element,
    document.getElementById('message')
  );
}


// JSXZ

var createReactClass = require('create-react-class')

var Page = createReactClass({
  render(){
    return <JSXZ in="template" sel=".container">
      <Z sel=".item">Burgers</Z>,
      <Z sel=".price">50</Z>
    </JSXZ>
  }
})

ReactDOM.render(
  <Page/>,
  document.getElementById('root')
)
