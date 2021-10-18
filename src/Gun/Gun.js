
const Gun = require('gun')
const omit = require('lodash.omit')

exports._create = (opts) => new Gun(opts)

exports._opt = (opts) => (gun) => gun.opt(opts)

exports._get = (decode) => (encode) => (key) => (gun) => {
  const node = gun.get(key)
  node.jsonDecode = decode
  node.jsonEncode = encode
  return node
}

exports._put = (data) => (gun) => gun.put(gun.jsonEncode(data))

exports._on = (cb) => (gun) => () => gun.on((data, key) => {
  const out = {
    key,
    data: gun.jsonDecode(omit(data, ['_'])),
    cursor: data._
  }
  cb(out)
})

exports._once = (cb) => (gun) => () => gun.once((data, key) => {
  const out = {
    key,
    data: gun.jsonDecode(omit(data, ['_'])),
    cursor: data._
  }
  cb(out)
})

exports._map = (cb) => (gun) => () => gun.map((data, key) => {
  const out = {
    key,
    data: gun.jsonDecode(omit(data, ['_'])),
    cursor: data._
  }
  cb(out)
})


exports._back = (steps) => (gun) => gun.back(steps)

exports._off = (gun) => () => gun.off()

// exports.notImpl = (gun) => {
//   return new Promise((resolve, reject) => {
//     gun.not ? gun.not((key) => resolve({ key })) : reject(new Error("Not included by default! You must include it yourself via `require('gun/lib/not.js')"))
//   })
// }