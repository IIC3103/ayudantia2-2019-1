class User < ApplicationRecord
  def Very_hard
    puts self.name
    num = 0 
    while num <100
      sleep(0.5)
      puts num
      num+=1
    end
  end
end
