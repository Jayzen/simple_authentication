50.times do |i|  
  User.create(name: "test#{i}", email: "test#{i}@test.com", password: "111111", password_confirmation: "111111")
end
