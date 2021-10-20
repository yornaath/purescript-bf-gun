var Main = require('../../output/Examples.Basic.Client');

function main () {
  Main.main();
}

if (module.hot) {
  module.hot.accept(function () {
    console.log('Reloaded, running main again');
    main();
  });
}

main();
