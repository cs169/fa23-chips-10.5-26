# frozen_string_literal: true

Given('there are representatives in the system') do
  Representative.create(name: 'Joe Biden', title: 'President')
  Representative.create(name: 'Kamala Harris', title: 'Vice President')
  Representative.create(name: 'Mark Warner', title: 'Senator')
end

Given('there is a representative in the system') do
  @representative = Representative.create(name: 'Time Kaine', title: 'U.S. Senator')
end

When('I visit the representative\'s page') do
  visit representative_path(@representative)
end

Then('I should see the details of that representative') do
  expect(page).to have_content(@representative.name)
  expect(page).to have_content(@representative.title)
end

Given('I visit the search page') do
  visit '/representatives/'
end

When('I search for Fairfax County') do
  fill_in 'address', with: 'Fairfax County'
  click_button 'Search'
end

When("I click on Joseph R. Biden's link in the search results") do
  click_link('Joseph R. Biden')
end

Then("I should see Joseph R. Biden's information") do
  expect(page).to have_content('Joseph R. Biden')
  expect(page).to have_content('ocd-division/country:us')
  expect(page).to have_content('President of the United States')
  expect(page).to have_content('1600 Pennsylvania Avenue Northwest')
  expect(page).to have_content('Washington')
  expect(page).to have_content('DC')
  expect(page).to have_content('20500')
  expect(page).to have_content('Democratic Party')
end
