# flox-compat

Compatibility layer between flox and Nix.

Reads Flox's `.flox/env/manifest.lock` and generates a mini-environment.

Makes the flox packages more accessible and available to other ecosystem tooling.

## Usage
```
nix run github:tomberek/flox-compat
```

## TODO
- [ ] turn into library for better re-use with any Flox Env.
- [ ] add support for `profile`
- [ ] consider path-trick to replace fetchClosure
- [ ] consider correct caches for each caches once this is in the lockfile
