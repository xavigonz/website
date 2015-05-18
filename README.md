##Defacto website

Start [Middleman](https://middlemanapp.com) server:

```
./serve
```

and browse to [http://localhost:4567](http://localhost:4567).

##### Build

```
middleman build
```

##### Deploy

Deploy to [Github pages](http://defactosoftware.github.io/website):

```
middleman deploy
```

Deploy to [Divshot development](http://development.defacto-website.divshot.io):

```
divshot push
```

Deploy to [Divshot production](http://defacto-website.divshot.io):

```
divshot promote development production
```

##### Useful links for debugging

- [http://localhost:4567/__middleman/config/](http://localhost:4567/__middleman/config/)
- [http://localhost:4567/__middleman/sitemap/](http://localhost:4567/__middleman/sitemap/)

##### Dependencies

- Ruby 2.1.0 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Bundler

To install other dependencies run `bundle install` from the root of the project.
