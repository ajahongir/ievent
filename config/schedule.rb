set :output, "log/cron.log"

every 1.minute do
   runner 'Scheduler.start'
end

