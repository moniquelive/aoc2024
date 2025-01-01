#!/usr/bin/env ruby
# frozen_string_literal: true

# class Robot
class Robot
  attr_reader :x, :y, :dx, :dy

  def initialize(line)
    @x, @y, @dx, @dy = line.match(/p=(\d+),(\d+) v=([-\d]+),([-\d]+)/).captures.map(&:to_i)
  end

  def step_in_board(steps, board_w, board_h)
    @x = (@x + @dx * steps) % board_w
    @y = (@y + @dy * steps) % board_h
  end

  def inspect
    "(#{x},#{y})@(#{dx},#{dy})"
  end
end

# class P14
class P14
  def initialize(filename, board_w = 11, board_h = 7)
    # lines = <<~LINES.split("\n")
    #   p=0,4 v=3,-3
    #   p=6,3 v=-1,-3
    #   p=10,3 v=-1,2
    #   p=2,0 v=2,-1
    #   p=0,0 v=1,3
    #   p=3,0 v=-2,-2
    #   p=7,6 v=-1,-3
    #   p=3,0 v=-1,-2
    #   p=9,3 v=2,3
    #   p=7,3 v=-1,2
    #   p=2,4 v=2,-3
    #   p=9,5 v=-3,-3
    # LINES
    @lines = File.readlines(filename)
    @board_w = board_w
    @board_h = board_h
    @quad1 = (@board_h / 2).times.flat_map { |row| (@board_w / 2).times.map { |col| [col, row] } }
    @quad2 = (@board_h / 2).times.flat_map { |row| (@board_w / 2).times.map { |col| [col + 1 + (@board_w / 2), row] } }
    @quad3 = (@board_h / 2).times.flat_map { |row| (@board_w / 2).times.map { |col| [col, row + 1 + (@board_h / 2)] } }
    @quad4 = (@board_h / 2).times.flat_map do |row|
      (@board_w / 2).times.map { |col| [col + 1 + (@board_w / 2), row + 1 + (@board_h / 2)] }
    end
  end

  def part1
    robots = @lines.map { |line| Robot.new(line) }
    robots.each { |r| r.step_in_board(100, @board_w, @board_h) }

    board = Hash.new(0)
    robots.each { |r| board[[r.x, r.y]] += 1 }

    [sum(@quad1, board),
     sum(@quad2, board),
     sum(@quad3, board),
     sum(@quad4, board)].reduce(&:*)
  end

  def part2
    robots = @lines.map { |line| Robot.new(line) }
    seconds = 6876 # found visually

    board = Hash.new(0)
    robots.each do |r|
      r.step_in_board(seconds, @board_w, @board_h)
      board[[r.x, r.y]] += 1
    end
    # puts pretty(board, @board_w, @board_h)
    seconds
  end

  private

  def sum(quad, board)
    quad.map { |p| board[p] }.sum
  end

  def pretty(board, width, height)
    height.times.map do |row|
      width.times.flat_map { |col| board[[col, row]] }.join + "\n" # rubocop:disable Style/StringConcatenation
    end.join
  end
end

if $PROGRAM_NAME == __FILE__
  # p = P14.new('../input/14-1.input')
  p = P14.new('../input/14-1.input', 101, 103)
  puts("Part 1 (216027840): #{p.part1}")
  puts("Part 2 (6876): #{p.part2}")
end
