// module.exports = function({ types: t }) {
//   return {
//     visitor: {
//       BinaryExpression(path, state) {
//         if (path.node.operator !== "===") {
//       return;
//       }
//       path.node.left = t.identifier("sebmck");
//       },
//     }
//   };
// };

module.exports = function (babel) {
  var t = babel.types;
  return {
    name: "my-babel-plugin",
    visitor: {
      JSXElement(path) {
        console.log("ENTER_CUSTOM_PLUGIN")
        // console.log(path)
        // get the opening element from jsxElement node
        var openingElement = path.node.openingElement;
        //  //tagname is name of tag like div, p etc
        var tagName = openingElement.name.name;
        // var my_expression = "";
        // if (tagName == "Declaration") {
        //   my_expression += openingElement.attributes[0].name.name + " ";
        //   my_expression += openingElement.attributes[0].value.value + " = ";
        //   my_expression += openingElement.attributes[1].value.expression.value + ";";
        // }
        // console.log(my_expression)

        ident = openingElement.attributes[0].name.name
        var_name = openingElement.attributes[0].value.value
        value = openingElement.attributes[1].value.expression.value
        // path.replaceWith(t.variableDeclaration("var",[ t.variableDeclarator(["toto"], 42) ]));
        // console.log(t.variableDeclaration("var", [t.variableDeclarator(t.identifier("toto"), "tata")]));

      },
    },
  };
};
