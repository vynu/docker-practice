var express = require("express");

express()
 .get("*", function(req, res) {
    res.send("Hello There! this is node js with docker - vynu");
 })
 .listen(3000, function(err) {
    if (err) {
      console.error(err);
      return;
    }

    console.log("Express Server listening on port 3000");
  })
;
