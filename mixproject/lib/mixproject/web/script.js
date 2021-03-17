var click = document.getElementById('click');
click.onclick = () => {
  const text = 'Hey I was created from JSX!';
  const element = <div>{text}</div>;
  ReactDOM.render(
    element,
    document.getElementById('root')
  );
}
