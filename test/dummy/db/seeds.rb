require 'benchmark'
puts Benchmark.measure { 
  500.times do 
    Article.create(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph
    )
  end
}
