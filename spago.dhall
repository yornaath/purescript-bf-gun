{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "bf-gun"
, dependencies =
  [ "aff"
  , "aff-coroutines"
  , "aff-promise"
  , "argonaut"
  , "console"
  , "debug"
  , "effect"
  , "express"
  , "foreign-generic"
  , "halogen"
  , "node-http"
  , "options"
  , "prelude"
  , "psci-support"
  , "test-unit"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs"]
, license = "(GPL-3.0-only OR MIT)"
, repository = "https://github.com/gorillatron/purescript-bf-gun.git"
}
