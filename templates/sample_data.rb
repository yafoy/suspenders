# encoding: utf-8
require 'ffaker'

puts 'GENERATING SAMPLE DATA ...'

10.times do |x|
  u = x + 1
  User.create!(
      email: "user#{u}@email.com"
  )
end