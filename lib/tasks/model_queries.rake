namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
  end

  task :model_queries => :environment do
    puts("Query 1: Number of tickets bought by a customer")
    result = Order.joins(:tickets).where(customer_id: 1).count()
    puts(result)
    puts("EOQ")
  end

  task :model_queries => :environment do
    puts("Query 2:  Total number of different events that a given customer has attended")
    result = TicketType.select(:event_id).joins(tickets: :order).where("customer_id = '1'").distinct.count()
    puts(result)
    puts("EOQ")
  end

  task :model_queries => :environment do
    puts("Query 3: Names of the events attended by a given customer")
    result = Event.select(:name).joins(ticket_types: {tickets: :order}).where("customer_id = '1'")
    puts(result)
    puts("EOQ")
  end

  task :model_queries => :environment do
    puts("Query 4:  Total number of tickets sold for an event")
    result = Order.select(:customer_id).joins(tickets: :ticket_type).where("event_id = '1'").count()
    puts(result)
    puts("EOQ")
  end

  task :model_queries => :environment do
    puts("Query 5: Total sales of an event ")
    result = Order.select(:customer_id).joins(tickets: :ticket_type).where("event_id = '1'").sum("ticket_price")
    puts(result)
    puts("EOQ")
  end

  task :model_queries => :environment do
    puts("Query 6: The event that has been most attended by women")
    result = TicketType.select("event_id, count(event_id) as c").joins(tickets: {order: :customer}).where("gender = 'f'").group(:event_id).order("c").first()
    puts(result)
    puts("EOQ")
  end

  task :model_queries => :environment do
    puts("Query 7: The event that has been most attended by men ages 18 to 30")
    result = TicketType.select("event_id, count(event_id) as c").joins(tickets: {order: :customer}).where("gender = 'm' AND age BETWEEN '18' AND '30'").group(:event_id).order("c").first()
    puts(result)
    puts("EOQ")
  end
end