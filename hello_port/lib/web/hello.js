require('@kbrw/node_erlastic').server(function(term, from, current_amount, done){
  if (term == "hello") return done("reply", "Hello World!");
  if (term == "what") return done("reply", "What What?");
  if (term == "kbrw") return done("reply",current_amount);
  if (term[0] == "kbrw") return done("noreply", current_amount = term[1]);
  throw new Error("unexpected request")
});
