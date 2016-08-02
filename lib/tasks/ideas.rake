namespace :ideas do
  desc "Count backer voting result"
  task backer_voting_results: :environment do
    Idea.count_backer_voting_results
  end

end
