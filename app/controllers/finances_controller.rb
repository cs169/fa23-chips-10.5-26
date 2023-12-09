# frozen_string_literal: true

class FinancesController < ApplicationController
  def search; end

  def search_finances
    cycle = params[:cycle]
    category = params[:category]
    url = "https://api.propublica.org/campaign-finance/v1/#{cycle}/candidates/leaders/#{category}.json"

    conn = Faraday.new do |faraday|
      faraday.url_prefix = url
      #faraday.headers['X-API-Key'] = '9lcjslvwVjbqtX0KcQQ3W9rFm316caQQ2T89n4xA'
      faraday.headers['X-API-Key'] = Rails.application.credentials[:PROPUBLICA_API_KEY]
      faraday.adapter Faraday.default_adapter
    end

    response = conn.get

    if response.success?
      top20 = JSON.parse(response.body)
      @candidates = Finance.get_candidates(top20)
      #Rails.logger.debug @candidates
    end
    render 'finances/show'
  end
end
