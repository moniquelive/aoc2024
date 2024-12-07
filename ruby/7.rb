#!/usr/bin/env ruby
# frozen_string_literal: true

# class Integer
class Integer
  def %(other)
    self + other
  end

  def /(other)
    (to_s + other.to_s).to_i
  end
end

# class P6
class P7
  attr_reader :part1, :part2

  def initialize(filename) # rubocop:disable Metrics/AbcSize
    # lines = <<~LINES.split("\n")
    #   190: 10 19
    #   3267: 81 40 27
    #   83: 17 5
    #   156: 15 6
    #   7290: 6 8 6 15
    #   161011: 16 10 13
    #   192: 17 8 14
    #   21037: 9 7 18 13
    #   292: 11 6 16 20
    # LINES
    lines = File.readlines(filename)
    @eqs = lines.map do |l|
      r, f = l.split(': ')
      [r.to_i, f.split]
    end
    # p try(@eqs[3].first, @eqs[3].last)
    @part1 = @eqs.map { |e| try(e.first, e.last) }.sum
    @part2 = @eqs.map { |e| try2(e.first, e.last) }.sum
  end

  private

  def interleave(a, b) # rubocop:disable Naming/MethodParameterName
    (a[..-2].zip(b).flatten(1) << a.last).join
  end

  def try(target, factors)
    %w[% *].repeated_permutation(factors.size - 1).map do |ops|
      return target if target == eval(interleave(factors, ops)) # rubocop:disable Security/Eval
    end
    0
  end

  def try2(target, factors)
    %w[/ % *].repeated_permutation(factors.size - 1).map do |ops|
      return target if target == eval(interleave(factors, ops)) # rubocop:disable Security/Eval
    end
    0
  end
end

if $PROGRAM_NAME == __FILE__
  p = P7.new('../input/7-1.input')
  puts("Part 1 (6231007345478): #{p.part1}")
  puts("Part 2 (333027885676693): #{p.part2}")
end
