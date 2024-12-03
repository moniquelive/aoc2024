#!/usr/bin/env ruby
# frozen_string_literal: true

# class P3
class P3
  def initialize(filename)
    @lines = File.open(filename).read
  end

  def part1
    @products ||= @lines.scan(/mul\((\d{1,3}),(\d{1,3})\)/).map { |a, b| a.to_i * b.to_i }
    @products.sum.to_s
  end

  def part2 # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
    mul = true
    @products2 ||= @lines.scan(/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/).map do |instr|
      case instr
      when /^mul/ then a, b = instr.scan(/\d{1,3}/).map(&:to_i)
                       mul ? a * b : 0
      when 'do()' then mul = true
                       0
      when "don't()" then mul = false
      end || 0
    end
    @products2.sum.to_s
  end
end

if $PROGRAM_NAME == __FILE__
  p = P3.new('../input/3-1.input')
  print('Part 1 (170068701): ')
  puts(p.part1)

  print('Part 2 (78683433): ')
  puts(p.part2)
end
