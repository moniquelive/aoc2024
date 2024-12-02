#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './utils'

# class P2
class P2
  def initialize(filename)
    @s1 = 0
    @s2 = 0
    File.open(filename).readlines.map(&:strip).each { |line| safe?(line) }
  end

  def to_s
    "Part 1 (383): #{@s1}\nPart 2 (436): #{@s2}"
  end

  private

  def safe0?(numbers)
    p = numbers.each_cons(2)
    ds = p.map { |a, b| b - a }
    return false unless ds.all? { |d| (1..3).include?(d.abs) }
    return false unless (numbers.sort == numbers) || (numbers.sort.reverse == numbers)

    true
  end

  def safe?(line)
    n = line.split.map(&:to_i)
    @s1 += 1 if safe0?(n)
    @s2 += 1 if (0..n.size - 1).any? { |i| safe0?(n.remove_at(i)) }
  end
end

puts(P2.new('../input/2-1.input')) if $PROGRAM_NAME == __FILE__
