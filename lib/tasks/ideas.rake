namespace :ideas do
  desc "Count backer voting result"
  task backer_voting_results: :environment do
    Idea.count_backer_voting_results
  end

  desc "Process eligible idea payments"
  task process_payments: :environment do
    Idea.process_eligible_payments
  end
end
