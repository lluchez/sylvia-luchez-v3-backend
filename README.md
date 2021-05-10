# README

## Commands

### Push

```
git push -f stage main:master
git push -f prod main:master
```

### Migrate

```
heroku run rake db:migrate -r stage
heroku run rake db:migrate -r prod
```
