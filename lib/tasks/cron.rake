desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
   if [1,3,5].includes?(Time.new.wday)
	Game.update
    end
end
