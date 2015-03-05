require 'spec_helper'

describe 'Articles Search' do

  it 'should support range facets', js: true do
    visit articles_index_path('s.q' => 'zebra')
    # click_link 'Publication Date'  # oops, not a real link
    find('.facet_limit h5', text: 'Publication Date').click
    fill_in 'pub_date_min_value',   with: 1890
    fill_in 'pub_date_max_value',   with: 1910
    click_button 'Limit'
    # page.save_and_open_page # debug
    page.all('#documents .result').count.should be >= 10

  end

  it 'should support multi-field searching', js: true do
    visit root_path
    within('.landing_page') do
      click_link('Articles')
    end
    # within ('.search_box') do
    click_link('Advanced Search')
    # end

    fill_in 'query',            with: 'economics'
    fill_in 'author',           with: 'Stiglitz'
    fill_in 'title',            with: 'Economics'
    fill_in 'publicationtitle', with: 'Journal'

    # find('button[type=submit]').click()
    # click('Search')
    click_button 'Search'

    expect(find('.well-constraints')).to have_content('Author: Stiglitz')
    expect(find('.well-constraints')).to have_content('Title: Economics')
    expect(find('.well-constraints')).to have_content('Publication Title: Journal')

    page.all('#documents .result').count.should be >= 10

  end

  # NEXT-581 - Articles Advanced Search should include Publication Title search
  # NEXT-793 - add Advanced Search to Articles, support Publication Title search
  it 'should let you perform an advanced publication title search', js: true do
    visit root_path
    within('li.datasource_link[source="articles"]') do
      click_link('Articles')
    end
    expect(find('#articles_q')).to be_visible

    # TODO
    # expect(page).to have_no_selector('.landing_page.articles .advanced_search')
    # expect('.landing_page.articles .advanced_search').to_not be_visible

    find('.search_box.articles .advanced_search_toggle').click
    expect(find('.landing_page.articles .advanced_search')).to be_visible
    within '.landing_page.articles .advanced_search' do
      fill_in 'publicationtitle', with: 'test'

      find('button[type=submit]').click

    end

    expect(find('.well-constraints')).to have_content('Publication Title')
  end

  # NEXT-622 - Basic Articles Search should have a pull-down for fielded search
  # NEXT-842 - Articles search results page doesn't put search term back into search box
  it 'should let you perform a fielded search from the basic search', js: true do
    visit articles_index_path
    within '.search_box.articles' do
      expect(find('#articles_q')).to be_visible
      fill_in 'q', with: 'catmull, ed'
      find('btn.dropdown-toggle').click
      within '.dropdown-menu' do
        find("a[data-value='s.fq[AuthorCombined]']").click
      end
      find('button[type=submit]').click
    end

    # Search string and search field should be preserved
    find('#articles_q').value.should eq 'catmull, ed'
    expect(find('.btn.dropdown-toggle')).to have_content('Author')

    # The entered fielded search should be echoed on the results page
    expect(find('.well-constraints')).to have_content('Author: catmull, ed')

    # And the search results too
    expect(find('#documents')).to have_content('Author Catmull')

    # AND, add in some test related to pub-date sorting...

    # page.save_and_open_page # debug

    first('.index_toolbar').should have_content('Sort by Relevance')
    first(:link, 'Sort by Relevance').click

    find_link('Relevance')
    find_link('Published Latest')
    find_link('Published Earliest').click

    first('.index_toolbar').should have_content('Published Earliest')
    first(:link, 'Published Earliest').click
    find_link('Relevance')
    find_link('Published Earliest')
    find_link('Published Latest').click

    first('.index_toolbar').should have_content('Published Latest')
    first(:link, 'Published Latest').click
    find_link('Relevance')
    find_link('Published Earliest')
    find_link('Published Latest')
  end

end
