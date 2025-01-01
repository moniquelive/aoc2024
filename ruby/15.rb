#!/usr/bin/env ruby
# frozen_string_literal: true

# class Wall
Wall = Struct.new(:x, :y) do
  def to_s
    '#'
  end
end

# class Swappable
Swappable = Struct.new('Swappable', :x, :y) do
  def swap(with)
    self.x, with.x = with.x, x
    self.y, with.y = with.y, y
  end

  def gps
    x + 100 * y
  end
end

# class Gap
class Gap < Swappable
  def to_s
    '.'
  end
end

# class Box
class Box < Swappable
  def to_s
    'O'
  end
end

# class Robot
class Robot < Swappable
  def to_s
    '@'
  end
end

# class Warehouse
class Warehouse
  def initialize(board, width, height)
    @board = board
    @width = width
    @height = height
  end

  def move(dir)
    d = robot.dup
    in_path = []
    until at(d.x, d.y).instance_of?(Wall) || at(d.x, d.y).instance_of?(Gap)
      in_path << at(d.x, d.y)
      update(d, dir)
    end
    return unless at(d.x, d.y).instance_of?(Gap)

    in_path << at(d.x, d.y)
    (in_path.size - 1).times { |i| in_path[i + 1].swap(in_path[i]) }
  end

  def to_s
    @height.times.map do |row|
      @width.times.map { |col| at(col, row).to_s }.join + "\n" # rubocop:disable Style/StringConcatenation
    end.join
  end

  def gps
    @board.map { |e| e.instance_of?(Box) ? e.gps : nil }.compact
  end

  private

  def update(pos, dir)
    case dir
    when '<' then pos.x -= 1
    when '>' then pos.x += 1
    when '^' then pos.y -= 1
    when 'v' then pos.y += 1
    else raise "huh? (#{dir})"
    end
  end

  def robot
    @board.find { |e| e.instance_of?(Robot) }
  end

  # TODO: cache this
  def at(pos_x, pos_y)
    @board.find { |e| e.x == pos_x && e.y == pos_y }
  end
end

# class P15
class P15
  attr_reader :part2

  def initialize(filename)
    lines = <<~LINES.split("\n\n")
      ##########
      #..O..O.O#
      #......O.#
      #.OO..O.O#
      #..O@..O.#
      #O#..O...#
      #O..O..O.#
      #.OO.O.OO#
      #....O...#
      ##########

      <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
      vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
      ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
      <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
      ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
      ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
      >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
      <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
      ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
      v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    LINES
    # lines = File.read(filename).split("\n\n")
    @board = lines.first.split("\n")
    @moves = lines.last.gsub("\n", '')
    @entities = { '@' => Robot, '#' => Wall, 'O' => Box, '.' => Gap }
  end

  def part1
    warehouse = build_warehouse
    @moves.chars.each { |m| warehouse.move(m) }
    # puts warehouse
    warehouse.gps.sum
  end

  private

  def build_warehouse
    e = @board.size.times.flat_map do |row|
      @board.first.size.times.map do |col|
        @entities.fetch(@board[row][col]).new(col, row)
      end
    end
    Warehouse.new(e, @board.first.size, @board.size)
  end
end

if $PROGRAM_NAME == __FILE__
  p = P15.new('../input/15-1.input')
  puts("Part 1 (1487337): #{p.part1}")
  puts("Part 2 (): #{p.part2}")
end
