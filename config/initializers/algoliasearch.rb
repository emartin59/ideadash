AlgoliaSearch.configuration = {
    application_id: ENV['ALGOLIASEARCH_APPLICATION_ID'],
    api_key: ENV['ALGOLIASEARCH_API_KEY']
} if ENV['ALGOLIASEARCH_APPLICATION_ID'].present?
