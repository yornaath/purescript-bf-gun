const Gun = require('gun')
const SEA = Gun.SEA

exports._pair = SEA.pair.bind(SEA)

const noop = () => undefined

exports._work = (pair) => (data) => (options) => () => {
  return SEA.work(data, pair, noop, options)
}

exports._sign = (pair) => (data) => () => SEA.sign(data, pair)

exports._verify = (pair) => (data) => () => SEA.verify(data, pair)

exports._encrypt = (epriv) => (data) => () => SEA.encrypt(data, epriv)

exports._decrypt = (epriv) => (data) => () => SEA.decrypt(data, epriv)

exports._secret = (pairA) => (pairB) => () => SEA.secret(pairA, pairB)

exports._certify = (publicKey) => (paths) => (pair) => () => SEA.certify(publicKey, paths, pair)