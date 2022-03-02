# README

## Commands

### Push

```
git push -f stage main:master
git push -f prod main:master
```

### Migrate

```
heroku run -r stage rake db:migrate
heroku run -r prod rake db:migrate
```


## Tips

Use `byebug` to set a break point


## To do
- Update github actions to run Rubocop
- Update Rack::Attack to return a JSON response. [Example](https://gitlab.encs.vancouver.wsu.edu/dustin.bartolus/Autolab/-/blob/9fad2ccd2a6e3d30925dc1fd13a5a4bfe48c401f/config/initializers/rack-attack.rb#L86)
