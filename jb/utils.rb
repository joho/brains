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
    if taking_damage?
      return :move!, rand(1), rand(1)
    elsif not facing_nearest_enemy?
      return :turn, zombie.direction_from_me(me)
    elsif me.energy > 40
      return :shoot!
    else
      return :rest!
    end
  end
  
  def taking_damage?
    my_last_state && my_last_state.health > me.health
  end
  
  def nearest_zombie
    zombies.sort_by do |zombie|
      zombie.distance_from_me(me)
    end.last
  end
  
  def facing_nearest_enemy?
    me.dir == nearest_zombie.direction_from_me(me)
  end
end