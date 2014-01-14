var page = require('webpage').create();
page.open('http://vigilance.meteofrance.com/', function() {
  console.log(page.content);
  phantom.exit();
});
