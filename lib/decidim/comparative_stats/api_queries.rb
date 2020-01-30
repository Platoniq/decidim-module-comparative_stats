# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module ApiQueries
      NAME_AND_VERSION = <<~GRAPHQL
        query {
           decidim {
             applicationName
             version
           }
         }
      GRAPHQL

      PARTICIPATORY_PROCESSES = <<~GRAPHQL
        query {
        	participatoryProcesses {
            id
            title {
              translations {
                text
              }
            }
            startDate
            endDate
          }
        }
      GRAPHQL

      GLOBAL_METRICS = <<~GRAPHQL
        query {
          metrics {
            count
            name
          }
        }
      GRAPHQL

      GLOBAL_HISTORY_METRICS = <<~GRAPHQL
        query {
          metrics {
            count
            name
            history {
              key
              value
            }
          }
        }
      GRAPHQL
    end
  end
end
