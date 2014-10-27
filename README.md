Service Call
===========

Remind Lightspeed customers of upcoming service appointments.

http://servicecall.royowl.net


Run in dev:
-----------
```rb
bundle install
foreman start
```

Run tasks:
----------
```rb
foreman run rake mail:service_reminder
```

Run tests:
----------
```rb
foreman run ruby test.rb
```

Logs:
----------------
[Papertrail](https://papertrailapp.com/systems/lightspeed-servicecall/events)
Or
```sh
heroku addons:open papertrail
```

Monitor:
-----------
- https://uptimerobot.com
- http://servicecall.royowl.net/ping
- http://servicecall.royowl.net/info

Deployment:
-----------
Prereqs:
- `servicecall`, `servicecall.pub` keys.

```sh
ssh-add ~/.ssh/servicecall
heroku account set servicecall
git push heroku master
```
