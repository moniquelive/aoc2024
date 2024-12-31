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
  attr_reader :part1, :part2

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
    lines = File.readlines(filename)
    robots1 = lines.map { |line| Robot.new(line) }
    robots2 = lines.map { |line| Robot.new(line) }
    robots1.each { |r| r.step_in_board(100, board_w, board_h) }

    board = Hash.new(0)
    robots1.each { |r| board[[r.x, r.y]] += 1 }

    quad1 = (board_h / 2).times.flat_map { |row| (board_w / 2).times.map { |col| [col, row] } }
    quad2 = (board_h / 2).times.flat_map { |row| (board_w / 2).times.map { |col| [col + 1 + (board_w / 2), row] } }
    quad3 = (board_h / 2).times.flat_map { |row| (board_w / 2).times.map { |col| [col, row + 1 + (board_h / 2)] } }
    quad4 = (board_h / 2).times.flat_map do |row|
      (board_w / 2).times.map do |col|
        [col + 1 + (board_w / 2), row + 1 + (board_h / 2)]
      end
    end
    q1 = quad1.map { |p| board[p] }.sum
    q2 = quad2.map { |p| board[p] }.sum
    q3 = quad3.map { |p| board[p] }.sum
    q4 = quad4.map { |p| board[p] }.sum
    @part1 = q1 * q2 * q3 * q4

    @part2 = 6876 # found visually
    robots2.each { |r| r.step_in_board(@part2 - 1, board_w, board_h) }
    board.clear
    robots2.each do |r|
      r.step_in_board(1, board_w, board_h)
      board[[r.x, r.y]] += 1
    end
    # puts pretty(board, board_w, board_h)
  end

  private

  def pretty(board, width, height)
    width.times.flat_map do |col|
      height.times.map { |row| board[[col, row]] }.join + "\n"
    end.join
  end
end

if $PROGRAM_NAME == __FILE__
  # p = P14.new('../input/14-1.input')
  p = P14.new('../input/14-1.input', 101, 103)
  puts("Part 1 (216027840): #{p.part1}")
  puts("Part 2 (6876): #{p.part2}")
end
