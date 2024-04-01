# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(TrainingCoursesController, type: :routing) do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/training_courses').to(route_to('training_courses#index'))
    end

    it 'routes to #new' do
      expect(get: '/training_courses/new').to(route_to('training_courses#new'))
    end

    it 'routes to #show' do
      expect(get: '/training_courses/1').to(route_to('training_courses#show', id: '1'))
    end

    it 'routes to #edit' do
      expect(get: '/training_courses/1/edit').to(route_to('training_courses#edit', id: '1'))
    end

    it 'routes to #create' do
      expect(post: '/training_courses').to(route_to('training_courses#create'))
    end

    it 'routes to #update via PUT' do
      expect(put: '/training_courses/1').to(route_to('training_courses#update', id: '1'))
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/training_courses/1').to(route_to('training_courses#update', id: '1'))
    end

    it 'routes to #destroy' do
      expect(delete: '/training_courses/1').to(route_to('training_courses#destroy', id: '1'))
    end
  end
end
