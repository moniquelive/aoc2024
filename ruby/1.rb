#!/usr/bin/env ruby
# frozen_string_literal: true

# class P1
class P1
  def initialize(filename)
    @c1 = []
    @c2 = []
    File.open(filename).readlines.map(&:strip).each do |line|
      line.split.map(&:to_i).tap do |n1, n2|
        @c1 << n1
        @c2 << n2
      end
      @c1.sort!
      @c2.sort!
    end
  end

  def part1
    @c1.zip(@c2).map { |n1, n2| (n1 - n2).abs }.sum
  end

  def part2
    @c1.map { |n1| n1 * @c2.count(n1) }.sum
  end
end

if $PROGRAM_NAME == __FILE__
  p = P1.new('../input/1-1.input')

  print('Part 1 (1151792): ')
  puts(p.part1)

  print('Part 2 (21790168): ')
  puts(p.part2)
end
