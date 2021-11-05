
exports._user = (gun) => gun.user()

exports._userAt = (path) => (gun) => gun.user(path)

exports._auth = (ErrorType) => (Successtype) => (alias) => (pass) => (usernode) => () => new Promise((resolve) => {
  usernode.auth(alias, pass, (data) => {
    if(data.err) {
      resolve(ErrorType(data))
    }
    else {
      resolve(Successtype(data))
    }
  })
})

exports._createUser = (ErrorType) => (Successtype) => (alias) => (pass) => (usernode) => () => new Promise((resolve) => {
  usernode.create(alias, pass, (data) => {
    if(data.err) {
      resolve(ErrorType(data))
    }
    else {
      resolve(Successtype(data))
    }
  })
})

exports._recall = (ErrorType) => (Successtype) => (usernode) => () => new Promise((resolve) => {
  usernode.recall({sessionStorage: true}, (data) => {
    if(data.err) {
      resolve(ErrorType(data))
    }
    else {
      resolve(Successtype(data))
    }
  })
})

exports._leave = (usernode) => () => usernode.leave()

exports._delete = (alias) => (pass) => (usernode) => () => new Promise((resolve) => usernode.delete(alias, pass, resolve))