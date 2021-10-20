var Main = require('./output/Main');

function main () {
    /*
    Here we could add variables such as

    var baseUrl = process.env.BASE_URL;

    Parcel will replace `process.env.BASE_URL`
    with the string contents of the BASE_URL environment
    variable at bundle/build time.
    A .env file can also be used to override shell variables
    for more information, see https://en.parceljs.org/env.html

    These variables can be supplied to the Main.main function.
    However, you will need to change the type to accept variables, by default it is an Effect.
    You will probably want to make it a function from String -> Effect ()
  */

  Main.main();
}

// HMR setup. For more info see: https://parceljs.org/hmr.html
if (module.hot) {
  module.hot.accept(function () {
    console.log('Reloaded, running main again');
    main();
  });
}

console.log('Starting app');

main();

// const Gun = require("gun")
// var SEA = Gun.SEA;
// ;(async () => {
// var pair = await SEA.pair();
// var enc = await SEA.encrypt('hello self', pair);
// var data = await SEA.sign(enc, pair);
// console.log(data);
// var msg = await SEA.verify(data, pair.pub);
// var dec = await SEA.decrypt(msg, pair);
// var proof = await SEA.work(dec, pair);
// var check = await SEA.work('hello self', pair);
// console.log(dec);
// console.log(proof === check);
// // now let's share private data with someone:
// var alice = await SEA.pair();
// var bob = await SEA.pair();
// var enc = await SEA.encrypt('shared data', await SEA.secret(bob.epub, alice));
// await SEA.decrypt(enc, await SEA.secret(alice.epub, bob));
// // `.secret` is Elliptic-curve Diffie–Hellman
// // Bob allows Alice to write to part of his graph, he creates a certificate for Alice
// var certificate = await SEA.certify(alice.pub, ["^AliceOnly.*"], bob)
// console.log("certificate", certificate)
// // Alice logs in 
// const gun = Gun();
// await gun.user().auth(alice);
// // and uses the certificate
// await gun.get('~'+bob.pub).get('AliceOnly').get('do-not-tell-anyone').put(enc, null, {opt: {cert: certificate}})
// await gun.get('~'+bob.pub).get('AliceOnly').get('do-not-tell-anyone').once(console.log) // return 'enc'
// })();