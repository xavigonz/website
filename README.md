## Defacto website

The sourcecode for our [website](http://www.defacto.nl). More detailed information can be found at the [Wiki](https://github.com/DefactoSoftware/website/wiki).

##### Server

Start [Middleman](https://middlemanapp.com) server and browse to [http://localhost:4567](http://localhost:4567):

```bash
rake serve:nl
rake serve:de
```

##### Build

```bash
rake build:nl
rake build:de
```

##### Deploy (and build before)

```bash
rake deploy:nl
rake deploy:de
rake deploy # Deploy all locales
```

`:nl` is deployed to [website/tree/gh-pages](https://github.com/DefactoSoftware/website/tree/gh-pages). `:de` is deployed to [website-de/tree/gh-pages](https://github.com/DefactoSoftware/website-de/tree/gh-pages).

##### Useful links for debugging

- http://localhost:4567/__middleman/config/
- http://localhost:4567/__middleman/sitemap/

##### Dependencies

- Ruby 2.1.0 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Bundler

To install other dependencies run `bundle install` from the root of the project.
