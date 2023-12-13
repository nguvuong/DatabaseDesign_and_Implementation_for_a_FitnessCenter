//one to many  approach 

// reference approach 

db.amenity.insertMany([
    {amenityid: 10, amenity: 'Sauna'},
    {amenityid: 11, amenity: 'Green Zone'},
    {amenityid: 12, amenity: 'Hot Yoga'}])



db.GymLocation.insertMany([
            {locationid: 100, locationname: 'Midtown', address: 'Brampton', tel: '123-456-789', email: 'nguvuong@sheridancollege.ca', visitedTime: 15, amenityid: [10,11,12]},
            {locationid: 101, locationname: 'Çabbagetown', address: 'Brampton1', tel: '123-456-789', email: 'nguvuong1@sheridancollege.ca', visitedTime: 8, amenityid: [11,12]},
   {locationid: 102, locationname: 'Midtown', address: 'Brampton2', tel: '123-456-789', email: 'nguvuong2@sheridancollege.ca', visitedTime: 3, amenityid: 10}])




db.GymLocation.find()
db.amenity.find()

db.amenity.drop()
db.GymLocation.drop()
