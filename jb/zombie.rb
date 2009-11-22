require 'ostruct'

class Zombie < OpenStruct
  FRIENDS = %w(GT.local. ozmeiermac.local. nullobject.local.)
  
  def self.new_from_env(visible_objects)
    visible_objects.select do |object|
      object['state'] != 'dead' &&
      !FRIENDS.include?(object['name'])
    end.collect do |zombie_hash|
      new(zombie_hash)
    end
  end
  
  def direction_from_me(me)
    (Math.atan2(me.x - x, me.y - y).to_deg + 180) % 360
  end
  
  def distance_from_me(me)
    Math.sqrt((me.x - self.x)**2 + (me.y-self.y)**2)
  end
    
end
