# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  @movies_count = movies_table.hashes.count
  movies_table.hashes.each do |movie|
     m = Movie.new(movie)
     m.save
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should (not )?see "(.*)" before "(.*)"/ do |not_see, e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  match = /#{e1}.*#{e2}/m =~ page.body 
  if not_see
    result = match == nil
  else 
    result = match != nil
  end
  result.should == true
end




# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|  
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    if( uncheck )
      uncheck("ratings_" + rating.gsub(/\s/,''))
    else
      check("ratings_" + rating.gsub(/\s/,''))
    end
  end
end

Then /I should see all of the movies/ do 
  page.all('table#movies tr').count.should == (@movies_count+1)
end

Then /I should see none of the movies/ do 
  page.all('table#movies tr').count.should == 1
end

=begin
When /^I press (.*)/ do |button|
  click_button(button)
end

Then /I should see "(.*)"/ do |result|
  regexp = Regexp.new(result)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end
=end