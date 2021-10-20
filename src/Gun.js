const Gun = require("gun")

const omitSingle = (key, obj) => {
  const out = obj
  delete out[key]
  return out
}

exports._create = (opts) => () => {
  return new Gun(opts)
}

exports._opt = (opts) => (gun) => () => gun.opt(opts)

exports._get = (decode) => (encode) => (key) => (gun) => () => {
  const node = gun.get(key)
  node.jsonDecode = decode
  node.jsonEncode = encode
  return node
}

exports._put = (data) => (gun) => () => gun.put(gun.jsonEncode(data))

exports._putWithCertificate = (cert) => (data) => (gun) => () => gun.put(gun.jsonEncode(data), null, {opt: { cert }})

exports._on = (cb) => (gun) => () => gun.on((data, key) => {
  const out = {
    key,
    raw: data._,
    data: gun.jsonDecode(omitSingle("_", data))
  }
  cb(out)
})

exports._once = (cb) => (gun) => () => gun.once((data, key) => {
  const out = {
    key,
    raw: data._,
    data: gun.jsonDecode(omitSingle("_", data))
  }
  cb(out)
})

exports._map = (cb) => (gun) => () => gun.map((data, key) => {
  const out = {
    key,
    raw: data._,
    data: gun.jsonDecode(omitSingle("_", data))
  }
  cb(out)
})

exports._back = (steps) => (gun) => () => gun.back(steps)

exports._off = (gun) => () => gun.off()