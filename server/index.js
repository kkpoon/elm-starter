var express = require("express");
var morgan = require("morgan");
var passport = require("passport");
var BasicStrategy = require("passport-http").BasicStrategy;

passport.use(new BasicStrategy(
  function(username, password, done) {
    if (username === "hello" && password === "world") {
      return done(null, { username: "hello", token: "hehehaha" });
    }
    return done(null, false);
  }
));

var app = express();

app.use(morgan("tiny"));

app.post(
  "/login",
  passport.authenticate("basic", { session: false }),
  function(req, res) {
    res.json(req.user);
  }
);

app.listen(+process.env.PORT || 5000);
