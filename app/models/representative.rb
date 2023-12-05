# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end

      if official.address.present?
        address = [official.address[0].line1,
        official.address[0].city,
        official.address[0].state,
        official.address[0].zip].compact.join(', ')
      else
        address = 'Address unavailable'
      end
      
      party = official.party || 'Party unavailable'
      photo_url = official.photo_url || 'default_photo_url'

      existing_representative = Representative.find_by(name: official.name)

      if existing_representative
        existing_representative.update(contact_address: address, political_party: party, photo_url: photo_url)
        reps.push(existing_representative)
      else
        rep = Representative.create!(
          name: official.name,
          ocdid: ocdid_temp,
          title: title_temp,
          contact_address: address,
          political_party: party,
          photo_url: photo_url
        )

        reps.push(rep)
      end
    end

    reps
  end
end
