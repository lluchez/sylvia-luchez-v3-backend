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


## Migration attempt from Heroku to AWS/CodePipeline

Useful links
- [Using the Elastic Beanstalk Ruby platform](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_Ruby.container.html) (AWS)
- [Deploying a rails application to Elastic Beanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-rails-tutorial.html) (AWS)
- [Automate Deployments with AWS CodePipeline](https://dev.to/raphael_jambalos/automate-deployments-with-aws-codepipeline-52f5)
- [nginx error: (13: Permission denied) while connecting to upstream)](https://stackoverflow.com/questions/35177177/nginx-error-13-permission-denied-while-connecting-to-upstream) (stackoverflow)
- [Rails application deployed on Elastic Beanstalk with Puma fails - 502 errors on every request](https://stackoverflow.com/questions/30355569/rails-application-deployed-on-elastic-beanstalk-with-puma-fails-502-errors-on) (stackoverflow)
- [Right Way To Deploy Rails Puma Postgres App To Elastic Beanstalk](https://www.faqcode4u.com/faq/316249/right-way-to-deploy-rails-puma-postgres-app-to-elastic-beanstalk)

## To do
- Update CORS origins
- Update github actions to run Rubocop
- [DEPRECATION] Rack::Attack.throttled_response is deprecated. Please use Rack::Attack.throttled_responder instead
