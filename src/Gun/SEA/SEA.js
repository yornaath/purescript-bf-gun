const Gun = require('gun')
const SEA = Gun.SEA

exports._pair = SEA.pair.bind(SEA)

// work(data: any, pair?: any, callback?: (data: string | undefined) => void, opt?: Partial<{
//   name: 'SHA-256' | 'PBKDF2';
//   encode: 'base64' | 'base32' | 'base16';
//   /** iterations to use on subtle.deriveBits */
//   iterations: number;
//   salt: any;
//   hash: string;
//   length: any;
// }>): Promise<string | undefined>;

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