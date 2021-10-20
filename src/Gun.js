const Gun = require("gun")

const omitSingle = (key, obj) => {
  const out = obj
  delete out[key]
  return out
}

exports._create = (opts) => () => {
  return Gun(opts)
}

exports._opt = (opts) => (gun) => () => gun.opt(opts)

exports._get = (decode) => (encode) => (key) => (gun) => () => {
  const node = gun.get(key)
  node._jsonDecode = decode
  node._jsonEncode = encode
  return node
}

exports._put = (data) => (gun) => () => gun.put(gun._jsonEncode(data))

exports._set = (data) => (gun) => () => gun.set(gun._jsonEncode(data))

exports._putWithCertificate = (cert) => (data) => (gun) => () => gun.put(gun._jsonEncode(data), null, {opt: { cert }})

exports._on = (cb) => (gun) => () => {
  return gun.on((data, key) => {
    const out = {
      key,
      raw: data._,
      data: gun._jsonDecode(omitSingle("_", data))
    }
    cb(out)()
  })
}

exports._once = (cb) => (gun) => () => {
  return gun.once((data, key) => {
    const out = {
      key,
      raw: data._,
      data: gun._jsonDecode(omitSingle("_", data))
    }
    cb(out)()
  })
}

exports._map = (cb) => (gun) => () => {
  return gun.map((data, key) => {
    const out = {
      key,
      raw: data._,
      data: gun._jsonDecode(omitSingle("_", data))
    }
    cb(out)()
  })
}

exports._back = (steps) => (gun) => () => gun.back(steps)

exports._off = (gun) => () => gun.off()