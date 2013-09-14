# Allow setting Gem.user_home attribute to be able to remove the
# default 'ubuntu' user on the first run.
module Gem
  def self.user_home=(value)
    @user_home = value
  end
end

