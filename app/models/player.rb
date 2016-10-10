class Player
  attr_reader :name
  attr_reader :color
  @@assigned_colors = []
  def initialize(input)
    @color = input.fetch(:color)
    @name = input.fetch(:name)
    @@assigned_colors << @color
  end
end