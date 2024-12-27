#!/usr/bin/env ruby
# frozen_string_literal: true

# class Machine
class Machine
  attr_reader :a, :b, :c

  def initialize(lines)
    c = ->(s) { s.match(/(\d+)\D*(\d+)/).captures.map(&:to_i) }
    @a = c.call(lines[0])
    @b = c.call(lines[1])
    @c = c.call(lines[2])
  end

  def to_s
    "#{a}, #{b}, #{c}"
  end

  def farther_prize
    farther = 10_000_000_000_000
    @c = [c.first + farther, c.last + farther]
    self
  end

  def solve # rubocop:disable Metrics/AbcSize
    # Create the coefficient matrix determinant
    det = (a[0] * b[1]) - (a[1] * b[0])
    return nil if det.zero? # No unique solution exists

    # Find x using Cramer's rule
    det_x = (c[0] * b[1]) - (c[1] * b[0])
    x = det_x / det.to_f

    # Find y using Cramer's rule
    det_y = (a[0] * c[1]) - (a[1] * c[0])
    y = -det_y / det.to_f

    [x, y]
  end
end

# class P13
class P13
  attr_reader :part1, :part2

  def initialize(filename) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    # lines = <<~LINES.split("\n\n")
    #   Button A: X+94, Y+34
    #   Button B: X+22, Y+67
    #   Prize: X=8400, Y=5400
    #
    #   Button A: X+26, Y+66
    #   Button B: X+67, Y+21
    #   Prize: X=12748, Y=12176
    #
    #   Button A: X+17, Y+86
    #   Button B: X+84, Y+37
    #   Prize: X=7870, Y=6450
    #
    #   Button A: X+69, Y+23
    #   Button B: X+27, Y+71
    #   Prize: X=18641, Y=10279
    # LINES
    lines = File.read(filename).split("\n\n")
    machines = lines.map { |line| Machine.new(line.split("\n")) }
    possible = machines.filter { |m| m.solve.map(&:abs).all? { |n| n == n.to_i } }
    @part1 = possible.sum do |m|
      x, y = m.solve.map(&:abs).map(&:to_i)
      x * 3 + y
    end
    possible = machines.map(&:farther_prize).filter { |m| m.solve.map(&:abs).all? { |n| n == n.to_i } }
    @part2 = possible.sum do |m|
      x, y = m.solve.map(&:abs).map(&:to_i)
      x * 3 + y
    end
  end
end

if $PROGRAM_NAME == __FILE__
  p = P13.new('../input/13-1.input')
  puts("Part 1 (29388): #{p.part1}")
  puts("Part 2 (99548032866004): #{p.part2}")
end
