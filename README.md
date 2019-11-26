# Order calculator

Treat this exercise as you would a real-life business problem. You can ask for clarification of any domain name or rule. If the business requirement is not clear, assume you have access to a business owner to answer your questions.

There is **no** requirement to complete this exercise, we are more looking at your thought process & how you approach the problem.

## The problem

Farmdrop would like to build a system to calculate the final total of an order.

Based on customer feedback we have noticed customers would like to see an itemised breakdown of their order. This
should include a following items: 

* Cost of all line items
* Cost of delivery
* Total to pay

## What to build

Build an application that returns itemised billing for an order.

A seperate order service will send you the required data, so the application should accept `line_items` and a `delivery_slot_id`. Based on this an itemised bill should be returned.

There is already a postgres database populated with a `delivery_slots` and `delivery_costs` table. You can see the details of the tables at `db/structure.sql` 

A `delivery_slot` can have multiple `delivery_costs`. The `delivery_cost` defines the minimum spend, and the cost to charge if that minimum spend is met. If a delivery cost is not found we can assume
the cost is `0`.

This is the structure for `line_items`:

```ruby
{
  id: 32433,
  quantity: 1,
  price_pence: 150
}
```

You can assume the interviewer is the business owner and ask any clarification on the above.

## Example

Given the following data was sent from the order service:

```ruby
[
  {
    id: 53888,
    quantity: 2,
    price_pence: 299
  },
  {
    id: 99633,
    quantity: 1,
    price_pence: 125
  }
]
```

and a delivery slot id was also provided, allowing us to which allows us to retrieve the following `delivery_cost` record in the database

```ruby
delivery_slot_id: 342344

{
  id: 343424,
  delivery_slot_id: 342344,
  cost_pence: 100,
  minimum_spend_pence: 500,
  label: "£1 delivery when you spend over £5"
}
```

The application will return the following response: 

```ruby
{
 item_total_pence: 723,
 shipment_total_pence: 100,
 total_pence: 823
}
```

## Docker installation

Run the following commands to setup the application.

```
docker-compose build
docker-compose run --rm app rake db:setup
docker-compose up
```

## Standard installation

Firstly, open the `.env` file, then modify the host portion of the `DATABASE_URL` && `INITIAL_DATABASE_URL` from `db` to `localhost`.

Then run the following commands

```
bundle install
rake db:setup
thor app:server
thor app:console # if you would like a console
```
