# frozen_string_literal: true

require_relative 'account'
require_relative 'system'
require_relative 'cate'

module Howtosay
  # Behaviors of the currently logged in account
  class Home

    def initialize(system ,account, cate)
      
      @all = projects_list.map do |proj|
        policy = ProjectPolicy.new(account, proj)
        Project.first(id: proj.id)
               .full_details
               .merge(policies: policy.summary)
      end
    end

    def to_json(options = {})
      JSON(@all, options)
    end
  end
end