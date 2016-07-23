def name_match?(known_names, name)
  return true if naive_match(known_names, name)

  known_people = create_known_people(known_names)
  alias_name = Person.new(name)
  
  return check_person_against_known_people(alias_name, known_people)
end

def naive_match(known_names, name)
  known_names.include? name
end

def create_known_people(known_names)
  known_names.map do |known_name|
    Person.new(known_name)
  end
end

def check_person_against_known_people(alias_name, known_people)
  known_people.each do |known_person|
    return true if alias_name == known_person
  end

  return false
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
    # check first_name
    return false if self.name_fragment_missing?(self.first, other_person)
    # check last_name
    return false if self.name_fragment_missing?(self.last, other_person)
    # check middle name
    if self.middle && other_person.middle
      return false if self.name_fragment_missing?(self.middle, other_person)
    end

    return true
  end

  def name_fragment_missing?(name_fragment, other_person)
    # check first name
    return false if Person.similiar_names(name_fragment, other_person.first)
    #check last name
    return false if Person.similiar_names(name_fragment, other_person.last)
    #check middle name
    return false if other_person.middle && Person.similiar_names(name_fragment, other_person.middle)

    return true
  end

  private

  def parse_name(name_string)
    split_name = name_string.split
    @first = split_name.first
    @last = split_name.last

    if split_name.length == 3
      @middle = split_name[1]
    end
  end

  def self.similiar_names(name1, name2)
    errors = 0
    longer_name_length = [name1.length, name2.length].max

      if name1.length == 1 || name2.length == 1
        return name1[0] == name2[0]
      else
        longer_name_length.times do |index|
          if name1[index] != name2[index]
            errors += 1
            return false if errors > 1
          end
        end
      end

    return true
  end
end


require "minitest/autorun"
describe 'exact match' do
  known_names = ["Alphonse Gabriel Capone", "Al Capone"]

  it 'works' do
    name_match?(known_names, "Alphonse Gabriel Capone").must_equal(true)
    name_match?(known_names, "Al Capone").must_equal(true)
    name_match?(known_names, "Alphonse Francis Capone").must_equal(false)
  end
end

describe 'Middle name unknown match' do
  known_names = ["Alphonse Capone"]

  it 'works' do
    name_match?(known_names, "Alphonse Gabriel Capone").must_equal(true)
    name_match?(known_names, "Alexander Capone").must_equal(false)
  end
end

describe 'Middle name unknown match' do
  known_names = ["Alphonse Gabriel Capone"]

  it 'works' do
    name_match?(known_names, "Alphonse Capone").must_equal(true)
  end
end

describe 'Multiple middle name aliases' do
  known_names = ["Alphonse Gabriel Capone", "Alphonse Francis Capone"]

  it 'works' do
    name_match?(known_names, "Alphonse Gabriel Capone").must_equal(true)
    name_match?(known_names, "Alphonse Francis Capone").must_equal(true)
    name_match?(known_names, "Alphonse Edward Capone").must_equal(false)
  end
end

describe 'Middle name and middle initials match' do
  known_names = ["Alphonse Gabriel Capone", "Alphonse F Capone"]

  it 'works' do
    name_match?(known_names, "Alphonse G Capone").must_equal(true)
    name_match?(known_names, "Alphonse Francis Capone").must_equal(true)
    name_match?(known_names, "Alphonse E Capone").must_equal(false)
  end
end

describe 'Name transposition' do
  known_names = ["Alphonse Gabriel Capone"]

  it 'works' do
    name_match?(known_names, "Gabriel Alphonse Capone").must_equal(true)
    name_match?(known_names, "Gabriel Capone").must_equal(true)
    name_match?(known_names, "Gabriel A Capone").must_equal(true)
    name_match?(known_names, "Capone Francis Alphonse").must_equal(false)
  end
end

describe 'Misspellings' do
  known_names = ["Alphonse Capone"]

  it 'works' do
    name_match?(known_names, "Alphonce Capone").must_equal(true)
    name_match?(known_names, "Alphonce Capome").must_equal(true)
    name_match?(known_names, "Alphons Capon").must_equal(true)
    name_match?(known_names, "Alphosne Capone").must_equal(false)
    name_match?(known_names, "Alfonse Capone").must_equal(false)
  end
end
