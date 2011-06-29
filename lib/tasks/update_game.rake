desc "manually trigger a game update"
task :update_game => :environment do
    Game.update(1)
end
