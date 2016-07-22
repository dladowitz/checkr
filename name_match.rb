def name_match?(known_names, name)
  return true if naive_match(known_names, name)

  known_people = []
  known_names.each do |know_name|
    known_people << Person.new(know_name)
  end

  alias_name = Person.new(name)

  known_people.each do |known_person|
    return true if alias_name == known_person
  end

  return false
end

def naive_match(known_names, name)
  known_names.include? name
end


class Person
  attr_accessor :first, :middle, :last

  def initialize(name_string)
    @first = nil
    @middle = nil
    @last = nil

    parse_name(name_string)
  end

  def == (other_person)
    return false unless self.has_name_fragment(other_person.first)
    return false unless self.has_name_fragment(other_person.last)
    return false unless self.has_name_fragment(other_person.middle) if other_person.middle

    return true
  end

  def has_name_fragment(name_fragment)
    # puts "Self.first: #{self.first}"
    # puts "name_fragment: #{name_fragment}"
    return true if self.first[0] == name_fragment[0]
    return true if self.first == name_fragment

    return true if self.last[0] == name_fragment[0]
    return true if self.last == name_fragment

    if self.middle
      puts "Self.middle: #{self.middle}"
      puts "name_fragment: #{name_fragment}"
      return true if self.middle[0] == name_fragment[0]
      return true if self.middle == name_fragment
    end

    return false
  end

  def parse_name(name_string)
    split_name = name_string.split
    @first = split_name.first
    @last = split_name.last

    if split_name.length == 3
      @middle = split_name[1]
    end
  end
end


require "minitest/autorun"
describe 'exact match' do
  known_names = ["Alphonse Gabriel Capone", "Al Capone"]

  it 'works' do
    # name_match?(known_names, "Alphonse Gabriel Capone").must_equal(true)
    # name_match?(known_names, "Al Capone").must_equal(true)
    name_match?(known_names, "Alphonse Francis Capone").must_equal(false)
  end
end
#
# describe 'Middle name unknown match' do
#   known_names = ["Alphonse Capone"]
#
#   it 'works' do
#     name_match?(known_names, "Alphonse Gabriel Capone").must_equal(true)
#     name_match?(known_names, "Alexander Capone").must_equal(false)
#   end
# end
#
# describe 'Middle name unknown match' do
#   known_names = ["Alphonse Gabriel Capone"]
#
#   it 'works' do
#     name_match?(known_names, "Alphonse Capone").must_equal(true)
#   end
# end
#
# describe 'Multiple middle name aliases' do
#   known_names = ["Alphonse Gabriel Capone", "Alphonse Francis Capone"]
#
#   it 'works' do
#     name_match?(known_names, "Alphonse Gabriel Capone").must_equal(true)
#     name_match?(known_names, "Alphonse Francis Capone").must_equal(true)
#     name_match?(known_names, "Alphonse Edward Capone").must_equal(false)
#   end
# end
#
# describe 'Middle name and middle initials match' do
#   known_names = ["Alphonse Gabriel Capone", "Alphonse F Capone"]
#
#   it 'works' do
#     name_match?(known_names, "Alphonse G Capone").must_equal(true)
#     name_match?(known_names, "Alphonse Francis Capone").must_equal(true)
#     name_match?(known_names, "Alphonse E Capone").must_equal(false)
#   end
# end
#
# describe 'Name transposition' do
#   known_names = ["Alphonse Gabriel Capone"]
#
#   it 'works' do
#     name_match?(known_names, "Gabriel Alphonse Capone").must_equal(true)
#     name_match?(known_names, "Gabriel Capone").must_equal(true)
#     name_match?(known_names, "Gabriel A Capone").must_equal(true)
#     name_match?(known_names, "Capone Francis Alphonse").must_equal(false)
#   end
# end
#
# describe 'Misspellings' do
#   known_names = ["Alphonse Capone"]
#
#   it 'works' do
#     name_match?(known_names, "Alphonce Capone").must_equal(true)
#     name_match?(known_names, "Alphonce Capome").must_equal(true)
#     name_match?(known_names, "Alphons Capon").must_equal(true)
#     name_match?(known_names, "Alphosne Capone").must_equal(false)
#     name_match?(known_names, "Alfonse Capone").must_equal(false)
#   end
# end
