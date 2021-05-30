FactoryBot.define do
    factory :task do
        name {'テストを書く'}
        description {'RSpec & Capybara & FactoryBotを'}
        user
    end
end