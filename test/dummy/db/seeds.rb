20.times do |i|
  User.create(name: "#{i+1}name", email: "#{1+i}qq.com", password: "111111", password_confirmation: "111111")
end
