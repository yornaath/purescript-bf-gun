
exports._user = (gun) => () => gun.user()

exports._auth = (onError) => (onSuccess) => (alias) => (pass) => (usernode) => () => new Promise((resolve) => {
  usernode.auth(alias, pass, (data) => {
    if(data.err) {
      resolve(onError(data))
    }
    else {
      resolve(onSuccess(data))
    }
  })
})

exports._createUser = (onError) => (onSuccess) => (alias) => (pass) => (usernode) => () => new Promise((resolve) => {
  usernode.create(alias, pass, (data) => {
    if(data.err) {
      resolve(onError(data))
    }
    else {
      resolve(onSuccess(data))
    }
  })
})