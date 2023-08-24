# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:user) { create :user }
    let(:context) do
      {}
    end

    let(:permission_action) do
      Decidim::PermissionAction.new(
        action: action[:action],
        scope: action[:scope],
        subject: action[:subject]
      )
    end

    context "when scope is not admin" do
      let(:action) do
        { scope: :foo, action: :index, subject: :graph }
      end

      it_behaves_like "permission is not set"
    end

    context "when subject is not a endpoint or graph" do
      let(:action) do
        { scope: :admin, action: :index, subject: :foo }
      end

      it_behaves_like "permission is not set"
    end

    context "when action is a random one" do
      let(:action) do
        { scope: :admin, action: :foo, subject: :graph }
      end

      it_behaves_like "permission is not set"
    end

    context "when subject is graph" do
      context "and action is index" do
        let(:action) do
          { scope: :admin, action: :index, subject: :graph }
        end

        it { is_expected.to be true }
      end

      context "and action is not index" do
        let(:action) do
          { scope: :admin, action: :foo, subject: :graph }
        end

        it_behaves_like "permission is not set"
      end
    end

    context "when subject is endpoint" do
      context "and action is index" do
        let(:action) do
          { scope: :admin, action: :index, subject: :endpoint }
        end

        it { is_expected.to be true }
      end

      context "and action is create" do
        let(:action) do
          { scope: :admin, action: :create, subject: :endpoint }
        end

        it { is_expected.to be true }
      end

      context "and action is update" do
        let(:action) do
          { scope: :admin, action: :update, subject: :endpoint }
        end

        it { is_expected.to be true }
      end

      context "and action is destroy" do
        let(:action) do
          { scope: :admin, action: :destroy, subject: :endpoint }
        end

        it { is_expected.to be true }
      end

      context "and action is not index,create,update,destroy" do
        let(:action) do
          { scope: :admin, action: :foo, subject: :endpoint }
        end

        it_behaves_like "permission is not set"
      end
    end
  end
end
