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

      GLOBAL_EVENTS = <<~GRAPHQL
        query {
          assemblies {
            id
            slug
            components (filter: {withGeolocationEnabled: true }) {
              id
              ...geolocatedMeetings
              ...geolocatedProposals
            }
          }
          participatoryProcesses {
            id
            slug
            components (filter: {withGeolocationEnabled: true }) {
              id
              ...geolocatedMeetings
              ...geolocatedProposals
            }
          }
        }

        fragment geolocatedMeetings on Meetings {
          meetings {
            edges {
              node {
                id
                address
                title {
                  translations {
                    text
                  }
                }
                description {
                  translations {
                    text
                  }
                }
                startTime
                endTime
                location {
                  translations {
                    text
                  }
                }
                locationHints {
                  translations {
                    text
                  }
                }
                coordinates {
                  latitude
                  longitude
                }
              }
            }
          }
        }

        fragment geolocatedProposals on Proposals {
          proposals {
            edges {
              node {
                id
                address
                title
                body
                coordinates {
                  latitude
                  longitude
                }
              }
            }
          }
        }
      GRAPHQL
    end
  end
end
