Service Call
===========

Remind Lightspeed customers of upcoming service appointments.

http://servicecall.royowl.net


Run in dev:
-----------
```rb
bundle install
bundle exec foreman start web
```

Logs:
----------------
[Papertrail](https://papertrailapp.com/systems/lightspeed-servicecall/events)
Or
```sh
heroku addons:open papertrail
```

Monitoring:
-----------
https://uptimerobot.com

Deployment:
-----------
Prereqs:
- `servicecall`, `servicecall.pub` keys.

```sh
ssh-add ~/.ssh/servicecall
heroku account set servicecall
git push heroku master
```
