const Gun = require("gun")

const omitSingle = (key, obj) => {
  const out = obj
  delete out[key]
  return out
}

exports._create = (opts) => () => {
  return Gun(opts)
}

exports._opt = (opts) => (gun) => () => {
  return gun.opt(opts)
}

exports._get = (key) => (gun) => () => {
  return gun.get(key)
}

exports._put = (data) => (gun) => () => {
  return gun.put(data)
}

exports._set = (data) => (gun) => () => {
  return gun.set(data)
}

exports._putWithCertificate = (cert) => (data) => (gun) => () => gun.put(data, null, {opt: { cert }})

exports._on = (cb) => (gun) => () => {
  return gun.on((data, key) => {
    return cb(data)()
  })
}

exports._once = (cb) => (gun) => () => {
  return gun.once((data, key) => {
    return cb(data)()
  })
}

exports._map = (cb) => (gun) => () => {
  return gun.map((data, key) => {
    return cb(data)()
  })
}

exports._back = (steps) => (gun) => () => gun.back(steps)

exports._off = (gun) => () => gun.off()