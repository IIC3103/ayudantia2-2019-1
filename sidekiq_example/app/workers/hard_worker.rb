class HardWorker
  include Sidekiq::Worker

  def perform(user_id)
    puts User.find(user_id).name
    num = 0 
    while num <100
      sleep(0.5)
      puts num
      num+=1
    end
  end
end
