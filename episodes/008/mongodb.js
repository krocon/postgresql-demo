// Folge 008 – MongoDB-Seite des Vergleichs (mongosh). NICHT für den PostgreSQL-Container.
// Zum Ausprobieren z. B.:
//   docker run --rm -d --name mongo-demo -p 127.0.0.1:27017:27017 mongo:8
//   docker exec -i mongo-demo mongosh --quiet < episodes/008/mongodb.js
db = db.getSiblingDB("ep008");
db.orders.drop();

// Zusammen gespeichert, was zusammen gelesen wird: Kunde eingebettet
db.orders.insertMany([
  { _id: "o-1001", customer: { name: "Ada", city: "Kiel" },      items: [{ sku: "TSHIRT-XL", qty: 2 }], total: 129.90 },
  { _id: "o-1002", customer: { name: "Ada", city: "Kiel" },      items: [{ sku: "MUG", qty: 1 }],       total: 15.00 },
  { _id: "o-1003", customer: { name: "Linus", city: "Hamburg" }, items: [{ sku: "BOOK-SQL", qty: 1 }],  total: 42.50 },
]);

// Code aus dem Video / code from the video
printjson(db.orders.find({ "customer.city": "Kiel" }).toArray());

// Auswertung mit der Aggregation-Pipeline / report with the aggregation pipeline
printjson(db.orders.aggregate([
  { $group: { _id: "$customer.city", orders: { $sum: 1 }, revenue: { $sum: "$total" } } },
  { $sort: { revenue: -1 } },
]).toArray());

// Schema-Validierung ist optional möglich / optional schema validation:
// db.createCollection("orders", { validator: { $jsonSchema: { required: ["customer", "total"] } } })
