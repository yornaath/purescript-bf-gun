const Gun = require('gun')
const SEA = Gun.SEA

exports._pair = SEA.pair.bind(SEA)

exports._sign = (pair) => (data) => SEA.sign(data, pair)