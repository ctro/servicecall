Service Call
===========

Remind Lightspeed customers of upcoming service appointments.


Run in dev:
-----------
```rb
bundle install
bundle exec foreman start web
```

Deployment:
-----------
Prereqs:
- `servicecall`, `servicecall.pub` keys.

```sh
ssh-add ~/.ssh/servicecall
heroku account set servicecall
git push heroku master
```
