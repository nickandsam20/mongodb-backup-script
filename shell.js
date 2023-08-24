for (var i = 1; i <= 30000; i++) {
   db.a1.insert( { x : i } ,{y:Math.random()},{z:Math.random()})
	 db.a2.insert( { x : i } ,{y:Math.random()},{z:Math.random()})
	 db.a3.insert( { x : i } ,{y:Math.random()},{z:Math.random()})
	 db.a4.insert( { x : i } ,{y:Math.random()},{z:Math.random()})
}

db.a1.createIndex( { x: -1 } )
db.a2.createIndex( { y: -1 } )
db.a3.createIndex( { z: -1 } )
db.a4.createIndex( { x: -1,y:-1,z:-1 } )


db.a1.createIndex( { x: 1 ,y:-1} )
db.a2.createIndex( { y: 1 ,x:-1} )
db.a3.createIndex( { z: 1 ,x:-1} )
db.a4.createIndex( { x: 1,y:-1,z:1 } )

db.a1.createIndex( { x: 1 } )
db.a2.createIndex( { y: 1 } )
db.a3.createIndex( { z: 1 } )
db.a4.createIndex( { x: 1,y:1,z:-1 } )