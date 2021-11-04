const omit = require("lodash.omit")

exports.getDataImpl = (node) => {
  if(node.value0.put) {
    return omit(node.value0.put, ["_"])
  }
  else if(node.value0._) {
    return omit(node.value0, ["_"])
  }
  else {
    node.value0
  }
}