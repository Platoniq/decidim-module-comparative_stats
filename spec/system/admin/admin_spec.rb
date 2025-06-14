# frozen_string_literal: true

require "spec_helper"

describe "Visit the admin page" do
  let(:content_security_policy) { { "script-src" => "www.gstatic.com" } }
  let(:organization) { create(:organization, content_security_policy:) }
  let!(:admin) { create(:user, :admin, :confirmed, organization:) }
  let!(:endpoint) { create(:endpoint, organization:) }
  let(:data) do
    {
      __schema: Decidim::Api::Schema.execute(GraphQL::Introspection::INTROSPECTION_QUERY).fetch("data").fetch("__schema"),
      decidim: {
        version: "0.25.2"
      },
      metrics: [
        {
          count: 55_053,
          name: "users",
          history: [
            {
              key: "2021-01-12",
              value: 55_053
            },
            {
              key: "2021-01-11",
              value: 55_035
            }
          ]
        },
        {
          count: 28_419,
          name: "participants",
          history: [
            {
              key: "2021-01-12",
              value: 28_419
            },
            {
              key: "2021-01-11",
              value: 28_417
            }
          ]
        }
      ],
      participatoryProcesses: [
        {
          id: "5",
          title: {
            translations: [
              {
                text: "Normes de Participació"
              },
              {
                text: "Normas de Participación"
              }
            ]
          },
          startDate: "2016-10-20",
          endDate: "2017-07-30",
          slug: "revisio-de-la-normativa-de-participacio-ciutadana",
          components: [
            {
              id: "17",
              __typename: "Meetings",
              meetings: {
                edges: [
                  {
                    node: {
                      id: "646",
                      address: "Carrer del Regomir, 3, 08002 Barcelona, Espanya",
                      title: {
                        translations: [
                          {
                            text: "Sessió de treball amb els secretaris i tècnics de Consells Sectorials de Districte i Tècnics de Barri "
                          },
                          {
                            text: "Sessió de treball amb els secretaris i tècnics de Consells Sectorials de Districte i Tècnics de Barri "
                          }
                        ]
                      },
                      description: {
                        translations: [
                          {
                            text: "<p>L’Ajuntament de Barcelona ha iniciat un procés participatiu</p>"
                          },
                          {
                            text: "<p>L’Ajuntament de Barcelona ha iniciat un procés participatiu</p>"
                          }
                        ]
                      },
                      startTime: "2016-10-17T12:00:00+02:00",
                      endTime: "2016-10-17T15:00:00+02:00",
                      location: {
                        translations: [
                          {
                            text: ""
                          },
                          {
                            text: ""
                          }
                        ]
                      },
                      locationHints: nil,
                      coordinates: {
                        latitude: 41.3815653,
                        longitude: 2.17902400000003
                      }
                    }
                  }
                ]
              }
            },
            {
              id: "171",
              __typename: "Proposals",
              proposals: {
                edges: [
                  {
                    node: {
                      id: "805",
                      address: "",
                      title: "0.22 title style",
                      body: "0.22 description style",
                      coordinates: {
                        latitude: 31.3,
                        longitude: -10.1
                      }
                    }
                  },
                  {
                    node: {
                      id: "965",
                      address: "",
                      title: {
                        translations: [
                          {
                            text: "0.23 title style"
                          }
                        ]
                      },
                      body: {
                        translations: [
                          {
                            text: "0.23 description style"
                          }
                        ]
                      },
                      coordinates: {
                        latitude: 61.3,
                        longitude: 20.1
                      }
                    }
                  }
                ]
              }
            }
          ]
        }
      ],
      assemblies: []
    }
  end

  before do
    stub_request(:post, endpoint.endpoint).to_return({ status: 200, body: "{\"data\":#{data.to_json}}", headers: {} })

    switch_to_host(organization.host)
    login_as admin, scope: :user
    visit decidim_admin.root_path
    click_on "Comparative Stats"
  end

  context "when default" do
    it "renders the admin page" do
      expect(page).to have_content("API endpoints")
    end
  end

  context "when visiting manage API endpoints" do
    before do
      click_on "Add a Decidim URL"
    end

    it "renders the page" do
      expect(page).to have_content("API endpoints")
    end
  end

  context "when visiting manage graphs" do
    before do
      click_on "Manage Graphs"
    end

    it "renders the page" do
      expect(page).to have_content("Manage graphs")
    end

    context "and click tab #1" do
      before do
        click_on "Global stats"
      end

      it "renders the page" do
        expect(page).to have_content("Registered users")
      end
    end

    context "and click tab #2" do
      before do
        click_on "Global stats timeline"
      end

      it "renders the page" do
        expect(page).to have_content("Registered users")
      end
    end

    context "and click tab #3" do
      before do
        click_on "Processes timeline"
      end

      it "renders the page" do
        expect(page).to have_content("Normes de Participació")
      end
    end

    context "and click tab #4" do
      before do
        click_on "Aggregated maps"
      end

      it "renders the page" do
        expect(page).to have_xpath("//div[@class='leaflet-control-container']")
      end
    end
  end
end
