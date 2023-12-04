# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp, title_temp = find_office_info(rep_info.offices, index)

      address = build_address(official)
      party = official.party || 'Party unavailable'
      photo_url = official.photo_url || 'default_photo_url'

      existing_representative = find_existing_representative(official.name)

      if existing_representative
        update_existing_representative(existing_representative, address, party, photo_url)
        reps.push(existing_representative)
      else
        rep_params = { name: official.name, ocdid: ocdid_temp, title: title_temp,
        contact_address: address, political_party: party, photo_url: photo_url }
        rep = create_new_representative(rep_params)
        reps.push(rep)
      end
    end

    reps
  end

  def self.find_office_info(offices, index)
    offices.each do |office|
      return [office.division_id, office.name] if office.official_indices.include?(index)
    end
    ['', '']
  end

  def self.build_address(official)
    if official.address.present?
      [official.address[0].line1, official.address[0].city, official.address[0].state,
       official.address[0].zip].compact.join(', ')
    else
      'Address unavailable'
    end
  end

  def self.find_existing_representative(name)
    Representative.find_by(name: name)
  end

  def self.update_existing_representative(rep, address, party, photo_url)
    rep.update(contact_address: address, political_party: party, photo_url: photo_url)
  end

  def self.create_new_representative(params)
    Representative.create!(params)
  end
end
