# https://github.com/javan/whenever

# Should run these at the same granularity as appts?
every 1.hour do
  rake "mail:service_reminder"
end
