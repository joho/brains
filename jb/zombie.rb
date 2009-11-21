require 'ostruct'

class Zombie < OpenStruct
  def self.new_from_env(visible_objects)
    visible_objects.select do |object|
      object['type'] == 'zombie' &&
      object['state'] != 'dead'
    end.collect do |zombie_hash|
      new(zombie_hash)
    end
  end
  
  def direction_from_me(me)
    (Math.atan2(x - me.x, y - me.y).to_deg + 180) % 360
  end
  
  def distance_from_me(me)
    Math.sqrt((me.x - self.x)**2 + (me.y-self.y)**2)
  end
    
end
