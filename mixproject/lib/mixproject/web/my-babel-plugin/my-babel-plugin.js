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
        // console.log(path.replaceWith(t.variableDeclaration("var",[ t.variableDeclarator(["toto"], 42) ])));
        // console.log(t.variableDeclaration("var", [t.variableDeclarator(t.identifier("toto"), "tata")]));
        // path.replaceWith(t.variableDeclaration(ident, [t.variableDeclarator(t.identifier(var_name), literal)]));

        // path.replaceWithSourceString(my_expression, path.node);
      },
    },
  };
};
//
// module.exports = function({ types: t }) {
//   return {
//     visitor: {
//       // BinaryExpression(path, state) {
//       //   if (path.node.operator !== "===") {
//       // return;
//       // }
//       // path.node.left = t.identifier("sebmck");
//       // },
//       ExpressionStatement(path, state)
//       {
//         console.log("test");
//         var openingElement = path.node.openingElement;
//         var tagName = openingElement.name.name;
//         if (tagName == "Declaration") {
//           console.log("tata")
//         }
//         // console.log(type);
//         // console.log(name);
//         // console.log(value);
//         // path.replaceWith(t.variableDeclaration(type, [t.variableDeclarator(t.identifier(name), value)]));
//       },
//     }
//   };
// };
// module.exports = function({ types: t }){
//   return {
//     visitor: {
//       BinaryExpression(path) {
//         if (path.node.operator !== "===") {
//           return;
//         }
//
//         path.node.left = t.identifier("Samedi");
//         path.node.right = t.identifier("week-end");
//       },
// ​
//       ExpressionStatement(path) {
//         console.log("ici");
//         expression = path.node.expression;
//         if (t.isJSXElement(expression)) {
//           open_elem = expression.openingElement
//           if (open_elem.name != "declaration") {
//             return;
//           }
//           attributes = expression.attributes
//           if (attributes.length != 2) {
//             return;
//           }
// ​
//           ident = attributes[0].name.name
//           var_name = attributes[0].value.value
//           value = attributes[1].value.value
// ​
//           literal = t.nullLiteral();
//           if (t.isStringLiteral(value)) {
//             literal = t.stringLiteral(value)
//           }
//           if (t.isNumeriLiteral(value)) {
//             literal = t.numericLiteral(value)
//           }
// ​
//           path.replaceWith(t.variableDeclaration(ident, [t.variableDeclarator(t.identifier(var_name), literal)]));
//         }
//       },
//     }
//   };
// }
