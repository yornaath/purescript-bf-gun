const Gun = require("gun")
const clone = require("lodash.clone")
const omit = require("lodash.omit")

const omitSingle = (key, obj) => {
  const out = obj
  delete out[key]
  return out
} 

exports._create = (opts) => {
  return Gun(opts)
}

exports._opt = (opts) => (gun) => {
  return gun.opt(opts)
}

exports._get = (key) => (gun) => {
  return gun.get(key)
}

exports._put = (data) => (gun) => {
  return gun.put(data.value0)
}

exports._set = (data) => (gun) => {
  return gun.set(data.value0)
}

exports._putWithCertificate = (cert) => (data) => (gun) => gun.put(data.value0, null, {opt: { cert }})

exports._on = (cb) => (gun) => {
  return gun.on((data, key) => {
    return cb(key)(data)()
  })
}

exports._once = (cb) => (gun) => {
  return gun.once((data, key) => {
    return cb(key)(data)()
  })
}

exports._map = (cb) => (gun) => {
  return gun.map((data, key) => {
    return typeof cb && cb.value0 == "function" ? cb.value0(data)() : data
  })
}

exports._back = (steps) => (gun) => () => gun.back(steps)

exports._off = (gun) => () => gun.off()

const getDataFromRaw = (raw) => {
  return omit(clone(raw), ["_"])
}

exports._toJSON = (nodeOrRawOrRecord) => () => {
  if(nodeOrRawOrRecord && nodeOrRawOrRecord.put) {
    return getDataFromRaw(nodeOrRawOrRecord.put)
  }
  else {
    return getDataFromRaw(nodeOrRawOrRecord)
  }
}