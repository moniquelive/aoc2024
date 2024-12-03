#!/usr/bin/env ruby
# frozen_string_literal: true

# class P3
class P3
  attr_reader :part1, :part2

  def initialize(filename) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    mul_regexp = /mul\((\d{1,3}),(\d{1,3})\)/
    all_regexp = /mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/

    @parse_products = -> { File.read(filename).scan(mul_regexp).map { |nums| nums.map(&:to_i) } }
    @parse_products_dos_donts = -> { File.read(filename).scan(all_regexp) }

    @part1 ||= @parse_products.call.map { |a, b| a * b }.sum.to_s
    @part2 ||= @parse_products_dos_donts.call.each_with_object({ multiply: 1, results: [] }) do |instr, state|
      state[:results] << case instr
                         when /^mul/ then instr.scan(/\d{1,3}/).map(&:to_i).reduce(&:*) * state[:multiply]
                         when 'do()' then state[:multiply] = 1
                                          0
                         when "don't()" then state[:multiply] = 0
                         end
    end[:results].sum.to_s
  end
end

if $PROGRAM_NAME == __FILE__
  p = P3.new('../input/3-1.input')
  print('Part 1 (170068701): ')
  puts(p.part1)

  print('Part 2 (78683433): ')
  puts(p.part2)
end
