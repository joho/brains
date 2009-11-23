require 'ostruct'

class Robot < OpenStruct
  
  @@past_states = []
  def self.store_state(robot)
    @@past_states << robot
  end
  
  def self.past_states
    @@past_states
  end
  
  attr_reader :targeted_zombie, :was_resting
  
  def ran?
    @ran
  end
  
  def visible_zombies
    @visible_zombies ||= Zombie.new_from_env(visible)
  end
  
  def my_last_state
    @@past_states.last
  end
  
  def taking_damage?
    my_last_state.health > health
  end
  
  def last_targeted_zombie
    my_last_state.targeted_zombie
  end
  
  def nearest_zombie
    visible_zombies.sort_by do |zombie|
      zombie.distance_from_me(self)
    end.first
  end
  
  def need_to_start_rest?
    energy <= 1
  end
  
  def need_to_continue_rest?
    my_last_state.was_resting && energy < 6
  end
  
  def next_action
    if !my_last_state
      # first turn
      return :rest!
    elsif need_to_start_rest? || need_to_continue_rest?
      puts "!!RESTING!!"
      @was_resting = true
      return :rest!
    elsif ran_two_turns_ago?
      puts "!!RUNNING!!"
      @ran = true
      return :move!, 1, 1
    elsif last_targeted_zombie
      puts "!!SHOOTING!!"
      return :shoot!
    elsif nearest_zombie
      puts "!!TARGETING!!"
      @targeted_zombie = nearest_zombie
      return :turn!, nearest_zombie.direction_from_me(self)
    else
      puts "!!SCANNING!!"
      if nothing_nearby?
        return :rest!
      else
        return :turn!, dir + 60
      end
    end
  end
  
  def nothing_nearby?
    Robot.past_states[-3] && Robot.past_states[-3].nearest_zombie == nil
  end
  
  def ran_two_turns_ago?
    Robot.past_states[-2] && Robot.past_states[-2].ran?
  end
  
  def inspect
    <<-INSP
#<Robot health="#{health}" energy="#{energy}" score="#{score}" dir="#{dir}" x="#{x}" y="#{y}" state="#{state}">
    INSP
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