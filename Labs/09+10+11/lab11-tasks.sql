--ibrahim johar - 23K-0074 - BAI-5A
--lab11 - tasks

--q1
use inventoryDB

db.furniture.insertMany([
  { name: "stool", color: "black", dimensions: [25, 40] },
  { name: "bench", color: "oak", dimensions: [55, 110] },
  { name: "cabinet", color: "white", dimensions: [45, 90] }
])

--q2
db.furniture.insertOne({ name: "desk", color: "brown", dimensions: [50, 100] })

--q3
db.furniture.find({ "dimensions.0": { $gt: 30 } })

--q4
db.furniture.find({ color: "brown", name: { $in: ["table", "chair"] } })

--q5
db.furniture.updateOne( { name: "table" }, { $set: { color: "ivory" } } )

--q6
db.furniture.updateMany( { color: "brown" }, { $set: { color: "dark brown" } } )

--q7
db.furniture.deleteOne({ name: "chair" })

--q8
db.furniture.deleteMany({ dimensions: [12, 18] })

--q9
db.furniture.aggregate([
  {
    $group: { _id: "$color", item_count: { $sum: 1 } }
  }
])

--q10
db.furniture.createIndex({ name: "text" })

db.furniture.find({ $text: { $search: "table" } })
