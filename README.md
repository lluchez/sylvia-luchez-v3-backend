# README

## Commands

Run the following command first for authentication:

```
heroku login
```

### Push

```
git push -f stage $(git branch --show-current):master
git push -f prod main:master
```

### Migrate

```
heroku run -r stage rake db:migrate
heroku run -r prod rake db:migrate
```

### Rails Console

```
heroku run -r stage rails c
heroku run -r prod rails c
```


## Tips

Use `byebug` to set a break point


## To do
- Update github actions to run Rubocop
