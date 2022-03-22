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
- Update CORS origins
- Update github actions to run Rubocop
