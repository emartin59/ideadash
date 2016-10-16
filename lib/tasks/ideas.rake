namespace :ideas do
  desc "Count backer voting result"
  task backer_voting_results: :environment do
    Idea.count_backer_voting_results
  end

  desc "Process eligible idea payments"
  task process_payments: :environment do
    Idea.process_eligible_payments
  end

  task backer_voting_results_monthly: :environment do
    if Date.today == Date.today.end_of_month
      Idea.count_backer_voting_results
    end
  end

  desc "Process eligible idea payments"
  task process_payments_monthly: :environment do
    if Date.today == Date.today.beginning_of_month
      Idea.process_eligible_payments
    end
  end
end
