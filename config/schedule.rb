# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

rails_env = ENV['RAILS_ENV'] ||= 'development'
set :output, 'log/cron_log.log'
set :environment, rails_env
# *** Add ENV or it will not work!!!!
ENV.each { |k, v| env(k, v) }

# Fetch data from github every 12 hours
every 12.hours do
  rake 'github:fetch_data'
end

# # *for test
# every 1.minute do
#   rake "github:fetch_data"
# end
