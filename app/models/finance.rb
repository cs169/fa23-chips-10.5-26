# frozen_string_literal: true

class Finance < ApplicationRecord
  def self.get_candidates(data)
    return [] unless data && data['results'].is_a?(Array)
  
    data['results'].map do |candidate_data|
      {
        name: reformat_name(candidate_data['name']),
        party: candidate_data['party'],
        state: parse_state_code(candidate_data['state'])
      }
    end
  end
  
  def self.reformat_name(name)
    return name unless name.include?(',')
  
    if name.include?('/')
      name.split(' / ').map(&method(:reformat_again)).join(' / ')
    else
      reformat_again(name)
    end
  end
  
  def self.reformat_again(input_name)
    parts = input_name.split(', ')
    return input_name unless parts.length >= 2
  
    last_name, first_part = parts
    first_name, middle_initial = extract_first_name_and_initial(first_part)
  
    "#{first_name}#{middle_initial} #{last_name}".strip.gsub(/\s+/, ' ')
  end
  
  def self.extract_first_name_and_initial(name_part)
    name_parts = name_part.split
    given_name = name_parts[0]
    middle_initial = name_parts.length > 1 ? " #{name_parts[1]}" : ''
  
    [given_name, middle_initial]
  end
    
  def self.parse_state_code(state)
    return unless state

    parts = state.split('/')
    file_name = parts.last || ''
    file_name.split('.').first
  end
end
