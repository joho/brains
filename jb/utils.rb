require 'ostruct'

class Robot < OpenStruct
  @@past_states = []
  def self.store_state(robot)
    @@past_states << robot
  end
  
  def self.past_states
    @@past_states
  end
  
  def visible_zombies
    Zombie.new_from_env(visible)
  end
  
  def my_last_state
    Robot.past_states.last
  end
  
  def next_action
    if enough_energy?
      do_something! 
    else
      :rest!
    end
  end
  
  def taking_damage?
    my_last_state && my_last_state.health > health
  end
  
  def nearest_zombie
    visible_zombies.sort_by do |zombie|
      zombie.distance_from_me(self)
    end.last
  end
  
  def facing_nearest_enemy?
    dir.near? nearest_zombie.direction_from_me(self), 5
  end
  
  def enough_energy?
    energy > 50
  end
  
  def do_something!
    if taking_damage?
      return :move!, rand(1), rand(1)
    elsif nearest_zombie && facing_nearest_enemy?
      return :shoot!
    elsif nearest_zombie
      return :turn!, nearest_zombie.direction_from_me(self)
    else
      return :turn!, (dir.to_deg + 60).to_rad
    end
  end
end

class Numeric
  def to_deg
    self * (180 / Math::PI)
  end
  def to_rad
    self * (Math::PI / 180)
  end
  def near?(other, precision=1)
    (other - precision) <= self && self <= (other + precision)
  end
end