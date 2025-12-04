use SchoolDB                                         -- start DB

db.createCollection("Students")                      -- create students
db.createCollection("Courses")                       -- create courses

db.Students.insertMany([                             -- insert lab students
  { name:"Alice", age:20, math:88, science:92 },
  { name:"Bob", age:22, math:76, science:81 },
  { name:"Charlie", age:23, math:90, science:78 },
  { name:"Daisy", age:21, math:82, science:75 }
])

db.Courses.insertMany([                              -- insert lab courses
  { courseName:"Math 101", instructor:"Dr. Smith", studentsEnrolled:[1,2] },
  { courseName:"Physics 201", instructor:"Dr. Adams", studentsEnrolled:[2,3] },
  { courseName:"Chemistry 301", instructor:"Dr. Brown", studentsEnrolled:[3,4] }
])

-- findOne: math >= 85 AND age < 22
db.Students.findOne({
  $and:[ { math:{ $gte:85 } }, { age:{ $lt:22 } } ]
})

-- findOne: array contains 3 AND instructor matches
db.Courses.findOne({
  studentsEnrolled:3,
  instructor:"Dr. Adams"
})

-- find: math >= 80 AND science < 90
db.Students.find({ math:{ $gte:80 }, science:{ $lt:90 } })

-- find: age < 23 OR math >= 85
db.Students.find({ $or:[ { age:{ $lt:23 } }, { math:{ $gte:85 } } ] })

-- find: science >= 80 AND (math < 75 OR age > 22)
db.Students.find({
  science:{ $gte:80 },
  $or:[ { math:{ $lt:75 } }, { age:{ $gt:22 } } ]
})

-- update Bob's science score
db.Students.updateOne(
  { name:"Bob", math:{ $gte:75 } },
  { $inc:{ science:1 } }
)

-- increment math by 5 for selected students
db.Students.updateMany(
  { science:{ $lt:80 }, age:{ $gt:22 } },
  { $inc:{ math:5 } }
)

-- delete Daisy
db.Students.deleteOne({ name:"Daisy", science:{ $lt:80 } })

-- delete courses containing student 2 OR instructor Dr Smith
db.Courses.deleteMany({
  $or:[ { studentsEnrolled:2 }, { instructor:"Dr. Smith" } ]
})

-- drop collections
db.Students.drop()
db.Courses.drop()
