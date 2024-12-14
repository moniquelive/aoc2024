#!/usr/bin/env ruby
# frozen_string_literal: true

# class P11
class P11
  attr_reader :part1, :part2

  def initialize(filename)
    @memo = {}

    # line = '125 17'.split.map(&:to_i)
    line = File.read(filename).split.map(&:to_i)
    @part1 = line.flat_map { |x| count(x, 25) }.sum
    @part2 = line.flat_map { |x| count(x, 75) }.sum
  end

  private

  def count(n, steps)
    return @memo[[n, steps]] if @memo.key?([n, steps])
    return Array(n).size if steps.zero? # Return the actual array for zero steps

    @memo[[n, steps]] = Array(n).map do |x|
      ds = x.digits.size
      count(if x.zero?
              [1]
            elsif ds.even?
              place = 10**(ds / 2).to_i
              [x / place, x % place]
            else
              [x * 2024]
            end, steps - 1)
    end.flatten.sum
  end
end

if $PROGRAM_NAME == __FILE__
  p = P11.new('../input/11-1.input')
  puts("Part 1 (175006): #{p.part1}")
  puts("Part 2 (207961583799296): #{p.part2}")
end
