Prescriptions and Reports (Under Each Visit)
users (Collection)
|--- UID123 (Document)
    |--- members (Sub-collection)
        |--- MID456 (Document)
            |--- visits (Sub-collection)
                |--- VID789 (Document)
                    |--- prescriptions (Sub-collection)
                        |--- PID101 (Document)
                            |-- images: ["url1", "url2"]
                            |-- prescribedBy: "Dr. Smith"
                            |-- createdAt: Timestamp
                    |--- reports (Sub-collection)
                        |--- RID202 (Document)
                            |-- images: ["url3", "url4"]
                            |-- reportedBy: "Dr. Smith"
                            |-- createdAt: Timestamp

------------ X ------------
Doctors Collection
doctors (Collection)
|
|--- DID789 (Document)
     |-- name: "Dr. Smith"
     |-- specialty: "Cardiology"
     |-- contact: "123456789"
     |-- createdAt: Timestamp

------------ X ------------
Users Collection

users (Collection)
|
|--- UID123 (Document)
     |-- displayName: "John Doe"
     |-- email: "johndoe@example.com"
     |-- createdAt: Timestamp

Members Sub-Collection (Under Each User)
users (Collection)
|--- UID123 (Document)
    |--- members (Sub-collection)
        |--- MID456 (Document)
            |-- name: "Jane Doe"
            |-- relationship: "Daughter"
            |-- createdAt: Timestamp

Visits Sub-Collection (Under Each Member)
users (Collection)
|--- UID123 (Document)
    |--- members (Sub-collection)
        |--- MID456 (Document)
            |--- visits (Sub-collection)
                |--- VID789 (Document)
                    |-- doctorId: "DID789"
                    |-- date: Timestamp
                    |-- reason: "Annual Checkup"
                    |-- createdAt: Timestamp
